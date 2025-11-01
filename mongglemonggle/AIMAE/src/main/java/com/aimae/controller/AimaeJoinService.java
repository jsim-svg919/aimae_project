package com.aimae.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.aimae.model.UserDAO;
import com.aimae.model.UserInfo;


@WebServlet("/JoinService")
public class AimaeJoinService extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		        // 1. join.html을 통해서 회원가입정보를 받는다.
				// 2. form태그를 통해서 JoinService로 데이터들을 전송한다,
				// 3. join.html에서 입력받은 데이터들을 받아온다!!
				//    * post방식으로 보낸 데이터들을 받아오면 된다!
				//		-> 데이터 받을 때마다 인코딩 필수
				request.setCharacterEncoding("UTF-8");
				
				String userId = request.getParameter("USER_ID");
				String userPw = request.getParameter("PASSWORD");
				String userPw2 = request.getParameter("PASSWORD2");
				String email = request.getParameter("EMAIL");
				String username = request.getParameter("USER_NAME");
				String phone1 = request.getParameter("PHONE1");
				String phone2 = request.getParameter("PHONE2");
				String phone3 = request.getParameter("PHONE3");
				String phone = phone1 + phone2 + phone3;
				
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String joinDate = LocalDate.now().format(formatter);
				
				String address = request.getParameter("USER_ADRRESS");
				
				UserDAO dao= new UserDAO();
				
				int emailCount = dao.findEmail(email);
	            if (emailCount > 0) {
	                // 이메일이 이미 존재하면 회원가입을 중단하고 메시지를 보냄
	                request.setAttribute("error_message", "이미 사용 중인 이메일입니다.");
	                RequestDispatcher rd = request.getRequestDispatcher("join.jsp");
	                rd.forward(request, response);
	                return; // 다음 로직 실행 방지
	            }
				
				
				if (!userPw.equals(userPw2) ) {
					
					System.out.println("가입실패");
					response.sendRedirect(request.getContextPath() + "/jsp/join.jsp?error=pw_mismatch");
					
					return;
				}
				
				// 비밀번호 해싱
				String hashedPw = BCrypt.hashpw(userPw, BCrypt.gensalt());
				
				
				// 4. 받아온 데이터를 DB에 저장하는 작업
				
				UserInfo joinUser = new UserInfo();
				joinUser.setUSER_ID(userId);
				joinUser.setPASSWORD(hashedPw);
				joinUser.setEMAIL(email);
				joinUser.setUSER_NAME(username);
				joinUser.setPHONE(phone);
				joinUser.setJOIN_DATE(joinDate);
				joinUser.setUSER_ADRRESS(address);
				joinUser.setPASSWORD(hashedPw);
				
				
				// 5. DB연결할 수 있도록 UserDAO의 join메서드 호출
				// 		-> join메서드를 사용하기 위해서 UserDAO 객체 생성
				
				int cnt = dao.join(joinUser);
				
				
				// 6. 결과 값 처리
				if (cnt>0) {
					// insert구문 실행시, 영향 받은 행의 개수>0
					// -> 성공
					// 회원가입 성공-> 회원가입한 email 데이터를 가지고 페이지 이동
//					request.setAttribute("email", email);
					//forward방식으로 이동
					
					request.setAttribute("joinSuccess", "true");
					
					RequestDispatcher rd =
							request.getRequestDispatcher("/index.jsp");
					rd.forward(request, response);
//					return "index.html";
					// response.sendRedirect("join_success.jsp");
					
				}else {
					// 영향 받은 행의 개수 = 0, <0
					response.sendRedirect(request.getContextPath() + "/jsp/join.jsp");
//					return "redirect:/index.html";
					
				}
	
	}

}
