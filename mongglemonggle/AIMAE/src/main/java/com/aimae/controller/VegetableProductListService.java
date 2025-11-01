package com.aimae.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import com.aimae.model.Product;
import com.aimae.model.ProductDAO;
import java.sql.*;

public class VegetableProductListService extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== VegetableProductListService 시작 ===");
        request.setCharacterEncoding("UTF-8");

        try {
            // 채소 카테고리 상품만 조회
            ProductDAO dao = new ProductDAO();
            System.out.println("ProductDAO 생성 완료");
            

            
            // 새로운 메서드 사용
            List<Product> vegetableProducts = dao.searchVegetableProducts();
            System.out.println("채소 상품 조회 완료");
            System.out.println("채소 상품 개수: " + vegetableProducts.size());
            
            if (vegetableProducts != null && !vegetableProducts.isEmpty()) {
                for(Product p : vegetableProducts) {
                    System.out.println("채소: " + p.getPRODUCT_NAME() + " - " + p.getCATEGORY());
                }
            } else {
                System.out.println("채소 상품이 없습니다.");
            }
            
            request.setAttribute("products", vegetableProducts);
            request.setAttribute("category", "채소");
            
            System.out.println("request.setAttribute 완료");
            System.out.println("forward 시작");
            request.getRequestDispatcher("/jsp/vegetableProducts.jsp").forward(request, response);
            System.out.println("forward 완료");
            
        } catch (Exception e) {
            System.out.println("=== 오류 발생 ===");
            e.printStackTrace();
            System.out.println("오류 메시지: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
