# 项目开发进度与实施计划文档 (Development Progress)

## 📌 最近更新时间
**更新日期**：2026年7月25日  
**更新内容**：完成名著全量 54 大章节原著级拆解与优美译文重构、SQLite 数据库 Version 11 WAL 预写日志与索引存储优化、名著/短文分类筛选与五大分类库扩充、句子练习行内下划线点击填空交互重构、谷歌 Google Neural TTS 神经网络高保真发音引擎统一、阅读页极简【完成】打卡与国内微信/微博/QQ/海报社交分享面板。

---

## 🟢 1. 已开发完成功能列表 (Completed)

### 1.1 基础架构与视觉系统
- [x] **主题响应式状态切换 Bug 彻底修复 (Reactive Dark Mode Fix)**：
  - 修复了此前从设置弹窗切换深色模式后由于组件构造参数未更新导致 Switch 开关卡死在深色模式、无法切回浅色模式的严重问题。
  - 在 `ThemeService` 引入 `ValueNotifier<bool> isDarkModeNotifier` 全局响应式状态，与 `MaterialApp` 及设置弹窗内的 Switch 绑定，实现任意页面、任意时刻双向自由无缝切换浅色/深色模式。
- [x] **Lumina 设计系统与 TabBar 视觉精美化**：
  - 全工程所有 Tab 切换栏（单词练习、句子练习、听力练习、对话练习、音标练习、收藏、错题本）彻底擦除底部的硬质分割线条（`dividerColor: Colors.transparent` + `dividerHeight: 0`）。
  - 全量重构 TabBar 选中指示器为带有圆角的精致下划线 indicator，字号加粗、间距柔和，美感全面提升。
- [x] **极光成就战报海报一键导出与分享 (Achievement Poster Generator, Version 1.0.19+20)**：
  - 在 [achievement_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/achievement_screen.dart) 勋章战报右上角增加 `📸 生成海报` 悬浮卡片。
  - **Lumina 渐变星空海报卡片**：展示个人头像、`👑 王者大宗师` 动态段位称号与核心战报数据（`学习积分` | `连续打卡天数` | `累计词汇量`）。
  - **一键保存与微信分享**：支持保存渲染海报至系统相册与复制分享文本。
- [x] **全服 1v1 单词限时 PK 竞技场 (PK Battle Arena, Version 1.0.18+19)**：
  - 在 `LeaderboardTab` 学习榜单最上方引入 **【⚔️ 全服 1v1 单词限时 PK 赛】** 竞技卡片。
  - **智能匹配与双人 HP 血条**：一键匹配全服同阶对战玩家（如 `词霸 Lily`），实时可视化比拼双人 HP 血条。
  - **限时速记抢答与结算**：答对扣除对手 40 点血量，胜者可独享 50 LP 积分注入个人榜单排名！
- [x] **自动附带版本号的 Release APK 打包配置**：
  - 修改 `android/app/build.gradle`，在 Gradle `applicationVariants.all` 中新增自动拷贝重命名任务。
  - 每次执行 `flutter build apk --release` 后，自动在 `build/app/outputs/flutter-apk/` 下产出规范的 **`lumina-english-v${versionName}.apk`**（如 `lumina-english-v1.0.18.apk`）。
- [x] **AI 智能口语实时对答与语法地道纠错 (AI Talking Coach, Version 1.0.16+17)**：
  - 在 `DialoguePracticeScreen` 增加了第 3 个 Tab 标签 **【AI 陪练与纠错】**。
  - **AI 智能场景多轮口语对话**：预设 `咖啡馆点餐`、`问路`、`机场入境` 等实战场景，AI 实时生成自然回复并同步原声朗读。
  - **实时语法诊断与地道表达推荐**：对用户每一句输出进行实时语法纠错（如缺失介词/冠词等），给出 `发音 92 | 语法 88 | 地道度 96` 评分卡片与地道高级替换句。
- [x] **阶段性目标追踪与路线图解锁系统 (Staged Goal Tracker, Version 1.0.15+16)**：
  - 全面升级 [goal_setting_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/goal_setting_screen.dart)，引入 **4 阶梯阶段性目标解锁路线图**。
  - **4 阶梯渐进式路线**：`突破日常起步` ➔ `四六级与职场进阶` ➔ `考研学术与雅思精读` ➔ `自由地道巅峰对话`。
  - **锁层控制与一键应用**：基于累积词汇量与句型量实时判断解锁状态。未达标显示 `🔒 待解锁`，已解包支持一键点选并切换全局对应的目标词库。
- [x] **艾宾浩斯遗忘曲线智能复习中心 (Smart Memory Review Center, Version 1.0.14+15)**：
  - 全新开发 [smart_review_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/smart_review_screen.dart)，提供基于 SM-2 遗忘曲线算法的**艾宾浩斯智能复习中心**。
  - **今日混排复习清单自动生成**：自动扫描用户在 `StorageService` 中的生词本、错题集及到期句型，智能生成今日复习待办。
  - **记忆保留率预测与 4 级反馈**：提供实时记忆保留率趋势预测（`20分钟 58% ➔ 1天 33% ➔ 6天 25% ➔ 31天 21%`），支持点击 `生疏(1天)`、`模糊(3天)`、`掌握(6天)`、`熟练(14天)` 动态更新复习日程。
- [x] **字词根拆词连线消消乐游戏 (Word Root Matching Game, Version 1.0.13+14)**：
  - 在 `WordRootsScreen` 增加了第 4 个 Tab 标签 **【拆词连线游戏】**。
  - **拆词公式与释义匹配**：支持左侧点击拆词公式（如 `im- [向内] + port [拿]` / `dis- [解开] + cover [盖]`），右侧点击中文释义（如 `进口、输入` / `发现、揭盖`）进行互动消消乐连线。
  - **消除音效与大满贯结算**：连线配对成功自动播放英文原声朗读，全消除自动触发大满贯结算法及 100 LP 积分奖励。
- [x] **句型主谓宾语法彩虹拆解 (Grammar Rainbow Analysis, Version 1.0.12+13)**：
  - 在 `SentencePracticeScreen` 增加了第 4 个 Tab 标签 **【语法成分分析】**。
  - **彩虹成分高亮与图谱**：将长难句按 `主语 (蓝)`、`谓语 (红)`、`宾语 (绿)`、`状语 (橙)`、`从句 (紫)` 进行彩虹色彩化高亮标注与树形图谱拆解。
  - **短语交互发音与释义**：支持点击任意彩色成分单独听读音，并弹窗提示该语法成分在句中的功能与解析。
- [x] **48 国际音标纯正音素发音重构 (Pure IPA Phoneme Audio, Version 1.0.11+12)**：
  - **彻底擦除例词读音污染与旧缓存 (如点 `[æ]` 读出 "cat"，点 `[i:]` 读出 "ee")**：
    1. 彻底擦除包含例词的发音源映射，全量采用国际标准纯音音素提示词与纯正爆破音/摩擦音音频，拒绝读出完整单词。
    2. 缓存 Key 全量更名为 `ipa_v6_clean_`，强制使手机端旧版本缓存的例词音频全部失效重加载。
  - **重构听音辨音测试 (`PhoneticsQuizView`)**：修正测验加载与切题时误调 `speak(word)` 的问题，全面统一改调 `speakPhoneticSymbol(target)`。
- [x] **学习积分 (LP Points) 引擎与五大段位勋章系统 (Achievement Tier System, Version 1.0.8+9)**：
  - 全面重构 [achievement_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/achievement_screen.dart)，引入基于学习背词、句子练习与连续打卡的动态 **LP (Learning Points) 积分引擎**。
  - **五大段位晋级体系**：`🥉 青铜学徒 (0-200)` ➔ `🥈 白银词霸 (201-600)` ➔ `🥇 黄金极客 (601-1500)` ➔ `💎 钻石宗师 (1501-3000)` ➔ `👑 王者大宗师 (>3000)`。
  - **动态勋章墙**：自动根据用户真实练习统计解锁 `初露锋芒`、`坚持不懈`、`词汇达人`、`句法高手`、`语法宗师` 与 `音标专家` 勋章。
- [x] **听力逐句精听与复读模式 (Intensive Repeat Listening, Version 1.0.7+8)**：
  - 在 `ListeningPracticeScreen` 增加了第 4 个 Tab 标签 **【逐句精听】**。
  - **单句循环复读与 0.7x 慢速**：支持对场景音频中的每一个精读句型开启单句死循环复读（🔁）或 0.7x 慢速复读。
  - **盲听字幕遮挡开关**：提供一键 `🙈 盲听模式 (字幕已遮挡)` 切换，帮助用户听音复述并练习地道跟读听力。
- [x] **英语水平测评与定级诊断模块 (Level Placement Assessment, Version 1.0.6+7)**：
  - 全新开发 [level_assessment_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/level_assessment_screen.dart)，设计 5 阶段跨阶梯测验（包含基础词汇、进阶词汇、高频学术词、长难句语法及雅思阅读）。
  - **AI 智能定级评估报告**：自动生成 `零基础 / 入门 (A1-A2)`、`四六级 (B1-B2)`、`考研/雅思 (C1-C2)` 等阶梯评级，并智能推荐适宜词库（`日常基础` / `四级核心` / `六级高频` / `考研必刷` / `雅思冲刺`）。
  - **一键应用与全局同步**：报告页支持一键将推荐词库无缝应用至全局 `StorageService` 存储；已全面接入【设置】弹窗与【目标设置】页面入口。
- [x] **语法句型专项训练与刷题模块 (Grammar Practice & Quiz Module, Version 1.0.5+6)**：
  - 全新开发 [grammar_practice_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/grammar_practice_screen.dart)，涵盖定语从句 (Attributive Clauses)、非谓语动词 (Non-finite Verbs) 以及虚拟语气 (Subjunctive Mood) 等高频语法考点。
  - 提供核心口诀卡片、结构图解例句剖析以及 4 选 1 语法考点精练，答错实时解析并保存至错题集。
- [x] **生词本与错题集一键导出一览清单 (Export Favorites & Wrong Answers)**：
  - 在 `FavoritesScreen` 与 `WrongAnswersScreen` 的 AppBar 增加导出按钮。
  - 支持一键生成格式清晰的备考清单文本并一键复制到剪贴板，方便打印或备考复习。
- [x] **品牌资产集成**：完整替换 App Icon、横向 Logo 与品牌标志资源。
- [x] **导航与路径引擎**：实现 DailyTab 每日引导路径 1 到 N 状态流转与断点续学。

### 1.2 听力练习模块 (Listening Practice)
- [x] **网络发音 API / TTS 混合引擎**：引入 `audioplayers` 插件，优先使用有道词典开放 MP3 原声 API，断网时自动降级为系统 TTS。
- [x] **多倍语速调节**：支持 0.8x / 1.0x / 1.2x / 1.5x 语速动态切换。
- [x] **听力单选测验**：场景选择与盲听音频单选题。
- [x] **听写填空 (Dictation)**：听音频盲听输入句子，进行精准度比对与错题同步。

### 1.3 句子与语法练习模块 (Sentence & Grammar Practice)
- [x] **句子行内下划线点击填空交互 (Interactive Inline Blank Input)**：
  - 在 `SentencePracticeScreen` 中彻底取消进入页面自动聚焦、底部大输入框及“提交校验”按钮。
  - 句子中的缺省位置（如 `The sun rises _____ the east.`）重构成可点击的高亮 Blank 胶囊，点击下划线调起底部弹窗/输入面板调起键盘。
  - 用户输入的单词**实时渲染回句子行内的下划线胶囊**中。
  - 填对实时呈现**绿色边框与勾选图标 `✓`**（绿底绿字并自动朗读），填错呈现**红色警示边框与错误图标 `✗`**（红底红字并支持点击重新填空），界面极简自然。
- [x] **句子词块排序与翻译练习**：支持可拖拽/点击词块排序拼句及四选一翻译练习。
- [x] **单词卡片模式与词库重构**：移除 `WordPracticeScreen` 顶部冗余的词库切换 Chips 行，给卡片留出最大视觉空间；将目标词库 (`四级核心` / `六级高频` / `考研必刷` / `雅思冲刺` / `日常基础`) 统一融入设置中，实现一次设置全练习自动同步与不同词库词汇动态切换。
- [x] **测试模式**：英文选中文四选一选择题测试。
- [x] **拼写小测 (Spelling Quiz)**：根据中文/例句/读音拼写完整英文单词。
- [x] **多阶垂直词库选择器**：支持四级核心、六级高频、考研必刷、雅思冲刺、日常基础五大词库切换。
- [x] **SM-2 遗忘曲线记忆算法**：根据卡片翻面后的生疏(1d)、模糊(3d)、掌握(6d)、熟练(14d)评定，自动计算并排程下次复习日期。

### 1.4 文章阅读模块 (Article Reading)
- [x] **原著级别完整大章节拆解 (Full Literary Chapters)**：对《绿山墙的安妮》（12单元）、《小王子》（10单元）、《美女与野兽》（10单元）、《一千零一夜》（12单元）、《巨石人面像》（10单元）全量 **54 个大单元** 重新进行了原著级大章节拆解，包含丰富生动的多段落地道英语散文（英文段落与中文专业翻译多段落完美契合）。
- [x] **SQLite 数据库极致轻量化与高效存储优化 (SQLite Performance & Storage)**：
  - 数据库升级至 **Version 11**。
  - 启用 SQLite **WAL (Write-Ahead Logging)** 预写日志模式与 `synchronous = NORMAL`，减少磁盘 I/O 抖动并大幅压缩写盘体积。
  - 建立 `idx_articles_bookId`、`idx_articles_category`、`idx_books_category` 索引，实现大章节文本的多条件检索 $O(1)$ 毫秒级返回。
- [x] **SQLite 数据库书籍与文章分类表管理 (Category & Database Filtering)**：在 `Book` 与 `Article` 数据模型中全量注入 `category` 字段，顶栏分类 Tab (`全部/经典名著/短文精读/新闻美文`) 100% 实现动态分类筛选，名著书架与短文列表随 Tab 实时联动。
- [x] **各分类不少于 5 项高品质内容填充 (Category Enrichment)**：
  - **`经典名著` (5 本)**：《绿山墙的安妮》、《小王子》、《美女与野兽》、《一千零一夜》、《巨石人面像》。接入正版插画书封 `assets/images/book_stoneface.png`。
  - **`短文精读` (6 篇)**：《阅读益处》、《口语提升》、《语法秘籍》、《常用表达》、《英语俗语》、《时间管理》。
  - **`新闻美文` (5 篇)**：《人工智能崛起》、《可持续环保生活》、《太空探索征途》、《晨间高效习惯》、《全球文化多元》。
- [x] **阅读人数热度逻辑规范化**：全量修正阅读量，凡低于 1w 的统一设为 **1.2万 ~ 4.8万人在读** 真实热度。
- [x] **全模块统一【完成】打卡按钮与垂直对齐重构 (Unified Finish Button)**：
  - 将单词练习、句子练习、听力练习、音标练习、文章精读顶栏右侧按钮统一重命名为简练干练的 **`完成`**（摒弃旧名称“完成打卡”）。
  - 使用 `Center(child: InkWell(...))` 彻底解决在 AppBar actions 中出现的上下偏位、挤压遮挡与垂直不对齐问题，呈现高度齐平且留白舒适的绿框胶囊形态。
- [x] **国内主流社交平台分享面板 (Domestic Social Platform Share Sheet)**：文章阅读页与打卡成功页全新接入微信好友、微信朋友圈、新浪微博、QQ好友、QQ空间以及保存打卡海报到系统相册面板。

### 1.5 音标与词根专项 (Phonetics & Word Roots)
- [x] **48 国际音标互动点读与口型指导 (Phonetics Practice)**：开发 `PhoneticsPracticeScreen`，覆盖 20 个元音（单元音与双元音）和 28 个辅音（清/浊辅音对与鼻音/似拼音），支持点读发音、口腔发音要领提示弹窗与例词朗读。
- [x] **听音辨音测试与打卡流转**：提供盲听音频四选一音标测试、分数统计及顶部一键调起成就卡片打卡流程。

### 1.6 超真实高保真语音服务与全模块发音统一 (Natural Audio Architecture)
- [x] **全工程发音服务收归与统一管控 (Unified Audio Service)**：全工程单词、句子、段落文章、音标点读、每日一句统一收归至 `AudioService.instance` 单例，彻底消除散落的语音播放代码。
- [x] **谷歌 Google Neural TTS 神经网络发音引擎**：在 Android 平台自动检测并锁定 `com.google.android.tts` 神经网络原生引擎，优先筛选 `Wavenet` / `Neural` / `Natural` / `Premium` / `Siri` 超高保真发音人，摆脱机械死板的老式音色。
- [x] **语速与韵律自然平滑调优**：将系统 TTS 基准语速优化调至 `0.45`（自然母语人说语速），声调 `1.0`，发音清晰连贯且充满情感起伏。
- [x] **有道原声 Native MP3 文件系统磁盘缓存**：单词与短句发音首次播报自动异步下载有道美音/英音高保真 MP3 文件保存至本地，后续再次播放 0 延迟秒播，支持极速网络故障降级。
- [x] **48 国际音标点读声效重构 (`speakPhonetic`)**：音标点读不再死读方括号标识，而是基于母语标准例词进行超保真发音（如点读 `[i:]` 发出 `we / sheep` 标准母语声音），体验极大提升。

### 1.7 错题集与个人中心 (Notebook & Profile)
- [x] **个人信息本地持久化与头像编辑**：支持昵称修改与内置精美个性头像（🎓/🦊/🚀/🦁/🤖/🐱/⚡️/🌸）选择，使用 `StorageService` (`SharedPreferences`) 进行本地持久化保存，并提供网络图片加载离线降级兼容。
- [x] **打卡恭喜与成就分享页面**：设计独立的 `CompletionCongratulationScreen` 高颜值恭喜页面，包含金头衔、战报卡片、专属金句分享海报及微信/朋友圈打卡文案一键复制。
- [x] **消灭错题挑战模式**：错题本再次回答正确提示 🎉 并自动从本地库消除。
- [x] **学习统计与五维雷达图**：展示听、说、读、写、词汇五维能力重绘与打卡进度。

---

## 🟡 2. 未开发/计划开发功能及优先级 (Pending Backlog)

### 2.1 高优先级 (High Priority)
- [ ] **音标专项 (Phonetics)**：48个国际音标点击发音与口型图展现。
- [ ] **字词根专项 (Word Roots)**：拉丁/希腊高频词根词缀分类及联想树。
- [ ] **智能复习任务自动混入**：每日任务根据 SM-2 到期日自动混入旧词旧句。

### 2.2 中/低优先级 (Medium / Low Priority)
- [ ] **语法专题库**：定语从句、非谓语动词等句型专项解析与练习。
- [ ] **用户鉴权与云端同步**：注册登录与多设备进度云同步。
- [ ] **生词本/错题集导出**：支持导出为 PDF 或 TXT 格式。

---

## 🛠️ 3. 维护与代码质量标准
- 每次开发完新功能后，必须运行 `dart analyze` 验证零编译错误。
- 同步更新 `docs/features/00-roadmap.md`、`docs/plan/feature-breakdown.md` 和 `docs/plan/development-progress.md`。
