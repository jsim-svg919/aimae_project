// 검색 아이콘 클릭 시 처리
const searchIcon = document.getElementById("search-icon");
if (searchIcon) {
    searchIcon.addEventListener("click", function(event) {
        event.preventDefault();  // 기본 링크 동작 막기
        performSearch();  // 검색 함수 호출
    });
}

// Enter 키를 눌렀을 때 검색 처리
const searchInput = document.getElementById("search-input");
if (searchInput) {
    searchInput.addEventListener("keydown", function(event) {
        if (event.key === "Enter") {  // Enter 키가 눌렸을 때
            event.preventDefault();  // 기본 폼 제출 막기
            performSearch();  // 검색 함수 호출
        }
    });
}

// 검색 함수
function performSearch() {
    const query = document.getElementById("search-input").value.trim();
    
    if (query) {
        alert("검색어: " + query);  // 여기에 실제 검색 기능을 추가할 수 있음
        console.log("검색어:", query);
    } else {
        alert("질문을 입력하세요.");
    }
}

// 이미지 아이콘 클릭 시 파일 첨부창 열기
const imageIcon = document.getElementById("image-icon");
if (imageIcon) {
    imageIcon.addEventListener("click", function(event) {
        event.preventDefault();  // 기본 링크 동작 막기
        const fileInput = document.getElementById("file-input");
        if (fileInput) {
            fileInput.click();  // 파일 첨부 창 열기
        }
    });
}

// 파일이 첨부되었을 때 처리
const fileInput = document.getElementById("file-input");
if (fileInput) {
    fileInput.addEventListener("change", function() {
        const file = this.files[0];
        if (file) {
            alert("첨부된 파일: " + file.name);  // 첨부된 파일 이름을 알림으로 출력
        }
    });
}

// form 제출 시 기본 동작 막기 (Enter 키 눌렀을 때)
const searchForm = document.getElementById("search-form");
if (searchForm) {
    searchForm.addEventListener("submit", function(event) {
        event.preventDefault();  // 폼 제출 기본 동작 방지
        performSearch();  // 검색 함수 호출
    });
}