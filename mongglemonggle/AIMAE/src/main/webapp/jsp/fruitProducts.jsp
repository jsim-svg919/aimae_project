<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aimae.model.Product" %>
<%@ page import="com.aimae.model.ProductDAO" %>

<%@ page import="java.time.LocalDate, java.time.format.TextStyle, java.util.Locale" %>

<%
    LocalDate tomorrow = LocalDate.now().plusDays(1);
    String dayOfWeek = tomorrow.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN);
%>

<%
    // 과일 카테고리 상품 조회
    ProductDAO dao = new ProductDAO();
    List<Product> fruitProducts = dao.searchFruitProducts();
    request.setAttribute("products", fruitProducts);
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
    <link rel="stylesheet" href="../css/product.css">
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
		<c:if test="${not empty sessionScope.sUser}">
    <!-- 로그인된 경우 -->
    <div class="nav">
        <ul class="nav-ul">
            <!-- 관리자일 때, 관리자 페이지로 이동하는 링크 표시 -->
            <c:if test="${sessionScope.sUser.RULE == 1}">
                <li><a href="admin.jsp" class="link">관리자페이지</a></li>
            </c:if>
            
            <!-- 공통 메뉴: 로그아웃, 고객센터, 장바구니 -->
            <li><a href="/AIMAE/LogoutService" class="link">로그아웃</a></li>
            <li><a href="#" class="link">고객센터</a></li>
            <li><a href="javascript:void(0)" onclick="goToCart()" class="link">장바구니 <span id="cart-count" style="background: red; color: white; border-radius: 50%; padding: 2px 6px; font-size: 12px; margin-left: 5px;">0</span></a></li>
        </ul>
        
        <!-- 사용자 이름 출력 -->
        <span class="user-greeting" style="color: #3500ff; font-weight: bold;">${sessionScope.sUser.USER_NAME}님</span>
        
        <!-- 일반 사용자일 때만 마이페이지 버튼 표시 -->
        <c:if test="${sessionScope.sUser.RULE != 1}">
            <button class="login-btn" onclick="location.href='mypage.jsp'">마이페이지</button>
        </c:if>
    </div>
</c:if>

<c:if test="${empty sessionScope.sUser}">
    <!-- 로그인 안된 경우 -->
    <div class="nav">
        <ul class="nav-ul">
            <li><a href="join.jsp" class="link">회원가입</a></li>
            <li><a href="login.jsp" class="link">장바구니</a></li>
            <li><a href="support.jsp" class="link">고객센터</a></li>
        </ul>
        
        <button class="login-btn" onclick="location.href='login.jsp'">로그인</button>
    </div>
</c:if>

<script>
	document.addEventListener('DOMContentLoaded', () => {
	    const params = new URLSearchParams(window.location.search);
	    if (params.get('logout') === 'success') {
	        alert('로그아웃 되었습니다.');
	    }
	    
	    // 장바구니 개수 조회
	    loadCartCount();
	});
	
	// 장바구니 개수 조회 함수
	function loadCartCount() {
	    fetch('/AIMAE/CartService?action=count')
	        .then(response => response.text())
	        .then(count => {
	            const cartCountElement = document.getElementById('cart-count');
	            if (cartCountElement) {
	                cartCountElement.textContent = count;
	                if (count > 0) {
	                    cartCountElement.style.display = 'inline';
	                } else {
	                    cartCountElement.style.display = 'none';
	                }
	            }
	        })
	        .catch(error => {
	            console.error('장바구니 개수 조회 오류:', error);
	        });
	}
	
	// 장바구니 페이지로 이동하는 함수
	function goToCart() {
	    window.location.href = 'cart.jsp';
	}
</script>

    </div>

    <!-- Content -->
    <div class="product-container">
        <div class="product-header">
            <h1 class="section-title fruits">🍎 과일 상품 목록</h1>
            <p class="section-subtitle">신선한 과일을 가장 빠르게 만나보세요!</p>
        </div>
        <!-- <div style="border-bottom: 1px solid #cbcbcb; margin-bottom: 3rem;"></div> -->
        <div class="sort-options">
            <button class="sort-btn active">최근 상품</button>
            <button class="sort-btn">가격 높은순</button>
            <button class="sort-btn">가격 낮은순</button>
            <button class="sort-btn">많이 팔린 상품순</button>
        </div>
        <div class="product-grid" style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: space-between;">
            <c:if test="${not empty products}">
                <c:forEach var="p" items="${products}">
                    <a href="../ProductDetail?productId=${p.PRODUCT_ID}" class="product-link" style="width: calc(20% - 19.2px); display: block; text-decoration: none; color: inherit;">
                        <div class="product-item" style="background-color: #fff; border-radius: 12px; box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08); text-align: center; overflow: hidden; display: flex; flex-direction: column; height: 100%;">
                            <img src="${pageContext.request.contextPath}/${p.PHOTO_PATH}" alt="${p.PRODUCT_NAME}" class="product-img" style="width: 100%; height: 180px; object-fit: cover; border-bottom: 1px solid #eee;">
                            <div class="product-info" style="padding: 16px; flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                                <h4 class="product-name" style="font-size: 1.05rem; font-weight: 600; color: #222; margin-bottom: 10px;">${p.PRODUCT_NAME}</h4>
                                <p style="margin-bottom: 10px; color: #00c300;">내일(<%= dayOfWeek %>) 새벽 도착 보장</p>
                                <p class="product-price" style="font-size: 1.1rem; font-weight: 500; margin-bottom: 14px;">₩ <fmt:formatNumber value="${p.PRICE}" type="number" groupingUsed="true"/>원</p>
                            	<div class="product-span">
                                	<span class="product-tag">무료배송</span><span class="product-tag">신선보장</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:if>
            <c:if test="${empty products}">
                <p style="text-align: center; grid-column: 1 / -1; padding: 2rem; color: #666;">
                    현재 등록된 과일 상품이 없습니다.
                </p>
            </c:if>
        </div>
    </div>

    <div class="content-box-img">
        <img class="content-img" src="../images/freedelivery.png">
        <img class="content-img" src="../images/freedelivery2.png">
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

        <div class="footer-bottom">
            <p>&copy; 2025 AIMAE</p>
        </div>
    </div>

    <!-- JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="../js/index.js"></script>

    <!-- 슬라이드 -->
    <script>
        $(document).ready(function(){
            $('.product-slider').slick({
                slidesToShow: 3,       // 한 번에 보여줄 개수
                slidesToScroll: 3,     // 한번에 스크롤할 개수
                arrows: true,          // < > 버튼
                infinite: false,        // 무한 루프 여부 (원하는 대로)
                prevArrow: '<button type="button" class="slick-prev"><i class="fa-solid fa-angle-left"></i></button>',
                nextArrow: '<button type="button" class="slick-next"><i class="fa-solid fa-angle-right"></i></button>'
            });
        });
    </script>

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
                if (!dropdown.contains(e.target)) {
                dropdown.classList.remove('show');
                }
            });
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const sortButtons = document.querySelectorAll('.sort-btn');

            sortButtons.forEach(button => {
                button.addEventListener('click', () => {
                    sortButtons.forEach(btn => btn.classList.remove('active'));
                    button.classList.add('active');
                });
            });
        });
    </script>

</body>
</html>