@echo off
title YATRA Backend (FastAPI :8000)
setlocal

set REPO_ROOT=%~dp0
cd /d "%REPO_ROOT%services\api"

echo ============================================================
echo   YATRA -- FastAPI Analytics and Transit Intelligence Backend
echo ============================================================
echo   Endpoint:  http://localhost:8000
echo   API Docs:  http://localhost:8000/docs
echo   Health:    http://localhost:8000/health
echo ============================================================
echo.

if not exist "%REPO_ROOT%.venv\Scripts\python.exe" (
    echo [ERROR] Python virtual environment not found at .venv\Scripts\python.exe
    pause
    exit /b 1
)

"%REPO_ROOT%.venv\Scripts\python.exe" -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
pause
