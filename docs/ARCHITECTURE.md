# 项目架构说明

## 目录结构

```
lib/
├── main.dart                    # 应用入口，初始化服务
├── models/                      # 数据模型
│   ├── article.dart
│   ├── word.dart
│   ├── sentence.dart
│   └── user.dart
├── screens/                     # UI页面
│   ├── home_screen.dart
│   ├── article_list_screen.dart
│   ├── article_detail_screen.dart
│   ├── word_practice_screen.dart
│   ├── sentence_practice_screen.dart
│   ├── dialogue_practice_screen.dart
│   └── ...
├── services/                    # 服务层 (业务逻辑)
│   ├── storage_service.dart     # 本地存储服务
│   ├── word_service.dart       # 单词服务
│   ├── sentence_service.dart   # 句子服务
│   ├── dialogue_service.dart   # 对话服务
│   ├── article_service.dart    # 文章服务
│   └── user_service.dart       # 用户服务
└── mock/                       # Mock数据 (开发/测试用)
    ├── mock_words.dart
    ├── mock_sentences.dart
    ├── mock_dialogues.dart
    ├── mock_articles.dart
    └── mock_user.dart
```

## 服务层架构

### 1. StorageService (存储服务)
使用 SharedPreferences 实现本地数据持久化：
- 用户收藏夹管理
- 学习进度记录
- 连续学习天数追踪
- 应用设置存储

### 2. 业务服务 (WordService, SentenceService, etc.)
- 提供业务逻辑方法
- 支持 Mock 数据切换
- 调用 StorageService 进行数据持久化

### 数据流向
```
Screens → Services → Storage/Mock Data
```

## Mock 数据切换

所有服务默认使用 Mock 数据 (`_useMockData = true`)。切换到真实数据只需：
1. 实现 API 调用逻辑
2. 将 `_useMockData` 设为 `false`

## 扩展指南

### 添加新功能
1. 在 `models/` 创建数据模型
2. 在 `mock/` 创建 Mock 数据
3. 在 `services/` 创建服务类
4. 在 `screens/` 创建页面
5. 更新 `main.dart` 初始化服务

### 添加本地存储
使用 StorageService 提供的方法：
```dart
// 保存数据
await storageService.saveKey(key, value);

// 读取数据
var value = storageService.getKey(key);
```
