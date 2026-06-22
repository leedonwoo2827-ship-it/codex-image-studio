@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================================
echo   Local Image Studio - Setup (double-click)
echo ============================================================
echo.

REM 1) Find Python (py launcher first)
set "PY="
where py >nul 2>nul && set "PY=py -3"
if not defined PY ( where python >nul 2>nul && set "PY=python" )
if not defined PY (
  echo [ERROR] Python 3.10+ not found.
  echo         Install it ONCE from https://www.python.org/downloads/
  echo         and CHECK "Add Python to PATH", then double-click setup.bat again.
  pause & exit /b 1
)
echo [OK] Python: %PY%

REM 2) Create venv
if not exist "venv\Scripts\python.exe" (
  echo [1/4] Creating virtual environment "venv" ...
  %PY% -m venv venv
  if errorlevel 1 ( echo [ERROR] Failed to create venv & pause & exit /b 1 )
) else (
  echo [1/4] venv already exists - skipping
)
set "VPY=venv\Scripts\python.exe"

REM 3) Install Python dependencies
echo [2/4] Installing Python dependencies ... (first run may take 1-2 minutes)
"%VPY%" -m pip install -r requirements.txt
if errorlevel 1 ( echo [ERROR] pip install failed. See messages above. & pause & exit /b 1 )

REM 4) Ensure codex CLI (keyless image engine)
echo [3/4] Checking codex CLI ...
where codex >nul 2>nul
if errorlevel 1 (
  where npm >nul 2>nul
  if errorlevel 1 (
    echo [ERROR] Node.js/npm not found - needed to install the codex CLI.
    echo         Install it ONCE from https://nodejs.org/  then double-click setup.bat again.
    echo         ^(Alternatively, use the Gemini free-key engine in the app Settings.^)
    pause & exit /b 1
  )
  echo   codex not found - installing via npm ^(global^) ...
  call npm i -g @openai/codex
  if errorlevel 1 ( echo [ERROR] codex install failed. & pause & exit /b 1 )
) else (
  echo   [OK] codex CLI found.
)

REM 5) ChatGPT login (per-PC, one time)
echo [4/4] Checking ChatGPT login ...
if exist "%USERPROFILE%\.codex\auth.json" (
  echo   [OK] Already logged in on this PC.
) else (
  echo   Not logged in - opening ChatGPT login in your browser ...
  echo   ^(Sign in with your ChatGPT account, then this window continues.^)
  call codex login
)

echo.
echo ============================================================
echo   Setup complete!  Now double-click run.bat
echo   The browser will open http://127.0.0.1:8765/ automatically.
echo ============================================================
pause
