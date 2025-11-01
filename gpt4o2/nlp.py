from typing import List, Dict
import re, json
import pandas as pd

# 검색에 도움 안 되는 단어는 키워드에서 제거(흔한 단어는 키워드 가치 없음)
STOPWORDS = {"제품","상품","추천","가성비","저렴","저렴한","좋은","정리","해줘","주세요","좀","관련","정보"}
IMG_KEYWORD_WEIGHT = 3  # 이미지 라벨 가중치 (2~5로 조절 가능)


# OpenAI API 호출 & 질문 처리 및 키워드 도출
def get_keywords_from_question(client, question: str) -> List[str]:

    # None이나 빈 문자열을 안전하게 처리, 앞뒤 공백 제거
    question = (question or "").strip()
    if not question:
        return []
    
    # 프롬프트 작성
    try:
        prompt = (
            "다음 사용자의 쇼핑 질문에서 검색에 유용한 핵심 키워드를 최대 2개만 뽑아줘.\n"
            "- 한국어 그대로 출력\n- 불용어 제외\n- 각 키워드는 한 줄에 하나씩\n" 
            "- 출력 형식: 키워드만 줄바꿈으로 (다른 설명/기호/따옴표 X)\n\n" # 한 줄로 쓰면 파싱이 까다로워짐
            f"질문: {question}"
        )

        # OpenAI API 호출
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role":"user","content":prompt}],
            temperature=0.2,
            max_tokens=20,
        )

        # 질문(모델)이 종종 깔끔하지 않음(지저분한 기호 등) -> 후처리
        text = (resp.choices[0].message.content or "").strip() # 모델 답변, 앞뒤 공백 제거
        kws = [x.strip().strip('"\':,.;()[]{}') for x in text.splitlines()] # 기호 제거
        kws = [x for x in kws if x and x not in STOPWORDS][:2] # stopwords 제거, 최대 2개까지 추출
        if kws:
            return kws # 키워드가 있으면 함수 종료
        
    except Exception:
        pass  # 문제 발생 시 문제는 그냥 넘기고
    tokens = re.findall(r"[가-힣A-Za-z0-9]+", question) # 한글/영문/숫자로 된 단어만 뽑아
    tokens = [t for t in tokens if len(t) >= 2 and t not in STOPWORDS] # 최소 2글자 이상만
    return tokens[:2] # 뽑은 단어 중 2개만 돌려줘


# 제품명 키워드 불러오기 -> 가중치 2점 주려고
def load_item_keywords(path="ITEMS.csv"):
    try:
        df = pd.read_csv(path)
        return set(df["keyword"].dropna().astype(str).str.strip())
    except Exception:
        return set()

ITEM_KEYWORDS = load_item_keywords()



# 텍스트 키워드와 이미지 라벨을 받아서, 최종 키워드 리스트와 가중치 맵 두 개를 튜플로 돌려주는 함수
def build_kw_weights(text_keywords, img_label=None):
    
    # text_keywords 값 중, 빈 값이 아니면(if k) 모아서 keywords 리스트에 담아라
    keywords = [k for k in (text_keywords or []) if k]
    kw_weights = {}

    for k in keywords:
        if k in ITEM_KEYWORDS:     # CSV에 있으면 2점
            kw_weights[k] = 3
        else:
            kw_weights[k] = 1    # 기본 키워드에 1점

    # 이미지 라벨이 존재한다면
    if img_label:
        if img_label not in kw_weights: # 라벨이 기존 키워드에 없다면
            keywords = [img_label] + keywords # 라벨을 맨 앞에 붙임
        else:
            keywords = [img_label] + [k for k in keywords if k != img_label]
        
        kw_weights[img_label] = 3  # 이미지 라벨은 3점

    # 최종적으로 (keywords, kw_weights) 튜플 반환
    return keywords, kw_weights


# 상품 추천 이유
def make_reasons(client, question: str, products: list[dict], img_label: str | None = None) -> list[str]:
    """
    products 순서에 맞춰 한 줄짜리 추천 이유를 JSON 배열로 반환.
    실패시엔 간단한 규칙 기반 폴백.
    """
    if not products:
        return []

    # 각 상품 정보를 너무 길지 않게 축약 (토큰 절약)
    rows = []
    for p in products:
        name = p.get("PRODUCT_NAME","")
        cat  = p.get("CATEGORY","")
        price = p.get("PRICE","")
        info = (p.get("PRD_INFO","") or "").replace("\n"," ").strip()
        if len(info) > 120:
            info = info[:120].rstrip() + "…"
        rows.append(f"- 이름:{name} / 카테고리:{cat} / 가격:{price} / 설명:{info}")

    hint = f"(이미지 라벨: {img_label})" if img_label else ""
    user_msg = (
        "아래 상품 목록과 사용자의 질문을 참고해서, 각 상품을 왜 추천하는지 한국어로 한 문장씩 써줘.\n"
        "중요: 반드시 JSON 배열만 반환해. 배열 길이는 상품 개수와 동일, 순서도 동일.\n"
        "문장 톤은 짧고 따뜻하게, 질문 의도를 반영해 핵심 근거 하나만 포함(가격/용도/스펙/휴대성 등).\n"
        f"사용자 질문: {question} {hint}\n"
        "상품 목록:\n" + "\n".join(rows) + "\n\n"
        "출력 예시: [\"가격이 합리적이라 입문용으로 좋아요.\", \"소음이 적어 야간 사용에 적합해요.\"]"
    )

    try:
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role":"system","content":"Return STRICT JSON only."},
                {"role":"user","content":user_msg}
            ],
            temperature=0.4,
            max_tokens=150,
        )
        text = (resp.choices[0].message.content or "").strip()
        try:
            arr = json.loads(text)
        except Exception:
            m = re.search(r"\[.*\]", text, re.S)
            arr = json.loads(m.group(0)) if m else []
        if isinstance(arr, list) and len(arr) == len(products):
            return [str(x).strip() for x in arr]
    except Exception:
        pass

    # 폴백: 간단 규칙 기반
    out = []
    q = (question or "").lower()
    for p in products:
        info = (p.get("PRD_INFO","") or "").lower()
        name = p.get("PRODUCT_NAME","")
        if "저렴" in q or "가성비" in q or "가격" in q:
            out.append("가격 대비 구성이 좋아 가성비를 찾는 분께 어울려요.")
        elif any(k in info for k in ["조용","저소음","소음"]):
            out.append("소음이 적어 실내에서 쓰기 편해요.")
        elif any(k in info for k in ["가벼", "휴대", "컴팩트"]):
            out.append("부담 없는 무게로 휴대가 간편해요.")
        else:
            out.append(f"{name}의 주요 기능이 질문 의도와 잘 맞아요.")
    return out