package com.aimae.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import com.aimae.model.Product;
import com.aimae.model.ProductDAO;

public class ElectronicProductListService extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ElectronicProductListService 시작 ===");
        request.setCharacterEncoding("UTF-8");

        try {
            // 전자제품 카테고리 상품만 조회
            ProductDAO dao = new ProductDAO();
            System.out.println("ProductDAO 생성 완료");
            
            // 새로운 메서드 사용
            List<Product> electronicProducts = dao.searchElectronicProducts();
            System.out.println("전자제품 상품 조회 완료");
            System.out.println("전자제품 상품 개수: " + electronicProducts.size());
            
            if (electronicProducts != null && !electronicProducts.isEmpty()) {
                for(Product p : electronicProducts) {
                    System.out.println("전자제품: " + p.getPRODUCT_NAME() + " - " + p.getCATEGORY());
                }
            } else {
                System.out.println("전자제품 상품이 없습니다.");
            }
            
            request.setAttribute("products", electronicProducts);
            request.setAttribute("category", "전자제품");
            
            System.out.println("request.setAttribute 완료");
            System.out.println("forward 시작");
            request.getRequestDispatcher("/jsp/electronicProducts.jsp").forward(request, response);
            System.out.println("forward 완료");
            
        } catch (Exception e) {
            System.out.println("=== 오류 발생 ===");
            e.printStackTrace();
            System.out.println("오류 메시지: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
