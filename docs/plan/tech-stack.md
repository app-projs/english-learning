# 技术栈规划

## 🛠 当前技术栈

### 前端框架
- **Flutter SDK**: 3.0.0+
- **Dart**: 3.0.0+
- **UI框架**: Material Design 3
- **状态管理**: StatefulWidget (基础实现)

### 核心依赖 (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

### 开发工具
- **IDE**: VS Code / Android Studio
- **版本控制**: Git
- **包管理**: Pub
- **调试工具**: Flutter Inspector

## 📦 计划添加的技术栈

### 状态管理
#### Provider (推荐)
```yaml
provider: ^6.0.5
```
**优势**: 
- 官方推荐状态管理解决方案
- 易于学习和使用
- 与Material Design集成良好
- 适合中小型项目

#### Riverpod (备选)
```yaml
flutter_riverpod: ^2.4.0
```
**优势**:
- 更现代的状态管理方案
- 编译时安全
- 测试友好
- 性能优秀

### 本地存储
#### SQLite + SharedPreferences
```yaml
sqflite: ^2.3.0
shared_preferences: ^2.2.0
```
**用途**:
- 用户偏好设置存储
- 学习进度本地缓存
- 文章离线存储
- 练习记录保存

#### Hive (备选)
```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
```
**优势**:
- 纯Dart实现，性能优秀
- 支持复杂对象存储
- 无需额外配置

### 网络请求
#### Dio + 缓存策略
```yaml
dio: ^5.3.2
dio_http_adapter: ^2.0.0
```
**功能**:
- HTTP/HTTPS请求
- 请求拦截器
- 响应拦截器
- 错误处理
- 请求取消

### 图像处理
#### 缓存网络图片
```yaml
cached_network_image: ^3.3.0
```
**用途**:
- 用户头像加载
- 文章配图显示
- 自动缓存管理

#### 图片选择器
```yaml
image_picker: ^1.0.4
```
**用途**:
- 用户头像上传
- 图片相关功能

### 音频处理
#### 音频播放
```yaml
audioplayers: ^5.2.1
```
**用途**:
- 单词发音播放
- 听力练习音频
- 对话录音回放

#### 录音功能
```yaml
record: ^5.0.4
permission_handler: ^11.0.1
```
**用途**:
- 对话练习录音
- 发音练习录制
- 权限管理

### 图表可视化
#### 学习统计图表
```yaml
fl_chart: ^0.63.0
```
**用途**:
- 学习进度可视化
- 时间统计图表
- 成绩分析展示

### 国际化
```yaml
intl: ^0.18.1
flutter_localizations:
  sdk: flutter
```
**支持语言**:
- 中文 (简体)
- 英文
- 未来可扩展其他语言

### 路由管理
#### Go Router
```yaml
go_router: ^12.1.3
```
**优势**:
- 声明式路由
- 深度链接支持
- 嵌套路由
- 导航类型安全

## 🔧 AI服务集成

### 语音识别
#### Speech to Text
```yaml
speech_to_text: ^6.3.0
```
**功能**:
- 实时语音识别
- 多语言支持
- 离线模式支持

### 翻译服务
#### Google Translate API
```yaml
google_translate: ^1.0.1
```
**功能**:
- 文本翻译
- 语言检测
- 批量翻译

### 发音评分
#### 第三方API集成
**候选服务**:
- Google Cloud Speech-to-Text API
- Azure Speech Services
- 讯飞语音API

## 📱 平台支持

### 移动端
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+

### 桌面端 (计划)
- **Windows**: Windows 10+
- **macOS**: macOS 10.14+
- **Linux**: Ubuntu 18.04+

### Web端 (计划)
- **浏览器**: Chrome 84+, Safari 14+, Firefox 90+
- **PWA支持**: 离线访问能力

## 🏗️ 架构设计

### 项目结构
```
lib/
├── main.dart                 # 应用入口
├── app/                     # 应用层
│   ├── router/              # 路由配置
│   ├── theme/               # 主题配置
│   └── constants/           # 常量定义
├── core/                   # 核心层
│   ├── utils/               # 工具类
│   ├── extensions/          # 扩展方法
│   └── exceptions/          # 异常定义
├── data/                   # 数据层
│   ├── models/              # 数据模型
│   ├── repositories/        # 数据仓库
│   ├── datasources/         # 数据源
│   └── database/           # 数据库
├── domain/                # 领域层
│   ├── entities/           # 业务实体
│   ├── usecases/          # 用例
│   └── repositories/       # 仓库接口
├── presentation/          # 表现层
│   ├── pages/             # 页面
│   ├── widgets/           # 组件
│   └── providers/         # 状态管理
└── services/             # 服务层
    ├── api/              # API服务
    ├── storage/          # 存储服务
    └── external/        # 外部服务
```

### 设计模式
- **架构模式**: Clean Architecture
- **状态管理**: Provider/Riverpod
- **数据模式**: Repository Pattern
- **UI模式**: MVVM (Model-View-ViewModel)

## 🔒 安全性

### 数据安全
- **本地加密**: AES-256加密敏感数据
- **传输安全**: HTTPS/TLS 1.3
- **密钥管理**: 安全密钥存储

### 用户隐私
- **权限管理**: 最小权限原则
- **数据匿名化**: 去除个人标识
- **数据清理**: 定期清理无用数据

## 🚀 性能优化

### 应用性能
- **启动优化**: 冷启动 < 3秒
- **内存管理**: 峰值 < 200MB
- **电池优化**: 后台任务最小化
- **网络优化**: 请求合并和缓存

### 用户体验
- **响应时间**: 页面切换 < 500ms
- **动画流畅度**: 60 FPS
- **离线支持**: 核心功能离线可用
- **适配性**: 多屏幕尺寸适配

## 🧪 测试策略

### 单元测试
```yaml
flutter_test:
  sdk: flutter
mockito: ^5.4.2
```

### 集成测试
```yaml
integration_test:
  sdk: flutter
```

### 测试覆盖率目标
- **单元测试**: 80%+
- **集成测试**: 主要用户流程
- **UI测试**: 关键页面和交互

## 📦 部署策略

### Android部署
- **构建工具**: Gradle
- **签名配置**: Release Key
- **商店发布**: Google Play Store
- **内测发布**: Firebase App Distribution

### iOS部署
- **构建工具**: Xcode
- **证书配置**: Distribution Certificate
- **商店发布**: App Store
- **内测发布**: TestFlight

### CI/CD
- **代码检查**: GitHub Actions
- **自动构建**: GitHub Actions
- **自动测试**: GitHub Actions
- **自动部署**: 按标签触发

## 🔄 版本管理

### 语义化版本
- **主版本**: 重大功能变更
- **次版本**: 新功能添加
- **修订版本**: Bug修复

### 发布周期
- **Alpha**: 内部测试 (每周)
- **Beta**: 公开测试 (每两周)
- **Release**: 正式发布 (每月)

---

## 🇨🇳 国内网络环境与 API 选型规范

鉴于本项目核心服务中国大陆移动端用户，技术选型与网络架构遵循以下原则：

1. **语音 API 选型**：优先采用有道词典国内直连语音 API (`dict.youdao.com/dictvoice`)，断网下自动切系统 `FlutterTts`，无需翻墙。
2. **图片与头像选型**：头像使用本地预设与首字母卡片降级，禁止使用 Unsplash/Google 等被 GFW 墙或超时的海外图源。
3. **离线优先设计**：核心学习功能本地存储化 (`SQLite` + `SharedPreferences`)，离线或弱网下完全可用。

---

**最后更新**: 2026年7月25日  
**维护者**: 开发团队