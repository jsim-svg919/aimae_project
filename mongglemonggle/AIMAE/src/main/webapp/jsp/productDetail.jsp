<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AIMAE</title>

    <!-- Favicon -->
    <link rel="icon" href="<%= request.getContextPath() %>/images/favicon.ico" sizes="52x52" type="image/png">

    <!-- Style -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/footer.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/productDetail.css">
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
                    <a href="jsp/fruitProducts.jsp">과일</a>
                    <a href="jsp/vegetableProducts.jsp">채소</a>
                    <a href="jsp/electronicProducts.jsp">전자제품</a>
                </div>

            </div>

            <a href="./index.jsp" class="logo">
                <span style="margin-left: 10px;">AIMAE</span>
            </a>
            
    </div>

        <!-- 로그인 / 로그아웃 헤더 변경 -->
		<%@ include file="../loginheader.jsp" %>

    </div>

  <div class="product-detail-container">
    <!-- 상품 이미지 -->
    <div class="product-detail-image">
    <!-- 메인 이미지 -->
    <img id="mainImage" src="${pageContext.request.contextPath}/${product.PHOTO_PATH}" alt="제품 이미지">

        <!-- 썸네일 리스트 -->
        <div class="thumbnail-list">
            <img src="${pageContext.request.contextPath}/${product.PHOTO_PATH}" alt="썸네일 1" class="thumbnail active">
            <img src="${pageContext.request.contextPath}/${product.PHOTO_THUMB}1.jpg" alt="썸네일 2" class="thumbnail">
            <img src="${pageContext.request.contextPath}/${product.PHOTO_THUMB}2.jpg" alt="썸네일 3" class="thumbnail">
            <img src="${pageContext.request.contextPath}/${product.PHOTO_THUMB}4.jpg" alt="썸네일 4" class="thumbnail">
        </div>
    </div>


    <!-- 상품 정보 -->
    <div class="product-detail-info">
        <h1 class="product-title">${product.PRODUCT_NAME}</h1>
        <p class="product-price">₩ <fmt:formatNumber value="${product.PRICE}" type="number" groupingUsed="true"/>원</p>

        <!-- 추가 정보 -->
        <ul class="product-highlights">
            <li>✅ 100% 국내산 신선 과일</li>
            <li>🚚 오후 3시 이전 주문 시 당일 출고</li>
            <li>🌱 무농약 · 친환경 인증 농산물</li>
            <li>📦 안전한 포장으로 신선도 유지</li>
        </ul>

  
    <!-- 추가 설명 -->
    <div class="product-detail-extra">
        <h3>상품 설명</h3>
        <p>${product.PRD_INFO}</p>
            
            <h3>보관 방법</h3>
            <p>
                수령 후 냉장 보관해주세요.  
                신선도를 위해 수령 후 3일 이내 섭취 권장드립니다.
            </p>
            
            <h3>배송 정보</h3>
    		<p>배송 옵션: ${productDetail.DELY_OPT}</p>
    		<p>배송 지역: ${productDetail.DELY_AREA}</p>
    		<p>영수증: ${productDetail.RECEIPT}</p>
    		<p>A/S: ${productDetail.AFTER_SERVICE}</p>
</div>
            <!-- 버튼 영역 -->
            <div class="product-actions">
                <button class="btn add-cart">장바구니에 담기</button>
                <!--<button class="btn buy-now">바로 구매</button>   -->
                <button class="now-btn" id="buyNowBtn">바로 구매</button>
            </div>
        </div>
    </div>
    </div>

    <!-- 상품 상세 설명 -->
    <div class="product-description-section">
        <h2 class="detail-title">제품 상세 설명</h2>

        <div class="detail-image-wrapper">
            <img src="${pageContext.request.contextPath}/${product.PRD_DETAIL}" alt="상품 상세 이미지" style="width: 100%; max-width: 800px; height: auto;">
        </div>
    </div>
    
    <!-- 반품/교환 안내 -->
    <div class="return-policy-section">
        <h2 class="return-title">📦 반품/교환 안내</h2>

        <p class="return-intro">
            <strong>상품 수령 후 7일 이내</strong>에 신청하실 수 있습니다. <br>
            단, 제품이 표시·광고 내용과 다르거나, 계약과 다르게 이행된 경우는 <br>
            <strong>수령일로부터 3개월 이내</strong> 또는 <strong>그 사실을 안 날부터 30일 이내</strong>에 가능합니다.
        </p>

        <h3 class="return-subtitle">❌ 반품/교환이 불가능한 경우</h3>
        <ul class="return-list">
            <li><strong>공통:</strong>
            <ul>
                <li>소비자의 책임 있는 사유로 상품이 멸실 또는 훼손된 경우</li>
                <li>사용 또는 소비로 인해 상품 가치가 현저히 감소한 경우</li>
                <li>시간 경과로 재판매가 곤란할 정도로 상품 가치가 하락한 경우</li>
                <li>복제가 가능한 상품의 포장이 훼손된 경우</li>
                <li>개별 생산 상품 제작이 이미 시작된 경우</li>
            </ul>
            </li>

            <li><strong>저온/신선 상품:</strong>
            <ul>
                <li>단순 변심, 주소 오류, 보관 부주의 등 고객 귀책 사유</li>
                <li>옵션 변경 요청 (다른 상품으로 교환 등)</li>
                <li>배송 완료 후 24시간 이내 사진 포함 반품 신청 누락</li>
                <li>반품 신청 후 72시간 이내 연락 두절</li>
                <li>배송받은 아이스박스, 냉매제, 상품 등을 임의 폐기한 경우</li>
            </ul>
            </li>
        </ul>
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
                    <img src="${imagePath}/favicon.ico" alt="" style="width: 5rem;">
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
    
    <!-- 👩 아임포트 SDK -->
	<script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
	<!-- 👩 공통 결제 로직 -->
	<script src="${jsPath}/payment.js"></script>

	<%-- 👩 로그인 여부 계산: cart.jsp와 동일한 세션 로직 재사용 --%>
	<%
	  String userNum = (String) session.getAttribute("userNum");
	  if (userNum == null) {
	    com.aimae.model.UserInfo sUser = (com.aimae.model.UserInfo) session.getAttribute("sUser");
	    if (sUser != null) userNum = sUser.getUSER_NUM();
	  }
	  boolean isLoggedIn = (userNum != null);
	%>
	
	<script>

	document.addEventListener('DOMContentLoaded', () => {
		  const buyNowBtn = document.getElementById('buyNowBtn');
		  if (buyNowBtn) {
		    buyNowBtn.addEventListener('click', () => {
		      if (window.IS_LOGGED_IN) {
		        // 로그인 되어 있으면 결제창 이동
		        location.href = 'jsp/orderAction.jsp?productId=${product.PRODUCT_ID}';
		      } else {
		        // 로그인 안 되어 있으면 로그인 페이지로 이동
		        alert("로그인이 필요합니다.");
		        location.href = window.LOGIN_URL;
		      }
		    });
		  }
		});
	
	</script>
	
	<script>
	  // 전역 플래그 & 로그인 URL (컨텍스트패스 안전)
	  window.IS_LOGGED_IN = <%= isLoggedIn ? "true" : "false" %>;
	  window.LOGIN_URL = "<%= request.getContextPath() %>/jsp/login.jsp";
	</script>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const mainImage = document.getElementById('mainImage');
            const thumbnails = document.querySelectorAll('.thumbnail');

            thumbnails.forEach(thumbnail => {
            thumbnail.addEventListener('click', () => {
                // 메인 이미지 변경
                mainImage.src = thumbnail.src;

                // 썸네일 active 클래스 갱신
                thumbnails.forEach(t => t.classList.remove('active'));
                thumbnail.classList.add('active');
            });
            });

            // 장바구니 버튼 이벤트 추가 (메인화면과 완전히 동일)
            const addCartBtn = document.querySelector('.add-cart');
            if (addCartBtn) {
                addCartBtn.addEventListener('click', (e) => {
                    e.preventDefault(); // 링크 이동 방지
                    e.stopPropagation(); // 이벤트 버블링 방지
                    
                    const productId = '${product.PRODUCT_ID}';
                    const productName = '${product.PRODUCT_NAME}';
                    
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
            }
        });
    </script>


</body>
</html>
