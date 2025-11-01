// index.jsp에서 window.CONTEXT_PATH가 정의 안 돼도 에러 안 나게 || "" 처리.
var CONTEXT_PATH = window.CONTEXT_PATH || "";

// 페이지 식별
var IS_RECOM = document.body.classList.contains("page-recom");
var IS_INDEX = document.body.classList.contains("page-index");


// index.jsp에서는 /ask 관련 함수들을 무력화 (세이프가드)
if (!IS_RECOM) {
	window.sendAsk = function() { return false; };
	window.renderResult = function() { };
}

// /ask로 질문/이미지 전송하는 함수
function sendAsk() {
	var ASK_URL = "http://127.0.0.1:5000/ask";
	var question = $("#search-input").val().trim();
	var fileIn = $("#file-input")[0];

	if (!question && (!fileIn || fileIn.files.length === 0)) {
		alert("질문이나 이미지를 입력하세요.");
		return;
	}

	// 로딩 표시(로딩중에 다른거 작업 못하게)
	setLoading(true);

	// 파일이 있으면 → FormData로 전송 (recom.jsp에서만 호출됨)
	if (fileIn && fileIn.files.length > 0) {
		var fd = new FormData();
		fd.append("question", question);
		fd.append("image", fileIn.files[0]); // app.py가 'image' 키로 받는 기준

		$.ajax({
			url: ASK_URL,
			type: "POST",
			data: fd,
			processData: false,
			contentType: false,
			success: function(res) {
				setLoading(false);
				renderResult(res);
				// recom.jsp에서 URL q 파라미터 동기화
				if (IS_RECOM && question) {
					var newUrl = window.location.pathname + "?q=" + encodeURIComponent(question);
					history.replaceState({}, "", newUrl);
				}
				
			},
			error: function(xhr) {
				setLoading(false);
				alert("서버 요청 중 오류: " + (xhr.responseText || xhr.statusText));
			}
		});
		return; // ← 여기서 끝
	}

	// 텍스트만 있으면 JSON
	$.ajax({
		url: ASK_URL,
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({ question: question }),
		success: function(res) {
			setLoading(false);
			renderResult(res);
			// recom.jsp에서 URL q 파라미터 동기화
			if (IS_RECOM && question) {
				var newUrl = window.location.pathname + "?q=" + encodeURIComponent(question);
				history.replaceState({}, "", newUrl);
			}
		},
		error: function(xhr) {
			setLoading(false);
			alert("서버 요청 중 오류: " + (xhr.responseText || xhr.statusText));
		}
	});
}

//Flask 응답 → 화면 반영
function renderResult(res) {
    console.log("서버 응답:", res);

    // 1. answer 반영
    $(".content-product-header").text(res.answer || " ");

    // 2. products 반영
    var slider = $("#product-slider2");
    slider.empty();  // 기존 카드 지우기

    if (res.products && res.products.length > 0) {
        res.products.forEach(function(p) {
            // 상품명: 첫 번째 ',' 이전만 표시
            var displayName = p.PRODUCT_NAME ? p.PRODUCT_NAME.split(',')[0] : '이름 없음';

            // 가격: 천 단위 구분 + ₩원
            var displayPrice = (p.PRICE !== null && p.PRICE !== undefined && p.PRICE !== "")
                ? '₩ ' + Number(p.PRICE).toLocaleString() + '원'
                : '정보 없음';

            var card = `
                <div class="product-list-box">
                    <a href="/AIMAE/ProductDetail?productId=${p.PRODUCT_ID}" class="list-pbox">
                        <img src="${p.PHOTO_THUMB ? '../' + p.PHOTO_THUMB + 'main.jpg' : '../images/favicon.ico'}" alt="상품 이미지" class="product-img" onerror="this.onerror=null; this.src='../images/favicon.ico';">
                        <div class="product-info">
                            <h3 class="product-name" title="${p.PRODUCT_NAME || ''}">
                                ${displayName}
                            </h3>
                            <p class="product-price">${displayPrice}</p>
                            <button class="add-cart-btn"><i class="fas fa-shopping-cart"></i> 장바구니</button>
                        </div>
                    </a>
                </div>`;
            slider.append(card);
        });
    } else {
        slider.append("<p>추천 가능한 상품이 없습니다.</p>");
    }


	// 추천 상세 비교표 채우기
	var tbody = $("#recommend-tbody");
	tbody.empty();

	if (res.products && res.products.length > 0) {
	    res.products.forEach(function(p) {
	        // 상품명은 ',' 앞까지만 출력 (없으면 전체 출력)
	        var displayName = p.PRODUCT_NAME ? p.PRODUCT_NAME.split(',')[0] : '이름 없음';

	        // 가격은 천 단위 구분, ₩ 앞뒤 붙이기
	        var displayPrice = (p.PRICE !== null && p.PRICE !== undefined && p.PRICE !== "")
	            ? '₩ ' + Number(p.PRICE).toLocaleString() + '원'
	            : '정보 없음';
	            
	            function wrapText(text, maxLength) {
	                if (!text) return "정보 없음";
	                return text.replace(new RegExp(`(.{${maxLength}})`, 'g'), '$1<br>');
	            }

	            // ✅ REASON 있으면 우선, 없으면 PRD_INFO 사용
	            var explain = p.REASON && p.REASON.trim() !== ""
	                ? p.REASON
	                : p.PRD_INFO;

	            var row = `
	                <tr>
	                    <td title="${p.PRODUCT_NAME || ''}">
	                        ${displayName}
	                    </td>
	                    <td>${displayPrice}</td>
	                    <td>${wrapText(explain, 70)}</td>
	                </tr>`;
	            tbody.append(row);  // ✅ 여기까지 수정
	    });
	} else {
		tbody.append(`
	        <tr>
	            <td colspan="4" style="text-align:center; color:#666;">
	                추천 가능한 상품이 없습니다.
	            </td>
	        </tr>
	    `);
	}
}


// 전역: 미리보기 초기화 유틸 (중복 바인딩 정리 후에도 필요)
function clearPreview() {
  var $file = $("#file-input");
  $file.val("");                              // 파일 리셋
  $("#preview").attr("src", "").hide();       // 썸네일 숨김
  $("#clear-preview").hide();                 // X 버튼 숨김
  $("#image-status").text("");                // 상태 텍스트 초기화
}


// page-recom일때만 /ask 이벤트 실행되게
if (IS_RECOM) {
	
	// page-recom 전용: sessionStorage 이미지 복구 → #file-input에 주입
	$(function(){
	  if (!document.body.classList.contains('page-recom')) return;

	  var dataURL = sessionStorage.getItem('aimae_image_data');
	  var name    = sessionStorage.getItem('aimae_image_name');
	  var type    = sessionStorage.getItem('aimae_image_type') || 'image/jpeg';

	  if (dataURL) {
	    try {
	      var arr = dataURL.split(',');
	      var bstr = atob(arr[1]);
	      var len = bstr.length, u8 = new Uint8Array(len);
	      for (var i=0; i<len; i++) u8[i] = bstr.charCodeAt(i);
	      var blob = new Blob([u8], { type: type });
	      var file = new File([blob], name || 'upload.jpg', { type: type });

	      var dt = new DataTransfer();
	      dt.items.add(file);
	      var fileEl = document.getElementById('file-input');
	      if (fileEl) fileEl.files = dt.files;

	      // 미리보기도 즉시 반영
	      if ($("#preview").length) {
	        $("#preview").attr("src", dataURL).show();
	        $("#clear-preview").show();
	        $("#image-status").text(name || "");
	      }
		  
		  // q 파라미터가 없고(=이미지만 넘어온 경우) 자동 분석 실행
		  var qParam = new URLSearchParams(location.search).get("q");
		  if (!qParam) { setTimeout(function(){ sendAsk(); }, 0); }
		  
	    } catch(e) {
	      console.warn('이미지 복구 실패:', e);
	    } finally {
	      // 사용 후 정리
	      sessionStorage.removeItem('aimae_image_data');
	      sessionStorage.removeItem('aimae_image_name');
	      sessionStorage.removeItem('aimae_image_type');
	      sessionStorage.removeItem('aimae_image_size');
	    }
	  }
	});
	
	// /ask 이벤트, 자동실행(q 읽기) 등 넣기
	$("#search-icon").on("click", function(e) { e.preventDefault(); sendAsk(); });
	$("#search-input").on("keydown", function(e) { if (e.key === "Enter") { e.preventDefault(); sendAsk(); } });

	// q 파라미터 자동 실행
	$(function() {
		var q = new URLSearchParams(location.search).get("q");
		if (q && q.trim()) {
			$("#search-input").val(q.trim());
			setTimeout(function() { sendAsk(); }, 0);
		}
	});
	
	// 이미지 업로드/미리보기 바인딩
	 $(function () {
	   var MAX_MB = 5;
	   var ALLOW = ["image/jpeg", "image/png", "image/webp", "image/gif"];

	   $("#image-icon").off(".recom").on("click.recom", function (e) {
	     e.preventDefault();
	     $("#file-input").click();
	   });

	   $("#file-input").off(".recom").on("change.recom", function () {
	     var f = this.files && this.files[0];
	     if (!f) return;

	     if ($.inArray(f.type, ALLOW) === -1) {
	       alert("이미지(JPG/PNG/WebP/GIF)만 가능합니다.");
	       clearPreview();
	       return;
	     }
	     if (f.size > MAX_MB * 1024 * 1024) {
	       alert("최대 " + MAX_MB + "MB까지 가능합니다.");
	       clearPreview();
	       return;
	     }

	     var reader = new FileReader();
	     reader.onload = function (e) {
	       $("#preview").attr("src", e.target.result).show();
	       $("#clear-preview").show();
	       $("#image-status").text(f.name + " (" + (f.size / 1048576).toFixed(2) + "MB)");
	     };
	     reader.readAsDataURL(f);
	   });

	   $("#clear-preview").off(".recom").on("click.recom", clearPreview);
	 });
}


// ===== 검색바가 있는 모든 페이지에서 동작(방탄 바인딩) =====
$(function () {
	
  // index.jsp에서만 실행
  if(!IS_INDEX) return;
  
  // .search-form 과 #file-input 이 실제로 있을 때만 바인딩
  var hasSearch = document.querySelector('.search-form') && document.getElementById('file-input');
  if (!hasSearch) return;

  var MAX_MB = 5;
  var ALLOW = ["image/jpeg","image/png","image/webp","image/gif"];

  // 중복 바인딩 방지
  $("#image-icon").off(".idx").on("click.idx", function(e){ e.preventDefault(); $("#file-input").click(); });

  $("#file-input").off(".idx").on("change.idx", function(){
    var f = this.files && this.files[0];
    if (!f) return;
    if ($.inArray(f.type, ALLOW) === -1) { alert("이미지(JPG/PNG/WebP/GIF)만 가능합니다."); clearPreview(); return; }
    if (f.size > MAX_MB*1024*1024) { alert("최대 "+MAX_MB+"MB까지 가능합니다."); clearPreview(); return; }
    var reader = new FileReader();
    reader.onload = function(e){
      $("#preview").attr("src", e.target.result).show();
      $("#clear-preview").show();
      $("#image-status").text(f.name + " (" + (f.size/1048576).toFixed(2) + "MB)");
    };
    reader.readAsDataURL(f);
  });

  $("#clear-preview").off(".idx").on("click.idx", clearPreview);

  // index → recom 이동 (q 있으면 파라미터, 이미지 있으면 세션 저장)
  function gotoRecom(e){
    if (e){ e.preventDefault(); e.stopPropagation(); }
    var q = $("#search-input").val().trim();
    var fileEl = document.getElementById("file-input");
    var hasFile = !!(fileEl && fileEl.files && fileEl.files.length);
    if (!q && !hasFile) { alert("질문 또는 이미지를 입력/선택해 주세요."); return false; }

    var base = (window.CONTEXT_PATH || "") + "/jsp/recom.jsp";
    var url  = q ? (base + "?q=" + encodeURIComponent(q)) : base;

    if (!hasFile) { window.location.assign(url); return false; }

    var file = fileEl.files[0];
    var reader = new FileReader();
    reader.onload = function(ev){
      try {
        sessionStorage.setItem("aimae_image_data", ev.target.result);
        sessionStorage.setItem("aimae_image_name", file.name || "upload.jpg");
        sessionStorage.setItem("aimae_image_type", file.type || "image/jpeg");
        sessionStorage.setItem("aimae_image_size", String(file.size || 0));
      } catch(err){ console.warn("sessionStorage 저장 실패:", err); }
      window.location.assign(url);
    };
    reader.readAsDataURL(file);
    return false;
  }

  // form 기본 submit 막고, 버튼/엔터로 이동
  $(".search-form").off(".idx").on("submit.idx", function(e){ e.preventDefault(); return false; });
  $("#search-icon").off(".idx").on("click.idx", gotoRecom);
  $("#search-input").off(".idx").on("keydown.idx", function(e){ if (e.key === "Enter") gotoRecom(e); });
});



// 로딩 상태 헬퍼(setLoading 중 버튼 눌림 방지)
var $askBtn = $("#search-icon");
function setLoading(on) {
	if (on) {
		$askBtn.addClass("disabled").css("pointer-events", "none").css("opacity", "0.5");
		$(".content-product-header").text("분석 중입니다… 잠시만요");
	} else {
		$askBtn.removeClass("disabled").css("pointer-events", "").css("opacity", "");
	}
}
