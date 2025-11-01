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
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
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

@WebServlet("/NaverLoginService")
public class AimaeNaverLoginService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 네이버 개발자 센터에서 발급받은 Client ID와 Secret
    private static final String CLIENT_ID = "zNtk7Js2ruJpU5n22VvO"; 
    private static final String CLIENT_SECRET = "YWOLWR5Mct";
    private static final String REDIRECT_URI = "http://localhost:8081/AIMAE/NaverLoginService"; // 등록한 Callback URL과 일치해야 함

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 1. 네이버로부터 받은 인가 코드(code)와 상태 토큰(state)
            String code = request.getParameter("code");
            String state = request.getParameter("state");
            
            // 필수 파라미터가 누락되었을 경우 처리
            if (code == null || state == null) {
            	response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=missing_params");
                return;
            }
            
            // 2. 인가 코드로 access_token 발급 요청
            String accessToken = getAccessToken(code, state);
            if (accessToken == null) {
                out.println("<h1>Access Token 발급에 실패했습니다.</h1>");
                out.println("<p>콘솔 로그를 확인하여 실패 원인을 파악해주세요.</p>");
                return;
            }
            
            // 3. access_token으로 사용자 프로필 정보 요청
            JsonObject profile = getUserProfile(accessToken);
            if (profile == null) {
                out.println("<h1>사용자 프로필 정보를 가져오는데 실패했습니다.</h1>");
                return;
            }

            // 4. 받아온 프로필 정보 처리
            String naverId = profile.get("id").getAsString();
            String naverEmail = profile.get("email").getAsString();
            String naverName = profile.get("name").getAsString();
            String naverphone = profile.get("mobile").getAsString();
            
            
            // 여기에 DB 연동 로직을 추가하여 로그인 또는 회원가입을 처리합니다.
            // 예시:
            
             UserDAO dao = new UserDAO();
             UserInfo user = dao.findByNaverId("NAVER_" + naverId);
             String Grade = dao.findGrade("NAVER_" + naverId);
             if (user == null) {
                 // 신규 회원인 경우, 회원가입 처리
            	 UserInfo nUser = new UserInfo();
            	 
            	 DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            	 String joinDate = LocalDate.now().format(formatter);


                 System.out.println("신규 네이버 회원 가입!");
                 // 회원가입 시 소셜 로그인 계정임을 구분하기 위해 `NAVER_`와 같은 접두사 사용
                 
                 nUser.setUSER_ID("NAVER_" + naverId);
                 nUser.setUSER_NAME(naverName);
                 nUser.setEMAIL(naverEmail);
                 nUser.setPASSWORD(UUID.randomUUID().toString()); // 비밀번호는 임의의 값으로 설정
                 nUser.setPHONE(naverphone);
                 nUser.setUSER_ADRRESS(" ");
                 nUser.setGRADE(Grade);
                 nUser.setJOIN_DATE(joinDate);
                 
                 dao.join(nUser);
                 
                 user = nUser;
                 
             } else {
                 System.out.println("기존 네이버 회원 로그인!");
            // 세션에 로그인 정보 저장
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
     * 인가 코드를 사용하여 네이버 Access Token을 발급받는 메서드입니다.
     */
    private String getAccessToken(String code, String state) throws Exception {
    	
    	// 진단용 로그 추가
        System.out.println("--- 네이버 Access Token 요청 ---");
    	System.out.println("CLIENT_ID: " + CLIENT_ID);
        System.out.println("CLIENT_SECRET: " + CLIENT_SECRET);
        System.out.println("REDIRECT_URI: " + REDIRECT_URI);
        System.out.println("---------------------------");

        // Null 값 체크를 추가하여 오류를 명확하게 진단
        if (code == null || state == null) {
            System.err.println("오류: code 또는 state 값이 null입니다.");
            return null;
        }
    	
        String urlString = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code" +
                "&client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8") +
                "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, "UTF-8") +
                "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8") +
                "&code=" + URLEncoder.encode(code, "UTF-8") +
                "&state=" + URLEncoder.encode(state, "UTF-8");
        
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        int responseCode = conn.getResponseCode();
        System.out.println("네이버 API 응답 코드: " + responseCode); // 응답 코드 출력

        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();
            
            System.out.println("네이버 API 응답 내용: " + response.toString()); // 성공 응답 내용 출력
            
            JsonElement jsonElement = JsonParser.parseString(response.toString());
            if (jsonElement.getAsJsonObject().get("access_token") != null) {
                return jsonElement.getAsJsonObject().get("access_token").getAsString();
            }
        } else {
            // 실패 시 응답 내용 출력
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            StringBuilder errorResponse = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                errorResponse.append(line);
            }
            br.close();
            System.err.println("네이버 API 오류 응답: " + errorResponse.toString()); // 오류 응답 내용 출력
        }
        return null;
    }
    
    /**
     * Access Token을 사용하여 네이버 사용자 프로필 정보를 가져오는 메서드입니다.
     */
    private JsonObject getUserProfile(String accessToken) throws Exception {
        URL url = new URL("https://openapi.naver.com/v1/nid/me");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        
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
            if (jsonElement.getAsJsonObject().get("response") != null) {
                return jsonElement.getAsJsonObject().get("response").getAsJsonObject();
            }
        }
        return null;
    }
}
