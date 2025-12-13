@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title RVC 音色克隆启动器

echo ==================================================
echo        RVC 音色克隆 - 简化版启动器
echo ==================================================
echo.

echo 欢迎使用RVC音色克隆！
echo.

:: 检查Python环境
echo 正在检查Python环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Python环境
    echo.
    echo 解决方案：
    echo 1. 请先安装Python 3.10或更高版本
    echo 2. 安装时请勾选"Add Python to PATH"
    echo 3. 重启计算机后再次运行此程序
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b
)

:: 检查Python版本
for /f "tokens=2" %%v in ('python --version') do set PYTHON_VERSION=%%v
echo Python版本: %PYTHONTHON_VERSION%

:: 检查核心依赖
echo.
echo 正在检查核心依赖...
set MISSING_DEPS=
for %%d in (torch librosa numpy scipy soundfile gradio faiss-cpu) do (
    python -c "import %%d" >nul 2>&1
    if !errorlevel! neq 0 (
        if "!MISSING_DEPS!"=="" (
            set MISSING_DEPS=%%d
        ) else (
            set MISSING_DEPS=!MISSING_DEPS!,%%d
        )
    )
)

if defined MISSING_DEPS (
    echo.
    echo ❌ 检测到缺失的依赖库: !MISSING_DEPS!
    echo.
    echo 是否自动安装缺失的依赖？(Y/N)
    set /p choice=
    if /i "%choice%"=="Y" (
        echo.
        echo 正在安装依赖库，请稍候...
        pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117
        pip install librosa soundfile scipy numpy==1.23.5 faiss-cpu==1.7.2 gradio==3.36.0
        pip install praat-parselmouth pyworld torchcrepe resampy tqdm ffmpeg-python pedalboard
        
        echo.
        echo 依赖安装完成！
        echo.
        echo 按任意键继续...
        pause >nul
    ) else (
        echo.
        echo 请手动安装依赖库后再运行程序
        echo.
        echo 按任意键退出...
        pause >nul
        exit /b
    )
) else (
    echo.
    echo ✅ 所有依赖库均已安装
)

:: 显示功能菜单
echo.
echo ==================================================
echo 请选择要启动的功能：
echo ==================================================
echo 1. 启动Web训练界面
echo 2. 启动实时语音转换
echo 3. 退出程序
echo.
set /p choice=请输入选项 (1-3):

if "%choice%"=="1" (
    echo.
    echo 正在启动Web训练界面...
    echo 请在浏览器中打开 http://localhost:7897
    python infer-web.py
) else if "%choice%"=="2" (
    echo.
    echo 正在启动实时语音转换...
    python gui_v1.py
) else (
    echo.
    echo 程序已退出
)

echo.
echo 按任意键退出...
pause >nul