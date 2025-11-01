import os, sys, subprocess

HERE = os.path.dirname(os.path.abspath(__file__))

def get_image_label(img_path: str) -> str | None:
    """
    외부 vit_finetuned.py 스크립트를 호출해 이미지 라벨을 받아온다.
    stdout 마지막 줄에 "label: 바나나" 형태가 온다고 가정.
    """
    try:
        proc = subprocess.run(
            [sys.executable, os.path.join(HERE, "vit_finetuned.py"), img_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            cwd=HERE,
            timeout=60,
        )
        if proc.returncode != 0:
            print("[VIT ERROR]\n", proc.stdout)
            return None
        out = (proc.stdout or "").strip().splitlines()
        last = out[-1] if out else ""
        label = last.split(":", 1)[-1].strip() if last else None
        return label or None
    except Exception as e:
        print("[VIT CALL ERROR]", e)
        return None