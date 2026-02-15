@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo [INFO] Working directory: %cd%

set "PY_CMD="
where py >nul 2>nul
if %errorlevel%==0 (
    set "PY_CMD=py -3"
) else (
    where python >nul 2>nul
    if %errorlevel%==0 (
        set "PY_CMD=python"
    )
)

if not defined PY_CMD (
    echo [ERROR] Python 3 was not found. Install Python 3.10+ and enable "Add python.exe to PATH".
    goto :failed
)

echo [INFO] Python command: %PY_CMD%

if not exist .venv (
    echo [INFO] Creating virtual environment...
    %PY_CMD% -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        goto :failed
    )
)

call .venv\Scripts\activate
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment.
    goto :failed
)

echo [INFO] Installing dependencies (first run may take a while)...
python -m pip install -U pip
if errorlevel 1 (
    echo [ERROR] Failed to upgrade pip.
    goto :failed
)

pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install requirements. Check network and Python version.
    goto :failed
)

echo.
echo [INFO] Starting server...
echo [INFO] Local URL: http://127.0.0.1:5000/
echo [INFO] LAN URL:   http://YOUR_PC_LAN_IP:5000/
echo.
python app.py

if errorlevel 1 (
    echo.
    echo [ERROR] Server exited with an error. Please send the full log output.
    goto :failed
)

echo.
echo [INFO] Server exited normally.
pause
exit /b 0

:failed
echo.
echo [HINT] Window will stay open. Read the error message above.
pause
exit /b 1
