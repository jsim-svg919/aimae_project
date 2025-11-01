<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
// 결제완료 주문 내역 조회 (강제 새로고침)
String userNum = (String) session.getAttribute("userNum");
System.out.println("=== mypage.jsp 디버깅 ===");
System.out.println("userNum: " + userNum);

if (userNum != null) {
    com.aimae.model.CartDAO cartDAO = new com.aimae.model.CartDAO();
    
    // MyBatis 캐시 클리어
    cartDAO.getSqlSession().clearCache();
    
    // STATUS=1인 상품들 조회
    java.util.List<com.aimae.model.Cart> purchasedCart = cartDAO.selectPurchasedCart(userNum);
    System.out.println("purchasedCart 크기: " + (purchasedCart != null ? purchasedCart.size() : "null"));
    
    if (purchasedCart != null && !purchasedCart.isEmpty()) {
        System.out.println("주문 내역 발견:");
        for (com.aimae.model.Cart item : purchasedCart) {
            System.out.println("- " + item.getCART_ID() + ": " + item.getPRODUCT_NAME() + " (STATUS: " + item.getSTATUS() + ")");
        }
    } else {
        System.out.println("주문 내역이 없습니다.");
    }
    
    request.setAttribute("purchasedCart", purchasedCart);
} else {
    System.out.println("userNum이 null입니다!");
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AIMAE</title>

    <!-- Favicon -->
    <link rel="icon" href="../images/favicon.ico" sizes="52x52" type="image/png">

    <!-- Style -->
    <link rel="stylesheet" href="../css/index.css">
    <link rel="stylesheet" href="../css/footer.css">
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/myPage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>

</head>

<body>
    <!-- Header -->
    <div class="header">
        <div class="brand">
            <div class="dropdown">
                <button class="category-logo">
                    <span><i class="fa-solid fa-bars"></i></span>
                </button>
                <div class="dropdown-content">
                    <a href="fruitProducts.jsp">과일</a>
                    <a href="vegetableProducts.jsp">채소</a>
                    <a href="electronicProducts.jsp">전자제품</a>
                </div>
            </div>
            <a href="../index.jsp" class="logo">
                <span style="margin-left: 10px;">AIMAE</span>
            </a>
        </div>

        <!-- 로그인 / 로그아웃 헤더 변경 -->
		<%@ include file="../loginheader.jsp" %>
		
    </div>

    <!-- Content -->
    <div class="my-page-container">
        <h2 class="my-page-title">마이페이지</h2>
        <div style="border-bottom: 1px solid #8c52ff;"></div>

        <div class="my-page-sections">
            <!-- 왼쪽 사이드 메뉴 -->
            <div class="my-page-sidebar">
                <ul>
                    <li><a href="#" id="showInfo">회원 정보</a></li>
                    <li><a href="#">주문 내역</a></li>
                    <li><a href="#">찜한 상품</a></li>
                    <li><a href="#">배송지 관리</a></li>
                    <li><a href="#" id="showEdit">정보 수정</a></li>
                    <li><a href="/AIMAE/LogoutService">로그아웃</a></li>
                    <li><a href="/AIMAE/UnregisterService">회원탈퇴</a></li>
                </ul>
            </div>

            <!-- 오른쪽 사이드 콘텐츠 -->
            <div class="my-page-content">
                <!-- 회원 정보 섹션 -->
                <div id="userInfoSection">
                    <div class="user-header">
                        <h3>회원정보</h3>
                    </div>

                    <div class="user-info-card">
                        <!-- 왼쪽: 기존 정보 -->
                        <div class="user-info">
                            <div class="info-item">
                                <div class="profile-icon"><i class="fa-solid fa-user"></i></div>
                                <div><strong>이름</strong><p>${sUser.USER_NAME }</p></div>
                            </div>
                            <div class="info-item">
                                <div class="email-icon"><i class="fa-solid fa-envelope"></i></div>
                                <div><strong>이메일</strong><p>${sUser.EMAIL }</p></div>
                            </div>
                            <div class="info-item">
                                <div class="phone-icon"><i class="fa-solid fa-mobile-screen-button"></i></div>
                                <c:choose>
									  <c:when test="${fn:length(sUser.PHONE) == 11}">
									    <div><strong>휴대폰</strong><p>${fn:substring(sUser.PHONE,0,3)}-${fn:substring(sUser.PHONE,3,7)}-${fn:substring(sUser.PHONE,7,11)}</p></div>
									  </c:when>
									  <c:otherwise>
									    <div><strong>휴대폰</strong><p>${sUser.PHONE}</p></div>
									  </c:otherwise>
								</c:choose>
                            </div>
                            <div class="info-item">
                                <div class="address-icon"><i class="fa-solid fa-house"></i></div>
                                <div><strong>주소</strong><p>${sUser.USER_ADRRESS }</p></div>
                            </div>
                            <div class="info-item">
                                <div class="calendar-icon"><i class="fa-solid fa-calendar-day"></i></div>
                                 <fmt:parseDate value="${sUser.JOIN_DATE}" pattern="yyyy-MM-dd" var="joinDate" />
                                <div><strong>가입일</strong><p><fmt:formatDate value="${joinDate }" pattern="yyyy년 MM월 dd일"/></p></div>
                            </div>
                        </div>

                        <div class="user-extra">
                            <div class="profile-photo">
                                <i class="fa-solid fa-user"></i>
                                <div>
                                    <h2>환영합니다, <a style="color: #8c52ff;">${sUser.USER_NAME }</a> 님 !</h2>
                                    <h3 style="color: #a7a7a7;">${sUser.EMAIL }</h3>
                                </div>
                            </div>

                            <div class="user-points">
                                <div class="point-card">
                                    <i class="fa-solid fa-coins"></i>
                                    <p><strong>포인트</strong></p>
                                    <span>1,250P</span>
                                </div>
                                <div class="point-card">
                                    <i class="fa-solid fa-ticket"></i>
                                    <p><strong>쿠폰</strong></p>
                                    <span>3장</span>
                                </div>
                                <div class="point-card">
                                    <i class="fa-solid fa-crown"></i>
                                    <p><strong>회원등급</strong></p>
                                    <span>${sUser.GRADE }</span>
                                </div>
                            </div>

                            <div class="logoList" style="display: flex; align-items: center; gap: 20px;">
                                <img src="../images/favicon.ico" alt="" style="width: 6rem;">
                                    <p style="font-weight: bold; font-size: 30px; color: #8c52ff">AIMAE</p>
                            </div>

                        </div>
                    </div>

                    <div style="border-bottom: 1px solid #8c52ff; margin-top: 2rem;"></div>
                    <h3>최근 주문</h3>
                    <div class="order-summary">
                        <table>
                            <thead>
                                <tr>
                                    <th>주문번호</th>
                                    <th>상품명</th>
                                    <th>날짜</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- 주문 내역이 있으면 보여주기 -->
                                <c:if test="${not empty purchasedCart}">
                                    <c:forEach var="order" items="${purchasedCart}" varStatus="status">
                                        <!-- 최대 10개까지만 보여주기 -->
                                        <c:if test="${status.index < 10}">
                                            <tr>
                                                <td>${order.CART_ID}</td>
                                                <td>${order.PRODUCT_NAME}</td>
                                                <td>
                                                    <fmt:parseDate value="${order.ORDER_DATE}" pattern="yyyy-MM-dd HH:mm:ss" var="orderDate" />
                                                    <fmt:formatDate value="${orderDate}" pattern="yyyy-MM-dd"/>
                                                </td>
                                                <td>결제완료</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                
                                <!-- 주문 내역이 없으면 보여주기 -->
                                <c:if test="${empty purchasedCart}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; color: #666;">주문 내역이 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 회원 정보 수정 폼 (처음엔 숨김) -->
                
<div id="editFormSection" style="display:none;">
  <div class="user-header">
    <h3><i class="fa-solid fa-user-pen"></i> 회원정보 수정</h3>
  </div>

  <div style="border-bottom: 1px solid #8c52ff; margin-bottom: 2rem;"></div>
  
  <form class="edit-form" action="/AIMAE/UpdateService" method="post">
     <input type="hidden" name="USER_ID" value="${sUser.USER_ID}">
     
    <label><i class="fa-solid fa-user"></i> <a style="margin-left: 0.5rem;"> 이름 </a></label>
    <input type="text" name="USER_NAME" value="${sUser.USER_NAME }" />
    
    <label><i class="fa-solid fa-envelope"></i> <a style="margin-left: 0.5rem;"> 이메일 </a></label>
    <input type="email" name="EMAIL" value="${sUser.EMAIL }" />

    <label><i class="fa-solid fa-key"></i> <a style="margin-left: 0.5rem;"> 비밀번호 </a></label>
    <input type="pw" name="PASSWORD" value="" />
    
    <label><i class="fa-solid fa-phone"></i> <a style="margin-left: 0.5rem;"> 휴대폰 </a></label>
    <input type="tel" name="PHONE" value="${sUser.PHONE }" />
    
    <label><i class="fa-solid fa-location-dot"></i> <a style="margin-left: 0.5rem;"> 주소 </a></label>
    <input type="text" name="USER_ADRRESS" value="${sUser.USER_ADRRESS }" />
    
    
    <div class="form-buttons">
      <button type="submit" class="save-btn"><i class="fa-solid fa-floppy-disk"></i> 저장</button>
      <button type="button" class="cancel-btn" onclick="toggleSection('info')"><i class="fa-solid fa-xmark"></i> 취소</button>
    </div>
  </form>
</div>
            </div>
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="../js/index.js"></script>

    <!-- 드롭다운 -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const dropdown = document.querySelector('.dropdown');
            const btn = dropdown.querySelector('.category-logo');
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                dropdown.classList.toggle('show');
            });
            window.addEventListener('click', (e) => {
                if (!dropdown.contains(e.target)) dropdown.classList.remove('show');
            });
        });
    </script>

    <!-- 로그인 -->
    <script>
        function oauthLogin(provider) {
            const routes = {
                kakao:  "/oauth2/authorization/kakao",
                google: "/oauth2/authorization/google",
                naver:  "/oauth2/authorization/naver"
            };
            const url = routes[provider] || "#";
            window.location.href = url;
        }
    </script>

    <!-- 마이페이지 토글 -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const infoSection = document.getElementById('userInfoSection');
            const editFormSection = document.getElementById('editFormSection');
            const showInfoBtn = document.getElementById('showInfo');
            const showEditBtn = document.getElementById('showEdit');

            showInfoBtn.addEventListener('click', (e) => {
                e.preventDefault();
                toggleSection('info');
            });
            showEditBtn.addEventListener('click', (e) => {
                e.preventDefault();
                toggleSection('edit');
            });

            window.toggleSection = function(type) {
                if (type === 'edit') {
                    infoSection.style.display = 'none';
                    editFormSection.style.display = 'block';
                } else {
                    infoSection.style.display = 'block';
                    editFormSection.style.display = 'none';
                }
            }
        });
    </script>
    
    <!-- 로그아웃 메시지 -->
    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const params = new URLSearchParams(window.location.search);
        
        // 회원 탈퇴 성공 시 알림창 띄우기
        if (params.get('status') === 'unregister_success') {
            alert('회원 탈퇴 되었습니다.');
        }

        if (params.get('logout') === 'success') {
            alert('로그아웃 되었습니다.');
        }
    });
</script>

</body>
</html>
