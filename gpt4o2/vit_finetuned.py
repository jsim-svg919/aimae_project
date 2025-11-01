# vit_250818.py — torchvision 전처리로 통일
from transformers import ViTForImageClassification
from PIL import Image
import torch, sys
from torchvision import transforms

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

MODEL_DIR = "./vit_20250818_143345"
model = ViTForImageClassification.from_pretrained(MODEL_DIR).to(device).eval()

# ✅ 여기에 한글 라벨 덮어쓰기
CLASS_NAMES = ["사과","아스파라거스","아보카도","바나나","콩나물","믹서기","블루베리","양배추","당근","체리","오이",
               "제습기","가지","선풍기","전기그릴","무화과","부추","헤어드라이어","한라봉","헤드셋","다리미","키보드",
               "라임","망고","모니터","마우스","버섯","양파","배","파인애플","자두","무","샤인머스켓","시금치","딸기","토마토","청소기"]
model.config.id2label = {str(i): name for i, name in enumerate(CLASS_NAMES)}
model.config.label2id = {name: i for i, name in enumerate(CLASS_NAMES)}


# ✅ 학습 때와 동일하게 맞추세요 (예: Resize만 했다면 Normalize 빼기)
transform = transforms.Compose([
    transforms.Resize((224, 224)),      # ← 학습 때 크기와 동일
    transforms.ToTensor(),              # ← [0,1] 스케일
    # transforms.Normalize(mean=[0.5,0.5,0.5], std=[0.5,0.5,0.5])  # 학습에 썼다면 주석 해제
])

img_path = sys.argv[1] if len(sys.argv) > 1 else "test.jfif"
image = Image.open(img_path).convert("RGB")
x = transform(image).unsqueeze(0).to(device)

with torch.no_grad():
    logits = model(x).logits
    pred_id = int(torch.argmax(logits, dim=-1).item())

# id2label이 str키일 수도 있으니 둘 다 대비
id2label = getattr(model.config, "id2label", {}) or {}
label = id2label.get(pred_id) or id2label.get(str(pred_id)) or str(pred_id)

print(label)  # ★ 서버가 마지막 줄만 읽어가므로 라벨만 출력