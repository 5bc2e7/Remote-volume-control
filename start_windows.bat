@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

echo [INFO] 工作目录: %cd%

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
    echo [ERROR] 未找到 Python 3。请先安装 Python 3.10+，并勾选 "Add python.exe to PATH"。
    goto :failed
)

echo [INFO] 使用解释器: %PY_CMD%

if not exist .venv (
    echo [INFO] 首次运行，正在创建虚拟环境...
    %PY_CMD% -m venv .venv
    if errorlevel 1 (
        echo [ERROR] 创建虚拟环境失败。
        goto :failed
    )
)

call .venv\Scripts\activate
if errorlevel 1 (
    echo [ERROR] 激活虚拟环境失败。
    goto :failed
)

echo [INFO] 安装/更新依赖（首次可能较慢）...
python -m pip install -U pip
if errorlevel 1 (
    echo [ERROR] pip 更新失败。
    goto :failed
)

pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] 依赖安装失败，请检查网络或 Python 版本。
    goto :failed
)

echo.
echo [INFO] 服务即将启动，若看到 "Running on http://0.0.0.0:5000" 说明已成功。
echo [INFO] 本机访问: http://127.0.0.1:5000/
echo [INFO] 手机访问: http://你的电脑局域网IP:5000/
echo.
python app.py

if errorlevel 1 (
    echo.
    echo [ERROR] 服务异常退出。请把上方报错截图发给我，我可继续帮你定位。
    goto :failed
)

echo.
echo [INFO] 服务已正常退出。
pause
exit /b 0

:failed
echo.
echo [HINT] 黑窗口不会立即关闭，请查看上方错误信息。
pause
exit /b 1
