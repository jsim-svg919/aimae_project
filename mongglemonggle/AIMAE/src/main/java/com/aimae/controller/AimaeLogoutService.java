package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/LogoutService")
public class AimaeLogoutService extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	
				// 1. session 꺼내오기
				HttpSession session = request.getSession();
				// 2. session 처리하기
				session.invalidate();
				// 3. redirect방식으로  이동
				response.sendRedirect(request.getContextPath() + "/index.jsp?logout=success");
				System.out.println("성공");
	
	}

}
