@echo off
echo Flutter 英语学习App 快速启动脚本
echo ===================================

REM 设置Flutter路径
set PATH=C:\tools\flutter\bin;%PATH%

REM 检查Flutter是否可用
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Flutter未找到，请检查安装路径
    pause
    exit /b 1
)

echo Flutter版本:
flutter --version
echo.

REM 进入项目目录
cd /d "D:\workspace\test\flutter-app"

echo 正在安装依赖...
flutter pub get

echo.
echo 选择运行模式:
echo 1. Windows桌面版
echo 2. Web版 (Chrome)
echo 3. Web版 (Edge)
echo 4. 代码检查
echo 5. 退出
echo.

set /p choice=请输入选择 (1-5): 

if "%choice%"=="1" (
    echo 启动Windows桌面版...
    flutter run -d windows
) else if "%choice%"=="2" (
    echo 启动Web版 (Chrome)...
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo 启动Web版 (Edge)...
    flutter run -d edge
) else if "%choice%"=="4" (
    echo 运行代码检查...
    flutter analyze
    echo.
    pause
) else if "%choice%"=="5" (
    echo 退出
    exit /b 0
) else (
    echo 无效选择
    pause
)