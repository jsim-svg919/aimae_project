package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.aimae.model.CartDAO;

@WebServlet("/PaymentComplete")
public class PaymentCompleteService extends HttpServlet {
    
    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 로그인한 사용자 정보 가져오기
        HttpSession session = request.getSession();
        String userNum = (String) session.getAttribute("userNum");
        
        // 2. 로그인 안했으면 로그인 페이지로 이동
        if (userNum == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }
        
        // 3. 장바구니 DAO 생성
        CartDAO cartDAO = new CartDAO();
        
        try {
            // 4. 선택된 상품들 처리
            String selectedItemsParam = request.getParameter("selectedItems");
            
            if (selectedItemsParam != null && !selectedItemsParam.isEmpty()) {
                // 선택된 상품들만 결제완료로 변경
                String[] selectedCartIds = selectedItemsParam.split(",");
                
                for (String cartId : selectedCartIds) {
                    cartDAO.updateCartStatusById(cartId);
                }
            }
            
            // 5. 장바구니 관련 캐시만 클리어
            session.removeAttribute("latestCartData");
            
            // 6. 결제 완료 페이지로 이동
            response.sendRedirect("/AIMAE/jsp/payment.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/cart.jsp?error=payment_failed");
        }
    }
}