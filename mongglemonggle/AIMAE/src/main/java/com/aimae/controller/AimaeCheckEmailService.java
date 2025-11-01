package com.aimae.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aimae.model.UserDAO;

@WebServlet("/CheckEmailService")
public class AimaeCheckEmailService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");

		System.out.println("넘어온 useremail: " + email);

		UserDAO dao = new UserDAO();
		int result = dao.findEmail(email);

		// 1. 응답의 Content-Type을 "text/plain"으로 설정
		response.setContentType("text/plain;charset=UTF-8");
		PrintWriter out = response.getWriter();

		// 2. 중복 여부에 따라 다른 메시지를 텍스트로 보냄
		if (result > 0) {
			out.write("duplicate"); // 중복일 경우 'duplicate' 문자열 전송
		} else {
			out.write("available"); // 사용 가능일 경우 'available' 문자열 전송
		}

	}

}
