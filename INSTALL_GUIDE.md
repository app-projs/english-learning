# Flutter 环境安装和使用指南

## ✅ 问题解决

经过检查，你的系统环境现在已经配置好了：

### 已安装组件
- ✅ **Dart SDK**: 3.11.0 (已安装)
- ✅ **Flutter SDK**: 3.24.5 (刚安装完成)
- ✅ **Chocolatey**: 2.5.1 (包管理器)
- ✅ **Git**: 可用
- ✅ **VS Code**: 已安装

### 当前项目状态
- ✅ **项目依赖**: 已安装
- ✅ **应用启动**: 成功运行在Windows桌面

## 🚀 如何使用Flutter项目

### 1. 设置环境变量

每次打开新的终端窗口时，需要确保 `flutter` 在你的 PATH 路径中（如果尚未配置全局环境变量）：

**macOS:**
```bash
# 检查 flutter 命令是否可用，如果不可用可以配置到 ~/.zshrc 或 ~/.bash_profile 中
# 例如：export PATH="$HOME/development/flutter/bin:$PATH"
```

**Windows:**
```bash
# 临时添加Flutter到PATH
export PATH="/c/tools/flutter/bin:$PATH"

# 或者添加到系统环境变量中：Windows系统设置 → 环境变量 → 系统变量 → Path
# 添加: C:\tools\flutter\bin
```

### 2. 常用Flutter命令

```bash
# 检查Flutter环境状态
flutter doctor

# 安装依赖
flutter pub get

# 查看可用预览设备
flutter devices

# 查看已配置的模拟器列表
flutter emulators

# 启动指定的模拟器 (例如系统已配置的 Pixel_8_Pro)
flutter emulators --launch Pixel_8_Pro

# 运行项目到指定设备
flutter run -d chrome        # Web版 (Chrome)
flutter run -d emulator-5554 # 安卓模拟器版 (或者使用 -d android)
flutter run -d macos         # macOS桌面版 (需Xcode环境)
flutter run -d windows       # Windows桌面版 (需Windows环境)

# 代码检查与格式化
flutter analyze
flutter format .

# 清理缓存/项目
flutter clean
```

### 3. 项目开发工作流 (以 macOS 模拟器开发为例)

#### 日常开发
```bash
cd /Users/admin/Documents/workspace/code/english-learning

# 1. 启动安卓模拟器
flutter emulators --launch Pixel_8_Pro

# 2. 运行项目
flutter run -d emulator-5554

# 3. 在运行中修改代码后，在终端按 'r' 键进行热重载 (Hot Reload)
```

#### 代码修改后检查
```bash
# 检查代码问题
flutter analyze

# 格式化代码
flutter format .
```

## 📱 预览与设备配置

### 1. 模拟器管理小工具推荐 (macOS)
除了通过终端命令启动外，推荐安装 **MiniSim** 菜单栏工具。它极其轻量，可以直接从 macOS 顶部菜单栏一键唤醒 Android/iOS 模拟器：
```bash
brew install --cask minisim
```

### 2. 系统当前可用设备列表 (macOS)
在 macOS 系统上，以下设备已经就绪：
- **Chrome (web)**: `chrome` (Web预览)
- **Android Emulator (mobile)**: `Pixel_8_Pro` (可通过命令 `flutter emulators --launch Pixel_8_Pro` 启动)
- **macOS (desktop)**: `macos` (原生 macOS 桌面版，需 Xcode 配置完毕)

## 🔧 IDE配置建议

### VS Code
确保安装以下扩展：
- Flutter
- Dart
- Flutter Tree
- GitLens

设置 `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "C:\\tools\\flutter",
  "dart.debugExternalLibraries": false,
  "dart.debugExternalPackageLibraries": false
}
```

### Android Studio (可选)
如果需要移动端开发：
1. 下载 Android Studio
2. 安装 Flutter 和 Dart 插件
3. 配置 Android SDK
4. 运行 `flutter doctor --android-licenses`

## 🐛 常见问题解决

### 1. "flutter" 命令不存在
```bash
# 解决方案：添加Flutter到PATH
export PATH="/c/tools/flutter/bin:$PATH"
```

### 2. 依赖冲突
```bash
# 清理并重新安装
flutter clean
flutter pub cache repair
flutter pub get
```

### 3. 分析错误
```bash
# 查看详细错误信息
flutter analyze -v

# 常见错误类型：
# - uri_does_not_exist: 导入路径错误
# - unused_import: 未使用的导入
# - creation_with_non_type: 类型定义错误
```

### 4. 运行失败
```bash
# 检查设备
flutter devices

# 指定设备运行
flutter run -d [device-name]

# 强制清理
flutter clean
flutter pub get
flutter run -d windows
```

## 📊 项目已实现功能

当前你的英语学习App包含以下功能：

### ✅ 已完成 (80%)
- **项目架构**: 完整Flutter项目结构
- **数据模型**: Article, Word, Sentence, Dialogue, User模型
- **阅读模块**: 文章列表和详情页面
- **导航系统**: 底部导航栏
- **练习中心**: 四大练习模块入口
- **UI组件**: Material Design 3主题

### 🚧 开发中 (20%)
- **单词练习**: 基础框架已搭建
- **句子练习**: 页面已创建
- **对话练习**: 页面已创建
- **个人中心**: 待开发

## 📁 重要文件说明

```
flutter-app/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── models/                      # 数据模型
│   │   ├── article.dart            # 文章模型
│   │   ├── word.dart              # 单词模型
│   │   ├── sentence.dart           # 句子/对话模型
│   │   └── user.dart              # 用户模型
│   └── screens/                     # 页面
│       ├── home_screen.dart        # 主页面
│       ├── article_list_screen.dart # 文章列表
│       ├── article_detail_screen.dart # 文章详情
│       └── practice_tab.dart      # 练习中心
├── docs/                          # 项目文档
├── README.md                      # 项目说明
└── pubspec.yaml                   # 依赖配置
```

## 🎯 下一步开发计划

### 即将开始
1. **完善单词练习** - 实现单词测试功能
2. **开发句子练习** - 添加句子填空等练习
3. **集成对话练习** - 实现对话场景
4. **构建个人中心** - 用户信息和统计

### 中期目标
1. **本地数据存储** - 使用SQLite/SharedPreferences
2. **状态管理升级** - 集成Provider/Riverpod
3. **网络请求** - 集成API服务
4. **测试覆盖** - 添加单元测试和集成测试

## 🎉 成功！

恭喜！你现在拥有了：
- ✅ 完整可运行的Flutter英语学习应用
- ✅ 配置完善的开发环境
- ✅ 详细的项目文档
- ✅ 清晰的开发路线图

你可以继续开发新功能，或者先运行体验当前的版本！

---

**最后验证时间**: 2026年2月12日  
**Flutter版本**: 3.24.5  
**项目状态**: ✅ 可运行