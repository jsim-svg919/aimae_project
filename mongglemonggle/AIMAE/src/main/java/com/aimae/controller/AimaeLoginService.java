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

@WebServlet("/AimaeLoginService")
public class AimaeLoginService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userId = request.getParameter("USER_ID");
        String inputPw = request.getParameter("PASSWORD"); // 사용자가 입력한 비밀번호

        UserDAO dao = new UserDAO();
        UserInfo dbUser = dao.login(userId); // 아이디로만 조회

        if (dbUser != null) {
            String storedHashedPw = dbUser.getPASSWORD(); // DB에 저장된 해시값

            if (BCrypt.checkpw(inputPw, storedHashedPw)) {
                // ✅ 로그인 성공
                HttpSession session = request.getSession();
                session.setAttribute("sUser", dbUser);
                session.setAttribute("userNum", dbUser.getUSER_NUM());
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
        }

        // 로그인 실패 (아이디 없음 또는 비밀번호 불일치)
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?login=err");
    }
}
