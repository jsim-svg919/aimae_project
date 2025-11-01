from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
import os, tempfile, shutil
from dotenv import load_dotenv
from openai import OpenAI

from utils import load_products, build_context
from nlp import get_keywords_from_question, build_kw_weights, make_reasons
from search_engine import search_products_multi
from vision import get_image_label


# --- setup ---
load_dotenv() # .env 파일 로드
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=False)


# --- CSV data 읽기 ---
DF = load_products("PRODUCT.csv")


# 라우트 선언(POST와 OPTIONS 요청)
@app.route("/ask", methods=["POST", "OPTIONS"])
@cross_origin(origins="*", methods=["POST","OPTIONS"], headers=["Content-Type"])
def ask():

    # CORS 프리플라이트(예비 점검 요청) 처리
    if request.method == "OPTIONS":
        return ("", 204)


    question = ""
    img_label = None
    tmpdir = None

    try:
        # 파일 업로드 방식(form-data)
        if request.files:

            question = (request.form.get("question") or "").strip()
            f = request.files.get("image") or request.files.get("file")

            if f and f.filename: # 실제 파일이 있으면 
                tmpdir = tempfile.mkdtemp(prefix="vit_") # 임시 폴더 생성
                img_path = os.path.join(tmpdir, os.path.basename(f.filename))
                f.save(img_path) # 저장
                img_label = get_image_label(img_path) # 이미지 라벨 도출

        else:

            data = request.get_json(silent=True) or {} # 파일 없으면 바디 파싱
            question = (data.get("question") or "").strip() # question만 추출
    
    finally:

        if tmpdir:
            shutil.rmtree(tmpdir, ignore_errors=True) # 임시 폴더 삭제(서버에 쌓이지 않도록)


    # 1) 텍스트 키워드 + 2) 이미지 라벨 최우선/가중치
    text_keywords = get_keywords_from_question(client, question) # 질문 -> 키워드로 정제
    keywords, kw_weights = build_kw_weights(text_keywords, img_label) # 키워드 목록, 가중치
    print(f"[DEBUG] keywords(final)={keywords} | weights={kw_weights} | img_label={img_label}")


    # 3) 멀티 검색 엔진 호출 (A/B/C)
    #    A/B/C 의도 분기(카테고리/키워드/설명 임베딩 등)를 혼합해 상위 3개 랭킹 산출.
    products = search_products_multi(DF, keywords, question, limit=3, kw_weights=kw_weights, client=client)
    print("[DEBUG] products:", products)


    # ✅ 각 상품에 추천 이유 추가
    reasons = make_reasons(client, question, products, img_label=img_label)
    for i, r in enumerate(reasons):
        if i < len(products):
            products[i]["REASON"] = r


    # 4) 멘트 프롬프트 빌드(제품 수에 따른 분기)
    context = build_context(products, max_chars=120)
    if not products:

        prompt = (
            f"사용자가 '{question}' 라고 물었어. 우리 쇼핑몰에 관련 제품이 없어.\n"
            f"일반적으로 도움이 될 만한 조언을 짧게 해주고, "
            f"마지막에 우리 쇼핑몰에는 관련 제품이 없다고 말해줘.\n"
            f"멘트는 한두 문장, 친근하고 따뜻하게."
        )

    elif len(products) >= 3:

        prompt = (
            f"사용자가 '{question}' 라고 물었어.\n"
            f"아래 추천 제품 목록을 참고해서, 공통 특징을 반영한 간단한 멘트(한두 문장) 친근하고 따뜻하게.\n"
            f"중요: 목록에 없는 상품은 절대 언급하지 마.\n"
            f"추천 제품 목록:\n{context}"
        )

    else:

        prompt = (
            f"사용자가 '{question}' 라고 물었어.\n"
            f"아래 추천 제품 목록을 참고해서 특징을 반영한 간단한 멘트(한두 문장) 친근하고 따뜻하게. "
            f"제품명 전체를 말하지 말고, 일반적인 보완 조언을 함께 해줘도 돼.\n"
            f"추천 제품 목록:\n{context}"
        )


    # LLM 호출(OpenAI) + 예외 대응
    try:

        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are a helpful shopping assistant. Keep it brief, warm, and friendly."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.5, # 낮을수록 일관, 정해진 / 높을수록 창의적
            max_tokens=120,
        )

        answer = (resp.choices[0].message.content or "").strip()

    except Exception as e:

        print("[LLM ERROR]", e)
        answer = "추천을 간단히 정리했어요. 목록을 참고해 주세요."

    if not answer:
        answer = "추천을 간단히 정리했어요. 목록을 참고해 주세요."

    return jsonify({"question": question, "answer": answer, "products": products})


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)