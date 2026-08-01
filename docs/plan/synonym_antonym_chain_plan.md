# 英语词汇同义反义词逻辑关联链开发计划 (Synonym & Antonym Chain Plan)

## 📌 需求概述
在 `WordPracticeScreen` (`lib/screens/word_practice_screen.dart`) 中全量新增第 4 个专项 Tab **【同反义词逻辑链】**。通过同义辨析、反义词对比、词族延伸以及同义替换考点刷题，帮助用户摆脱用词单一的问题，迅速扩充高级词汇库与写作替换能力。

---

## 🎯 核心功能设计

### 1. 核心词卡片与同反义词解构 (Deconstruction)
- **同义词组 (Synonyms)**：提供 3-4 个精选同义/近义词及语境微小差异提示（如 `important` ➔ `crucial` / `vital` / `essential`）。
- **反义词组 (Antonyms)**：提供反义对比词（如 `trivial` / `insignificant`）。
- **词族延伸 (Word Family)**：衍生词性（名词、副词、形容词）及地道短语搭配。

### 2. 同义替换考点精练 (Synonym Replacement Quiz)
- **划线替换题**：在具体句子里将基础词划线，让用户选出最地道的高级同义替换词。
- **即时诊断与解析**：答对播放发音，答错弹窗详细剖析近义词适用语境差异。

### 3. 一键收藏与打卡 (Favorites & Storage)
- **生词本联动**：支持一键收藏高级替换词与同义词链。
- **结算**：完成练习增加 +50 积分并更新学习进度。

---

## 🛠️ 实施步骤

1. **创建计划文档**：`docs/plan/synonym_antonym_chain_plan.md`。
2. **实现 UI 与逻辑**：在 `lib/screens/word_practice_screen.dart` 中添加 `_buildSynonymChainTab()`。
3. **编译与分析验证**：运行 `flutter analyze` 确保 0 Error，升级 `pubspec.yaml` 版本。
4. **更新进度文档**：更新 `docs/plan/development-progress.md`。
