package com.aimae.controller;

import com.aimae.model.UserDAO;
import com.aimae.model.UserInfo;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.DataOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/KakaoLoginService")
public class AimaeKakaoLoginService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 카카오 개발자 센터에서 발급받은 Client ID와 Secret
    private static final String CLIENT_ID = "09d398830455de57746f120a7bceca3d"; 
    private static final String REDIRECT_URI = "http://localhost:8081/AIMAE/KakaoLoginService";

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String code = request.getParameter("code");
            
            if (code == null) {
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=missing_code");
                return;
            }
            
            // 1. 인가 코드로 access_token 발급 요청
            String accessToken = getAccessToken(code);
            if (accessToken == null) {
                out.println("<h1>Access Token 발급에 실패했습니다.</h1>");
                return;
            }
            
            // 2. access_token으로 사용자 프로필 정보 요청
            JsonObject profile = getUserProfile(accessToken);
            if (profile == null) {
                out.println("<h1>사용자 프로필 정보를 가져오는데 실패했습니다.</h1>");
                return;
            }

            // 3. 받아온 프로필 정보 처리
            JsonObject kakaoAccount = profile.getAsJsonObject("kakao_account");
            String kakaoId = profile.get("id").getAsString();
            String kakaoEmail = kakaoAccount.has("email") ? kakaoAccount.get("email").getAsString() : null;
            String kakaoNickname = kakaoAccount.getAsJsonObject("profile").get("nickname").getAsString();
            
            // 4. DB 연동 및 로그인/회원가입 로직
            UserDAO dao = new UserDAO();
            UserInfo user = dao.findByNaverId("KAKAO_" + kakaoId);
            String Grade = dao.findGrade("KAKAO_" + kakaoId);
            
            if (user == null) {
                 // 신규 회원인 경우
                 UserInfo nUser = new UserInfo();
                 
                 DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                 String joinDate = LocalDate.now().format(formatter);
                 
                 System.out.println("신규 카카오 회원 가입!");
                 
                 nUser.setUSER_ID("KAKAO_" + kakaoId);
                 nUser.setUSER_NAME(kakaoNickname);
                 nUser.setEMAIL(kakaoEmail);
                 nUser.setPASSWORD(UUID.randomUUID().toString()); // 임의의 비밀번호
                 nUser.setPHONE(" ");
                 nUser.setUSER_ADRRESS(" ");
                 nUser.setGRADE(Grade);
                 nUser.setJOIN_DATE(joinDate);
                 
                 dao.join(nUser);
                 
                 user = nUser;
                 
            } else {
                 System.out.println("기존 카카오 회원 로그인!");
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("sUser", user);
            
            response.sendRedirect("/AIMAE/index.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h1>오류가 발생했습니다: " + e.getMessage() + "</h1>");
        }
    }

    /**
     * 인가 코드를 사용하여 카카오 Access Token을 발급받는 메서드입니다.
     */
    private String getAccessToken(String code) throws Exception {
        URL url = new URL("https://kauth.kakao.com/oauth/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
        conn.setDoOutput(true);
        
        String postData = "grant_type=authorization_code" +
                          "&client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8") +
                          "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8") +
                          "&code=" + URLEncoder.encode(code, "UTF-8");
        
        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.writeBytes(postData);
            wr.flush();
        }
        
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();
            
            JsonElement jsonElement = JsonParser.parseString(response.toString());
            if (jsonElement.getAsJsonObject().get("access_token") != null) {
                return jsonElement.getAsJsonObject().get("access_token").getAsString();
            }
        }
        return null;
    }
    
    /**
     * Access Token을 사용하여 카카오 사용자 프로필 정보를 가져오는 메서드입니다.
     */
    private JsonObject getUserProfile(String accessToken) throws Exception {
        URL url = new URL("https://kapi.kakao.com/v2/user/me");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
        conn.setDoOutput(true);
        
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();
            
            JsonElement jsonElement = JsonParser.parseString(response.toString());
            return jsonElement.getAsJsonObject();
        }
        return null;
    }
}
