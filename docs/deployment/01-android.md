# Android 编译与部署指南

本文档说明如何针对个人自用、开发调试以及应用商店发布进行 Android App 编译打包。

---

## 📱 1. 个人自用打包 (推荐)

如果你只是想在自己的安卓手机、平板或发送给朋友安装使用，请使用以下命令：

### 1.1 通用 Release APK (所有安卓手机通用)

```bash
flutter build apk --release
```

- **输出路径**：`build/app/outputs/flutter-apk/app-release.apk`
- **特点**：包含全架构（arm64-v8a, armeabi-v7a, x86_64）支持，兼容所有安卓手机，直接安装即可使用。

---

### 1.2 架构拆分 APK (缩小体积)

如果你想降低 APK 大小（如从 40MB 降至 15MB 左右）：

```bash
flutter build apk --split-per-abi
```

- **输出路径**：`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- **特点**：针对现代主流 64 位安卓真机优化，体积更精简。

---

## 🏬 2. 应用商店打包 (Google Play)

用于提交至 Google Play Store 或部分要求 AAB 格式的安卓应用市场：

```bash
flutter build appbundle
```

- **输出路径**：`build/app/outputs/bundle/release/app-release.aab`

---

## 🐞 3. 开发调试打包

用于本地调试与查看详细日志：

```bash
flutter build apk --debug
```

- **输出路径**：`build/app/outputs/flutter-apk/app-debug.apk`

---

## 🛠️ 4. 常见问题与提示

1. **安装时提示“未知的来源”**：
   自用编译的 APK 属于侧载安装，在手机上安装时需在设置中允许“安装未知来源应用”。
2. **应用签名配置**：
   项目已配置默认密钥对，打出来的 APK 可直接安装更新。如需自定义签名，可修改 `android/app/build.gradle` 中的 `signingConfigs`。
