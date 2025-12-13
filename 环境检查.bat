@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title RVC 环境检查工具

echo ==================================================
echo        RVC 音色克隆环境检查工具
echo ==================================================
echo.

echo 正在检查系统环境...
echo.

:: 检查操作系统
echo 1. 检查操作系统...
ver | findstr /i "10\." >nul
if %errorlevel% == 0 (
    echo    ✓ Windows 10 检测通过
) else (
    ver | findstr /i "11\." >nul
    if %errorlevel% == 0 (
        echo    ✓ Windows 11 检测通过
    ) else (
        echo    ⚠ 不支持的操作系统版本，建议使用 Windows 10/11
    )
)
echo.

:: 检查Python环境
echo 2. 检查Python环境...
python --version >nul 2>&1
if %errorlevel% == 0 (
    for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
    echo    ✓ !PYTHON_VERSION! 检测通过
) else (
    echo    ❌ Python未安装或未添加到PATH环境变量
    echo    解决方案：运行 python-installer.exe 安装Python 3.10
    echo.
    goto check_end
)

:: 检查Python版本
python -c "import sys; print(sys.version_info.major)" >temp_ver.txt 2>nul
set /p PY_MAJOR=<temp_ver.txt
del temp_ver.txt >nul 2>&1

python -c "import sys; print(sys.version_info.minor)" >temp_ver.txt 2>nul
set /p PY_MINOR=<temp_ver.txt
del temp_ver.txt >nul 2>&1

if %PY_MAJOR% geq 3 (
    if %PY_MINOR% geq 7 (
        echo    ✓ Python版本符合要求 (^>=3.7^)
    ) else (
        echo    ⚠ Python版本过低，建议升级到3.10
    )
) else (
    echo    ⚠ Python版本过低，建议升级到3.10
)
echo.

:: 检查核心依赖库
echo 3. 检查核心依赖库...
echo.

set DEPENDENCIES=torch librosa numpy scipy soundfile gradio faiss-cpu
set MISSING_DEPS=

for %%d in (%DEPENDENCIES%) do (
    python -c "import %%d" >nul 2>&1
    if !errorlevel! == 0 (
        echo    ✓ %%d 已安装
    ) else (
        echo    ❌ %%d 未安装
        if "!MISSING_DEPS!" == "" (
            set MISSING_DEPS=%%d
        ) else (
            set MISSING_DEPS=!MISSING_DEPS!,%%d
        )
    )
)
echo.

:: 检查RVC特定依赖
echo 4. 检查RVC特定依赖...
echo.

set RVC_DEPENDENCIES=praat-parselmouth pyworld torchcrepe resampy
for %%d in (%RVC_DEPENDENCIES%) do (
    python -c "import %%d" >nul 2>&1
    if !errorlevel! == 0 (
        echo    ✓ %%d 已安装
    ) else (
        echo    ⚠ %%d 未安装（可选依赖）
    )
)
echo.

:: 检查目录结构
echo 5. 检查目录结构...
echo.

if exist "assets\" (
    echo    ✓ assets 目录存在
) else (
    echo    ❌ assets 目录不存在
)

if exist "configs\" (
    echo    ✓ configs 目录存在
) else (
    echo    ❌ configs 目录不存在
)

if exist "infer\" (
    echo    ✓ infer 目录存在
) else (
    echo    ❌ infer 目录不存在
)

if exist "tools\" (
    echo    ✓ tools 目录存在
) else (
    echo    ❌ tools 目录不存在
)

if exist "datasets\" (
    echo    ✓ datasets 目录存在
) else (
    echo    ⚠ datasets 目录不存在（将自动创建）
    mkdir datasets >nul 2>&1
)

if exist "logs\" (
    echo    ✓ logs 目录存在
) else (
    echo    ⚠ logs 目录不存在（将自动创建）
    mkdir logs >nul 2>&1
)
echo.

:: 检查关键模型文件
echo 6. 检查关键模型文件...
echo.

set MODEL_FILES=assets\hubert\hubert_base.pt assets\pretrained_v2\f0G40k.pth assets\pretrained_v2\f0D40k.pth
set MISSING_MODELS=

for %%f in (%MODEL_FILES%) do (
    if exist "%%f" (
        echo    ✓ %%f 存在
    ) else (
        echo    ❌ %%f 不存在
        if "!MISSING_MODELS!" == "" (
            set MISSING_MODELS=%%f
        ) else (
            set MISSING_MODELS=!MISSING_MODELS!,%%f
        )
    )
)
echo.

:: 检查训练脚本
echo 7. 检查训练脚本...
echo.

if exist "infer-web.py" (
    echo    ✓ infer-web.py 存在
) else (
    echo    ❌ infer-web.py 不存在
)

if exist "gui_v1.py" (
    echo    ✓ gui_v1.py 存在
) else (
    echo    ❌ gui_v1.py 不存在
)

if exist "go-web.bat" (
    echo    ✓ go-web.bat 存在
) else (
    echo    ❌ go-web.bat 不存在
)

if exist "go-realtime-gui.bat" (
    echo    ✓ go-realtime-gui.bat 存在
) else (
    echo    ❌ go-realtime-gui.bat 不存在
)
echo.

:check_end
echo ==================================================
echo 检查完成！
echo ==================================================
echo.

if defined MISSING_DEPS (
    echo 发现缺失的依赖库: !MISSING_DEPS!
    echo.
    echo 解决方案:
    echo 1. 双击运行 "安装依赖.bat"
    echo 2. 或在命令行中运行: pip install !MISSING_DEPS!
    echo.
)

if defined MISSING_MODELS (
    echo 发现缺失的模型文件: !MISSING_MODELS!
    echo.
    echo 解决方案:
    echo 1. 运行 tools\download_models.py 下载模型
    echo 2. 或手动下载并放入对应目录
    echo.
)

if not defined MISSING_DEPS (
    if not defined MISSING_MODELS (
        echo 🎉 环境检查通过！您可以开始使用RVC音色克隆了。
        echo.
        echo 使用方法:
        echo 1. 双击运行 "启动RVC.cmd"
        echo 2. 根据菜单选择功能
        echo.
    )
)

echo 按任意键退出...
pause >nul