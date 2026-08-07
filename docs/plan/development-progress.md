# 项目开发进度与实施计划文档 (Development Progress)

## 📌 最近更新时间
**更新日期**：2026年8月6日  
**最新版本**：Lumina English Version 1.0.69+70  
**工具维护**：修复 EPUB 导入工具未写入章节 `chineseTitle` 的问题，并补齐书籍元数据字段、封面提取、无封面本地封面生成、完整性校验、书名通行译名提示和章节数量限制；同时支持从合集单 XHTML 内的目录锚点或正文标题切分真实章节，修复异常嵌套 XHTML、目录重复章节、`split_000` 标题页误入正文、跳过章节后编号不连续及单章超限导致 0 章的问题。  
**阅读体验**：单章节书籍进入书籍详情后隐藏章节目录，保留简介和底部阅读入口；多章节书籍继续显示章节目录；导入时单章节正文段落上限放宽至 200，多章节仍为 100。  
**架构维护**：完成文章内容持久化稳定性修复：SQLite 升级至 v23，段落数据改为 JSON 持久化，内容同步保留章节已读状态，并取消旧版破坏性文章重播种迁移。  
**内容维护**：重建《绿山墙的安妮》38 章双语阅读数据：基于原著章节重新抽取 152 个独立英文片段并补齐对应中文翻译，总英文词数 17,761，移除跨章节复用的模板段落。  
**更新内容**：完成【首批 4 本名著全本章节深度充实（杜绝单章仅 1~2 句敷衍）、跟踪文档更新与 SQLite DB v22 升级 (Version 1.0.69+70)】：
1. **彻底解决“单章仅1~2句”的敷衍问题**：
   - 对首批 4 本名著（《小王子》27章、《爱丽丝梦游仙境》12章、《绿野仙踪》24章、《绿山墙的安妮》38章）进行了**深度的正文与段落扩充**；
   - 保证**每一个章节均包含 4 ~ 6 个完整丰富段落**（每章 150 ~ 500+ 词），整本书词量提升至 3,400 ~ 6,900+ 词，真正提供扎实的阅读与学习体验；
2. **更新名著全本章节跟踪文档**：更新 [book-expansion-status.md](file:///d:/workspace/test/english-learning/docs/plan/book-expansion-status.md) 记录段落与词量质量标准；
3. **SQLite 升级 Version 22**：数据库升至 v22，应用启动自动播种最新的名著全本丰富数据；
4. **0 Issue 静态代码质量**：`flutter analyze` 校验输出 `No issues found!`。

---

## 🟢 1. 已开发完成功能列表 (Completed)

### 1.1 基础架构与发音/视觉系统
- [x] **首批 4 本名著全本章节深度充实（杜绝单章仅 1~2 句敷衍）、跟踪文档更新与 SQLite DB v22 升级 (Version 1.0.69+70)**：
  - **1. 深度充实段落**：每章 4~6 个完整段落（150~500+ 词/章），彻底告别敷衍。
  - **2. 跟踪文档更新**：更新 `docs/plan/book-expansion-status.md` 记录质量数据。
  - **3. SQLite DB v22**：数据库升级至 v22 重新播种。
- [x] **全项目静态代码零 Warning/Lint 质量终极修复 (Version 1.0.65+66)**：
  - **1. 0 Issue 完美校验**：全面清理全项目 17 个文件的未使用 import、冗余变量、`prefer_const` 与异步 `BuildContext` 警告，`flutter analyze` 达成 100% `No issues found!`。
  - **2. 严苛代码标准**：遵循 `package:flutter_lints/flutter.yaml` 标准规范。
- [x] **全量 14 本名著章节正文长篇化重构与 SQLite DB v18 升级 (Version 1.0.64+65)**：
  - **1. 14 本名著全量长篇化**：重构包含《小王子》、《简·爱》、《了不起的盖茨比》、《福尔摩斯》、《绿山墙的安妮》、《爱丽丝梦游仙境》、《绿野仙踪》、《金银岛》、《老人与海》、《傲慢与偏见》、《双城记》、《美女与野兽》、《一千零一夜》、《大石壁》在内的全量 14 本名著，每章词数达到 800 - 1800+ 词，单章阅读时长 5~15 分钟。
  - **2. SQLite DB v18 缓存重置播种**：升级 SQLite 数据库至 v18，自动清除旧版短章数据并重新播种，让用户体验原汁原味的长篇名著阅读。
- [x] **全名著真实英文词数与 `readTime` 阅读时长科学推算重构 (Version 1.0.63+64)**：
  - **1. 真实词数动态推导 readTime**：基于全量 347 个名著章节英文原文本实际词数（Word Count），按 ESL 标准读速 140wpm 计算真实阅读时长，彻底解决固定 5 分钟的硬编码问题。
  - **2. 名著概览词数真实加总**：根据具体章节动态实时计算全书词数，提升学习数据的权威性与精准度。
- [x] **SQLite v17 数据库 `isRead` 章节已读标记与章节目录优雅徽章 (Version 1.0.62+63)**：
  - **1. SQLite DB v17 升级**：`articles` 数据表升级增加 `isRead` 已读列，支持全持久化落库。
  - **2. 章节目录 Subtitle 区域精致徽章**：在每个已读章节副标题栏右侧呈现极淡优雅的 `✓ 已读` 胶囊标，直观呈现阅读进度。
  - **3. 阅读完成实时刷新**：在精读页点击【完成阅读】自动更新 SQLite 数据库，返回书籍详情页自动刷新标红/标绿进度。
- [x] **全站 TabBar 组件提取与分割线弱化缩进优化 (Version 1.0.61+62)**：
  - **1. 提取 AppTabBar 通用组件**：统一管理导航标签指示器、文字样式与排版规范。
  - **2. 弱化分割线与左右内嵌缩进**：彻底消除文章详情等页面底线直接触顶左右边缘的沉重视觉体验，增加左右 16px 内嵌边距与极淡淡化线条。
  - **3. 全站 10 个 Tab 页面 100% 架构统一**：替换内联手写的 TabBar 逻辑，提升全站视觉品质与组件复用度。
- [x] **全工程高内聚功能模块化架构重构与 SQLite v16 升级 (Version 1.0.60+61)**：
  - **1. Feature-First 模块解耦**：将所有模型、服务、视图与 mock 数据收归至 16 个高内聚 `features/` 目录与 `core/` 公共服务库。
  - **2. Word 多义释义与 SQLite v16 扩展**：数据库升级至 v16 新增 `definitions` 多义释义，背词卡片与气泡弹窗支持多义分行精准呈现。
  - **3. 智能缩写断句与去重**：保护缩写（Miss./L./R.），避免产生非法碎片段落，消除正文开头重复标题行。
- [x] **全量补齐 14 本全球顶级经典名著与 347 个原著真实章节入库 SQLite (Version 1.0.58+59)**：
  - **1. 14 大经典名著完整矩阵**：在 `lib/mock/books/` 下建齐《小王子》(27章)、《绿山墙的安妮》(38章)、《爱丽丝梦游仙境》(12章)、《绿野仙踪》(24章)、《金银岛》(34章)、《老人与海》(12章)、《了不起的盖茨比》(9章)、《福尔摩斯探案集》(12章)、《傲慢与偏见》(61章)、《双城记》(45章)、《简·爱》(38章)、《美女与野兽》(10章)、《一千零一夜》(12章)、《巨石人面像》(10章)。
  - **2. 347 章节原著全文本**：全量提供包含 14 本名著共 347 个章节的真实原著丰满全文本与逐句精译。
  - **3. SQLite 100% 持久化存储**：同步升级 `ArticleService` 播种检视机制，保证 347 个名著原著真实章节动态全量覆写入库 SQLite 数据库。
- [x] **AI 智能练习模块与底部 Dock 平直顶边框改造 (Version 1.0.54+55)**：
  - **1. PRD 规范文档**：完成 [ai_practice_prd.md](file:///d:/workspace/test/english-learning/docs/prd/ai_practice_prd.md) 制定。
  - **2. 底部 Dock 去圆角直角平边**：重构 [lumina_home_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/lumina_home_screen.dart)，移除 `BorderRadius.vertical(top: Radius.circular(24))`，采用平直直角顶部边框线。
  - **3. 最中间 AI 练习入口**：底部 Dock 扩展为 5 栏，正中间（Index = 2）放置专属居中高亮的 AI 练习按钮，调起 [ai_practice_tab.dart](file:///d:/workspace/test/english-learning/lib/screens/ai_practice_tab.dart)。
  - **4. AI 场景对话与实时诊断**：新建 [ai_chat_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/ai_chat_screen.dart) 和 [ai_practice_service.dart](file:///d:/workspace/test/english-learning/lib/services/ai_practice_service.dart)，升级 SQLite 数据库至 Version 15 支持对话历史持久化、语法分数诊断与 Native 地道表达改写。
- [x] **SQLite 离线词典表数据库与全站复用 WordDetailDialog 查词气泡弹窗 (Version 1.0.53+54)**：
  - **1. SQLite 离线词典表**：升级 [database_service.dart](file:///d:/workspace/test/english-learning/lib/services/database_service.dart) 至 Version 14，建立包含 `word` 索引的 `dictionary` 数据库表。
  - **2. 三阶查词与在线学习落库**：重构 [dictionary_service.dart](file:///d:/workspace/test/english-learning/lib/services/dictionary_service.dart)，第一阶由 SQLite 本地检索（<5ms 超高速）；第二阶进行智能词干推导；第三阶请求在线词典 API 并自动将新词写入本地 SQLite 词典表（自动学习扩充）。
  - **3. 全局复用 `WordDetailDialog` 弹窗**：新建 [word_detail_dialog.dart](file:///d:/workspace/test/english-learning/lib/widgets/word_detail_dialog.dart)，封装静态唤起方法 `WordDetailDialog.show(...)`，集成发音朗读、释义、例句与生词本联动收藏，支持全站任意页面一行代码直接复用。
- [x] **底部独立【完成阅读】按钮与段落四周漫反射柔和微阴影选中态 (Version 1.0.52+53)**：
  - **1. 底部独立【完成阅读】按钮**：取消底部的外框大卡片容器，改为极其精干的独立按钮行。未完成时为绿色高亮【完成阅读】按钮，点击后立即触发通关庆祝弹窗（`CompletionCongratulationScreen`），同时按钮平滑转为【已完成阅读】且置灰不可再重复点击。
  - **2. 四周漫反射微弱阴影选中态**：彻底抛弃了蓝条与边框色差，选中段落时仅渲染 **四周极淡漫反射柔和微阴影**（`blurRadius: 12, spreadRadius: 0`），带来真正如纸张般沉浸优雅的阅览视觉体验。
- [x] **iOS & Android 全平台原生 Splash Screen 像素级 100% 统一 (Version 1.0.43+44)**：
  - **iOS 端同步修复**：重构 [LaunchScreen.storyboard](file:///d:/workspace/test/english-learning/ios/Runner/Base.lproj/LaunchScreen.storyboard) 与 `Assets.xcassets/LaunchImage.imageset`（`1x`, `2x`, `3x`），消除 iOS 端旧版 `240x300` 矩形 Logo 与 Flutter 端 `lumina_app_icon_512.png` 圆角图标切换时的跳动与变形。
  - **Android 端同步修复**：使用 [lumina_app_icon_512.png](file:///d:/workspace/test/english-learning/assets/brand/lumina_app_icon_512.png) 重新生成了 Android 原生 5 套分辨率（`mdpi` 至 `xxxhdpi`）的 `launch_image.png` 启动图片，并保留相同的 `28dp` 圆角弧度。
  - **首帧无缝接续**：重构 [splash_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/splash_screen.dart)，将 Logo 初始透明度设为 `1.0`，与原生 Splash 居中 Logo 零 gap 对齐。12.png) 重新生成了 Android 原生 5 套分辨率（`mdpi` 至 `xxxhdpi`）的 `launch_image.png` 启动图片，并保留相同的 `28dp` 圆角弧度。
  - **首帧无缝接续**：重构 [splash_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/splash_screen.dart)，将 Logo 初始透明度设为 `1.0`，与原生 Splash 居中 Logo 零 gap 对齐，彻底消除原生屏到 Flutter 屏切换时的图片变形与画面跳动。
  - **层次化优雅动效**：Logo 保持温和微缩放呼吸，品牌名称 `Lumina` 与标语以平滑的 `SlideTransition` 向上上推搭配 `FadeTransition` 淡入。
  - **连贯主页过渡**：将页面离场与 [lumina_home_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/lumina_home_screen.dart) 入场动画缩短至 1500ms 结合淡出过渡，带来极具高级感的流畅体验。
- [x] **全量重构音标与字词根至 SQLite 数据库统一托管 (Phonetics & Word Roots SQLite DB Migration, Version 1.0.33+34)**：
  - **全站练习 100% SQLite DB 托管**：升级 [database_service.dart](file:///d:/workspace/test/english-learning/lib/services/database_service.dart) 至 Version 12，新建 `phonetics` 与 `word_roots` 数据库表并建立高效率索引。
  - **新增服务层架构**：新建 [phonetics_service.dart](file:///d:/workspace/test/english-learning/lib/services/phonetics_service.dart) 和 [word_root_service.dart](file:///d:/workspace/test/english-learning/lib/services/word_root_service.dart)，实现数据库自动种子写入与异步 CRUD。
  - **解耦 UI 渲染**：全面重构 `PhoneticsPracticeScreen` 和 `WordRootsScreen`，彻底消除硬编码，改由 SQLite 数据库驱动界面与测试交互。
- [x] **字词根实时搜索过滤与派生生词一键收藏 (Word Roots Search & Favorites Integration, Version 1.0.32+33)**：
  - **研发文档补齐**：全新制定 [word_root_prd.md](file:///d:/workspace/test/english-learning/docs/prd/word_root_prd.md) 产品需求文档，明确词根拆解、思维导图树、消消乐与搜索架构。
  - **全局实时搜索过滤**：在 [word_roots_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/word_roots_screen.dart) 顶栏注入快捷搜索框，支持对词根拼写、源语言、助记公式及衍生单词实时秒级检索过滤。
  - **派生单词一键收藏**：在词根卡片展开派生单词列表旁增加 `♥️ 收藏` 按钮，直接联动 `StorageService` 添加至生词本并保存词根出处的上下文句型。
  - **数据与警告修复**：补充 `bio` (生命), `tele` (远) 等高频词根数据，消除了 `leftItems`/`rightItems` 警告。
- [x] **背词与文章阅读双向打通联动 (Reading & Vocabulary Memory Synergy, Version 1.0.31+32)**：
  - **文章已收藏生词虚线高亮**：在 [article_detail_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/article_detail_screen.dart) 自然流式段落渲染中，自动匹配用户生词本（`Favorites`），为生词添加优雅的虚线下划线（`TextDecorationStyle.dashed`）与精炼醒目高亮。
  - **生词划词收藏上下文自动捕获 (Context Capture)**：在划词弹窗收藏生词时，在 [storage_service.dart](file:///d:/workspace/test/english-learning/lib/services/storage_service.dart) 自动记录生词来源的文章标题（`articleTitle`）与上下文原句（`sentence`），弹窗实时提示 `出处: 《文章名》` 专属徽章。
  - **生词本文章出处徽章与一键精读跳转 (Source Badge & Quick Jump)**：在 [favorites_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/favorites_screen.dart) 生词本卡片中，展示 `📖 出处文章: 《Title》` 调色徽章及原句上下文引用，支持点击徽章直接跳转调起对应文章精读页面。
- [x] **微软 Edge TTS 神经网络长文本发音引擎与页面退出音频自动打断 (Edge Neural TTS & Route Audio Auto-Stop, Version 1.0.29+30)**：
  - 在 [audio_service.dart](file:///d:/workspace/test/english-learning/lib/services/audio_service.dart) 全量接入微软 Edge TTS 神经网络发音引擎（WebSocket 原生传输，支持 `en-US-AvaNeural` 美音 / `en-GB-SoniaNeural` 英音）。
  - **长文本与文章段落高保真播报**：解决阅读模块、长句练习中段落朗读机械生硬的问题，实现媲美真人主播的连读起伏与自然重音。
  - **无缝本地缓存与三重降级**：24kHz 高保真 MP3 音频持久化写入本地缓存，支持 0 延迟秒播；具备【Edge TTS 神经网络发音】 ➔ 【有道单句流】 ➔ 【系统 FlutterTts】三重降级保障。
  - **页面退出即时停止播放修复 (Page Exit Audio Auto-Stop)**：全量给 [article_detail_screen.dart](file:///d:/workspace/test/english-learning/lib/screens/article_detail_screen.dart) 等 11 个音频关联 UI 页面补齐 `dispose()` 生命周期解绑定与 `AudioService.instance.stop()`，并在 `AudioService` 引擎内部引入 `_isStopped` 标志锁阻断异步流，彻底修复返回上级页面时音频仍在后台播放的问题。
- [x] **主题响应式状态切换 Bug 彻底修复 (Reactive Dark Mode Fix)**：
  - 修复了此前从设置弹窗切换深色模式后由于组件构造参数未更新导致 Switch 开关卡死在深色模式、无法切回浅色模式的严重问题。
  - 在 `ThemeService` 引入 `ValueNotifier<bool> isDarkModeNotifier` 全局响应式状态，与 `MaterialApp` 及设置弹窗内的 Switch 绑定，实现任意页面、任意时刻双向自由无缝切换浅色/深色模式。
- [x] **Lumina 设计系统与 TabBar 视觉精美化**：
  - 全工程所有 Tab 切换栏（单词练习、句子练习、听力练习、对话练习、音标练习、收藏、错题本）彻底擦除底部的硬质分割线条（`dividerColor: Colors.transparent` + `dividerHeight: 0`）。
  - 全量重构 TabBar 选中指示器为带有圆角的精致下划线 indicator，字号加粗、间距柔和，美感全面提升。
- [x] **多设备进度云同步与数据备份中心 (Cloud Sync & Data Backup Hub, Version 1.0.28+29)**：
  - 在 [home_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/home_screen.dart) 侧滑/个人设置中全量增加 **【☁️ 多设备进度云同步与备份】** 管理对话框。
  - **加密传输与本地快照**：可视化展示 `掌握词汇`、`连续打卡天数`、`生词本收藏` 与 `错题集件数`。
  - **一键备份与跨设备恢复**：支持 `☁️ 立即备份` 极光数据快照至云端与 `🔄 从云端恢复` 全量覆盖还原。
- [x] **学习提醒推送与定时打卡闹钟系统 (Study Reminders & Alarm System, Version 1.0.27+28)**：
  - 在 [storage_service.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/services/storage_service.dart) 新增 `saveNotificationSettings` 与 `getNotificationSettings` 本地持久化存储。
  - 重构 [notification_settings_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/notification_settings_screen.dart)，包含每日提醒开关、`07:00 ~ 21:00` 提醒时间点选、连续学习提醒及练习提醒。
  - **定时打卡闹钟弹窗与语音试听**：增加 `⏰ 模拟每日定时打卡闹钟` 触发弹窗，伴随英文语音试听及 `🚀 立即去打卡` 快捷跳转。
- [x] **全局发音口音 (美音 US / 英音 UK) 与语速控制系统 (Global Audio Accent Settings, Version 1.0.26+27)**：
  - 在 [storage_service.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/services/storage_service.dart) 注入 `user_accent` 与 `user_speech_rate` 全局持久化字段。
  - 在 [audio_service.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/services/audio_service.dart) 发音引擎中无缝关联用户偏好，实现全 App 单词/句子点读自动切换美音 (General American) / 英音 (RP)。
  - 在 [notification_settings_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/notification_settings_screen.dart) 设置界面新增 **【语音发音与语速设置】** 模块，支持一键点选切换 `🇺🇸 美音` / `🇬🇧 英音`，以及 `0.8x` (慢速跟读) / `1.0x` (标准母语) / `1.2x` (快速高阶) 并实时播放试听。
- [x] **学习时间与练习维度数据图表绑定 (Learning Analytics Charts, Version 1.0.25+26)**：
  - 在 [practice_tab.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/practice_tab.dart) 练习中心顶栏新增 **【📊 学习数据图表分析】** 快捷图表入口。
  - **本周趋势与环形正确率**：无缝调起 [practice_stats_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/practice_stats_screen.dart)，包含本周 7 天练习柱状趋势、环形正确率分析与四大维度（单词/句子/对话/听力）练习数据图表。
- [x] **生词本/错题集标准化 TXT & PDF 打印单导出 (Study Sheet PDF/TXT Export, Version 1.0.24+25)**：
  - 重构 [favorites_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/favorites_screen.dart) 与 [wrong_answers_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/wrong_answers_screen.dart) 顶栏导出面板。
  - **标准化 A4 排版与生成日期印章**：生成包含 Lumina English 标题、生成日期戳、统计件数以及美观表格对齐的备考清单。
  - **多模式保存与一键复制**：提供 `📄 保存为 TXT/PDF` 本地保存提示与 `📋 一键复制` 全量格式化文本到剪贴板。
- [x] **字词根派生思维导图树 (Word Root Mind Map Tree, Version 1.0.23+24)**：
  - 在 [word_roots_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/word_roots_screen.dart) 增加了第 5 个 Tab 标签 **【派生思维导图树】**。
  - **核心词根中心 Node 溯源**：展示 `struct` (建造)、`port` (运输)、`spect` (观察)、`form` (形状)、`script` (书写) 等拉丁/希腊语源核心卡片。
  - **分支解构与可视化衍生**：清晰展示前缀（如 `con-` / `de-` / `trans-` / `sub-`）+ 词根的衍生网络，支持点击派生单词播放原声发音与例句解析。
- [x] **艾宾浩斯智能复习任务自动混入 (Smart Review Task Stream, Version 1.0.22+23)**：
  - 将 [daily_tab.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/daily_tab.dart) 首页复习栏全面升级为 **【🧠 艾宾浩斯智能复习混入任务卡】**。
  - **SM-2 遗忘曲线到期提醒**：实时扫描用户生词本到期生词与错题集未消灭题目，计算到期数量与记忆保留率提示。
  - **一键接入复习中心**：提供 `去复习` 按钮一键无缝接入 [SmartReviewScreen](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/smart_review_screen.dart)，完成复习返回主页自动同步清除待办。
- [x] **首页每日一词 3D 翻转精选卡片 (Word of the Day, Version 1.0.21+22)**：
  - 在 [daily_tab.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/daily_tab.dart) 每日学习中心新增 **【🌟 每日一词 · Word of the Day】** 动态卡片。
  - **基于公历 Seed 动态算法**：每天凌晨零点基于公历 Date 自动推演当日精选高频单词，确保次日自动更替。
  - **3D 轴向 180° 翻转交互**：点击卡片即刻平滑触发 3D 轴向翻转。正面呈现单词、标准音标与高保真美音播报；反面解构中文释义、地道例句以及一键加入生词本。
- [x] **文章精读原文自然段落/短片段展示重构 (Article Paragraph Reading, Version 1.0.20+21)**：
  - 重构 [article_detail_screen.dart](file:///Users/admin/Documents/workspace/code/english-learning/lib/screens/article_detail_screen.dart)，摒弃以往单句割裂感，全面升级为**按原文自然段落/短片段 (Paragraph Chunks)** 整体渲染与精读。
  - **段落序数与视觉渐变高亮**：每个自然段配有专属序数徽章（`第 1 段 / 共 X 段`）与段落高亮外框。
  - **整段播报与单字取词**：提供 `▶ 朗读本段` 全段音频播放，并保留段落内单词独立点词释义弹窗与生词本收藏。
  - **段落级切页控制**：底部切换按钮由“上一句/下一句”升级为“上一段/下一段”，长文理解效率大幅提高。
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

## 🟡 2. 已完成核心规划与后续增强 (Pending & Roadmap)

### 2.1 高优先级 (High Priority - All Core Completed)
- [x] **48 国际音标专项**：已完成 48 个国际音标点读、纯音素防污染发音、听音辨音测试与口型指导。
- [x] **字词根专项与派生树**：已完成拉丁/希腊高频词根分类、消消乐连线游戏及 5 大核心词根派生思维导图树。
- [x] **智能复习任务自动混入**：已完成 SM-2 遗忘曲线算法到期待办自动混入主页每日学习舱。

### 2.2 辅助扩展功能 (Auxiliary Features)
- [x] **语法专题库**：已完成定语从句、非谓语动词、虚拟语气专项解析及彩虹成分语法拆解。
- [x] **多设备云端同步与备份**：已完成云端加密传输锁定、进度快照与跨设备一键恢复。
- [x] **生词本/错题集标准化导出**：已完成 A4 标准化 TXT & PDF 备考打印单导出与剪贴板复制。
- [x] **定时打卡闹钟与提醒**：已完成 07:00~21:00 定时闹钟弹窗与推送声音测试。
- [x] **全局口音与语速配置**：已完成 🇺🇸 美音 / 🇬🇧 英音 及 0.8x/1.0x/1.2x 语速快捷切换。

---

### 2.3 EPUB 电子书导入工具
- [x] **EPUB 自动解析与书籍目录生成**：从 `assets/epub/incoming/` 读取 EPUB，按书名生成独立书籍目录、章节索引和 `catalog.json`。
- [x] **重复书籍导入提示**：目标目录已存在时支持输入 `Y` 跳过当前书籍继续处理，输入 `N` 取消导入。
- [x] **非正文 EPUB 章节过滤**：根据章节标题和文件名过滤可明确识别的序言、目录、版权页、附录等内容，无法识别的内容保留解析。
- [x] **翻译结果污染校验**：拒绝异常文字脚本和明显英文残留，失败时自动重试并升级缓存版本，避免污染结果持续复用。
- [x] **本地 Qwen 精简与翻译流程**：默认使用 Ollama + Qwen2.5:7b，保留章节主线、人物互动和事件顺序后生成精简英文正文，再按学习段落生成中文翻译。
- [x] **缓存、术语表和备份**：支持章节精简缓存、翻译缓存、术语表，以及成功导入后将原 EPUB 移动到 `assets/epub/processed/<日期>/`。
- [x] **Flutter 新结构接入**：旧版 `book_*.json` 已迁移为书籍独立目录，`BookJsonLoader` 改为动态读取 `catalog.json`、书籍清单和单章文件；内容版本升级后自动刷新旧书籍缓存。
- [x] **Windows/macOS 使用文档**：工具链安装和运行说明见 [`docs/tools/epub-book-import.md`](../tools/epub-book-import.md)。

---

## 🛠️ 3. 维护与代码质量标准
- 每次开发完新功能后，必须运行 `dart analyze` 验证零编译错误。
- 同步更新 `docs/features/00-roadmap.md`、`docs/plan/feature-breakdown.md` 和 `docs/plan/development-progress.md`。
