@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================================
echo   Local Image Studio - Setup
echo ============================================================
echo.

REM 1) Find Python (py launcher first)
set "PY="
where py >nul 2>nul && set "PY=py -3"
if not defined PY ( where python >nul 2>nul && set "PY=python" )
if not defined PY (
  echo [ERROR] Python 3.10+ is required.
  echo         Install from https://www.python.org/downloads/ and re-run.
  echo         Be sure to check "Add Python to PATH" during install.
  pause & exit /b 1
)
echo [OK] Using Python: %PY%

REM 2) Create virtual environment
if not exist "venv\Scripts\python.exe" (
  echo [1/3] Creating virtual environment "venv" ...
  %PY% -m venv venv
  if errorlevel 1 ( echo [ERROR] Failed to create venv & pause & exit /b 1 )
) else (
  echo [1/3] venv already exists - skipping
)
set "VPY=venv\Scripts\python.exe"

REM 3) Install dependencies
echo [2/3] Installing dependencies ... (first run may take 1-2 minutes)
"%VPY%" -m pip install --upgrade pip
"%VPY%" -m pip install -r requirements.txt
if errorlevel 1 (
  echo [ERROR] Dependency install failed. Check the messages above.
  pause & exit /b 1
)

REM 4) Check codex CLI / ChatGPT login (required for keyless image generation)
echo [3/3] Checking codex CLI / ChatGPT login ...
where codex >nul 2>nul
if errorlevel 1 (
  echo.
  echo   [NOTE] codex CLI not found. For keyless image generation, install and log in:
  echo            npm i -g @openai/codex
  echo            codex login
  echo   ^(Or switch to the Gemini free-key engine in the in-app Settings.^)
) else (
  if exist "%USERPROFILE%\.codex\auth.json" (
    echo   [OK] codex installed + login credentials found.
  ) else (
    echo   [NOTE] codex installed. If not logged in yet, run "codex login" in a terminal.
  )
)

echo.
echo ============================================================
echo   Setup complete!  Now double-click run.bat
echo   The browser will open http://127.0.0.1:8765/ automatically.
echo ============================================================
pause
