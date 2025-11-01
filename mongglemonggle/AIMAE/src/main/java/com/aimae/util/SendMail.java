package com.aimae.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendMail {

	final String ENCODING = "UTF-8";
	final String PORT = "587";
	final String SMTPHOST = "smtp.naver.com";
	final String SENDER_EMAIL = "dydtjr1564@naver.com"; // 발신 이메일
	final String SENDER_ALIAS = "AIMAE_관리자"; // 발신자명

	public Session setting(final String user_name, final String password) {

		Session session = null;
		Properties props = new Properties();

		try {

			props.put("mail.transport.protocol", "smtp");
			props.put("mail.smtp.host", SMTPHOST);
			props.put("mail.smtp.port", PORT);
			props.put("mail.smtp.auth", true);
			props.put("mail.smtp.starttls.enable", true);
			props.put("mail.smtp.quit-wait", "false");
			props.put("mail.smtp.ssl.protocols", "TLSv1.2");
			props.put("mail.smtp.ssl.trust", "smtp.naver.com");
			
			
			 // 네이버 SMTP 서버의 SSL/TLS 프로토콜 신뢰 설정
			


			session = Session.getInstance(props, new Authenticator() {

				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(user_name, password);
				}
			});
		} catch (Exception e) {
			System.out.println("session Setting 실패");
			
		}

		return session;

	}

	/**
	 * 메시지 생성후 메일전송
	 * 
	 * @param session
	 * @param title
	 * @param content
	 */
	public void goMail(Session session,String toEmail, String title, String content) {
		
		Message msg = new MimeMessage(session);

		if (session == null) {
			System.out.println("메일 세션이 유효하지 않습니다. 메일을 보낼 수 없습니다.");
			return;
		}
		
		try {
			msg.setFrom(new InternetAddress(SENDER_EMAIL, SENDER_ALIAS, ENCODING));
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
			msg.setSubject(title);
			msg.setContent(content, "text/html; charset=utf-8");

			Transport.send(msg);

			System.out.println("메일 보내기 성공");

		} catch (Exception e) {

			e.printStackTrace();
			System.out.println("메일 보내기 실패");

		}
	}

}