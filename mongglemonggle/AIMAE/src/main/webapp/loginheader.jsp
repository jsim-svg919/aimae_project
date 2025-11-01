<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>



<c:if test="${not empty sessionScope.sUser}">
    <!-- 로그인된 경우 -->
    <div class="nav">
        <ul class="nav-ul">
            <!-- 관리자일 때, 관리자 페이지로 이동하는 링크 표시 -->
            <c:if test="${sessionScope.sUser.RULE == 1}">
                <li><a href="/AIMAE/jsp/admin.jsp" class="link">관리자페이지</a></li>
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
            <button class="login-btn" onclick="location.href='/AIMAE/jsp/mypage.jsp'">마이페이지</button>
        </c:if>
    </div>
</c:if>

<c:if test="${empty sessionScope.sUser}">
    <!-- 로그인 안된 경우 -->
    <div class="nav">
        <ul class="nav-ul">
            <li><a href="/AIMAE/jsp/join.jsp" class="link">회원가입</a></li>
            <li><a href="/AIMAE/jsp/cart.jsp" class="link">장바구니</a></li>
            <li><a href="#" class="link">고객센터</a></li>
        </ul>
        
        <button class="login-btn" onclick="location.href='/AIMAE/jsp/login.jsp'">로그인</button>
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
	    console.log('loadCartCount 실행됨');
	    fetch('/AIMAE/CartService?action=count')
	        .then(response => {
	            console.log('응답 상태:', response.status);
	            return response.text();
	        })
	        .then(count => {
	            console.log('받은 카운트:', count);
	            const cartCountElement = document.getElementById('cart-count');
	            console.log('cart-count 요소:', cartCountElement);
	            if (cartCountElement) {
	                cartCountElement.textContent = count;
	                cartCountElement.style.display = 'inline';
	                console.log('카운트 업데이트 완료:', count);
	            } else {
	                console.log('cart-count 요소를 찾을 수 없음');
	            }
	        })
	        .catch(error => {
	            console.error('장바구니 개수 조회 오류:', error);
	        });
	}
	
	// 장바구니 페이지로 이동하는 함수
	function goToCart() {
	    // 현재 페이지 경로에 따라 cart.jsp 경로 결정
	    let cartPath;
	    if (window.location.pathname.includes('/jsp/')) {
	        cartPath = 'cart.jsp';
	    } else {
	        cartPath = 'jsp/cart.jsp';
	    }
	    window.location.href = cartPath;
	}

</script>