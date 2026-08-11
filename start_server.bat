@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

title Local Server
cls
echo.
echo ========================================
echo   Starting local server...
echo ========================================
echo.
echo After started, please visit:
echo http://localhost:8000
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"

echo.
echo Server stopped.
pause
