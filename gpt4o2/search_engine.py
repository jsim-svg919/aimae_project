from typing import List, Dict, Tuple
import pandas as pd
import json, re
from nlp import IMG_KEYWORD_WEIGHT


# 헬퍼 함수(상품명 대소문자 무시(case=False) 로 부분일치하는지 True/False 시리즈 반환)
def _contains_ci(s: pd.Series, kw: str):
    return s.astype(str).str.contains(kw, case=False, regex=False, na=False)


# 헬퍼 함수(PRICE 컬럼을 정수형 정렬용 컬럼 PRICE_int 로 안전 변환)
def _safe_price_int(df: pd.DataFrame):
    if "PRICE" in df.columns:
        df["PRICE_int"] = pd.to_numeric(df["PRICE"], errors="coerce").fillna(0).astype(int)
    else:
        df["PRICE_int"] = 0
    return df


# 사용자 질의가 A: 구체 품목, B: 카테고리, C: 일반 탐색 중 어디에 해당하는지 판별
def detect_intent(df: pd.DataFrame, keywords: list[str], kw_weights: dict[str,int] | None = None) -> Tuple[str, str | None]:
    kws = [k for k in (keywords or []) if k]

    # 키워드 없으면 → C (일반 탐색)
    if not kws:
        return "C", None

    # 이미지 라벨(가중치 높은 키워드)이 상품명에 걸리면 -> A 
    if kw_weights:
        for k in kws:
            if kw_weights.get(k, 1) >= IMG_KEYWORD_WEIGHT:
                if df["PRODUCT_NAME"].astype(str).str.contains(k, case=False, na=False).any():
                    return "A", None

    # A: 상품명에 어느 키워드든 1개 이상 매칭되면 구체 품목
    name_hits = sum(df["PRODUCT_NAME"].astype(str).str.contains(k, case=False, na=False).sum() for k in kws)
    if name_hits >= 1:
        return "A", None

    # B: 카테고리 컬럼이 있고, 키워드가 카테고리와 일치/근접
    if "CATEGORY" in df.columns:
        cats = set(str(c).strip().lower() for c in df["CATEGORY"].dropna().unique())
        for k in kws:
            kk = k.strip().lower()
            if kk in cats or any(c == kk for c in cats):
                return "B", kk

    return "C", None

# 후보 상품명 리스트를 만들고(names) → LLM에게 “종류가 겹치지 않게 k개만” 선택
def pick_diverse_with_llm(client, user_query: str, candidates: List[Dict], k: int = 3) -> List[str]:
    
    # 후보 이름 추출 + 빠른 종료
    names = [c.get("name", "") for c in candidates if c.get("name")]
    if len(names) <= k:
        return names
    
    # 프롬프트 구성 (system / user)
    sys_msg = "You are a helpful shopping assistant. Return STRICT JSON only."
    user_msg = (
        "아래 후보 상품명 목록에서 서로 다른 '종류'가 되도록 {k}개 골라줘.\n"
        "반드시 후보에 존재하는 '상품명'만 골라. 설명 없이 JSON 배열만 반환해.\n"
        f"사용자 질의: {user_query}\n" + "\n".join(f"- {n}" for n in names) +
        f"\n출력형식 예: [\"상품명1\",\"상품명2\",\"상품명3\"]\n반환개수: 정확히 {k}개"
    ).format(k=k)

    # LLM 호출 → 응답 파싱 1차(JSON)
    try:
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role":"system","content":sys_msg},{"role":"user","content":user_msg}],
            temperature=0.2,
            max_tokens=200,
        )
        text = (resp.choices[0].message.content or "").strip()
        
        try:
            arr = json.loads(text)
        
        # 실패시 대괄호 스니핑(정규식 Fallback)
        except Exception: 
            m = re.search(r"\[.*\]", text, re.S) # 대괄호 블록([...])만 뽑아 다시 json.loads 시도
            arr = json.loads(m.group(0)) if m else []
        
        # 유효성 필터링 → 최종 선택/반환
        picks = [p for p in arr if isinstance(p, str) and p in names]
        
        if picks:
            return picks[:k]
    
    # 실패 대비 최종 Fallback
    except Exception:
        pass  # LLM 호출/파싱이 모두 실패해도 서비스는 계속
    return names[:k]


# “구체 품목” 검색. 첫 번째 키워드 한 개를 상품명/설명에 직접 포함하는 상품을 고름
def search_specific_item(df: pd.DataFrame, keywords: list[str], limit=3, kw_weights=None):
    
    # 첫 키워드 추출 & 없으면 빈 결과
    kw = keywords[0] if keywords else ""
    if not kw:
        return []
    
    # 상품명 또는 설명에 부분일치(대소문자 무시) 하면 채택
    mask = _contains_ci(df["PRODUCT_NAME"], kw) | _contains_ci(df["PRD_INFO"], kw)
    cand = df[mask].copy()
    if cand.empty:
        return []
    
    # 후보가 많을 때는 무작위 샘플로 limit개 뽑아 다양성 확보
    return cand.sample(n=min(limit, len(cand)), random_state=None).to_dict("records")


# 키워드가 카테고리에 해당할 때, 그 카테고리 안에서 다양한 종류로 limit개 뽑기
def search_category_diverse(df: pd.DataFrame, keywords: List[str], user_query: str, limit: int = 3, client=None) -> List[Dict]:
    
    # 카테고리 컬럼 없거나 키워드가 비어 있으면 즉시 종료
    if "CATEGORY" not in df.columns:
        return []
    kws = [k for k in (keywords or []) if k]
    if not kws:
        return []
    
    # 정확 일치(k == cat) + 부분 일치(k in cat or cat in k) 모두 허용
    def cat_match(cat: str) -> bool:
        cat = str(cat or "").strip().lower()
        for kw in kws:
            k = kw.strip().lower()
            if k and (k == cat or k in cat or cat in k):
                return True
        return False
    
    # PRICE_int(저가 우선)
    # → PRODUCT_NAME 순으로 정렬, 최대 15개로 컷(LLM 비용/맥락 제한 목적)
    cand_df = df[df["CATEGORY"].astype(str).apply(cat_match)].copy()
    if cand_df.empty:
        return []
    cand_df = _safe_price_int(cand_df)
    cand_df.sort_values(["PRICE_int","PRODUCT_NAME"], ascending=[True, True], inplace=True)
    cand_df = cand_df.head(15)

    # LLM 사용 가능하면 서로 다른 ‘종류’ 되게 k개 선택 아니면 그냥 정렬 상위 limit
    cands = [{"name": r["PRODUCT_NAME"], "info": r.get("PRD_INFO",""), "category": r.get("CATEGORY","")} for _, r in cand_df.iterrows()]
    picked = pick_diverse_with_llm(client, user_query, cands, k=limit) if client else [r["PRODUCT_NAME"] for _, r in cand_df.head(limit).iterrows()]
    
    # 선택된 이름들로 행 필터 → 모자라면 나머지에서 채워 limit 맞춤
    out = cand_df[cand_df["PRODUCT_NAME"].isin(set(picked))]
    if len(out) < limit:
        remain = cand_df[~cand_df["PRODUCT_NAME"].isin(set(picked))]
        out = pd.concat([out, remain.head(limit-len(out))], axis=0)
    cols = ["PRODUCT_ID","PRODUCT_NAME","PRD_INFO","PRICE","CATEGORY","STOCK","PRD_DETAIL","IMAGE_URL"]
    
    # 필요한 컬럼만 뽑아 dict 리스트로 반환
    return [{k: rec.get(k) for k in cols if k in rec} for rec in out.to_dict("records")][:limit]


# 상품명/설명 전체에서 키워드 OR 매칭으로 후보를 모으고 가중치 점수로 랭킹
#  → LLM으로 다양성 선택(가능 시) → 상위 limit 반환
def search_general_diverse(df: pd.DataFrame, keywords: list[str], user_query: str, limit: int = 3, kw_weights=None, client=None):
    
    # 키워드 없으면 종료(일반 탐색 불가)
    kws = [k for k in (keywords or []) if k]
    if not kws:
        return []
    
    # 각 키워드에 대해 이름 OR 설명 매칭(m) 만들고, 키워드 간 OR 누적
    mask = False
    for kw in kws:
        m = _contains_ci(df["PRODUCT_NAME"], kw) | _contains_ci(df["PRD_INFO"], kw)
        mask = m if mask is False else (mask | m)
    cand_df = df[mask].copy()
    if cand_df.empty:
        return []
    
    # 가중치 점수 계산
    weights = kw_weights or {} # 키워드별 가중치(dict), 없으면 기본 1
    score = 0

    for kw in kws:
        # 해당 키워드가 그 행에 매칭되면 1, 아니면 0의 Series
        hit = (_contains_ci(cand_df["PRODUCT_NAME"], kw) | _contains_ci(cand_df["PRD_INFO"], kw)).astype(int)
        # 0(정수)에서 시작해 Series 연산으로 누적, 최종적으로 행별 점수 Series
        score = score + hit * int(weights.get(kw, 1))
    
    cand_df["__score"] = score

    # 정렬·컷 & 후보 목록 만들기
    cand_df = _safe_price_int(cand_df)

    # __score 내림차순(점수 높은 게 위) 
    # PRICE_int, PRODUCT_NAME 오름차순(동점 시 더 저렴한 순)
    cand_df.sort_values(["__score","PRICE_int","PRODUCT_NAME"], ascending=[False, True, True], inplace=True)
    
    # 15개 컷: LLM 컨텍스트·비용 절약 + 후속 로직 단순화.
    cand_df = cand_df.head(15)
    cands = [{"name": r["PRODUCT_NAME"], "info": r.get("PRD_INFO",""), "category": r.get("CATEGORY","")} for _, r in cand_df.iterrows()]
    
    # client 있으면 LLM으로 “종류 겹치지 않게” limit개 선택
    picked = pick_diverse_with_llm(client, user_query, cands, k=limit) if client else [r["PRODUCT_NAME"] for _, r in cand_df.head(limit).iterrows()]
    
    # 선택된 이름으로 필터링하고, 모자라면 남은 후보에서 채워 limit 보장
    out = cand_df[cand_df["PRODUCT_NAME"].isin(set(picked))]
    if len(out) < limit:
        remain = cand_df[~cand_df["PRODUCT_NAME"].isin(set(picked))]
        out = pd.concat([out, remain.head(limit-len(out))], axis=0)
    
    cols = ["PRODUCT_ID","PRODUCT_NAME","PRD_INFO","PRICE","CATEGORY","STOCK","PRD_DETAIL","IMAGE_URL"]
    
    # 프런트가 쓰는 핵심 컬럼만 dict로 추출
    return [{k: rec.get(k) for k in cols if k in rec} for rec in out.to_dict("records")][:limit]


# 앞서 만든 의도 감지 결과(A/B/C) 에 따라 해당 검색 함수로 라우팅
def search_products_by_intent(df: pd.DataFrame, keywords: list[str], user_query: str, limit: int = 3, kw_weights=None, client=None):
    
    # detect_intent로 A/B/C 판단
    intent, _ = detect_intent(df, keywords, kw_weights=kw_weights)
    
    # A: 첫 키워드 중심 구체 품목 검색
    if intent == "A":
        return search_specific_item(df, keywords, limit=limit, kw_weights=kw_weights)
    
    # B: 카테고리 내부에서 다양성 있게 선택
    if intent == "B":
        return search_category_diverse(df, keywords, user_query, limit=limit, client=client)
    
    # C(기본): 전체에서 키워드 OR 매칭 + 가중치 점수 + 다양성 선택
    
    return search_general_diverse(df, keywords, user_query, limit=limit, kw_weights=kw_weights, client=client)


# 바깥(예: app.py)에서 직접 호출하는 최상위 검색 함수
def search_products_multi(df: pd.DataFrame, keywords: list[str], user_query: str, limit: int = 3, kw_weights=None, client=None) -> List[Dict]:
    return search_products_by_intent(df, keywords, user_query, limit=limit, kw_weights=kw_weights, client=client)