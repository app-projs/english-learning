# 多平台编译指南

本文档说明如何在不同平台上编译和运行英语学习应用。

## 环境要求

| 平台 | 最低要求 |
|------|----------|
| Flutter SDK | 3.24.5+ |
| Dart SDK | 3.5.4+ |
| 磁盘空间 | 至少 3GB |

---

## Windows 桌面应用

### 前置条件

1. **Flutter SDK** - 已配置在 `C:\tools\flutter`
2. **Visual Studio Build Tools 2022** - 包含 C++ 桌面开发

### 编译步骤

```bash
# 1. 设置 Flutter 路径（如果未添加到环境变量）
set PATH=%PATH%;C:\tools\flutter\bin

# 2. 启用 Windows 桌面支持
flutter config --enable-windows-desktop

# 3. 检查可用设备
flutter devices

# 4. 安装依赖
flutter pub get

# 5. 运行调试版本
flutter run -d windows

# 6. 构建发布版本
flutter build windows --release
```

### 输出目录
```
build\windows\x64\runner\Release\
```

---

## macOS 桌面应用

### 前置条件

1. **Flutter SDK**
2. **Xcode** - 15.0+
3. **CocoaPods** - `sudo gem install cocoapods`

### 编译步骤

```bash
# 1. 设置 Flutter 路径
export PATH="$PATH:/Users/用户名/flutter/bin"

# 2. 启用 macOS 桌面支持
flutter config --enable-macos-desktop

# 3. 检查可用设备
flutter devices

# 4. 安装依赖
flutter pub get

# 5. 运行调试版本
flutter run -d macos

# 6. 构建发布版本
flutter build macos --release
```

### 输出目录
```
build\macos\Release\
```

### 注意事项

- 首次运行需要运行 `flutter doctor` 授权 Xcode
- 发布版本需要签名证书

---

## Android 应用

### 前置条件

1. **Flutter SDK**
2. **Android Studio** 或 **Android SDK Command-line Tools**
3. **Java JDK** - 17+

### 编译步骤

```bash
# 1. 启用 Android 支持（默认已启用）
flutter config --enable-android-sdk

# 2. 检查 Android 设备
flutter devices

# 3. 安装依赖
flutter pub get

# 4. 运行调试版本（USB连接手机）
flutter run -d android

# 5. 运行模拟器
flutter run -d android_emulator

# 6. 构建调试 APK
flutter build apk --debug

# 7. 构建发布 APK
flutter build apk --release
```

### 输出目录
```
build\app\outputs\flutter-apk\
```

### Android 配置

编辑 `android\app\build.gradle` 配置应用版本：

```gradle
android {
    defaultConfig {
        applicationId "com.example.englishlearning"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

---

## iOS 应用

### 前置条件

1. **Flutter SDK**
2. **Xcode** - 15.0+
3. **CocoaPods**
4. **Apple 开发者账号**（发布需要）

### 编译步骤

```bash
# 1. 启用 iOS 支持
flutter config --enable-ios-sdk

# 2. 检查可用设备
flutter devices

# 3. 安装依赖
flutter pub get

# 4. 运行调试版本（需要模拟器或真机）
flutter run -d ios
flutter run -d "iPhone 15 Pro"

# 5. 构建模拟器版本
flutter build ios --simulator --no-codesign

# 6. 构建发布版本
flutter build ios --release
```

### 输出目录
```
build\ios\iphoneos\
```

### iOS 配置

编辑 `ios\Runner\Info.plist` 配置应用：

```xml
<key>CFBundleDisplayName</key>
<string>英语学习</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

### 注意事项

- 真机调试需要配置签名证书
- 发布到 App Store 需要 Xcode 归档

---

## 常用命令汇总

```bash
# 清理构建缓存
flutter clean

# 重新获取依赖
flutter pub get

# 查看所有设备
flutter devices

# 代码分析
flutter analyze

# 格式化代码
flutter format .

# 运行测试
flutter test

# 查看 Flutter 版本
flutter --version

# 更新 Flutter
flutter upgrade
```

---

## 平台特定问题

### Windows

- 确保已安装 Visual Studio Build Tools
- 杀毒软件可能影响构建速度

### macOS

- 首次使用需要授权 Xcode：`sudo xcodebuild -license`
- M1/M2 芯片需要 Rosetta 2

### Android

- 手机需要开启开发者选项和 USB 调试
- 模拟器建议使用 x86_64 架构

### iOS

- 真机调试需要 Apple 开发者账号
- 模拟器在 Apple Silicon 上需要 Rosetta 2

---

## 持续集成建议

### GitHub Actions 示例

```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter build apk --debug
```

---

## 相关文档

- [安装指南](./INSTALL_GUIDE.md)
- [开发进度](./plan/development-progress.md)
- [功能规划](./features/00-roadmap.md)
