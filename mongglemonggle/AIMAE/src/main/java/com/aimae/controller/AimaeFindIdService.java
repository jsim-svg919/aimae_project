package com.aimae.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.mail.Session;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aimae.model.AuthCodeGenerator;
import com.aimae.model.UserDAO;
import com.aimae.model.UserInfo;
import com.aimae.util.SendMail;

@WebServlet("/FindIdService")
public class AimaeFindIdService extends HttpServlet {
   private static final long serialVersionUID = 1L;

   protected void service(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {

      String recipientEmail = request.getParameter("email");
      PrintWriter out = response.getWriter();

      if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
         response.setContentType("text/plain;charset=UTF-8");
         out.write("error:empty_email");
         return; // 메서드 실행 중단
      }

      UserDAO dao = new UserDAO();
      String userId = dao.findId(recipientEmail);

      if (userId != null) {

         System.out.println("이메일 찾아짐");
         
         String title = "AIMAE_찾은 아이디";
         String content = "찾은 ID = " + userId + " 입니다.";
         String user_name = "dydtjr1564@naver.com";
         String password = "LSJVD1EXG8MM";

         SendMail mailSender = new SendMail();
         Session session = mailSender.setting(user_name, password);

         mailSender.goMail(session, recipientEmail, title, content);

         out.write("success");

         response.getWriter().write(userId);

      } else {
         // 세션 설정 실패 처리
         out.write("error:mail_session_fail");
         System.out.println("저장되어 있지 않음");
         
         String title = "AIMAE_찾은 아이디";
         String content = "가입된 ID가 없습니다.";
         String user_name = "dydtjr1564@naver.com";
         String password = "LSJVD1EXG8MM";

         SendMail mailSender = new SendMail();
         Session session = mailSender.setting(user_name, password);

         mailSender.goMail(session, recipientEmail, title, content);

      }

   }

}
