@echo off
title YATRA Delhi Transit Operations Platform
setlocal

set REPO_ROOT=%~dp0
cd /d "%REPO_ROOT%"

echo ============================================================
echo   YATRA -- Delhi Transit Operations and Intelligence Platform
echo   Launching Backend and Web Portal in Dedicated Windows
echo ============================================================
echo.

echo [1/2] Launching Backend on port 8000...
start "YATRA Backend (:8000)" cmd /k ""%REPO_ROOT%run_backend.bat""

echo [2/2] Launching Operator Web on port 3000...
start "YATRA Operator Web (:3000)" cmd /k ""%REPO_ROOT%run_operator_web.bat""

echo.
echo Waiting for services to initialize...
ping 127.0.0.1 -n 5 >nul

echo.
echo ============================================================
echo   YATRA Services Running Successfully
echo ============================================================
echo   - Operator Web Dashboard:   http://localhost:3000
echo   - Analytics API Docs:       http://localhost:8000/docs
echo   - Live Fleet Health:        http://localhost:8000/health
echo   - Transit Static API:       http://localhost:8000/api/v1/routes
echo   - Feeder Optimization:      http://localhost:8000/api/v1/analytics/feeder-routes
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
