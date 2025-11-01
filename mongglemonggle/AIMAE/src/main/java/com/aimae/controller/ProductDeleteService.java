package com.aimae.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.aimae.model.ProductDAO;

public class ProductDeleteService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 파라미터 받기
        String productId = request.getParameter("productId");
        
        try {
            // DAO를 통한 삭제
            ProductDAO dao = new ProductDAO();
            int result = dao.deleteProduct(productId);
            
            if (result > 0) {
                // 성공 시 관리자 페이지로 리다이렉트
                response.sendRedirect("jsp/admin.jsp?tab=products&delete=success");
            } else {
                // 실패 시 에러 메시지와 함께 리다이렉트
                response.sendRedirect("jsp/admin.jsp?tab=products&delete=fail");
            }
            
        } catch (Exception e) {
            // 기타 예외 발생 시
            e.printStackTrace();
            response.sendRedirect("jsp/admin.jsp?tab=products&delete=error");
        }
    }
}


