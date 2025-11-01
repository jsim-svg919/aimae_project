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
            
            <!-- 일반 사용자일 때: 장바구니 표시 -->
            <c:if test="${sessionScope.sUser.RULE != 1}">
                <li><a href="/AIMAE/jsp/cart.jsp" class="link">장바구니<span id="cart-count" style="background: red; color: white; border-radius: 50%; padding: 2px 6px; font-size: 12px; margin-left: 5px;">0</span></a></li>
            </c:if>
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
        
        <button class="login-btn" onclick="location.href='jsp/login.jsp'">로그인</button>
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
</script>