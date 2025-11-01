<%@page import="com.aimae.model.UserInfo"%>
<%@page import="com.aimae.model.Product"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.aimae.model.UserDAO"%>
<%@page import="com.aimae.model.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AIMAE</title>

    <!-- Favicon -->
    <link rel="icon" href="../images/favicon.ico" sizes="52x52" type="image/png">

    <!-- Style -->
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="brand">
             <a href="../index.jsp" class="logo">
                <span style="margin-left: 10px;">AIMAE</span>
            </a>
        </div>
        <div class="nav">
            <ul class="nav-ul">
                <li><a href="#" class="link">회원관리</a></li>
                <li><a href="#" class="link">주문관리</a></li>
                <li><a href="#" class="link">상품관리</a></li>
            </ul>
        </div>
    </div>

    <!-- Content -->
    <div class="admin-container">
        <h2 class="admin-title">관리자페이지</h2>
        <div style="border-bottom: 2px solid #8c52ff; margin-bottom: 2rem;"></div>

        <div class="admin-sections">
            <!-- 사이드바 -->
            <div class="admin-sidebar">
                <ul>
                    <li><a href="#" id="manageUsers">회원 관리</a></li>
                    <li><a href="#" id="manageOrders">주문 관리</a></li>
                    <li><a href="#" id="manageProducts">상품 관리</a></li>
                    <li><a href="/AIMAE/LogoutService">로그아웃</a></li>
                </ul>
            </div>

            <!-- 메인 콘텐츠 -->
            <div class="admin-content">
                <!-- 회원 관리 -->
                <div id="usersSection">
                    <h3>회원 관리</h3>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>회원번호</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>가입일</th>
                                <th>등급</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        	UserDAO dao = new UserDAO();
                        	List<UserInfo> result = dao.select();
                        	System.out.print(result.size());
                        	for(int i= 0; i <result.size(); i++){
                        %>
                            <tr>
                                <td><%=result.get(i).getUSER_NUM() %></td>
                                <td><%=result.get(i).getUSER_NAME() %></td>
                                <td><%=result.get(i).getEMAIL() %></td>
                                <td><%=result.get(i).getJOIN_DATE() %></td>
                                <td><%=result.get(i).getGRADE() %></td>
                                <td style="white-space: nowrap; text-align: center;">
                                    <button class="edit-btn" style="margin-right: 5px;" onclick="editUser('<%=result.get(i).getUSER_NUM()%>', '<%=result.get(i).getUSER_NAME()%>', '<%=result.get(i).getEMAIL()%>')"><i class="fa-solid fa-pen"></i></button>
                                    <button class="delete-btn" onclick="deleteUser('<%=result.get(i).getUSER_NUM()%>', '<%=result.get(i).getUSER_NAME()%>')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                        <%
                        	}
                        %>
                        </tbody>
                    </table>
                </div>

                <!-- 주문 관리 -->
                <div id="ordersSection" style="display:none;">
                    <h3>주문 관리</h3>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>회원</th>
                                <th>상품명</th>
                                <th>날짜</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#20250810</td>
                                <td>한찬희</td>
                                <td>AI 스마트 스피커</td>
                                <td>2025-08-10</td>
                                <td>배송중</td>
                                <td style="white-space: nowrap; text-align: center;">
                                    <button class="update-btn" onclick="updateOrder('#20250810', '한찬희', 'AI 스마트 스피커')"><i class="fa-solid fa-pen-to-square"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 상품 관리 -->
                <div id="productsSection" style="display:none;">
                    <h3>상품 관리</h3>
                     
                 <!-- 업데이트 결과 메시지 -->
                    <%
                      String updateResult = request.getParameter("update");
                      if (updateResult != null) {
                      if (updateResult.equals("success")) {
                    %>
                      <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 20px; border: 1px solid #c3e6cb; border-radius: 4px;">
                       ✅ 상품이 성공적으로 수정되었습니다!
                      </div>
                      <%
                       } else if (updateResult.equals("fail")) {
                      %>
                      <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                       ❌ 상품 수정에 실패했습니다. 다시 시도해주세요.
                      </div>
                      <%
                      } else if (updateResult.equals("invalid")) {
                      %>
                      <div style="background-color: #fff3cd; color: #856404; padding: 10px; margin-bottom: 20px; border: 1px solid #ffeaa7; border-radius: 4px;">
                      ⚠️ 잘못된 입력값입니다. 재고와 가격은 숫자로 입력해주세요.
                      </div>
                      <%
                      } else if (updateResult.equals("error")) {
                      %>
                      <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                      ❌ 오류가 발생했습니다. 다시 시도해주세요.
                      </div>
                      <%
                              }
                          }
                      %>
                      
                      <!-- 등록 결과 메시지 -->
                      <%
                      String registResult = request.getParameter("regist");
                      if (registResult != null) {
                      if (registResult.equals("success")) {
                      %>
                      <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 20px; border: 1px solid #c3e6cb; border-radius: 4px;">
                      ✅ 상품이 성공적으로 등록되었습니다!
                      </div>
                      <%
                      } else if (registResult.equals("fail")) {
                      %>
                      <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                      ❌ 상품 등록에 실패했습니다. 다시 시도해주세요.
                      </div>
                      <%
                      } else if (registResult.equals("invalid")) {
                      %>
                      <div style="background-color: #fff3cd; color: #856404; padding: 10px; margin-bottom: 20px; border: 1px solid #ffeaa7; border-radius: 4px;">
                      ⚠️ 잘못된 입력값입니다. 재고와 가격은 숫자로 입력해주세요.
                      </div>
                      <%
                      } else if (registResult.equals("error")) {
                      %>
                      <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                      ❌ 오류가 발생했습니다. 다시 시도해주세요.
                      </div>
                      <%
                              }
                          }
                      %>
                      
                      <!-- 삭제 결과 메시지 -->
                      <%
                      String deleteResult = request.getParameter("delete");
                      if (deleteResult != null) {
                      if (deleteResult.equals("success")) {
                      %>
                      <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 20px; border: 1px solid #c3e6cb; border-radius: 4px;">
                      ✅ 상품이 성공적으로 삭제되었습니다!
                      </div>
                      <%
                      } else if (deleteResult.equals("fail")) {
                      %>
                      <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                      ❌ 상품 삭제에 실패했습니다. 다시 시도해주세요.
                      </div>
                      <%
                      } else if (deleteResult.equals("error")) {
                      %>
                      <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                      ❌ 오류가 발생했습니다. 다시 시도해주세요.
                      </div>
                      <%
                              }
                          }
                      %>
                    
                     <!-- 검색 기능 -->
                     <div style="margin-bottom: 20px; display: flex; gap: 10px; align-items: center;">
                     <input type="text" id="searchInput" placeholder="상품명을 입력하세요..." style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 200px;">
                     <button onclick="searchProducts()" style="padding: 8px 16px; background-color: #8c52ff; color: white; border: none; border-radius: 4px; cursor: pointer;">
                     <i class="fa-solid fa-search"></i> 검색
                     </button>
                     <button onclick="clearSearch()" style="padding: 8px 16px; background-color: #666; color: white; border: none; border-radius: 4px; cursor: pointer;">
                     <i class="fa-solid fa-times"></i> 초기화
                     </button>
                     <button onclick="showAddProductModal()" style="padding: 8px 16px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; margin-left: auto;">
                     <i class="fa-solid fa-plus"></i> 상품 등록
                     </button>
                     </div>
                    
                    <%
                    ProductDAO productDao = new ProductDAO();
                    List<Product> allProducts = productDao.searchAllProducts();
                        
                    // 검색 필터링
                    String searchKeyword = request.getParameter("search");
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    List<Product> filteredProducts = new ArrayList<>();
                    for (Product p : allProducts) {
                    if (p.getPRODUCT_NAME().toLowerCase().contains(searchKeyword.toLowerCase())) {
                        filteredProducts.add(p);
                         }
                        }
                        allProducts = filteredProducts;
                     }
                        
                        // 페이지네이션 설정
                        int itemsPerPage = 5; // 한 페이지당 5개
                        int currentPage = 1;
                        
                        // 현재 페이지 파라미터 받기
                        String pageParam = request.getParameter("page");
                        if (pageParam != null && !pageParam.isEmpty()) {
                            currentPage = Integer.parseInt(pageParam);
                        }
                        
                        // 전체 페이지 수 계산
                        int totalItems = allProducts.size();
                        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
                        
                        // 현재 페이지에 해당하는 상품들만 추출
                        int startIndex = (currentPage - 1) * itemsPerPage;
                        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
                        
                        List<Product> products = allProducts.subList(startIndex, endIndex);
                    %>
                    
                    <!-- 페이지네이션 -->
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>상품번호</th>
                                <th>상품명</th>
                                <th>카테고리</th>
                                <th>재고</th>
                                <th>가격</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for(Product p : products) {
                            %>
                            <tr>
                                <td><%=p.getPRODUCT_ID()%></td>
                                <td><%=p.getPRODUCT_NAME()%></td>
                                <td><%=p.getCATEGORY()%></td>
                                <td><%=p.getSTOCK()%></td>
                                <td>₩<%=String.format("%,d", p.getPRICE())%></td>
                                <td style="white-space: nowrap; text-align: center;">
                                    <button class="edit-btn" style="margin-right: 5px;" onclick="editProduct('<%=p.getPRODUCT_ID()%>', '<%=p.getPRODUCT_NAME()%>', '<%=p.getCATEGORY()%>', '<%=p.getSTOCK()%>', '<%=p.getPRICE()%>')"><i class="fa-solid fa-pen"></i></button>
                                    <button class="delete-btn" onclick="deleteProduct('<%=p.getPRODUCT_ID()%>', '<%=p.getPRODUCT_NAME()%>')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>

                    <!-- 페이지네이션 -->
                    <div class="pagination" style="text-align: center; margin-top: 20px; margin-bottom: 50px;">
                        <%
                            if (totalPages > 1) {
                        %>
                            <!-- 이전 페이지 -->
                            <% if (currentPage > 1) { %>
                                <a href="javascript:void(0)" onclick="goToPage(<%=currentPage-1%>)" class="page-link" style="margin: 0 5px; padding: 5px 10px; text-decoration: none; border: 1px solid #ddd; color: #333; cursor: pointer;">이전</a>
                            <% } %>
                            
                            <!-- 페이지 번호들 -->
                            <% 
                                int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);
                                
                                for (int i = startPage; i <= endPage; i++) {
                            %>
                                <% if (i == currentPage) { %>
                                    <span class="page-link current" style="margin: 0 5px; padding: 5px 10px; background-color: #8c52ff; color: white; border: 1px solid #8c52ff;"><%=i%></span>
                                <% } else { %>
                                    <a href="javascript:void(0)" onclick="goToPage(<%=i%>)" class="page-link" style="margin: 0 5px; padding: 5px 10px; text-decoration: none; border: 1px solid #ddd; color: #333; cursor: pointer;"><%=i%></a>
                                <% } %>
                            <% } %>
                            
                            <!-- 다음 페이지 -->
                            <% if (currentPage < totalPages) { %>
                                <a href="javascript:void(0)" onclick="goToPage(<%=currentPage+1%>)" class="page-link" style="margin: 0 5px; padding: 5px 10px; text-decoration: none; border: 1px solid #ddd; color: #333; cursor: pointer;">다음</a>
                            <% } %>
                            
                            <!-- 전체 정보 -->
                            <div style="margin-top: 10px; color: #666;">
                                총 <%=totalItems%>개 상품 중 <%=startIndex+1%>-<%=endIndex%>번째 상품 (페이지 <%=currentPage%>/<%=totalPages%>)
                            </div>
                        <%
                            }
                        %>
                                         </div>
                 </div>
             </div>
         </div>
           </div>
      
      <!-- 상품 등록 모달 -->
      <div id="addProductModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4);">
          <div class="modal-content" style="background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 50%; border-radius: 8px;">
              <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                  <h3 style="margin: 0; color: #333;">상품 등록</h3>
                  <span class="close" onclick="closeAddModal()" style="color: #aaa; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
              </div>
              
                             <form id="addProductForm" action="../ProductRegist" method="post" enctype="multipart/form-data">
                  <div style="margin-bottom: 15px;">
                      <label for="addProductName" style="display: block; margin-bottom: 5px; font-weight: bold;">상품명:</label>
                      <input type="text" id="addProductName" name="productName" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                  </div>
                  
                  <div style="margin-bottom: 15px;">
                      <label for="addCategory" style="display: block; margin-bottom: 5px; font-weight: bold;">카테고리:</label>
                      <select id="addCategory" name="category" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                          <option value="과일">과일</option>
                          <option value="야채">야채</option>
                          <option value="가전제품">가전제품</option>
                      </select>
                  </div>
                  
                  <div style="margin-bottom: 15px;">
                      <label for="addStock" style="display: block; margin-bottom: 5px; font-weight: bold;">재고:</label>
                      <input type="number" id="addStock" name="stock" required min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                  </div>
                  
                  <div style="margin-bottom: 15px;">
                      <label for="addPrice" style="display: block; margin-bottom: 5px; font-weight: bold;">가격:</label>
                      <input type="number" id="addPrice" name="price" required min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                  </div>
                  
                                     <div style="margin-bottom: 15px;">
                       <label for="addPrdInfo" style="display: block; margin-bottom: 5px; font-weight: bold;">상품 설명:</label>
                       <textarea id="addPrdInfo" name="prdInfo" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; height: 80px; resize: vertical;"></textarea>
                   </div>
                   
                   <div style="margin-bottom: 20px;">
                       <label for="addProductImage" style="display: block; margin-bottom: 5px; font-weight: bold;">상품 이미지:</label>
                       <input type="file" id="addProductImage" name="productImage" accept="image/*" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                       <small style="color: #666; font-size: 12px;">지원 형식: JPG, PNG, GIF (최대 5MB)</small>
                   </div>
                  
                  <div style="text-align: right;">
                      <button type="button" onclick="closeAddModal()" style="padding: 8px 16px; margin-right: 10px; background-color: #666; color: white; border: none; border-radius: 4px; cursor: pointer;">취소</button>
                      <button type="submit" style="padding: 8px 16px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;">등록</button>
                                </div>
                            </form>
                        </div>
                    </div>

      <!-- 상품 수정 모달 -->
      <div id="editProductModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4);">
         <div class="modal-content" style="background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 50%; border-radius: 8px;">
             <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                 <h3 style="margin: 0; color: #333;">상품 수정</h3>
                 <span class="close" onclick="closeEditModal()" style="color: #aaa; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
             </div>
             
                             <form id="editProductForm" action="../ProductUpdateService" method="post">
                 <div style="margin-bottom: 15px;">
                     <label for="editProductId" style="display: block; margin-bottom: 5px; font-weight: bold;">상품 ID:</label>
                     <input type="text" id="editProductId" name="productId" readonly style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background-color: #f9f9f9;">
                 </div>
                 
                 <div style="margin-bottom: 15px;">
                     <label for="editProductName" style="display: block; margin-bottom: 5px; font-weight: bold;">상품명:</label>
                     <input type="text" id="editProductName" name="productName" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                 </div>
                 
                 <div style="margin-bottom: 15px;">
                     <label for="editCategory" style="display: block; margin-bottom: 5px; font-weight: bold;">카테고리:</label>
                     <select id="editCategory" name="category" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                         <option value="과일">과일</option>
                         <option value="야채">야채</option>
                         <option value="가전제품">가전제품</option>
                     </select>
                 </div>
                 
                 <div style="margin-bottom: 15px;">
                     <label for="editStock" style="display: block; margin-bottom: 5px; font-weight: bold;">재고:</label>
                     <input type="number" id="editStock" name="stock" required min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                 </div>
                 
                 <div style="margin-bottom: 20px;">
                     <label for="editPrice" style="display: block; margin-bottom: 5px; font-weight: bold;">가격:</label>
                     <input type="number" id="editPrice" name="price" required min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
                 
                 <div style="text-align: right;">
                     <button type="button" onclick="closeEditModal()" style="padding: 8px 16px; margin-right: 10px; background-color: #666; color: white; border: none; border-radius: 4px; cursor: pointer;">취소</button>
                     <button type="submit" style="padding: 8px 16px; background-color: #8c52ff; color: white; border: none; border-radius: 4px; cursor: pointer;">수정</button>
            </div>
             </form>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h4 style="margin-bottom: 22px;">회사 정보</h4>
                <p class="footer-p">주소 : 서울특별시 강남구</p>
                <p class="footer-p">전화 : 010-1234-5678</p>
                <p class="footer-p">이메일 : support@aimae.com</p>
            </div>
            <div class="footer-section">
                <h4>고객센터</h4>
                <ul>
                    <li class="footer-tag"><a href="#">FAQ</a></li>
                    <li class="footer-tag"><a href="#">반품/교환</a></li>
                    <li class="footer-tag"><a href="#">배송정보</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>소셜 미디어</h4>
                <div class="social-icons">
                    <a href="https://www.facebook.com" target="_blank"><i class="fab fa-facebook-f"></i></a>
                    <a href="https://www.twitter.com" target="_blank"><i class="fab fa-twitter"></i></a>
                    <a href="https://www.instagram.com/chan2hee1" target="_blank"><i class="fab fa-instagram"></i></a>
                    <a href="https://www.linkedin.com" target="_blank"><i class="fab fa-linkedin-in"></i></a>
                </div>
                <div>
                    <img src="../images/favicon.ico" alt="" style="width: 5rem;">
                </div>
            </div>
        </div>
        <div class="footer-bottom"><p>&copy; 2025 AIMAE</p></div>
    </div>

    <!-- JS -->
     <!-- admin.js 제거 - 탭 전환 충돌 방지 -->
     
     <style>
         /* 테이블 스타일 개선 */
         .admin-table {
             table-layout: fixed;
             width: 100%;
         }
         
         .admin-table th,
         .admin-table td {
             padding: 12px 8px;
             vertical-align: middle;
             word-wrap: break-word;
             overflow: hidden;
             text-overflow: ellipsis;
             max-width: 0;
         }
         
         /* 상품명 컬럼은 더 넓게 */
         .admin-table th:nth-child(2),
         .admin-table td:nth-child(2) {
             width: 25%;
         }
         
         /* 관리 버튼 컬럼은 고정 너비 */
         .admin-table th:last-child,
         .admin-table td:last-child {
             width: 120px;
             min-width: 120px;
         }
         
         /* 버튼 스타일 개선 */
         .edit-btn, .delete-btn, .update-btn {
             padding: 6px 8px;
             border: none;
             border-radius: 4px;
             cursor: pointer;
             font-size: 12px;
         }
         
         .edit-btn {
             background-color: #007bff;
             color: white;
         }
         
         .delete-btn {
             background-color: #dc3545;
             color: white;
         }
         
         .update-btn {
             background-color: #28a745;
             color: white;
         }
         
         .edit-btn:hover, .delete-btn:hover, .update-btn:hover {
             opacity: 0.8;
         }
     </style>
     
     <script>
                 // 탭 전환 기능
         document.addEventListener('DOMContentLoaded', function() {
             // 탭 버튼들
             var manageUsersBtn = document.getElementById('manageUsers');
             var manageOrdersBtn = document.getElementById('manageOrders');
             var manageProductsBtn = document.getElementById('manageProducts');
             
             // 섹션들
             var usersSection = document.getElementById('usersSection');
             var ordersSection = document.getElementById('ordersSection');
             var productsSection = document.getElementById('productsSection');
             
             // URL에서 탭 파라미터 확인
             var urlParams = new URLSearchParams(window.location.search);
             var currentTab = urlParams.get('tab');
             
             // 기본적으로 회원관리 탭 표시
             usersSection.style.display = 'block';
             ordersSection.style.display = 'none';
             productsSection.style.display = 'none';
             
             // 탭 파라미터가 있으면 해당 탭 표시
             if (currentTab === 'products') {
                 usersSection.style.display = 'none';
                 ordersSection.style.display = 'none';
                 productsSection.style.display = 'block';
             } else if (currentTab === 'orders') {
                 usersSection.style.display = 'none';
                 ordersSection.style.display = 'block';
                 productsSection.style.display = 'none';
             }
             
             // 회원 관리 탭 클릭
             manageUsersBtn.addEventListener('click', function(e) {
                 e.preventDefault();
                 usersSection.style.display = 'block';
                 ordersSection.style.display = 'none';
                 productsSection.style.display = 'none';
             });
             
             // 주문 관리 탭 클릭
             manageOrdersBtn.addEventListener('click', function(e) {
                 e.preventDefault();
                 usersSection.style.display = 'none';
                 ordersSection.style.display = 'block';
                 productsSection.style.display = 'none';
             });
             
             // 상품 관리 탭 클릭
             manageProductsBtn.addEventListener('click', function(e) {
                 e.preventDefault();
                 usersSection.style.display = 'none';
                 ordersSection.style.display = 'none';
                 productsSection.style.display = 'block';
             });
         });
        
                 // 검색 기능
         function searchProducts() {
             var searchKeyword = document.getElementById('searchInput').value;
             if (searchKeyword.trim() !== '') {
                 window.location.href = '?search=' + encodeURIComponent(searchKeyword) + '&tab=products';
             }
         }
         
         // 검색 초기화
         function clearSearch() {
             window.location.href = window.location.pathname + '?tab=products';
         }
        
                 // 페이지 이동 함수
         function goToPage(pageNum) {
             var urlParams = new URLSearchParams(window.location.search);
             var searchParam = urlParams.get('search');
             
             var newUrl = '?page=' + pageNum + '&tab=products';
             if (searchParam && searchParam.trim() !== '') {
                 newUrl += '&search=' + encodeURIComponent(searchParam);
             }
             
             window.location.href = newUrl;
         }
        
                 // Enter 키로 검색
         document.addEventListener('DOMContentLoaded', function() {
             var searchInput = document.getElementById('searchInput');
             if (searchInput) {
                 searchInput.addEventListener('keypress', function(e) {
                     if (e.key === 'Enter') {
                         searchProducts();
                     }
                 });
                 
                 // URL에서 검색어 가져와서 입력창에 표시
                 var urlParams = new URLSearchParams(window.location.search);
                 var searchParam = urlParams.get('search');
                 if (searchParam) {
                     searchInput.value = searchParam;
                 }
             }
         });
         
                   // 상품 등록 모달 표시 함수
          function showAddProductModal() {
              document.getElementById('addProductModal').style.display = 'block';
          }
          
          // 상품 등록 모달 닫기 함수
          function closeAddModal() {
              document.getElementById('addProductModal').style.display = 'none';
          }
          
          // 상품 수정 함수
          function editProduct(productId, productName, category, stock, price) {
              // 모달에 데이터 설정
              document.getElementById('editProductId').value = productId;
              document.getElementById('editProductName').value = productName;
              document.getElementById('editCategory').value = category;
              document.getElementById('editStock').value = stock;
              document.getElementById('editPrice').value = price;
              
              // 모달 표시
              document.getElementById('editProductModal').style.display = 'block';
          }
          
          // 모달 닫기 함수
          function closeEditModal() {
              document.getElementById('editProductModal').style.display = 'none';
          }
          
          // 모달 외부 클릭 시 닫기
          window.onclick = function(event) {
              var addModal = document.getElementById('addProductModal');
              var editModal = document.getElementById('editProductModal');
              if (event.target == addModal) {
                  addModal.style.display = 'none';
              }
              if (event.target == editModal) {
                  editModal.style.display = 'none';
              }
          }
         
         // 상품 삭제 함수
         function deleteProduct(productId, productName) {
             if (confirm('상품 "' + productName + '"을(를) 정말 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.')) {
                 // 폼 생성하여 POST 요청
                 var form = document.createElement('form');
                 form.method = 'POST';
                 form.action = '../ProductDelete';
                 
                 var productIdInput = document.createElement('input');
                 productIdInput.type = 'hidden';
                 productIdInput.name = 'productId';
                 productIdInput.value = productId;
                 
                 form.appendChild(productIdInput);
                 document.body.appendChild(form);
                 form.submit();
             }
         }
         
         // 회원 수정 함수
         function editUser(userNum, userName, email) {
             if (confirm('회원 "' + userName + '"의 정보를 수정하시겠습니까?')) {
                 alert('회원 수정 기능은 아직 구현되지 않았습니다.\n\n회원 정보:\n- 번호: ' + userNum + '\n- 이름: ' + userName + '\n- 이메일: ' + email);
                 // TODO: 실제 수정 기능 구현
             }
         }
         
         // 회원 삭제 함수
         function deleteUser(userNum, userName) {
             if (confirm('회원 "' + userName + '"을(를) 정말 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.')) {
                 alert('회원 삭제 기능은 아직 구현되지 않았습니다.\n\n삭제할 회원:\n- 번호: ' + userNum + '\n- 이름: ' + userName);
                 // TODO: 실제 삭제 기능 구현
             }
         }
         
         // 주문 상태 업데이트 함수
         function updateOrder(orderId, userName, productName) {
             if (confirm('주문 "' + orderId + '"의 상태를 업데이트하시겠습니까?')) {
                 alert('주문 상태 업데이트 기능은 아직 구현되지 않았습니다.\n\n주문 정보:\n- 주문번호: ' + orderId + '\n- 회원: ' + userName + '\n- 상품: ' + productName);
                 // TODO: 실제 업데이트 기능 구현
             }
         }
    </script>

   
</body>
</html>
