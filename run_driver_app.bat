@echo off
title YATRA Driver App (Flutter)
setlocal

set "REPO_ROOT=%~dp0"
cd /d "%REPO_ROOT%apps\driver-mobile"

echo ============================================================
echo   YATRA -- Driver Assistance and Operations Mobile App
echo ============================================================
echo.

if exist "C:\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=C:\flutter\bin\flutter.bat"
    set "FLUTTER_ROOT=C:\flutter"
) else (
    set "FLUTTER_CMD=flutter.bat"
)

echo Checking dependencies...
if not exist ".dart_tool\package_config.json" (
    echo Running pub get...
    call "%FLUTTER_CMD%" pub get
) else (
    echo Dependencies ready.
)

echo.
echo Select target platform to run:
echo   [1] Microsoft Edge (Web - Recommended)
echo   [2] Google Chrome (Web)
echo   [3] Windows Desktop (Native)
echo   [4] Auto-detect / Connected Mobile Device
echo.
set "TARGET_CHOICE=1"
set /p "TARGET_CHOICE=Enter choice [1-4, default 1]: "

echo.
if "%TARGET_CHOICE%"=="2" (
    echo Launching on Google Chrome...
    call "%FLUTTER_CMD%" run -d chrome
) else if "%TARGET_CHOICE%"=="3" (
    echo Launching on Windows Desktop...
    call "%FLUTTER_CMD%" run -d windows
) else if "%TARGET_CHOICE%"=="4" (
    echo Auto-detecting device...
    call "%FLUTTER_CMD%" run
) else (
    echo Launching on Microsoft Edge...
    call "%FLUTTER_CMD%" run -d edge
)

echo.
echo ============================================================
echo   Flutter session finished.
echo ============================================================
pause
