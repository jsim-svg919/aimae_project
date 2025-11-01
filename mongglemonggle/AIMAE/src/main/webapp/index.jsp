<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<c:if test="${empty products}">
    <jsp:forward page="/ProductList"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AIMAE</title>

    <!-- Favicon -->
    <link rel="icon" href="images/favicon.ico" sizes="52x52" type="image/png">

    <!-- Style -->
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>



</head>

	
<!-- 👩 index.jsp에서 질문하면 recom.jsp로 넘어가도록 -->
<body class="page-index">

    <!-- Header -->
    <div class="header">

        <div class="brand">

            <div class="dropdown">
                <button class="category-logo">
                    <span><i class="fa-solid fa-bars"></i></span>
                </button>

                <div class="dropdown-content">
                    <a href="jsp/fruitProducts.jsp">과일</a>
                    <a href="jsp/vegetableProducts.jsp">채소</a>
                    <a href="jsp/electronicProducts.jsp">전자제품</a>
                </div>

            </div>

            <a href="index.jsp" class="logo">
                <span style="margin-left: 10px;">AIMAE</span>
            </a>
            
    </div>
		
		<!-- 로그인 / 로그아웃 헤더 변경 -->
		<%@ include file="loginheader.jsp" %>

    </div>

    <!-- Content -->
    <div class="content">

        <div>
            <h1 class="animated-text" style="font-size: 36px;">당신의 고민을 대신 추천해주는 AI 쇼핑 도우미 <span class="logo2">' AIMAE '</span> 입니다.</h1>
        </div>

        <div class="content-text">
            <p>당신의 쇼핑 고민을 해결해주는 최고의 인공지능 도우미</p>
            <p>AI가 당신의 취향과 필요를 분석하여 최적의 상품을 추천해줍니다.</p>
            <p>복잡한 쇼핑 과정에서 벗어나, 원하는 제품을 찾을 수 있습니다.</p>
        </div>
        
        <!-- 👩 미리보기 영역 -->
		<div class="preview-area">
		  <div class="preview-wrapper">
		    <img id="preview" class="preview-img" src="" alt="이미지 미리보기"/>
		    <button id="clear-preview" class="preview-clear">✕</button>
		  </div>
		  <span id="image-status" class="image-status"></span>
		</div>

        <!-- Search bar -->

        <div class="search">
            <form class="search-form">
                <a href="#" class="image-icon" id="image-icon"><i class="fa-solid fa-image"></i></a>
                <input type="text" placeholder="어떤 제품을 찾고 계신가요?" id="search-input" />
                <a href="#" class="search-icon" id="search-icon"><i class="fas fa-search"></i></a>
                <input type="file" id="file-input" style="display:none;">
            </form>
        </div>

    </div>

    <!-- Content2 -->
    <!-- 신상품 -->
<div class="content-product">
    <h2 class="section-header">🛍️ 신상품</h2>
    <div class="product-slider">
    <c:if test="${not empty products}">
    <c:forEach var="p" items="${products}" end="4">
        <div class="product-card">
         <a href="ProductDetail?productId=${p.PRODUCT_ID}" class="product-link" style="text-decoration: none">
  	     <img src="${pageContext.request.contextPath}/${p.PHOTO_PATH}" alt="" class="product-img">
            <div class="product-info">
                <c:choose>
				    <c:when test="${fn:contains(p.PRODUCT_NAME, ',')}">
				        <h3 class="product-name">${fn:substringBefore(p.PRODUCT_NAME, ',')}</h3>
				    </c:when>
				    <c:otherwise>
				        <h3 class="product-name">${p.PRODUCT_NAME}</h3>
				    </c:otherwise>
				</c:choose>
				<p class="product-price">₩ <fmt:formatNumber value="${p.PRICE}" type="number" groupingUsed="true"/>원</p>
                <button class="add-cart-btn"><i class="fas fa-shopping-cart"></i> 장바구니</button>
            </div>
            </a>
        </div>
		</c:forEach>
		</c:if>


    </div>
</div>

<!-- 최근 구매순 -->
<div class="content-product">
    <h2 class="section-header">🔥 인기순</h2>
    <div class="product-slider">
    <c:if test="${not empty stockProducts}">
    <c:forEach var="p" items="${stockProducts}" end="4">
        <div class="product-card">
            <a href="ProductDetail?productId=${p.PRODUCT_ID}" class="product-link" style="text-decoration: none">
                <img src="${pageContext.request.contextPath}/${p.PHOTO_PATH}" alt="${p.PRODUCT_NAME}" class="product-img">
                <div class="product-info">
                    <c:choose>
					    <c:when test="${fn:contains(p.PRODUCT_NAME, ',')}">
					        <h3 class="product-name">${fn:substringBefore(p.PRODUCT_NAME, ',')}</h3>
					    </c:when>
					    <c:otherwise>
					        <h3 class="product-name">${p.PRODUCT_NAME}</h3>
					    </c:otherwise>
					</c:choose>
                    <p class="product-price">₩ <fmt:formatNumber value="${p.PRICE}" type="number" groupingUsed="true"/>원</p>
                    <button class="add-cart-btn"><i class="fas fa-shopping-cart"></i> 장바구니</button>
                </div>
            </a>
        </div>
    </c:forEach>
    </c:if>
    </div>
</div>




    <div class="content-box-img">
        <img class="content-img" src="images/freedelivery.png">
        <img class="content-img" src="images/freedelivery2.png">
        <img class="content-img" src="images/freedelivery3.png">
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
                    <img src="images/favicon.ico" alt="" style="width: 5rem;">
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2025 AIMAE</p>
        </div>
    </div>
    
    <!-- 👩 index.jsp : 입력내용 → recom.jsp?q=... 로 이동 -->
	<script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>

    <!-- JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="js/index.js"></script>

    <!-- 슬라이드 -->
    <script>
        $(document).ready(function(){
            $('.product-slider').slick({
                slidesToShow: 3,
                slidesToScroll: 1,       // 1씩 스크롤
                arrows: true,
                infinite: false,
                prevArrow: '<button type="button" class="slick-prev"><i class="fa-solid fa-angle-left"></i></button>',
                nextArrow: '<button type="button" class="slick-next"><i class="fa-solid fa-angle-right"></i></button>',
                responsive: [
                    {
                        breakpoint: 1024,
                        settings: { slidesToShow: 2 }
                    },
                    {
                        breakpoint: 768,
                        settings: { slidesToShow: 1 }
                    }
                ]
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
    document.addEventListener('DOMContentLoaded', () => {
        const params = new URLSearchParams(window.location.search);

        // 회원 탈퇴 성공 시
        if (params.get('status') === 'unregister_success') {
            alert('회원 탈퇴 되었습니다.');
        }
        
     	// 로그인 실패 시
        if (params.get('login') === 'err') {
            alert('다시 확인해주세요.');
        }

        // 장바구니 버튼 이벤트 추가
        const addCartBtns = document.querySelectorAll('.add-cart-btn');
        addCartBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault(); // 링크 이동 방지
                e.stopPropagation(); // 이벤트 버블링 방지
                
                const productCard = btn.closest('.product-card');
                const productLink = productCard.querySelector('.product-link');
                const productId = productLink.href.split('productId=')[1];
                const productName = productCard.querySelector('.product-name').textContent;
                
                // CartService로 장바구니 추가 요청
                const params = new URLSearchParams();
                params.append('action', 'add');
                params.append('productId', productId);
                params.append('delyAddress', '결제 시 입력'); // 기본값 설정
                
                fetch('CartService', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params
                })
                .then(response => {
                    console.log('Response status:', response.status);
                    
                    // JSON 응답 처리
                    return response.json();
                })
                .then(data => {
                    console.log('Response data:', data);
                    if (data.success) {
                        alert(data.message);
                        // 장바구니 개수 업데이트
                        if (typeof loadCartCount === 'function') {
                            loadCartCount();
                        }
                    } else {
                        alert(data.message);
                        // 로그인이 필요한 경우 로그인 페이지로 이동
                        if (data.needLogin) {
                            console.log('로그인 필요 - 로그인 페이지로 이동');
                            window.location.href = 'jsp/login.jsp';
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('장바구니 추가 중 오류가 발생했습니다.');
                });
            });
        });
        
    });
	</script>
    
    
<c:if test="${not empty joinSuccess}">
        <script>
            alert('회원가입 성공했습니다!');
        </script>
    </c:if>

</body>
</html>
