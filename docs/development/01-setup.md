# 环境搭建指南

本文档介绍如何配置英语学习Flutter App的开发环境。

## 📋 系统要求

### 最低要求
- **操作系统**: Windows 10/11, macOS 10.14+, Ubuntu 18.04+
- **内存**: 8GB RAM (推荐16GB)
- **存储**: 10GB 可用空间
- **网络**: 稳定的网络连接

### 推荐配置
- **操作系统**: Windows 11, macOS Monterey+, Ubuntu 20.04+
- **内存**: 16GB+ RAM
- **存储**: 20GB+ 可用空间
- **处理器**: Intel i5/AMD R5 或 Apple Silicon M1+

## 🛠 软件安装

### 1. Flutter SDK

#### Windows
```powershell
# 下载 Flutter SDK
# 访问 https://flutter.dev/docs/get-started/install/windows
# 下载 Flutter ZIP 包并解压到 C:\flutter

# 添加到环境变量
# 将 C:\flutter\bin 添加到 PATH

# 验证安装
flutter --version
```

#### macOS
```bash
# 使用 Homebrew
brew install --cask flutter

# 或手动安装
# 下载 Flutter SDK 并解压
export PATH="$PATH:`pwd`/flutter/bin"

# 验证安装
flutter --version
```

#### Linux (Ubuntu)
```bash
# 下载 Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz

# 添加到 PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 验证安装
flutter --version
```

### 2. 开发工具

#### Android Studio (推荐)
1. 下载 [Android Studio](https://developer.android.com/studio)
2. 安装 Flutter 和 Dart 插件
   - File → Settings → Plugins
   - 搜索 "Flutter" 并安装
3. 配置 Android SDK
   - SDK Manager → SDK Platforms
   - 安装最新的 Android API
   - SDK Tools → 安装 Android SDK Build-Tools

#### VS Code
1. 下载 [VS Code](https://code.visualstudio.com/)
2. 安装扩展：
   ```bash
   # 推荐扩展
   - Flutter
   - Dart
   - Flutter Tree
   - GitLens
   - Prettier
   ```

### 3. 依赖工具检查

运行 Flutter 医生检查：
```bash
flutter doctor
```

理想输出应包含：
```
[✓] Flutter (Channel stable, 3.16.0, on Microsoft Windows [Version 10.0.19045.2673])
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.2)
[✓] VS Code (version 1.85)
[✓] Connected device (3 available devices)
```

## 🔧 项目配置

### 1. 克隆项目
```bash
git clone [项目仓库地址]
cd flutter-app
```

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 配置模拟器/设备

#### Android 模拟器
```bash
# 查看可用系统镜像
flutter emulators

# 创建模拟器
flutter emulators --create --name pixel_4_api_34

# 启动模拟器
flutter emulators --launch pixel_4_api_34
```

#### iOS 模拟器 (仅 macOS)
```bash
# 查看可用设备
flutter devices

# 打开 iOS 模拟器
open -a Simulator
```

#### 物理设备
1. 启用开发者选项
2. 开启 USB 调试
3. 连接设备并授权

## 🚀 运行项目

### 1. 选择设备
```bash
# 查看可用设备
flutter devices

# 选择设备运行
flutter run -d [设备ID]
```

### 2. 常用运行命令
```bash
# 调试模式运行
flutter run --debug

# 发布模式运行
flutter run --release

# 热重载 (开发中)
# 按 'r' 键热重载
# 按 'R' 键热重启
```

## 🐛 常见问题

### 1. Flutter Doctor 问题

#### Android license not accepted
```bash
flutter doctor --android-licenses
# 同意所有许可证条款
```

#### Chrome not found
```bash
# Windows
# 确保 Chrome 安装在默认路径
# 或设置环境变量
set CHROME_EXECUTABLE=C:\Program Files\Google\Chrome\Application\chrome.exe

# macOS/Linux
export CHROME_EXECUTABLE=/usr/bin/google-chrome
```

### 2. 依赖问题

#### 包冲突
```bash
# 清理缓存
flutter clean
flutter pub cache repair

# 重新获取依赖
flutter pub get
```

#### 版本不兼容
```bash
# 更新 Flutter
flutter upgrade

# 检查依赖版本
flutter pub deps
```

### 3. 构建问题

#### Android 构建失败
```bash
# 检查 Gradle
cd android
./gradlew clean

# 检查 Android SDK
flutter doctor -v
```

#### iOS 构建失败 (macOS)
```bash
# 更新 CocoaPods
cd ios
pod install
pod update
```

## ⚙️ 开发配置

### 1. IDE 设置

#### Android Studio
1. File → Settings → Editor → General
   - 勾选 "Show line numbers"
   - 勾选 "Show whitespaces"
2. Editor → Code Style → Dart
   - 导入项目代码风格

#### VS Code
1. settings.json 配置：
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.lineLength": 80,
  "editor.rulers": [80],
  "files.associations": {
    "*.dart": "dart"
  }
}
```

### 2. Git 配置
```bash
# 配置用户信息
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 配置 .gitignore (项目已包含)
# 确保不提交 build/ 和 .dart_tool/
```

### 3. 环境变量
```bash
# Windows (系统环境变量)
PUB_CACHE=C:\flutter\.pub-cache
FLUTTER_ROOT=C:\flutter

# macOS/Linux (~/.bashrc 或 ~/.zshrc)
export PUB_CACHE="$HOME/.pub-cache"
export FLUTTER_ROOT="/path/to/flutter"
```

## 🧪 测试环境

### 1. 单元测试
```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/widget_test.dart

# 测试覆盖率
flutter test --coverage
```

### 2. 集成测试
```bash
# 安装 integration_test 依赖
flutter pub add integration_test

# 运行集成测试
flutter test integration_test/
```

## 📱 设备测试

### 1. 真机测试
- **Android**: 测试不同 API 级别和设备制造商
- **iOS**: 测试不同 iOS 版本和设备型号
- **屏幕尺寸**: 测试不同屏幕密度和尺寸

### 2. 性能测试
```bash
# 性能分析
flutter run --profile

# 内存分析
flutter run --trace-startup
```

---

**环境配置完成后**，你就可以开始开发英语学习App了！如果遇到问题，请查看 Flutter 官方文档或项目 Issues。