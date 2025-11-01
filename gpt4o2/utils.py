import pandas as pd


# CSV 로드 & 컬럼 정리
def load_products(path: str) -> pd.DataFrame:

    # 지정 경로의 CSV를 UTF-8로 읽어
    df = pd.read_csv(path, encoding="utf-8") 

    # 컬럼명 앞뒤 공백 제거 → 이후 컬럼 접근 시 오타/공백 문제 예방
    df.columns = [c.strip() for c in df.columns]

    # 판다스가 인덱스를 같이 저장했을 때 생기는
    #  Unnamed: 0 같은 임시 컬럼을 찾음(대소문자 무시)
    drop_cols = [c for c in df.columns if c.lower().startswith("unnamed")]
    
    if drop_cols:
        # 위 임시 컬럼들을 제거해서 DF를 깔끔하게 유지
        df = df.drop(columns=drop_cols)
    return df


# 추천 목록을 한 줄 요약으로 포맷
def build_context(products, max_chars=120) -> str:
    lines = []

    for p in products or []:

        # 상품 설명을 가져오고 개행→공백으로 바꾼 뒤 앞뒤 공백 제거
        info = (p.get("PRD_INFO") or "").replace("\n", " ").strip()

        if len(info) > max_chars:
            info = info[:max_chars].rstrip() + "…"
        
        # 누락 대비 기본값 공백
        price = p.get("PRICE", "")
        name = p.get("PRODUCT_NAME","")

        # 한 상품을 한 줄 요약 형태로 추가
        lines.append(f"- {name} ({price}) : {info}")
        
    return "\n".join(lines)