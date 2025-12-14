@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title RVC 音色克隆 - 整合版

echo ==================================================
echo        RVC 音色克隆 - 整合应用程序版本
echo ==================================================
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
    echo 请先安装缺失的依赖库后再运行程序
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b
) else (
    echo.
    echo ✅ 所有依赖库均已安装
)

:: 询问用户是否需要清理Web组件
echo.
echo 是否需要清理Web组件，仅保留核心的实时音色克隆功能？(y/n)
echo.
set /p cleanup_choice=请输入选项 (y/n):

if /i "%cleanup_choice%"=="y" (
    echo.
    echo 正在清理Web组件...
    if exist "infer-web.py" del "infer-web.py"
    if exist "logs" rd /s /q "logs"
    if exist "TEMP" rd /s /q "TEMP"
    echo Web组件清理完成！
    echo.
)

:: 显示功能菜单
echo.
echo ==================================================
echo 核心功能：
echo ==================================================
echo 1. 实时音色克隆通话（推荐）
echo 2. 音频文件音色克隆
echo 3. 训练新音色模型
echo 4. 退出程序
echo.
set /p choice=请输入选项 (1-4):

if "%choice%"=="1" (
    echo.
    echo 正在启动实时音色克隆通话...
    python gui_v1.py
) else if "%choice%"=="2" (
    echo.
    echo 正在启动音频文件音色克隆...
    echo 请在浏览器中打开 http://localhost:7899
    if exist "infer-web.py" (
        python infer-web.py --port 7899
    ) else (
        echo.
        echo ❌ Web组件已被清理，无法启动Web界面
        echo 请重新安装或恢复Web组件
    )
) else if "%choice%"=="3" (
    echo.
    echo 正在启动音色模型训练...
    echo 请在浏览器中打开 http://localhost:7899
    if exist "infer-web.py" (
        python infer-web.py --port 7899
    ) else (
        echo.
        echo ❌ Web组件已被清理，无法启动Web界面
        echo 请重新安装或恢复Web组件
    )
) else (
    echo.
    echo 程序已退出
)

echo.
echo 按任意键退出...
pause >nul