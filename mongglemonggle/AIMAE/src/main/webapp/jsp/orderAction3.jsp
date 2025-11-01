<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.aimae.model.Product"%>
<%@page import="com.aimae.model.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
    // 세션에서 사용자 정보 가져오기
    com.aimae.model.UserInfo sessionUser = (com.aimae.model.UserInfo) session.getAttribute("sUser");
    String sessionUserNum = null;
    
    if (sessionUser != null) {
        sessionUserNum = sessionUser.getUSER_NUM();
    }

    // URL 파라미터에서 선택된 상품 ID들 가져오기
    String selectedItems = request.getParameter("selectedItems");
    List<com.aimae.model.Cart> cartList = null;
    
    if (sessionUserNum != null && selectedItems != null && !selectedItems.trim().isEmpty()) {
        com.aimae.model.CartDAO cartDAO = new com.aimae.model.CartDAO();
        // 전체 장바구니에서 선택된 상품들만 필터링
        List<com.aimae.model.Cart> allCartItems = cartDAO.cartList(sessionUserNum);
        String[] selectedCartIds = selectedItems.split(",");
        cartList = new ArrayList<>();
        
        for (com.aimae.model.Cart cartItem : allCartItems) {
            for (String selectedId : selectedCartIds) {
                if (cartItem.getCART_ID().equals(selectedId.trim())) {
                    cartList.add(cartItem);
                    break;
                }
            }
        }
    }

    request.setAttribute("cartList", cartList);
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/footer.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/productDetail.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/orderAction.css">
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
                    <a href="fruitProducts.html">과일</a>
                    <a href="vegetableProducts.html">채소</a>
                    <a href="electronicProducts.html">전자제품</a>
                </div>
            </div>

            <a href="<%= request.getContextPath() %>/index.jsp" class="logo">
                <span style="margin-left: 10px;">AIMAE</span>
            </a>
           </div>
   
              <!-- 로그인 / 로그아웃 헤더 변경 -->
            <%@ include file="../loginheader2.jsp" %>
   
          </div>
        </div>
        
        
    </div>

    <!-- 배송 정보 입력 폼 -->
<div class="checkout-container">
    <div class="shipping-info card">
        <h2 class="section-title">🚚 배송 정보</h2>

        <!-- 세션에서 사용자 정보 가져오기 -->
        <c:set var="user" value="${sessionScope.sUser}" />
        <c:set var="product" value="${sessionScope.product}" />

        <div class="input-group">
            <label for="name">이름</label>
            <input type="text" id="name" value="${user.USER_NAME}" placeholder="이름을 입력하세요" required>
        </div>

        <div class="input-group">
            <label for="address">배송 주소</label>
            <input type="text" id="address" value="${user.USER_ADRRESS}" placeholder="주소를 입력하세요" required>
        </div>

        <div class="input-group">
            <label for="phone">연락처</label>
            <input type="tel" id="phone" value="${user.PHONE}" placeholder="연락처를 입력하세요" required>
        </div>

        <div class="input-group">
            <label for="delivery-option">배송 옵션</label>
            <select id="delivery-option" required>
                <option value="standard">기본 배송</option>
                <option value="express">익스프레스 배송</option>
                <option value="pickup">직접 픽업</option>
            </select>
        </div>

        <div class="input-group">
            <label for="message">배송 메시지</label>
            <textarea id="message" placeholder="배송에 대한 메시지를 입력하세요 (선택 사항)"></textarea>
        </div>
    </div>
   
   
    <div class="order-summary card">
    <h2 class="section-title">🛒 주문 목록</h2>

    <!-- 주문 목록 반복 -->
<c:forEach var="item" items="${cartList}">
    <div class="order-item">
        <div class="item-info">
            <span class="item-name product-title">${item.PRODUCT_NAME}</span>
        </div>

        <div class="item-quantity">
            <button type="button" class="qty-btn" onclick="changeQty('${item.PRODUCT_ID}', -1)">-</button>
            <input type="number" id="quantity_${item.PRODUCT_ID}" value="1" min="1" readonly>
            <button type="button" class="qty-btn" onclick="changeQty('${item.PRODUCT_ID}', 1)">+</button>
        </div>

        <span class="item-price">
            ₩ <span id="itemTotal_${item.PRODUCT_ID}" data-price="${item.PRICE}">${item.PRICE}</span>원
        </span>
    </div>
</c:forEach>

    <!-- 배송비 -->
    <div class="order-item">
        <div class="item-info">
            <span class="item-name">배송비</span>
        </div>
        <span class="item-price">₩0</span>
    </div>

    <!-- 총액 -->
<div class="order-item total">
    <div class="item-info">
        <span class="item-name">💳 결제 예상 금액</span>
    </div>
    <span class="item-price product-price" id="totalPrice">₩ 0원</span>
</div>

    <!-- 결제하기 버튼 -->
    <button class="btn buy-now" onclick="processPayment()">결제하기</button>
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

        <div class="footer-bottom">
            <p>&copy; 2025 AIMAE</p>
        </div>
    </div>

    <!-- JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="../js/index.js"></script>
    
    <!--  아임포트 SDK -->
   <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
   <!--  공통 결제 로직 -->
   <script src="../js/orderAction.js"></script>

   <%-- 로그인 여부 계산: cart.jsp와 동일한 세션 로직 재사용 --%>
   <%
     String userNum = (String) session.getAttribute("userNum");
     if (userNum == null) {
       com.aimae.model.UserInfo sUser = (com.aimae.model.UserInfo) session.getAttribute("sUser");
       if (sUser != null) userNum = sUser.getUSER_NUM();
     }
     boolean isLoggedIn = (userNum != null);
   %>
   
   <script>
        window.IS_LOGGED_IN = <%= isLoggedIn ? "true" : "false" %>;
        window.LOGIN_URL = "<%= request.getContextPath() %>/jsp/login.jsp";
        window.CONTEXT_PATH = "<%= request.getContextPath() %>";
        
        // URL 파라미터에서 선택된 상품 정보 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const selectedItems = urlParams.get('selectedItems');
        const totalAmount = urlParams.get('totalAmount');
        
        console.log('=== orderAction3.jsp 디버깅 ===');
        console.log('URL 파라미터: ' + window.location.search);
        console.log('selectedItems: ' + selectedItems);
        console.log('totalAmount: ' + totalAmount);
        console.log('totalAmount 타입: ' + typeof totalAmount);
        console.log('=== orderAction3.jsp 디버깅 끝 ===');
        
        // 실시간 총액 계산 함수
        function calculateTotalAmount() {
          const orderItems = document.querySelectorAll('.order-item:not(.total)');
          let total = 0;
          
          orderItems.forEach(item => {
            const priceElement = item.querySelector('[data-price]');
            const qtyElement = item.querySelector('input[type="number"]');
            
            if (priceElement && qtyElement) {
              const price = parseInt(priceElement.getAttribute('data-price'));
              const qty = parseInt(qtyElement.value);
              total += price * qty;
            }
          });
          
          return total;
        }
        
        // 결제 처리 함수
        function processPayment() {
          if (!selectedItems || !totalAmount) {
            alert('결제할 상품 정보가 없습니다.');
            return;
          }
          
          // 실시간 총액 계산
          const currentTotalAmount = calculateTotalAmount();
          console.log('실시간 계산된 총액:', currentTotalAmount);
          
          // 결제 확인
          const confirmed = confirm('선택된 상품을 결제하시겠습니까?\n총 결제 금액: ₩' + currentTotalAmount.toLocaleString());
          console.log('사용자 선택:', confirmed ? '확인' : '취소');
          console.log('confirmed 값:', confirmed);
          console.log('confirmed 타입:', typeof confirmed);
          
          if (confirmed === true) {
            console.log('결제 확인됨 - Iamport 결제창 호출');
            
            // Iamport 결제창 호출
            IMP.init('imp07671867'); // 가맹점 식별코드
            
            IMP.request_pay({
              pg: 'nice', // 결제 PG
              pay_method: 'card', // 결제수단
              merchant_uid: 'order_' + new Date().getTime(), // 주문번호
              amount: currentTotalAmount, // 결제금액
              name: 'AIMAE 상품 구매', // 주문명
              buyer_email: 'test@test.com', // 구매자 이메일
              buyer_name: '구매자', // 구매자 이름
              buyer_tel: '010-1234-5678', // 구매자 전화번호
              popup: false, // 팝업 비활성화
              m_redirect_url: window.location.href, // 리다이렉트 URL 설정
            }, function(rsp) {
              if (rsp.success) {
                // 결제 성공 시
                console.log('결제 성공:', rsp);
                
                // 결제 성공 - PaymentComplete 호출
                console.log('결제 성공 - PaymentComplete 호출');
                window.location.href = '../PaymentComplete?selectedItems=' + selectedItems;
              } else {
                // 결제 실패 시
                console.log('결제 실패:', rsp.error_msg);
                alert('결제에 실패했습니다: ' + rsp.error_msg);
              }
            });
          } else {
            console.log('결제 취소됨');
            return; // 취소 시 함수 종료
          }
        }
   </script>

</body>
</html>


