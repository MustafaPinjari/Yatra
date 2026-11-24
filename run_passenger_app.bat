@echo off
title YATRA Passenger App (Flutter)
setlocal

set REPO_ROOT=%~dp0
cd /d "%REPO_ROOT%apps\passenger-mobile"

echo ============================================================
echo   YATRA -- Passenger Mobile and Web Application
echo ============================================================
echo.

set FLUTTER_CMD=flutter
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\flutter\bin\flutter.bat" (
        set FLUTTER_CMD=C:\flutter\bin\flutter.bat
    ) else (
        echo [ERROR] Flutter SDK not found in PATH or at C:\flutter\bin\flutter.bat.
        echo Please ensure Flutter is installed to run the mobile apps.
        echo.
        pause
        exit /b 1
    )
)

echo Resolving Flutter dependencies...
call %FLUTTER_CMD% pub get

echo.
echo Select target platform to run:
echo   1. Microsoft Edge (Web)
echo   2. Google Chrome (Web)
echo   3. Windows Desktop (Native)
echo   4. Auto-detect or Connected Phone / Emulator
echo.
set /p TARGET_CHOICE="Enter selection [1-4, default 1]: "

if "%TARGET_CHOICE%"=="2" (
    %FLUTTER_CMD% run -d chrome
) else if "%TARGET_CHOICE%"=="3" (
    %FLUTTER_CMD% run -d windows
) else if "%TARGET_CHOICE%"=="4" (
    %FLUTTER_CMD% run
) else (
    %FLUTTER_CMD% run -d edge
)

pause
