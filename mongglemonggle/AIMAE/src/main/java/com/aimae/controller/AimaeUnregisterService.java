package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aimae.model.UserDAO;
import com.aimae.model.UserInfo;


@WebServlet("/UnregisterService")
public class AimaeUnregisterService extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/plain;charset=UTF-8");
		HttpSession session = request.getSession();
		
		if (session == null) {
			response.getWriter().write("error:not_logged_in");
			return;
		}
		
		UserInfo sUser = (UserInfo) session.getAttribute("sUser");
		
		if (sUser == null) {
			response.getWriter().write("error:not_logged_in");
			return;
		}
		
		String userId = sUser.getUSER_ID();
		System.out.println("세션에 저장된 ID : " + userId);
		
		UserDAO dao = new UserDAO();
		
		int cnt = dao.unregister(userId);
		
		if (cnt>0) {
			session.invalidate();
			System.out.println("탈퇴완료.");
			
			response.sendRedirect("index.jsp?status=unregister_success");
		}else {
			System.out.println("탈퇴실패");
		}
		
	
	}

}
