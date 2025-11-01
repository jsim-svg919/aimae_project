package com.aimae.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.aimae.model.UserDAO;
import com.aimae.model.UserInfo;
import com.aimae.util.SendMail;

@WebServlet("/FindPwService")
public class AimaeFindPwService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String userId = request.getParameter("userId");
        String email = request.getParameter("email");

        if (userId == null || userId.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            out.write("error:invalid_input");
            return;
        }
        UserDAO dao = new UserDAO();
        UserInfo user = dao.findPw(userId, email); // 아이디+이메일 확인

        if (user != null) {
            // 임시 비밀번호 생성
            String tempPw = generateTempPassword(5);
            // BCrypt 해싱
            String hashedPw = BCrypt.hashpw(tempPw, BCrypt.gensalt());

            // DB 업데이트
            user.setPASSWORD(hashedPw);
            int result = dao.updatePassword(user);
            System.out.println("업데이트된 행 수: " + result);

            // 이메일 전송
            String title = "AIMAE 임시 비밀번호 안내";
            String content = "임시 비밀번호: " + tempPw + " 입니다. 로그인 후 필요 시 비밀번호를 변경하세요!";
            String user_name = "dydtjr1564@naver.com";
            String password = "LSJVD1EXG8MM";

            SendMail mailSender = new SendMail();
            javax.mail.Session session = mailSender.setting(user_name, password);
            mailSender.goMail(session, email, title, content);

            out.write("success");
        } else {
            out.write("error:not_found");
        }
    }

    // 임시 비밀번호 생성 메서드
    private String generateTempPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
