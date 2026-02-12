# 数据模型完整文档

本文档详细描述英语学习App中使用的所有数据模型和API接口。

## 📊 核心数据模型

### 1. Article - 文章模型

#### 属性说明
```dart
class Article {
  final String id;              // 文章唯一标识
  final String title;            // 文章标题
  final String content;          // 文章内容
  final String difficulty;       // 难度等级
  final List<String> tags;        // 文章标签
  final DateTime createdAt;       // 创建时间
  final int readTime;           // 预估阅读时间(分钟)
}
```

#### 难度等级
- `Beginner` - 初级 (基础词汇和简单语法)
- `Intermediate` - 中级 (常用词汇和复合语法)
- `Advanced` - 高级 (专业词汇和复杂语法)

#### 标签分类
- **技能类型**: Reading, Writing, Listening, Speaking
- **内容类型**: Grammar, Vocabulary, Business, Daily
- **话题分类**: Technology, Education, Travel, Culture

#### JSON 示例
```json
{
  "id": "article_001",
  "title": "The Benefits of Reading English Books",
  "content": "Reading books in English can significantly improve your language skills...",
  "difficulty": "Intermediate",
  "tags": ["Reading", "Vocabulary", "Education"],
  "createdAt": "2026-02-12T10:00:00.000Z",
  "readTime": 5
}
```

### 2. Word - 单词模型

#### 属性说明
```dart
class Word {
  final String id;                  // 单词唯一标识
  final String english;               // 英文单词
  final String chinese;               // 中文释义
  final String phonetic;              // 音标
  final List<String> synonyms;        // 同义词列表
  final List<String> antonyms;        // 反义词列表
  final String exampleSentence;       // 例句
  final DateTime createdAt;           // 添加时间
  final int masteryLevel;            // 掌握程度 (0-5)
}
```

#### 掌握程度定义
- `0` - 未学习
- `1` - 初次接触
- `2` - 认识但不熟练
- `3` - 基本掌握
- `4` - 熟练掌握
- `5` - 完全掌握

#### JSON 示例
```json
{
  "id": "word_001",
  "english": "significant",
  "chinese": "重要的，显著的",
  "phonetic": "/sɪɡˈnɪfɪkənt/",
  "synonyms": ["important", "meaningful", "notable"],
  "antonyms": ["insignificant", "trivial"],
  "exampleSentence": "This discovery has significant implications for medical research.",
  "createdAt": "2026-02-12T10:00:00.000Z",
  "masteryLevel": 2
}
```

### 3. Sentence - 句子模型

#### 属性说明
```dart
class Sentence {
  final String id;                  // 句子唯一标识
  final String english;               // 英文句子
  final String chinese;               // 中文翻译
  final List<Word> keyWords;        // 关键单词列表
  final String difficulty;           // 难度等级
  final String category;             // 句子分类
  final DateTime createdAt;           // 创建时间
}
```

#### 句子分类
- **语法类型**: Simple, Compound, Complex
- **功能类型**: Question, Statement, Command, Exclamation
- **场景类型**: Daily, Business, Academic, Social

#### JSON 示例
```json
{
  "id": "sentence_001",
  "english": "The rapid development of technology has changed our daily lives.",
  "chinese": "技术的快速发展改变了我们的日常生活。",
  "keyWords": [
    {
      "id": "word_001",
      "english": "rapid",
      "chinese": "快速的"
    }
  ],
  "difficulty": "Intermediate",
  "category": "Technology",
  "createdAt": "2026-02-12T10:00:00.000Z"
}
```

### 4. Dialogue - 对话模型

#### 属性说明
```dart
class Dialogue {
  final String id;                      // 对话唯一标识
  final String title;                    // 对话标题
  final List<DialogueLine> lines;       // 对话行列表
  final String difficulty;               // 难度等级
  final String context;                  // 对话场景描述
  final DateTime createdAt;               // 创建时间
}

class DialogueLine {
  final String speaker;     // 说话人
  final String english;      // 英文台词
  final String chinese;      // 中文翻译
}
```

#### 对话场景
- **日常对话**: Greeting, Shopping, Restaurant, Direction
- **商务对话**: Meeting, Presentation, Negotiation, Interview
- **学术对话**: Lecture, Discussion, Research, Conference

#### JSON 示例
```json
{
  "id": "dialogue_001",
  "title": "Ordering Coffee",
  "difficulty": "Beginner",
  "context": "在咖啡店点咖啡的日常对话",
  "createdAt": "2026-02-12T10:00:00.000Z",
  "lines": [
    {
      "speaker": "Customer",
      "english": "I'd like to order a coffee, please.",
      "chinese": "我想要点一杯咖啡。"
    },
    {
      "speaker": "Barista",
      "english": "What kind of coffee would you like?",
      "chinese": "您想要哪种咖啡？"
    }
  ]
}
```

### 5. User & UserProgress - 用户模型

#### User 属性说明
```dart
class User {
  final String id;              // 用户唯一标识
  final String username;          // 用户名
  final String email;             // 邮箱
  final String avatar;             // 头像URL
  final DateTime joinDate;        // 注册时间
  final UserProgress progress;     // 学习进度
}
```

#### UserProgress 属性说明
```dart
class UserProgress {
  final String userId;                           // 用户ID
  final int totalWordsLearned;                    // 学习单词总数
  final int totalArticlesRead;                    // 阅读文章总数
  final int totalPracticeSessions;                 // 练习次数
  final int currentStreak;                        // 当前连续学习天数
  final int longestStreak;                        // 最长连续学习天数
  final Map<String, int> wordMasteryLevels;      // 单词掌握程度映射
  final List<String> completedArticles;            // 已完成文章ID列表
  final List<String> completedSentences;           // 已完成句子ID列表
  final List<String> completedDialogues;           // 已完成对话ID列表
  final DateTime lastStudyDate;                  // 最后学习时间
  final int totalStudyMinutes;                    // 总学习时长(分钟)
}
```

#### JSON 示例
```json
{
  "id": "user_001",
  "username": "english_learner",
  "email": "learner@example.com",
  "avatar": "https://example.com/avatar.jpg",
  "joinDate": "2026-01-01T00:00:00.000Z",
  "progress": {
    "userId": "user_001",
    "totalWordsLearned": 150,
    "totalArticlesRead": 12,
    "totalPracticeSessions": 45,
    "currentStreak": 7,
    "longestStreak": 15,
    "wordMasteryLevels": {
      "word_001": 3,
      "word_002": 2
    },
    "completedArticles": ["article_001", "article_002"],
    "completedSentences": ["sentence_001", "sentence_002"],
    "completedDialogues": ["dialogue_001"],
    "lastStudyDate": "2026-02-12T10:00:00.000Z",
    "totalStudyMinutes": 480
  }
}
```

## 🔗 API 接口定义

### 本地存储 API

#### 1. 文章管理

```dart
// 获取所有文章
Future<List<Article>> getAllArticles();

// 根据难度获取文章
Future<List<Article>> getArticlesByDifficulty(String difficulty);

// 根据标签获取文章
Future<List<Article>> getArticlesByTag(String tag);

// 获取单篇文章
Future<Article?> getArticleById(String id);

// 搜索文章
Future<List<Article>> searchArticles(String query);
```

#### 2. 单词管理

```dart
// 获取所有单词
Future<List<Word>> getAllWords();

// 根据掌握程度获取单词
Future<List<Word>> getWordsByMasteryLevel(int level);

// 获取需要复习的单词
Future<List<Word>> getWordsForReview();

// 更新单词掌握程度
Future<void> updateWordMastery(String wordId, int level);

// 获取收藏单词
Future<List<Word>> getFavoriteWords();
```

#### 3. 练习记录

```dart
// 保存练习记录
Future<void> savePracticeRecord({
  required String type,
  required String contentId,
  required int score,
  required int duration,
  required DateTime timestamp,
});

// 获取练习历史
Future<List<PracticeRecord>> getPracticeHistory(String type);

// 获取今日练习统计
Future<PracticeStats> getTodayStats();
```

#### 4. 用户进度

```dart
// 保存用户进度
Future<void> saveUserProgress(UserProgress progress);

// 获取用户进度
Future<UserProgress?> getUserProgress(String userId);

// 更新学习记录
Future<void> updateLearningRecord({
  required String userId,
  required String type,
  required String contentId,
  required int score,
});
```

### 云端 API (计划中)

```dart
// 用户认证
Future<UserResponse> login(String email, String password);
Future<UserResponse> register(String username, String email, String password);
Future<void> logout();

// 数据同步
Future<void> syncToCloud();
Future<void> syncFromCloud();

// AI 服务
Future<String> translateText(String text, {String from = 'en', String to = 'zh'});
Future<String> checkGrammar(String text);
Future<List<Word>> extractWords(String text);
```

## 📈 数据流和状态管理

### 状态更新事件

```dart
// 学习进度更新
class ProgressUpdatedEvent {
  final String userId;
  final UserProgress newProgress;
}

// 新内容解锁
class ContentUnlockedEvent {
  final String contentType;
  final String contentId;
}

// 成就达成
class AchievementUnlockedEvent {
  final String achievementId;
  final String title;
  final String description;
}
```

### 数据验证规则

#### 文章验证
- 标题长度: 10-100 字符
- 内容长度: 100-5000 字符
- 难度: 必须为预定义等级
- 标签: 最多5个，每个不超过20字符

#### 单词验证
- 英文单词: 2-50 字符
- 中文释义: 2-100 字符
- 音标: 可选，符合IPA标准
- 例句: 可选，10-200 字符

#### 用户数据验证
- 用户名: 3-20 字符，字母数字下划线
- 邮箱: 有效的邮箱格式
- 头像: 可选，有效的URL格式

## 🔐 数据安全

### 敏感数据处理
- 用户密码使用bcrypt加密存储
- 个人信息在本地加密
- 网络传输使用HTTPS
- 定期数据备份和恢复

### 隐私保护
- 最小权限原则
- 数据脱敏处理
- 用户数据删除权利
- GDPR合规性检查

---

**文档版本**: v1.0  
**最后更新**: 2026年2月12日  
**维护者**: 开发团队