package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/CompletCodeService")
public class AimaeCompletCodeService extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String inputAuthCode = request.getParameter("authCode");
		
		HttpSession session = request.getSession();
		String sessionAuthCode = (String) session.getAttribute("authCode");
		
		response.setContentType("text/plain;charset=UTF-8");
		
		if (sessionAuthCode == null) {
			response.getWriter().write("expired");
			return;
		}
			
		if(sessionAuthCode.equals(inputAuthCode)) {
			response.getWriter().write("verified ");
			session.removeAttribute("authCode");
			
		}else {
			response.getWriter().write("mismatch");
		}
	
	}

}
