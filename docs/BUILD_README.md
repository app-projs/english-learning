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

# 6. 构建个人自用安装包 (推荐: 兼容所有安卓手机)
flutter build apk --release
# 生成文件位置: build/app/outputs/flutter-apk/app-release.apk

# 7. 构建按架构拆分安装包 (推荐: 个人自用缩小体积，如仅打 arm64)
flutter build apk --split-per-abi
# 生成文件位置: build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# 8. 构建 Google Play 商店安装包 (AAB)
flutter build appbundle
# 生成文件位置: build/app/outputs/bundle/release/app-release.aab
```

### 输出目录与安装包说明

| 打包类型 | 命令 | 输出路径 | 适用场景 |
|---------|------|---------|---------|
| **通用 Release APK (自用首选)** | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` | 个人安装、发送微信好友安装、无网络设备安装 |
| **轻量架构拆分包** | `flutter build apk --split-per-abi` | `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` | 体积更小，适合主流 64 位安卓真机自用 |
| **Google Play 商店包** | `flutter build appbundle` | `build/app/outputs/bundle/release/app-release.aab` | 上架应用商店 |
| **Debug 调试包** | `flutter build apk --debug` | `build/app/outputs/flutter-apk/app-debug.apk` | 开发阶段联调测试 |

### Android 配置与版本号递增

#### 1. 版本号定义方式 (`pubspec.yaml`)
Flutter 项目的版本名 (`versionName`) 与构建号 (`versionCode`) 统一在 `pubspec.yaml` 中配置：
```yaml
version: 1.0.41+42
```
- **`1.0.41`**：应用版本名 (`versionName` / `build-name`)
- **`42`**：内部打包递增构建号 (`versionCode` / `build-number`)

> **注意**：Flutter CLI 默认在打 release 包时**不会自动改写修改 `pubspec.yaml`** 文件，如果不传参，生成的版本号将固定为 `pubspec.yaml` 中定义的值。

#### 2. 打包时动态递增版本号命令
可以在每次编译打包时通过命令行参数直接指定递增的版本号与构建号，无需手动修改 `pubspec.yaml`：

```bash
# 打包时动态指定版本名 (build-name) 与构建号 (build-number)
flutter build apk --release --build-name=1.0.42 --build-number=43

# 按架构拆分打包时动态指定版本
flutter build apk --split-per-abi --build-name=1.0.42 --build-number=43
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
