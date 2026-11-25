@echo off
title YATRA Operator Web (Next.js :3000)
setlocal

set REPO_ROOT=%~dp0
cd /d "%REPO_ROOT%apps\operator-web"

echo ============================================================
echo   YATRA -- Operator Web and Delhi Government Intelligence
echo ============================================================
echo   URL:  http://localhost:3000
echo ============================================================
echo.

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm was not found in your PATH. Please install Node.js.
    pause
    exit /b 1
)

call npm.cmd run dev
if %errorlevel% neq 0 (
    call npm run dev
)
pause
