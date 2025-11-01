package com.aimae.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aimae.model.AuthCodeGenerator;
import com.aimae.util.SendMail;


@WebServlet("/AuthCodeService")
public class AimaeAuthCodeService extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

			String recipientEmail = request.getParameter("email");
			PrintWriter out = response.getWriter();
			
			if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
	            response.setContentType("text/plain;charset=UTF-8");
	            out.write("error:empty_email");
	            return; // 메서드 실행 중단
	        }
			
			AuthCodeGenerator authCodeGenerator = new AuthCodeGenerator();
			String authCode = authCodeGenerator.RandomCode(5); // 생성된 인증번호를 문자열로 저장
			
		
		 	String title = "AIMAE_인증";
		 	String content = "인증번호는 { "+ authCode +" } 입니다.";
		 	String user_name = "dydtjr1564@naver.com";
		 	String password = "LSJVD1EXG8MM";
		 	
		 	SendMail mailSender = new SendMail();
	        Session session = mailSender.setting(user_name, password);
	        
	        
	        
	        if (session != null) {
	            mailSender.goMail(session, recipientEmail, title, content);
	            
	         // 3. 발송된 인증번호를 세션에 저장 (인증 확인을 위해)
		 		HttpSession httpSession = request.getSession();
		 		httpSession.setAttribute("authCode", authCode);
		 		httpSession.setMaxInactiveInterval(300); // 5분 동안 유효
	            
	            out.write("success"); 
	            
	        } else {
	            // 세션 설정 실패 처리
	        	out.write("error:mail_session_fail");
	        	
	        }
	
	}

}
