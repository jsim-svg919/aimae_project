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
<link rel="icon" href="../images/favicon.ico" sizes="52x52"
   type="image/png">

<!-- Style -->
<link rel="stylesheet" href="../css/index.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/login.css">
<link rel="stylesheet"
   href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" type="text/css"
   href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />

</head>

<body>

   </div>

   <!-- join -->
   <div class="login-box" style="margin-top: 6rem; margin-bottom: 10rem;">

      <div class="login-container">

         <div class="login-header">
            <h1 class="login-logo">
               <a href="../index.jsp" class="logo">AIMAE</a>
            </h1>
            <h1 class="login-logo"
               style="margin-top: 1.45rem !important; font-size: 20px !important;">회원가입</h1>
         </div>

         <div class="login-form">
            <form id="joinForm" action="/AIMAE/JoinService" method="post">
               <label for="userId">아이디</label>
               <div class="form-input-join">
                  <input id="userId" type="text" name="USER_ID" value=""
                     placeholder="아이디를 입력해주세요." style="width: 17.02rem;" required>
                  <button type="button" onclick="checkUserId()" class="btn-2">중복
                     확인</button>
               </div>

               <label for="userPw">비밀번호</label> <a
                  style="color: #8c52ff; margin-left: 1rem;">12자리 까지 입력가능합니다.</a>
               <div class="form-input-join">
                  <input id="userPw" type="password" name="PASSWORD" value=""
                     placeholder="비밀번호를 입력해주세요." style="width: 23.3rem;"
                     maxlength="12" required>
               </div>

               <label for="userPw2">비밀번호 재확인</label> <a style="margin-left: 1rem;"
                  id="checkPw"></a>
               <div class="form-input-join">
                  <input id="userPw2" type="password" name="PASSWORD2" value=""
                     placeholder="한번더 입력 해주세요." style="width: 23.3rem;" maxlength="12"
                     required>
               </div>

               <label for="email">이메일</label>
               <div class="form-input-join" style="display: flex;">
                  <input id="email" type="text" name="EMAIL" value=""
                     placeholder="이메일을 입력해주세요." style="width: 15.1rem;" required>
                  <button type="button" onclick="sendAuthCode()" class="btn-2">인증번호
                     전송</button>
               </div>

               <div class="form-input-join">
                  <input type="text" name="auth_code" id="authCode"
                     placeholder="인증번호를 입력해주세요." style="width: 15.1rem;" required>
                  <button type="button" id="verifyCodeBtn" onclick="completCode()"
                     class="btn-2">인증번호 확인</button>
               </div>

               <label for="username">이름</label>
               <div class="form-input-join">
                  <input id="username" type="text" name="USER_NAME" value=""
                     placeholder="이름을 입력해주세요." style="width: 23.3rem;" required>
               </div>

               <label for="tell">전화번호</label>
               <div class="form-input-join" style="align-items: center;">
                  <input id="tel1" type="text" name="PHONE1" value="" maxlength="3"
                     required> <a>-</a> <input id="tel2" type="text"
                     name="PHONE2" value="" maxlength="4" required> <a>-</a> <input
                     id="tel3" type="text" name="PHONE3" value="" maxlength="4"
                     required>
               </div>

               <label for="address">주소</label>
               <div class="form-input-join">
                  <input id="address" type="text" name="USER_ADRRESS" value=""
                     placeholder="주소를 입력해주세요." style="width: 23.3rem;" required>
               </div>

               <div class="join-button">
                  <button type="submit">회원가입</button>
                  <button type="reset" onclick="" class="join-btn-c">취소</button>
               </div>

            </form>
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
               <a href="https://www.facebook.com" target="_blank"><i
                  class="fab fa-facebook-f"></i></a> <a href="https://www.twitter.com"
                  target="_blank"><i class="fab fa-twitter"></i></a> <a
                  href="https://www.instagram.com/chan2hee1" target="_blank"><i
                  class="fab fa-instagram"></i></a> <a href="https://www.linkedin.com"
                  target="_blank"><i class="fab fa-linkedin-in"></i></a>
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
   <script type="text/javascript"
      src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
   <script src="../js/index.js"></script>
   <!-- ID중복확인JS -->
   <script type="text/javascript">
       function checkUserId(){
          
          const userId = document.getElementById('userId').value;
          
          if (userId.trim() === '') {
               alert('아이디를 입력해주세요.');
               return;
           }
          
          // 3. 서버에 AJAX 요청 보내기
          fetch('/AIMAE/IdCheckService?userId=' + userId, {
               method: 'get'
           })
           .then(response => response.text()) // 1. 응답을 텍스트로 받기
           .then(text => {
               // 2. 받은 텍스트에 따라 분기 처리
               if (text === 'duplicate') {
                   alert('이미 사용 중인 아이디입니다.');
               } else if (text === 'available') {
                   alert('사용 가능한 아이디입니다.');
               } else {
                   alert('알 수 없는 오류가 발생했습니다.');
               }
           })
           .catch(error => {
               console.error('오류:', error);
               alert('서버 통신에 실패했습니다. 다시 시도해주세요.');
           });
       }
    

       async function sendAuthCode() {
           const email = document.getElementById('email').value;
       
           if (email.trim() === '') {
               alert('이메일을 입력해주세요.');
               return;
           }
           
           const isDuplicate = await isEmailDuplicate(email);
           
           if (isDuplicate) {
               // 중복이면 알림을 띄우고 함수 종료
               alert('중복된 이메일 입니다.');
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
       
    // 이메일 중복 확인을 위한 독립적인 비동기 함수
       async function isEmailDuplicate(email) {
           try {
               const response = await fetch('/AIMAE/CheckEmailService?email=' + email, {
                   method: 'GET'
               });
               const text = await response.text();
               return text === 'duplicate';
           } catch (error) {
               console.error('Error checking email:', error);
               return true; // 통신 오류 시 중복으로 간주하여 재시도 유도
           }
       }

   <!-- 인증번호 확인 -->

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

   <!-- 패스워드 확인 -->

        document.addEventListener('DOMContentLoaded', () => {
           const form = document.getElementById('joinForm');
            const pw1 = document.getElementById('userPw');
            const pw2 = document.getElementById('userPw2');
            const msg = document.getElementById('checkPw');
            const resetBtn = document.querySelector('.join-btn-c');

            function checkPasswordMatch() {
                if (pw1.value === '' || pw2.value === '') {
                    msg.textContent = '';
                    return;
                }

                if (pw1.value === pw2.value) {
                    msg.textContent = '비밀번호가 일치합니다';
                    msg.style.color = 'red';
                } else {
                    msg.textContent = '비밀번호가 일치하지 않습니다';
                    msg.style.color = 'red';
                }
            }

            pw1.addEventListener('input', checkPasswordMatch);
            pw2.addEventListener('input', checkPasswordMatch);

            // 취소 버튼 누르면 메시지 초기화
            resetBtn.addEventListener('click', () => {
                msg.textContent = '';
            });

              if (form) {
            form.addEventListener("submit", (event) => {
                 // 인증이 완료되지 않았다면 폼 제출을 막습니다.
                 if (isVerified == false) {
                     event.preventDefault(); // 폼 제출 기본 동작 방지
                     alert('이메일 인증을 먼저 완료해주세요.');
                     return;
                 }

                 // 유효성검사
                const userId = document.getElementById('userId');
                const userPw = document.getElementById('userPw');
                const userPw2 = document.getElementById('userPw2');
                const email = document.getElementById('email');
                const username = document.getElementById('username');
                const tel1 = document.getElementById('tel1');
                const tel2 = document.getElementById('tel2');
                const tel3 = document.getElementById('tel3');
                const address = document.getElementById('address');

                if (userId.value.trim() === '') { alert('아이디를 입력해주세요.'); userId.focus(); return; }
                if (userPw.value.trim() === '') { alert('비밀번호를 입력해주세요.'); userPw.focus(); return; }
                if (userPw2.value.trim() === '') { alert('비밀번호 재확인을 입력해주세요.'); userPw2.focus(); return; }
                if (userPw.value !== userPw2.value) { alert('비밀번호가 일치하지 않습니다.'); userPw2.focus(); return; }
                if (email.value.trim() === '') { alert('이메일을 입력해주세요.'); email.focus(); return; }
                if (username.value.trim() === '') { alert('이름을 입력해주세요.'); username.focus(); return; }
                if (tel1.value.trim() === '' || tel2.value.trim() === '' || tel3.value.trim() === '') { alert('전화번호를 입력해주세요.'); tel1.focus(); return; }
                if (address.value.trim() === '') { alert('주소를 입력해주세요.'); address.focus(); return; }

                form.submit();
            });
            }
        });
</script>


</body>
</html>