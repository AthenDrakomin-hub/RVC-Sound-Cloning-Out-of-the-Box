@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title 清理Web组件

echo ==================================================
echo        RVC 音色克隆 - 清理Web组件工具
echo ==================================================
echo.

echo 注意：此工具将删除Web界面相关的文件和目录
echo 仅保留核心的实时音色克隆功能
echo.
echo 要继续吗？(y/n)
set /p confirm=
if /i not "%confirm%"=="y" (
    echo 操作已取消
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b
)

echo.
echo 正在清理Web组件...

:: 删除Web界面相关的文件（如果存在）
if exist "infer-web.py" (
    del "infer-web.py"
    echo 已删除 infer-web.py
)

:: 删除可能存在的Web相关目录
if exist "logs" (
    rd /s /q "logs"
    echo 已删除 logs 目录
)

if exist "TEMP" (
    rd /s /q "TEMP"
    echo 已删除 TEMP 目录
)

echo.
echo Web组件清理完成！
echo 现在只剩下核心的实时音色克隆功能
echo.
echo 按任意键退出...
pause >nul