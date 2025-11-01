<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
    <link rel="stylesheet" href="../css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>

</head>

<body>

    </div>

    <!-- findID -->
    <div class="login-box">

        <div class="login-container">
            
            <div class="login-header">
                <h1 class="login-logo"><a href="../index.jsp" class="logo">AIMAE</a></h1>
                <h1 class="login-logo" style="margin-top: 1.45rem !important; font-size: 20px !important;">아이디 찾기</h1>
            </div>

                <div class="login-form">

                    <div class="form-input">
                        <input id="email" type="text" name="EMAIL" placeholder="이메일 입력해주세요.">
                        <button type="button" onclick="sendAuthCode()" class="btn-2">인증번호 전송</button>
                    </div>

                    <div class="form-input">
                        <input type="text" name="auth_code" id="authCode" placeholder="인증번호를 입력해주세요.">
                        <button type="button" onclick="completCode()" class="btn-2">인증번호 확인</button>
                    </div>

                    <button type="button" onclick="findId()">아이디 찾기</button>

                </div>

                <div class="login-span">
                    <span><a href="findPw.jsp">비밀번호 찾기</a></span> <a style="color: #939393;">|</a>
                    <span><a href="login.jsp">로그인</a></span> <a style="color: #939393;">|</a>
                    <span><a href="join.jsp">회원가입</a></span>
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

        <div class="footer-bottom">
            <p>&copy; 2025 AIMAE</p>
        </div>

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
                if (!dropdown.contains(e.target)) {
                dropdown.classList.remove('show');
                }
            });
        });
    </script>
    <!-- 인증번호 발송 -->
    <script>
		function sendAuthCode() {
		    const email = document.getElementById('email').value;
		
		    if (email.trim() === '') {
		        alert('이메일을 입력해주세요.');
		        return;
		    }
		
		    fetch('/AIMAE/AuthCodeService?email=' + email, {
		        method: 'GET'
		    })
		    .then(response => response.text())
		    .then(text => {
		        if (text === 'success') {
		            alert('인증번호가 발송되었습니다.');
		        } else {
		            alert('이메일 발송에 실패했습니다.');
		        }
		    })
		    .catch(error => {
		        console.error('오류:', error);
		        alert('서버 통신 중 오류가 발생했습니다.');
		    });
		}
	</script>
	
	<!-- 인증번호 확인 -->
	<script>
		let isVerified = false;
		
		function completCode() {
			const authCode = document.getElementById('authCode').value;
			
			if (authCode.trim() ===''){
				alert('인증번호를 입력해주세요.');
				return;
			}
			
			const encodedAuthCode = encodeURIComponent(authCode);
			
			fetch('/AIMAE/CompletCodeService?authCode=' + encodedAuthCode, {
		        method: 'GET'
		    })
		    .then(response => response.text()) // 서버 응답을 텍스트로 받기
		    .then(text => {
		        // 4. 서버로부터 받은 응답 처리
		        if (text.trim() === 'verified') {
		            alert('인증이 완료되었습니다.');
		            isVerified = true;
		             
		        } else if (text.trim() === 'mismatch') {
		            alert('인증번호가 일치하지 않습니다.');
		            isVerified = false;
		        } else if (text.trim() === 'expired') {
		            alert('인증 시간이 만료되었습니다. 다시 요청해주세요.');
		            isVerified = false;
		        } else {
		            alert('알 수 없는 오류가 발생했습니다.');
		            isVerified = false;
		        }
		    })
		    .catch(error => {
		        console.error('오류:', error);
		        alert('서버 통신 중 오류가 발생했습니다.');
		    });
			
		}
	
		function findId() {
			const email = document.getElementById('email').value;
			
			if (!isVerified) {
		        alert('먼저 인증번호 확인을 완료해주세요.');
		        return;
		    }
			
			if (email.trim() === '') {
		        alert('이메일을 입력해주세요.');
		        return;
		    }
			
			fetch('/AIMAE/FindIdService?email=' + encodeURIComponent(email))
		    .then(response => response.text())
		    .then(text => {
		        if (text.trim() === 'error:not_found') {
		            alert('일치하는 회원 정보가 없습니다.');
		        } else {
		            alert('Email을 확인해주세요.');
		        }
		    })
		    .catch(error => {
		        console.error('오류:', error);
		        alert('서버 통신 중 오류가 발생했습니다.');
		    });
			
			
		}
	</script>

</body>
</html>