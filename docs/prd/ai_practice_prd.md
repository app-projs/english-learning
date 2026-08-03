# AI 智能英语练习模块 (AI Practice Module) 产品需求文档 (PRD)

---

## 📄 文档信息
- **文档名称**：AI 智能英语练习模块产品需求文档
- **版本号**：v1.0.0
- **撰写时间**：2026年8月3日
- **目标应用**：Lumina English App
- **状态**：已评审待开发

---

## 🎯 1. 产品背景与目标

### 1.1 痛点分析
传统的英语学习软件普遍存在“哑巴英语”与“单向练习”的硬伤：
- 练习方式单一（背单词、看文章、单向听力），缺乏真实的对话场景。
- 口语表达缺乏实时反馈，用户无法得知语法错误、发音问题以及如何用更地道的英文表达（Native Rephrasing）。
- 寻找外教对话成本高昂且用户容易产生社恐心理。

### 1.2 核心目标
设计并研发 **AI 智能英语练习模块（AI Practice Module）**，作为 App 底部 Dock 菜单的正中间核心入口，为用户提供 24/7 随时可用的 AI 智能口语教练：
1. **沉浸式场景角色扮演 (AI Role-Play Dialogue)**：涵盖职场面试、机场出行、咖啡馆点餐、日常社交等真实场景。
2. **实时语法与地道表达诊断 (AI Grammar & Native Evaluation)**：对用户的每句输入提供多维度评级（语法准确度、词汇丰富度、地道改写建议）。
3. **AI 智能跟读与跟读声调测验 (AI Shadowing & Intonation)**：搭配微软 Edge 神经网络 Voice 生成原生听力并支持跟读。
4. **即时无压力互动体验**：提供一键生成推荐回复（AI Hints）、语音/文本双模输入、地道表达卡片。

---

## 🧩 2. 核心功能与模块设计

### 2.1 入口位置
- **App 底部导航栏正中央（Index = 2）**，具备突出高亮的 AI 专属 Icon 徽章与渐变视觉，吸引用户点击练习。

---

### 2.2 功能模块一：AI 场景角色扮演对话 (AI Role-Play Scenarios)
提供丰富多彩的日常与商务场景，用户选择场景后即可与 AI 展开对话。

| 场景分类 | 示例场景 | AI 角色 | 目标技能 |
| :--- | :--- | :--- | :--- |
| **日常生活 (Daily Life)** | ☕ 咖啡馆点餐 (Ordering Coffee) | Cafe Barista | 常用礼貌用语、食品名称 |
| **出行旅游 (Travel)** | ✈️ 机场过关与登机 (Airport Check-in) | Custom Officer | 航班、托运、海关问答 |
| **职场商务 (Career)** | 💼 英文求职面试 (Job Interview) | HR Interviewer | 职业背景表达、行为面试问答 |
| **自由交流 (Free Chat)** | 🌟 AI 自由聊天伙伴 (Free Oral Assistant) | Friend / Mentor | 任意话题自由交流 |

#### 交互细节：
- 每一轮对话中，AI 自动回应文本并支持**一键播放标准美音/英音**。
- 用户发送消息后，AI **自动在后台进行语法与地道表达分析**，并在消息卡片下方展开“AI 智能分析”点赞/诊断折叠板。
- 提供【💡 推荐回复 (AI Hints)】按钮：针对当前对话，AI 提示 3 个参考回复方案，降低开口难度。

---

### 2.3 功能模块二：AI 实时语法与地道表达评估 (AI Sentence Diagnosis)
每次用户输入后，AI 从三个维度进行即时评估与批改：

1. **语法准确度 (Grammar Accuracy Score)**：打分 0~100 分。
2. **错误修正 (Corrections)**：精确定位语法错误（如主谓不一致、时态错用、介词误用）。
3. **地道表达建议 (Native Rephrasing)**：提供标准的 Native Speaker 地道替换句型。

---

### 2.4 功能模块三：AI 智能跟读与打分 (AI Shadowing Practice)
针对 AI 发出的精选金句，支持用户点击【🎙️ 跟读练习】：
- 系统播放神经网络高保真发音。
- 用户录音/输入后，AI 对比跟读匹配度并给出打分及音标提示。

---

## 🎨 3. 页面 UI/UX 架构

### 3.1 AI 练习主主页 (`AiPracticeTab`)
1. **顶部 Header**：
   - 展现“AI 口语教练”高科技感渐变 Banner。
   - 呈现累计练习对话数、今日口语评分、连续练习天数。
2. **AI 模式切换 Tab**：
   - 【🎭 场景对话】 / 【💡 自由打卡】 / 【🎙️ 口语跟读】
3. **场景卡片网格 (Bento Grid)**：
   - 展现各场景图标、难度标签（如 A2/B1/B2）、练习人数及“开始对话”按钮。

### 3.2 AI 对话交互界面 (`AiChatScreen`)
1. **顶栏**：显示当前 AI 角色身份（如 “Barista Alex”）、场景目标进度。
2. **对话流 (Chat ListView)**：
   - AI 气泡：支持播放朗读、切换中文翻译。
   - 用户气泡：附带 AI 智能评估 Badge（如 “98分 · 完美” 或 “85分 · 提示小改进”）。
3. **底栏输入区**：
   - 文本输入框 + 发送按钮。
   - 语音输入唤起键 + 提示建议词条（AI Hints）。

---

## 🏗️ 4. 技术架构与数据设计

### 4.1 数据库结构 (`ai_practice` 扩展)
SQLite 中新增 `ai_chat_history` 与 `ai_scenarios` 表：

```sql
CREATE TABLE IF NOT EXISTS ai_scenarios (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  chinese_title TEXT NOT NULL,
  ai_role TEXT NOT NULL,
  avatar_icon TEXT,
  difficulty TEXT,
  category TEXT,
  system_prompt TEXT,
  initial_greeting TEXT
);

CREATE TABLE IF NOT EXISTS ai_chat_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scenario_id TEXT NOT NULL,
  sender TEXT NOT NULL, -- 'ai' or 'user'
  message TEXT NOT NULL,
  translation TEXT,
  grammar_score INTEGER,
  corrections TEXT,
  native_suggestion TEXT,
  created_at INTEGER
);
```

### 4.2 AI 智能服务引擎 (`AiPracticeService`)
- 内置经典口语场景库模型与 Mock AI 智能诊断引擎（支持根据语法规则进行错误检测与 Native 改写）。
- 可配置预置接口与响应策略，支持未来透明升级为大语言模型 (LLM) WebSocket API 实时流式响应。

---

## 🚀 5. 验收标准 (Acceptance Criteria)

1. **导航栏改造**：
   - App 底部 Dock **顶部去除圆角**（平直顶边框），视觉效果干练。
   - **最中间（Index = 2）** 成功加入 AI 练习模块，带有专属 Icon 和高亮标记。
2. **AI 练习主页**：
   - 能够平滑展现 4 大常用 AI 角色扮演场景与自由对话卡片。
3. **对话交互**：
   - 点击场景可进入沉浸式 AI 对话页面，能实时收发消息、播放神经网络发音、展现语法评估与 Native 表达建议。
4. **编译与代码质量**：
   - `flutter analyze` 0 报错。
   - `flutter build apk --release` 成功通过。
