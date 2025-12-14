@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title RVC 依赖安装工具

echo ==================================================
echo        RVC 音色克隆依赖安装工具
echo ==================================================
echo.

echo 注意：此脚本将自动安装RVC所需的所有Python依赖库
echo 安装过程可能需要5-10分钟，请耐心等待...
echo.

echo 是否继续安装？(Y/N)
set /p choice=
if /i not "%choice%"=="Y" (
    echo 安装已取消
    pause
    exit /b
)

echo.
echo 开始安装依赖库...
echo.

:: 升级pip
echo 1. 升级pip...
python-3.10\python.exe -m pip install --upgrade pip
if %errorlevel% neq 0 (
    echo    ❌ pip升级失败
    echo    尝试使用备用方法...
    python-3.10\python.exe -m ensurepip --upgrade
)
echo.

:: 安装torch和相关库
echo 2. 安装PyTorch相关库...
python-3.10\python.exe -m pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117
if %errorlevel% neq 0 (
    echo    ⚠ CUDA版本安装失败，尝试CPU版本...
    python-3.10\python.exe -m pip install torch==1.13.1+cpu torchvision==0.14.1+cpu torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu
)
echo.

:: 安装音频处理库
echo 3. 安装音频处理库...
python-3.10\python.exe -m pip install librosa soundfile scipy resampy
echo.

:: 安装机器学习和科学计算库
echo 4. 安装机器学习和科学计算库...
python-3.10\python.exe -m pip install numpy==1.23.5 faiss-cpu==1.7.2 praat-parselmouth pyworld torchcrepe
echo.

:: 安装Web界面库
echo 5. 安装Web界面库...
python-3.10\python.exe -m pip install gradio==3.36.0
echo.

:: 安装其他依赖
echo 6. 安装其他依赖库...
python-3.10\python.exe -m pip install tqdm ffmpeg-python pedalboard
echo.

:: 安装RVC特定依赖
echo 7. 安装RVC特定依赖...
python-3.10\python.exe -m pip install -r requirements.txt
echo.

echo ==================================================
echo 依赖安装完成！
echo ==================================================
echo.

echo 验证安装...
echo.

:: 验证核心依赖
set CORE_DEPS=torch librosa numpy scipy soundfile gradio faiss-cpu
set INSTALL_SUCCESS=1

for %%d in (%CORE_DEPS%) do (
    python-3.10\python.exe -c "import %%d" >nul 2>&1
    if !errorlevel! == 0 (
        echo    ✓ %%d 安装成功
    ) else (
        echo    ❌ %%d 安装失败
        set INSTALL_SUCCESS=0
    )
)

echo.

if %INSTALL_SUCCESS% == 1 (
    echo 🎉 所有依赖安装成功！
    echo.
    echo 您现在可以使用RVC音色克隆了。
    echo.
    echo 使用方法:
    echo 1. 双击运行 "启动RVC.cmd"
    echo 2. 根据菜单选择功能
    echo.
) else (
    echo ⚠ 部分依赖安装失败
    echo.
    echo 建议:
    echo 1. 检查网络连接是否正常
    echo 2. 尝试关闭杀毒软件后重新运行此脚本
    echo 3. 手动安装失败的依赖库
    echo.
)

echo 按任意键退出...
pause >nul