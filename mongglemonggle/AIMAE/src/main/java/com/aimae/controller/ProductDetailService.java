package com.aimae.controller;

import com.aimae.model.Product_Detail;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aimae.model.Product;
import com.aimae.model.ProductDAO;

@WebServlet(name = "ProductDetailService", urlPatterns = { "/ProductDetail" })
public class ProductDetailService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		try {
			System.out.println("=== ProductDetailService 시작 ===");
			request.setCharacterEncoding("UTF-8");
	        
	        String productId = request.getParameter("productId");
	        System.out.println("받은 productId: " + productId);
	        
	        // productId가 null이거나 빈 문자열인 경우 처리
//	        if (productId == null || productId.trim().isEmpty()) {
//	            System.out.println("productId가 null이거나 빈 문자열입니다.");
//	            response.sendRedirect(request.getContextPath() + "/ProductList");
//	            return;
//	        }
	        
	        System.out.println("ProductDAO 생성 시작");
	        ProductDAO dao = new ProductDAO();
	        System.out.println("ProductDAO 생성 완료");
	        
	        System.out.println("searchProductId 호출 시작");
	        Product product = dao.searchProductId(productId);
	        System.out.println("searchProductId 호출 완료");
	        System.out.println("조회된 상품: " + product);
	        
	        // 상품이 존재하지 않는 경우 처리
//	        if (product == null) {
//	            System.out.println("상품이 존재하지 않습니다.");
//	            response.sendRedirect(request.getContextPath() + "/ProductList");
//	            return;
//	        }
	        
	        // Product_Detail 조회
	        Product_Detail productDetail = dao.searchProductDetail(productId);
	        
	        // 세션에 상품 정보 저장 (다른 페이지에서도 사용 가능)
            request.getSession().setAttribute("product", product);
            request.getSession().setAttribute("productDetail", productDetail);
	        
	        System.out.println("request.setAttribute 시작");
	        request.setAttribute("product", product);
	        request.setAttribute("productDetail", productDetail);
	        // CSS 경로 설정
	        request.setAttribute("cssPath", request.getContextPath() + "/css");
	        request.setAttribute("imagePath", request.getContextPath() + "/images");
	        request.setAttribute("jsPath", request.getContextPath() + "/js");
	        System.out.println("request.setAttribute 완료");
	        
	        System.out.println("forward 시작");
	        request.getRequestDispatcher("/jsp/productDetail.jsp").forward(request, response);
	        System.out.println("forward 완료");
	        
		} catch (Exception e) {
			System.out.println("=== 오류 발생 ===");
			e.printStackTrace();
			System.out.println("오류 메시지: " + e.getMessage());
//			response.sendRedirect(request.getContextPath() + "/ProductList");
		}
	}
}