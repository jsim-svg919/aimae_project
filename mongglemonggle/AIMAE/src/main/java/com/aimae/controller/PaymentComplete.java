package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.aimae.model.CartDAO;

/**
 * 결제 완료 처리 서블릿
 * - 선택한 상품만 결제완료(STATUS=1)로 변경
 * - 결제 완료 후 payment.jsp로 이동
 */
@WebServlet("/PaymentComplete2")
public class PaymentComplete extends HttpServlet {
    
    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== PaymentComplete 시작 ===");
        System.out.println("요청 URL: " + request.getRequestURL());
        System.out.println("요청 파라미터: " + request.getQueryString());
        
        // 1. 로그인한 사용자 정보 가져오기
        HttpSession session = request.getSession();
        String userNum = (String) session.getAttribute("userNum");
        
        System.out.println("세션에서 가져온 userNum: " + userNum);
        
        // 2. 로그인 안했으면 로그인 페이지로 이동
        if (userNum == null) {
            System.out.println("userNum이 null이므로 로그인 페이지로 이동");
            response.sendRedirect("jsp/login.jsp");
            return;
        }
        
        // 3. 장바구니 DAO 생성
        CartDAO cartDAO = new CartDAO();
        System.out.println("CartDAO 생성 완료");
        
        try {
            System.out.println("=== try 블록 시작 ===");
            
            // 4. 선택된 상품들 처리
            String selectedItemsParam = request.getParameter("selectedItems");
            System.out.println("selectedItems 파라미터: " + selectedItemsParam);
            
            if (selectedItemsParam != null && !selectedItemsParam.isEmpty()) {
                // 선택된 상품들만 결제완료로 변경
                String[] selectedCartIds = selectedItemsParam.split(",");
                System.out.println("선택된 상품 개수: " + selectedCartIds.length);
                
                for (String cartId : selectedCartIds) {
                    System.out.println("선택 상품 결제완료 처리: " + cartId);
                    int updateResult = cartDAO.updateCartStatusById(cartId);
                    System.out.println("updateCartStatusById 결과: " + updateResult);
                }
            } else {
                // 선택된 상품이 없으면 모든 상품을 결제완료로 변경
                System.out.println("모든 상품 결제완료 처리 시작 - userNum: " + userNum);
                
                // 결제 전 장바구니 상태 확인
                System.out.println("cartCount 호출 시작");
                int beforeCount = cartDAO.cartCount(userNum);
                System.out.println("결제 전 장바구니 개수: " + beforeCount);
                
                // 장바구니 상태 업데이트
                System.out.println("updateAllCartStatus 호출 시작");
                int updateResult = cartDAO.updateAllCartStatus(userNum);
                System.out.println("updateAllCartStatus 결과: " + updateResult);
                
                // 결제 후 장바구니 상태 확인
                int afterCount = cartDAO.cartCount(userNum);
                System.out.println("결제 후 장바구니 개수: " + afterCount);
            }
            
            System.out.println("결제 처리 완료 - payment.jsp로 이동");
            
            // 5. 장바구니 관련 캐시만 클리어 (로그인 정보는 유지)
            session.removeAttribute("latestCartData");
            System.out.println("장바구니 캐시 클리어 완료");
            
            // 6. 결제 완료 페이지로 이동
            System.out.println("=== 결제 완료 - payment.jsp로 리다이렉트 시작 ===");
            System.out.println("리다이렉트 URL: jsp/payment.jsp");
            response.sendRedirect("jsp/payment.jsp");
            System.out.println("=== 리다이렉트 완료 ===");
            
        } catch (Exception e) {
            System.out.println("=== 결제 처리 중 오류 발생 ===");
            e.printStackTrace();
            System.out.println("오류 메시지: " + e.getMessage());
            System.out.println("오류 원인: " + e.getCause());
            response.sendRedirect("jsp/cart.jsp?error=payment_failed");
        }
    }
}
