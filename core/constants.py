"""앱 전역 경로/상수."""
from __future__ import annotations

import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
IMAGES_DIR = DATA_DIR / "images"
STATIC_DIR = BASE_DIR / "static"
DB_PATH = DATA_DIR / "app.db"
SETTINGS_PATH = DATA_DIR / "settings.json"

HOST = os.environ.get("HOST", "127.0.0.1")
PORT = int(os.environ.get("PORT", "8765"))

# gpt-image 가 네이티브로 지원하는 크기 3종 + 자동. (프론트에서 비율 라벨로 표시)
SIZE_CHOICES = ["auto", "1024x1024", "1536x1024", "1024x1536"]

# 디렉토리 보장
DATA_DIR.mkdir(parents=True, exist_ok=True)
IMAGES_DIR.mkdir(parents=True, exist_ok=True)
