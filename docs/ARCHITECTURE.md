# 项目架构说明

## 目录结构 (Feature-First Modular Architecture)

```
lib/
├── main.dart                    # 应用入口，服务初始化
├── app/                         # 应用级别配置
├── core/                        # 全局公共模块
│   ├── theme/                   # Lumina 设计系统与主题服务 (theme_service.dart, lumina_theme.dart)
│   ├── services/                # 全局底层基础设施 (storage_service.dart, database_service.dart, audio_service.dart)
│   └── widgets/                 # 全局复用 UI 组件 (word_detail_dialog.dart, modern_ui.dart, lumina_button.dart)
│
└── features/                    # 高内聚功能业务模块
    ├── home/                    # 首页与底部 Dock 壳 (lumina_home_screen.dart, daily_tab.dart)
    ├── word/                    # 单词背诵模块 (Word Model, WordService, WordPracticeScreen, MockWords)
    ├── article/                 # 文章名著模块 (Book/Article Model, ArticleService, ArticleDetailScreen, 14本名著Mock)
    ├── sentence/                # 句型翻译模块 (Sentence Model, SentenceService, SentencePracticeScreen)
    ├── grammar/                 # 语法测试模块 (GrammarPracticeScreen, MockGrammar)
    ├── listening/               # 听力训练模块 (ListeningPracticeScreen)
    ├── phonetics/               # 自然拼读/音标模块 (PhoneticsService, PhoneticsPracticeScreen)
    ├── word_root/               # 字词根词缀模块 (WordRootService, WordRootsScreen)
    ├── dialogue/                # 对话练习模块 (Dialogue Model, DialogueService, DialoguePracticeScreen)
    ├── ai_practice/             # AI 口语与诊断模块 (AiPracticeService, AiChatScreen, AiPracticeTab)
    ├── dictionary/              # SQLite 离线词典模块 (DictionaryService, DictionaryWordModel)
    ├── profile/                 # 个人中心模块 (User Model, UserService, HomeScreen, Settings)
    ├── achievement/             # 成就与勋章模块 (AchievementScreen)
    ├── leaderboard/             # 排行榜与 PK 竞技场 (LeaderboardTab)
    ├── review/                  # 智能复习与错题本 (SmartReviewScreen, WrongAnswersScreen)
    └── favorites/               # 生词本与上下文出处 (FavoritesScreen)
```

## 数据架构与 SQLite 持久化

- **SQLite Database (Version 16)**: `DatabaseService` 托管包含 `words` (含 `definitions` 多义释义 JSON 列)、`sentences`、`dialogues`、`books`、`articles`、`phonetics`、`word_roots`、`dictionary` 与 `ai_chat_history` 核心业务表。
- **Shared Storage**: `StorageService` 处理 SharedPrefs 快速读写，记录用户收藏、连续打卡天数与偏好设定。

## 发音引擎与降级机制

优先调用微软 Edge TTS 神经网络发音 / 有道网络发音 API，具备音素缓存及离线 `FlutterTts` 自动无缝降级保底。
