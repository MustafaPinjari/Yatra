@echo off
title YATRA Full Platform Launcher
setlocal

set REPO_ROOT=%~dp0
cd /d "%REPO_ROOT%"

echo ============================================================
echo   YATRA -- Delhi Transit Operations and Intelligence Platform
echo   Launching All Services in Dedicated Windows
echo ============================================================
echo.

echo [1/2] Launching Backend on port 8000...
start "YATRA Backend (:8000)" cmd /c ""%REPO_ROOT%run_backend.bat""

echo [2/2] Launching Operator Web on port 3000...
start "YATRA Operator Web (:3000)" cmd /c ""%REPO_ROOT%run_operator_web.bat""

echo.
echo Waiting for services to initialize...
ping 127.0.0.1 -n 5 >nul

echo.
echo ============================================================
echo   YATRA Services Running
echo ============================================================
echo   - Operator Web Portal:  http://localhost:3000
echo   - API Swagger Docs:     http://localhost:8000/docs
echo   - Live Health Status:   http://localhost:8000/health
echo ============================================================
echo.
echo Launching browser tabs...
start http://localhost:3000
start http://localhost:8000/docs
echo.
echo Both services are running in their respective windows.
echo To stop services, close the backend and web command prompt windows.
echo.
pause
