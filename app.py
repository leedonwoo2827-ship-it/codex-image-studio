# app.py — 로컬 이미지 스튜디오 오케스트레이터
import mimetypes
import os
import threading
import webbrowser

# Windows 일부 환경에서 .js MIME 매핑이 깨져 ES 모듈 로드가 실패하는 것을 방지
mimetypes.add_type("text/javascript", ".js")
mimetypes.add_type("application/javascript", ".mjs")

from dotenv import load_dotenv  # noqa: E402

# utf-8-sig: Notepad 로 저장한 .env 의 BOM 을 허용
load_dotenv(encoding="utf-8-sig")

from contextlib import asynccontextmanager  # noqa: E402

import uvicorn  # noqa: E402
from fastapi import FastAPI  # noqa: E402
from fastapi.responses import FileResponse  # noqa: E402
from fastapi.staticfiles import StaticFiles  # noqa: E402

from core.constants import HOST, PORT, STATIC_DIR  # noqa: E402
from core.database import init_db  # noqa: E402
from routes.auth_routes import router as auth_router  # noqa: E402
from routes.image_routes import router as image_router  # noqa: E402
from routes.project_routes import router as project_router  # noqa: E402
from routes.settings_routes import router as settings_router  # noqa: E402


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(title="Local Image Studio", lifespan=lifespan)

app.include_router(auth_router)
app.include_router(settings_router)
app.include_router(project_router)
app.include_router(image_router)


@app.get("/")
async def index():
    return FileResponse(STATIC_DIR / "index.html")


app.mount("/", StaticFiles(directory=str(STATIC_DIR)), name="static")


def _open_browser():
    try:
        webbrowser.open(f"http://{HOST}:{PORT}/")
    except Exception:
        pass


if __name__ == "__main__":
    # 브라우저는 서버가 뜬 직후 한 번만 연다(reload 비활성 시).
    threading.Timer(1.2, _open_browser).start()
    print(f"\n  로컬 이미지 스튜디오 → http://{HOST}:{PORT}/\n")
    uvicorn.run(app, host=HOST, port=PORT, log_level="info")
