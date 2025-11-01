package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.aimae.model.UserDAO;
import com.aimae.model.UserInfo;


@WebServlet("/UpdateService")
public class AimaeUpdateService extends HttpServlet {
   private static final long serialVersionUID = 1L;


   protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

      request.setCharacterEncoding("UTF-8");
      HttpSession session = request.getSession();
      UserInfo User = (UserInfo) session.getAttribute("userInfo");
      
      String userId = request.getParameter("USER_ID");
      String userName = request.getParameter("USER_NAME");
      String email = request.getParameter("EMAIL");
      String userPw = request.getParameter("PASSWORD");
      String phone = request.getParameter("PHONE");
      String address = request.getParameter("USER_ADRRESS");
      
      
      
      UserInfo updateUser = new UserInfo();
      
      updateUser.setUSER_ID(userId);
      
      if (userName != null && !userName.trim().isEmpty()) {
         updateUser.setUSER_NAME(userName);
      }
      if (email != null && !email.trim().isEmpty()) {
         updateUser.setEMAIL(email);
      }
      if (userPw != null && !userPw.trim().isEmpty()) {
         
         String hashedPw = BCrypt.hashpw(userPw, BCrypt.gensalt());
         
         updateUser.setPASSWORD(hashedPw);
      }
      if (phone != null && !phone.trim().isEmpty()) {
         updateUser.setPHONE(phone);
      }
      if (address != null && !address.trim().isEmpty()) {
         updateUser.setUSER_ADRRESS(address);
      }
      
      
      UserDAO dao = new UserDAO();
      
      int cnt = dao.update(updateUser);
      
      if (cnt > 0) {
         
         UserInfo completeUser = dao.login(userId);
         
         session.setAttribute("sUser", completeUser);
         response.sendRedirect(request.getContextPath() +"/jsp/mypage.jsp");
         System.out.println("성공");
         
      }
      
      
   
   
   }

}
