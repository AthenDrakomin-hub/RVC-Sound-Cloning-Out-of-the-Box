@echo off
title RVC 音色克隆启动器

echo ================================
echo RVC 音色克隆 - 开箱即用版
echo ================================

echo 1. 启动Web训练界面
echo 2. 启动实时语音转换
echo 3. 退出

set /p choice=请选择功能 (1-3): 

if "%choice%"=="1" (
    echo 启动Web训练界面...
    start go-web.bat
) else if "%choice%"=="2" (
    echo 启动实时语音转换...
    start go-realtime-gui.bat
) else (
    echo 再见！
)

pause
