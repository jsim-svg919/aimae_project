package com.aimae.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aimae.model.Cart;
import com.aimae.model.CartDAO;
import com.aimae.model.UserInfo;

public class CartService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        System.out.println("=== CartService 시작 ===");
        System.out.println("Action: [" + action + "]");
        
        // action이 null이면 기본값으로 list 설정
        if (action == null) {
            action = "list";
        }
        
        // 공백 및 개행문자 제거
        if (action != null) {
            action = action.trim().replaceAll("[\\r\\n]", "");
        }
        
        System.out.println("공백 제거 후 Action: [" + action + "]");
        switch(action) {
            case "add":
                System.out.println("=== addCart 메서드 호출 시작 ===");
                addCart(request, response);
                System.out.println("=== addCart 메서드 호출 완료 ===");
                break;
            case "list":
                cartList(request, response);
                break;
            case "delete":
                deleteCart(request, response);
                break;
            case "update":
                updateCart(request, response);
                break;
            case "count":
                cartCount(request, response);
                break;
            default:
                System.out.println("잘못된 action: " + action);
                response.sendRedirect("jsp/cart.jsp?error=invalid_action");
                break;
        }
    }
    
    // 1. 장바구니에 상품 추가
    private void addCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== addCart 메서드 내부 시작 ===");
            HttpSession session = request.getSession();
            System.out.println("Session ID: " + session.getId());
            
            String userNum = (String) session.getAttribute("userNum");
            System.out.println("Session userNum: " + userNum);
            
            // userNum이 null이면 sUser에서 가져오기
            if (userNum == null) {
                System.out.println("userNum이 null입니다. sUser에서 가져오기 시도...");
                UserInfo sUser = (UserInfo) session.getAttribute("sUser");
                System.out.println("세션에서 가져온 sUser: " + sUser);
                if (sUser != null) {
                    userNum = sUser.getUSER_NUM();
                    System.out.println("sUser에서 가져온 userNum: " + userNum);
                    // 세션에 userNum도 저장
                    session.setAttribute("userNum", userNum);
                    System.out.println("userNum을 세션에 다시 저장: " + userNum);
                } else {
                    System.out.println("세션에 sUser가 없습니다!");
                }
            }
            
            System.out.println("최종 userNum 확인: " + userNum);
            if (userNum == null) {
                System.out.println("로그인되지 않음 - JSON 응답으로 로그인 필요 메시지 전송");
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"로그인 시 이용 가능합니다\", \"needLogin\": true}");
                return;
            }
            
            String productId = request.getParameter("productId");
            String delyAddress = request.getParameter("delyAddress");
            System.out.println("받은 productId: " + productId);
            System.out.println("받은 delyAddress: " + delyAddress);
            
            Cart cart = new Cart();
            cart.setUSER_NUM(userNum);
            cart.setPRODUCT_ID(productId);
            cart.setDELY_ADDRESS(delyAddress);
            
            System.out.println("Cart 객체 생성 완료: " + cart);
            CartDAO dao = new CartDAO();
            System.out.println("CartDAO 생성 완료");
            int result = dao.addCart(cart);
            System.out.println("DAO addCart 결과: " + result);
            
            if (result > 0) {
                System.out.println("장바구니 추가 성공");
                // JSON 응답으로 변경
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"장바구니에 추가되었습니다!\"}");
            } else {
                System.out.println("장바구니 추가 실패");
                // JSON 응답으로 변경
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"장바구니 추가에 실패했습니다.\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // 예외 발생 시에도 JSON 응답으로 처리
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"장바구니 추가 중 오류가 발생했습니다.\"}");
        }
    }
    
    private void cartList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            String userNum = (String) session.getAttribute("userNum");

            if (userNum == null) {
                UserInfo sUser = (UserInfo) session.getAttribute("sUser");
                if (sUser != null) {
                    userNum = sUser.getUSER_NUM();
                    session.setAttribute("userNum", userNum);
                }
            }

            if (userNum == null) {
                response.sendRedirect("jsp/login.jsp");
                return;
            }

            CartDAO dao = new CartDAO();
            List<Cart> cartList = dao.cartList(userNum);

            request.setAttribute("cartList", cartList);

            // ====== 분기 처리 ======
            String target = request.getParameter("target");
            if ("mypage".equals(target)) {
                request.getRequestDispatcher("jsp/mypage.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("jsp/cart.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/cart.jsp?error=list_fail");
        }
    }

    
    // 3. 장바구니에서 상품 삭제
    private void deleteCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String cartId = request.getParameter("cartId");
            
            CartDAO dao = new CartDAO();
            int result = dao.deleteCart(cartId);
            
            if (result > 0) {
                System.out.println("장바구니 삭제 성공");
            } else {
                System.out.println("장바구니 삭제 실패");
            }
            
            // 삭제 후 CartService로 리다이렉트 (CSS 유지)
            response.sendRedirect("CartService?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CartService?action=list&error=delete_fail");
        }
    }
    
    // 4. 장바구니 상품 수정
    private void updateCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            String userNum = (String) session.getAttribute("userNum");
            
            if (userNum == null) {
                response.sendRedirect("jsp/login.jsp");
                return;
            }
            
            String cartId = request.getParameter("cartId");
            String delyAddress = request.getParameter("delyAddress");
            
            Cart cart = new Cart();
            cart.setCART_ID(cartId);
            cart.setUSER_NUM(userNum);  // 현재 로그인한 사용자 ID 추가
            cart.setDELY_ADDRESS(delyAddress);
            
            CartDAO dao = new CartDAO();
            int result = dao.updateCart(cart);
            
            if (result > 0) {
                System.out.println("장바구니 수정 성공");
            } else {
                System.out.println("장바구니 수정 실패");
            }
            
            response.sendRedirect("CartService?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CartService?action=list&error=update_fail");
        }
    }
    
    // 5. 장바구니 개수 조회
    private void cartCount(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            String userNum = (String) session.getAttribute("userNum");
            
            if (userNum == null) {
                response.getWriter().write("0");
                return;
            }
            
            CartDAO dao = new CartDAO();
            int count = dao.cartCount(userNum);
            
            response.getWriter().write(String.valueOf(count));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("0");
        }
    }
}