package com.aimae.controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.aimae.model.Product;
import com.aimae.model.ProductDAO;
import com.aimae.model.Photo;
import com.aimae.model.PhotoDAO;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ProductRegistService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 파라미터 받기
        String productName = request.getParameter("productName");
        String category = request.getParameter("category");
        String stockStr = request.getParameter("stock");
        String priceStr = request.getParameter("price");
        String prdInfo = request.getParameter("prdInfo");
        
        // 파일 업로드 처리
        String imageFileName = null;
        Part filePart = request.getPart("productImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            
            // 고유한 파일명 생성 (현재 시간 + 원본 확장자)
            imageFileName = "product_" + System.currentTimeMillis() + fileExtension;
            
            // 파일 저장 경로 설정
            String uploadPath = getServletContext().getRealPath("/images/products/");
            Path uploadDir = Paths.get(uploadPath);
            
            // 디렉토리가 없으면 생성
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }
            
            // 파일 저장
            Path filePath = uploadDir.resolve(imageFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
        }
        
        try {
            // 숫자 변환
            int stock = Integer.parseInt(stockStr);
            int price = Integer.parseInt(priceStr);
            
            			// Product 객체 생성 (ID는 데이터베이스 시퀀스에서 자동 생성)
			Product product = new Product();
			product.setPRODUCT_NAME(productName);
			product.setCATEGORY(category);
			product.setSTOCK(stock);
			product.setPRICE(price);
			product.setPRD_INFO(prdInfo);
			product.setPRD_DETAIL(prdInfo); // PRD_DETAIL도 PRD_INFO와 동일하게 설정
            
            // DAO를 통한 등록 (생성된 PRODUCT_ID 반환)
            ProductDAO dao = new ProductDAO();
            String createdProductId = dao.insertProductAndGetId(product);
            
            if (createdProductId != null) {
                // 상품 등록 성공 시 이미지 정보를 PHOTO 테이블에 저장
                if (imageFileName != null) {
                    try {
                        // PHOTO 테이블에 이미지 정보 저장
                        Photo photo = new Photo();
                        photo.setPRODUCT_ID(createdProductId);
                        photo.setPHOTO_PATH("/images/products/" + imageFileName);
                        
                        PhotoDAO photoDao = new PhotoDAO();
                        int photoResult = photoDao.insertPhoto(photo);
                        
                        if (photoResult > 0) {
                            System.out.println("이미지 정보가 PHOTO 테이블에 성공적으로 저장되었습니다. PRODUCT_ID: " + createdProductId);
                        } else {
                            System.out.println("이미지 정보 저장에 실패했습니다.");
                        }
                    } catch (Exception e) {
                        System.out.println("이미지 정보 저장 중 오류: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                
                // 성공 시 관리자 페이지로 리다이렉트
                response.sendRedirect("jsp/admin.jsp?tab=products&regist=success");
            } else {
                // 실패 시 에러 메시지와 함께 리다이렉트
                response.sendRedirect("jsp/admin.jsp?tab=products&regist=fail");
            }
            
        } catch (NumberFormatException e) {
            // 숫자 변환 실패 시
            response.sendRedirect("jsp/admin.jsp?tab=products&regist=invalid");
        } catch (Exception e) {
            // 기타 예외 발생 시
            e.printStackTrace();
            response.sendRedirect("jsp/admin.jsp?tab=products&regist=error");
        }
    }
}
