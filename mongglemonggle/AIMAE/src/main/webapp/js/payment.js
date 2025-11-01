/* /js/payment.js
 * 공통 결제 스크립트 (productDetail.jsp + cart.jsp)
 * - 아임포트 SDK는 각 JSP에서 이미 로드됨 (cdn.iamport.kr)
 * - 여기서는 버튼 바인딩/금액 파싱/결제창 호출/리디렉트만 처리
 */

(function () {
  // ====== 환경 설정 ======
  const IMP_MERCHANT_ID = "imp07671867"; // ← 콘솔에서 확인한 가맹점 식별코드로 교체
  const PAYMENT_PAGE = "payment.jsp";    // ← 결제 완료 후 이동할 페이지(원하면 "결제.jsp" 등으로 변경)

  // ====== 유틸: 금액 파싱 (문자열 → 정수) ======
  function parseAmount(text) {
    if (!text) return 0;
    // 예: "총 결제 금액: ₩12,345원" → "12345"
    const onlyDigits = String(text).replace(/[^\d]/g, "");
    return parseInt(onlyDigits, 10) || 0;
  }

  // ====== 아임포트 초기화 ======
  function ensureIMP() {
    if (!window.IMP) {
      alert("결제 모듈이 로드되지 않았습니다. 잠시 후 다시 시도해 주세요.");
      return null;
    }
    const IMP = window.IMP;
    // init은 여러 번 호출해도 무해하지만 최초 1회만 의미 있음
    IMP.init(IMP_MERCHANT_ID);
    return IMP;
  }

  // ====== 결제 요청 공통 함수 ======
  function requestPayment(amount, name) {
    const IMP = ensureIMP();
    if (!IMP) return;

    if (!Number.isInteger(amount) || amount <= 0) {
      alert("결제 금액이 올바르지 않습니다.");
      return;
    }

    const merchantUid = "mid_" + Date.now();

    IMP.request_pay(
      {
        pg: "nice",               // 테스트 채널이 나이스페이먼츠라면 "nice"
        pay_method: "card",
        merchant_uid: merchantUid,
        name: name || "상품 결제",
        amount: amount,           // 정수
        // 테스트 채널에서는 아래 구매자 정보 임의값으로 테스트 가능
        buyer_email: "test@example.com",
        buyer_name: "테스트",
        buyer_tel: "010-1234-5678",
      },
      function (rsp) {
        if (rsp.success) {
          // 결제 성공 시 원하는 페이지로 이동 (검증용 파라미터 전달)
          const q = new URLSearchParams({
            imp_uid: rsp.imp_uid || "",
            merchant_uid: rsp.merchant_uid || merchantUid,
            amount: String(amount),
          }).toString();
          window.location.href = `${PAYMENT_PAGE}?${q}`;
        } else {
          alert("결제에 실패했습니다.\n사유: " + (rsp.error_msg || "알 수 없음"));
        }
      }
    );
  }

  // ====== 상품 상세 페이지 바인딩 (productDetail.jsp) ======
  function bindProductDetail() {
    const buyNowBtn = document.querySelector(".buy-now");             // 버튼 :contentReference[oaicite:0]{index=0}
    const priceEl   = document.querySelector(".product-price");       // 금액 표시 :contentReference[oaicite:1]{index=1}
    const titleEl   = document.querySelector(".product-title");       // 상품명     :contentReference[oaicite:2]{index=2}

    if (!buyNowBtn || !priceEl) return; // 이 페이지가 아니면 스킵

    buyNowBtn.addEventListener("click", function (e) {
      e.preventDefault();
	  
	  // 로그인 확인 다이얼로그
	  if (!window.IS_LOGGED_IN) {
	    const goLogin = confirm("로그인이 필요한 기능입니다.\n로그인 페이지로 이동하시겠습니까?");
	    if (goLogin) {
	      const redirect = encodeURIComponent(window.location.href);
	      const loginUrl = (window.LOGIN_URL || "jsp/login.jsp") + "?redirect=" + redirect;
	      window.location.href = loginUrl;
	    }
	    return; // 취소하면 그대로 머무름
	  }
	  
      const amount = parseAmount(priceEl.innerText || priceEl.textContent);
      const name   = (titleEl && (titleEl.innerText || titleEl.textContent)) || "상품 결제";
      requestPayment(amount, name);
    });
  }

  // ====== 장바구니 페이지 바인딩 (cart.jsp) ======
  function bindCart() {
    const checkoutBtn = document.querySelector(".checkout-btn"); // 결제 버튼 :contentReference[oaicite:3]{index=3}
    const totalEl     = document.getElementById("total-price");  // 총 결제 금액  :contentReference[oaicite:4]{index=4}

    if (!checkoutBtn || !totalEl) return; // 이 페이지가 아니면 스킵

    checkoutBtn.addEventListener("click", function (e) {
      e.preventDefault();
      const amount = parseAmount(totalEl.innerText || totalEl.textContent);
      requestPayment(amount, "장바구니 결제");
    });
  }

  // ====== 초기화 ======
  document.addEventListener("DOMContentLoaded", function () {
    bindProductDetail();
    bindCart();
  });
})();