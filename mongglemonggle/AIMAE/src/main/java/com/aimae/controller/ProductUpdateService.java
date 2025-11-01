package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.aimae.model.Product;
import com.aimae.model.ProductDAO;

public class ProductUpdateService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 파라미터 받기
        String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String category = request.getParameter("category");
        String stockStr = request.getParameter("stock");
        String priceStr = request.getParameter("price");
        
        try {
            // 숫자 변환
            int stock = Integer.parseInt(stockStr);
            int price = Integer.parseInt(priceStr);
            
            // Product 객체 생성
            Product product = new Product();
            product.setPRODUCT_ID(productId);
            product.setPRODUCT_NAME(productName);
            product.setCATEGORY(category);
            product.setSTOCK(stock);
            product.setPRICE(price);
            
            // DAO를 통한 업데이트
            ProductDAO dao = new ProductDAO();
            int result = dao.updateProduct(product);
            
            if (result > 0) {
                // 성공 시 관리자 페이지로 리다이렉트
                response.sendRedirect("jsp/admin.jsp?tab=products&update=success");
            } else {
                // 실패 시 에러 메시지와 함께 리다이렉트
                response.sendRedirect("jsp/admin.jsp?tab=products&update=fail");
            }
            
        } catch (NumberFormatException e) {
            // 숫자 변환 실패 시
            response.sendRedirect("jsp/admin.jsp?tab=products&update=invalid");
        } catch (Exception e) {
            // 기타 예외 발생 시
            e.printStackTrace();
            response.sendRedirect("jsp/admin.jsp?tab=products&update=error");
        }
    }
}
