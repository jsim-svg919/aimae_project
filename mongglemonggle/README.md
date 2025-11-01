# 🛍️ AIMAE: 고민 많은 당신을 위한 AI 쇼핑 메이트

> 멀티모달 입력(텍스트 + 이미지)을 활용한 개인 맞춤형 제품 추천 및 비교 서비스

---

## 📌 프로젝트 소개

**AIMAE**는 사용자의 텍스트 질문이나 제품 사진을 바탕으로, 상황에 맞는 제품을 추천하고 비교 분석해주는 AI 쇼핑 어시스턴트입니다.

> "복잡한 쇼핑 고민, 한 줄 질문이나 사진 한 장으로 해결하세요!"

---

## 📁 프로젝트 폴더 구조

```plaintext
AIMAE/
├── 📁 메인 백엔드
│   ├── controller/          # 서비스 로직 및 요청 처리
│   ├── model/               # 데이터 모델 및 DAO
│   ├── mapper/              # MyBatis 매퍼 XML
│   └── util/                # 유틸리티(메일 발송, DB 세션 등)
│
├── 📁 웹 리소스
│   ├── css/                 # 스타일시트
│   ├── images/              # 이미지 리소스
│   ├── js/                  # JavaScript 파일
│   └── jar/                 # 외부 라이브러리(JAR)
│
├── 📁 JSP 페이지
│   ├── admin.jsp
│   ├── cart.jsp
│   ├── electronicProducts.jsp
│   ├── findID.jsp
│   ├── findPw.jsp
│   ├── fruitProducts.jsp
│   ├── join.jsp
│   ├── login.jsp
│   ├── mypage.jsp
│   ├── orderAction.jsp
│   ├── payment.jsp
│   ├── productDetail.jsp
│   ├── recom.jsp
│   └── vegetableProducts.jsp
│
└── 📁 설정
    └── WEB-INF/
        └── web.xml

```

---

# 🚀 설치 및 실행 방법

## 1) VSCode에서 클론 복제
```bash
git clone https://github.com/Hanchanhee1/gpt4o2.git
cd gpt4o2
```

## 2) 가상환경 생성 및 실행
```bash
# 가상환경 만들기
python -m venv .venv

# 윈도우 실행
.venv\Scripts\activate  

# 맥/리눅스 실행
source .venv/bin/activate
```

## 3) 필수 패키지 설치
```bash
pip install -r requirements.txt
```

👉 여기까지 하면 기본 실행 준비 완료!

## 4) 추가 리소스 다운로드 (필요 시)
프로젝트 실행에는 모델 및 리소스 파일이 필요합니다.  
깃허브 **Releases** 탭에서 아래 파일들을 다운로드 후 각 폴더에 배치하세요.

- 📁 **모델 파일**  
  `vit_20250818_143345` → `gpt4o2/` 폴더에 넣기

- 📁 **프로젝트 사진**  
  `projectPhoto` → `webapp/` 폴더에 넣기

- 📁 **상품 이미지**  
  `productImage` → `webapp/` 폴더에 넣기

## ✅ 서버 실행
```bash
python app.py
```
서버가 정상적으로 실행되면 웹 브라우저에서 확인할 수 있습니다 🎉

---

## ⏳ 프로젝트 기간

2025년 7월 28일 \~ 2025년 8월 28일 (1개월)

---

## 🔹 주요 기능

* **멀티모달 입력 기반 제품 추천**

  * 텍스트, 이미지, 혹은 동시 입력 가능
* **한눈에 보는 제품 정보**

  * 가격, 상세 내용, 리뷰 비교표 제공
* **간편한 구매**

  * 장바구니 기능: 추가, 삭제, 수량 변경
  * 클릭 시 바로 결제 연동
* **SNS 로그인 및 결제 연동**

  * 카카오/네이버 로그인
  * 아임포트 결제 API

---

## 🛠️ 기술 스택

| 구분     | 기술                            |
| ------ | ----------------------------- |
| 언어     | [![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge\&logo=python\&logoColor=white)]() [![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge\&logo=java\&logoColor=white)]()                  |
| 프론트엔드  | [![HTML](https://img.shields.io/badge/HTML-E34F26?style=for-the-badge\&logo=html5\&logoColor=white)]() [![CSS](https://img.shields.io/badge/CSS-1572B6?style=for-the-badge\&logo=css3\&logoColor=white)]() [![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge\&logo=javascript\&logoColor=black)]()         |
| 백엔드    | ![Servlet](https://img.shields.io/badge/Servlet-6DB33F?style=for-the-badge) ![MyBatis](https://img.shields.io/badge/MyBatis-1E90FF?style=for-the-badge) <img src="https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=Flask&logoColor=white">   |
| 서버     | [![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge\&logo=apachetomcat\&logoColor=white)]()                |
| 데이터베이스 | [![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge\&logo=oracle\&logoColor=white)]()                        |
| AI     | ![Google ViT](https://img.shields.io/badge/Google_ViT-4285F4?style=for-the-badge) ![GPT-4o](https://img.shields.io/badge/GPT-4o-00A67E?style=for-the-badge)            |
| 라이브러리  | ![bcrypt](https://img.shields.io/badge/bcrypt-DAA520?style=for-the-badge)                        |
| API    | ![Kakao](https://img.shields.io/badge/Kakao-FFCD00?style=for-the-badge&logo=kakaotalk&logoColor=black) ![Naver](https://img.shields.io/badge/Naver-03C75A?style=for-the-badge&logo=naver&logoColor=white) ![Iamport](https://img.shields.io/badge/Iamport-FF6A00?style=for-the-badge) |
| 개발도구   | ![Eclipse](https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=eclipse&logoColor=white) ![VSCode](https://img.shields.io/badge/VSCode-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white)               |
| 협업     | [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge\&logo=github\&logoColor=white)](https://github.com/2025-SMHRD-IS-CLOUD-3/mongglemonggle) [![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge\&logo=figma\&logoColor=white)]()             |

---

##  시스템 아키텍처

<img width="550" height="562" alt="image" src="https://github.com/user-attachments/assets/3d17b95a-d934-4cfd-86f2-07f7430c8b06" />


---

##  유스케이스
<img width="1101" height="624" alt="image" src="https://github.com/user-attachments/assets/a9c994e7-fad1-4083-935b-e3eb71147db2" />
<img width="1126" height="638" alt="image" src="https://github.com/user-attachments/assets/4e6e1eea-0d5c-47d5-ae36-545156b1c75c" />



---

##  서비스 흐름도

```
사용자
  │
  ▼
텍스트/이미지 입력
  │
  ▼
AI 분석 (Google Vit Model + GPT4-o)
  │
  ▼
추천 제품 리스트 + 비교표
  │
  ▼
장바구니 담기 / 결제 진행
  │
  ▼
주문 완료 / 마이페이지 업데이트
```

---

##  ER 다이어그램

<img width="809" height="533" alt="image" src="https://github.com/user-attachments/assets/c07cc8bd-074c-4c99-a0dd-dbfcaa5ec2e6" />


---

##  화면 구성

* **메인 페이지**:
  <img width="1892" height="945" alt="image" src="https://github.com/user-attachments/assets/2521436e-5f03-43ae-b593-2f770bbf62c9" />
<img width="1918" height="952" alt="image" src="https://github.com/user-attachments/assets/7b8b2ddb-0acf-4c0b-9edd-ed713925354c" />
<img width="1920" height="728" alt="image" src="https://github.com/user-attachments/assets/7fcaaa73-feb8-462f-9162-b65b22c66f5b" />


* **추천 결과 페이지**:
  <img width="1920" height="893" alt="image" src="https://github.com/user-attachments/assets/474e0b54-54ca-4b4f-8772-72b47dc05851" />
<img width="1919" height="950" alt="image" src="https://github.com/user-attachments/assets/e25ed4c5-8f94-4dfd-8724-42abf83f1298" />

* **상세 페이지**:
  <img width="1916" height="945" alt="image" src="https://github.com/user-attachments/assets/ea21a2d0-25ae-476f-bdd5-0004a25555dc" />
<img width="1916" height="906" alt="image" src="https://github.com/user-attachments/assets/44522117-8b14-4daf-a8dd-3cb429d245e7" />
<img width="1915" height="780" alt="image" src="https://github.com/user-attachments/assets/566dc229-f5ef-400c-b872-d81a94eba50a" />

* **마이페이지**:
  <img width="1350" height="917" alt="image" src="https://github.com/user-attachments/assets/7d382fb0-dc2e-4913-a2f8-aa368d3af44c" />


---

## 💡 기대효과 및 활용 방안

- 소비자의 제품 선택 피로도 감소
- 쇼핑몰의 체류 시간 및 구매 전환율 상승
- 이커머스, 건강기능식품, 뷰티 등 다양한 분야로 확장 가능
- B2B 기업 대상 추천 솔루션으로 활용 가능

---

## 👥 팀원 역할

| 이름       | 역할 및 담당                                                         |
| -------- | --------------------------------------------------------------- |
| 한찬희 (팀장) | 총괄, PM, 기획/DB/설계/문서, UI/UX, 프론트엔드·백엔드 개발, PPT/발표                |
| 임진서      | 기획/설계/문서, 백엔드, AI 모델 파인튜닝(Google ViT Model), API 연동(OpenAI, Iamport), 데이터 수집, PPT |
| 오정관      | DB 설계/구축, 백엔드, 장바구니 기능 구현, 물건 기능 구현, 자료 수집                                |
| 양용석      | 백엔드, 회원 기능 구현(가입, 정보 변경, 삭제/수정), 자료 수집, 간편 로그인 API 연동 (카카오, 네이버)                          |

---

## ⚠️ 트러블슈팅

### 1️⃣ **이미지 분석 정확도 문제** :

사용자가 **아보카도** 사진을 업로드하고 검색했을 때, 시스템이 정확하게 아보카도를 인식하지 못하고, 대신 **라임**과 관련된 제품들이 검색 결과로 나오는 문제가 발생했습니다. 이는 이미지 분석 정확도에 한계가 있어 발생한 문제였습니다.

- **해결 방법**: Google ViT 모델을 **파인튜닝(fine-tuning)** 하여 **아보카도**와 관련된 이미지를 더 잘 인식할 수 있도록 학습을 강화했습니다. 기존 모델을 기반으로 추가 학습을 통해 아보카도와 비슷한 이미지를 구분하는 능력을 향상시켰습니다. 이 과정에서 다양한 **아보카도 이미지**를 포함시켜 모델의 정확도를 높였으며, **상품 이미지에서 제품 이름을 정확히 추출**할 수 있도록 개선했습니다.

- **해결 결과**: 학습된 모델 덕분에 이제 **아보카도 이미지**를 정확히 인식하고 관련 제품을 정확하게 추천할 수 있게 되었습니다.

### 2️⃣ **회원탈퇴 오류 문제** :

- **문제**: 사용자가 회원탈퇴를 시도할 때, 회원탈퇴 오류가 발생했습니다. 오류 메시지를 확인해본 결과, **constraint 제약조건** 관련 오류가 발생하고 있었습니다. 구체적으로, **USERS 테이블**과 **CART 테이블** 간의 종속성 문제로 인해 해당 유저의 데이터를 삭제할 수 없었습니다.
    
- **문제 분석**:
    - **USERS 테이블**에는 `USER_NUM`이 **Primary Key (PK)** 로 설정되어 있고,
    - **CART 테이블**에서는 해당 `USER_NUM`이 **Foreign Key (FK)**로 설정되어 있어, 두 테이블 간에 **종속성**이 존재합니다.
    - 이로 인해, **CART 테이블**에 해당 유저의 데이터가 남아있으면 회원탈퇴가 불가능한 상황이 발생했습니다.
- **해결 방법**:
    1. **FK 제약조건**을 삭제하여 두 테이블 간의 종속성을 제거할 수 없다고 판단했습니다.
    2. 그 대신, **ON DELETE CASCADE** 옵션을 **CART 테이블**의 **Foreign Key**에 추가하여, 유저가 탈퇴할 때 해당 유저의 모든 데이터가 자동으로 삭제되도록 설정했습니다.
    3. 이를 통해 **회원탈퇴 시 유저 데이터와 관련된 모든 데이터(CART 데이터 포함)**가 함께 삭제되도록 변경했습니다.
        
- **해결 결과**:
    - 이제 **회원탈퇴 시**, **CART 테이블**에 해당 유저의 데이터가 존재해도 **자동으로 삭제**되며, **USER 테이블**의 유저 데이터와 함께 정상적으로 탈퇴가 처리되고 **회원탈퇴 오류**가 해결되었습니다.

```
```




