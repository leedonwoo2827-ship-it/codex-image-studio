# 로컬 이미지 스튜디오 (Local Image Studio)

GPT 입력창처럼 자연어로 **이미지를 생성·수정·병합**하는 로컬 웹앱.
**API 키 없이** `codex login`(Sign in with ChatGPT) 한 번으로, 본인 ChatGPT 구독
할당량을 써서 **gpt-image-2** 로 이미지를 만든다.

## 동작 방식
- 이미지 엔진(기본 `codex`)은 `~/.codex/auth.json` 의 ChatGPT OAuth 토큰을 읽어
  `chatgpt.com/backend-api/codex/responses` 의 `image_generation` 툴을 호출한다. **키 불필요.**
- 대체 엔진(`gemini`)은 Google AI Studio 무료 키로 `gemini-2.5-flash-image` 를 호출(설정에서 전환).

## 사전 준비
1. **codex CLI 설치 + 로그인** (키리스 엔진 전제)
   ```
   npm i -g @openai/codex
   codex login          # 브라우저에서 ChatGPT 계정으로 로그인
   ```
   ※ ChatGPT Plus/Pro/Business 구독이 있어야 이미지 생성 할당량을 쓸 수 있다.
2. Python 3.10+

## 실행
```
# Windows: 더블클릭 또는
run.bat

# 또는 수동
pip install -r requirements.txt
python app.py
```
실행되면 브라우저가 자동으로 `http://127.0.0.1:8765/` 를 연다.

## 주 기능
1. **생성** — 하단 입력창에 설명 → 생성. 좌측 **접이식 사이드바**(☰)에서 리스트/이미지 관리.
2. **수정** — 이미지 클릭 → 우측 패널에서 **자연어 수정** 또는 **🖱 영역 칠해서 수정**(마스크).
   모든 수정은 버전 계보·이력으로 DB 저장.
3. **＋ 가져오기/병합** — 입력창의 ＋ 버튼으로 여러 이미지를 골라 한 장으로 **병합/합성**.

부가: 즐겨찾기, 다운로드, 삭제, 프로젝트(폴더) 관리, 엔진/크기 설정.

## 데이터
- `data/app.db` (SQLite), `data/images/*.png`, `data/settings.json` — 모두 로컬 보관.

## 주의
- `backend-api/codex/responses` 는 Codex CLI 가 쓰는 **비공식 내부 엔드포인트**다(변경 가능).
  메커니즘은 오픈소스 `leeguooooo/chatgpt-imagegen` 의 검증된 방식을 차용했다.
- 토큰 만료 시 자동 갱신하며, 실패하면 `codex login` 으로 재로그인하면 된다.
