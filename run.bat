@echo off
setlocal
cd /d "%~dp0"

REM Run Local Image Studio (Windows)
if not exist "venv\Scripts\python.exe" (
  echo [NOTE] venv not found. Running setup.bat first ...
  call setup.bat
)

call venv\Scripts\activate.bat
python app.py
pause
