# 听力专区 - 逐句断句听写与盲听拼写挑战开发计划 (Listening Dictation Challenge)

## 📌 需求概述
在 `ListeningPracticeScreen` (`lib/screens/listening_practice_screen.dart`) 中全量新增第 5 个专项 Tab **【断句听写挑战】**。通过盲听音频、逐句慢速复读、文本实时听写以及逐词差异化比对分析，帮助用户突破听力瓶颈、强化单词听音辨词与断句拼写能力。

---

## 🎯 核心功能设计

### 1. 听力素材与断句分割 (Audio Chunking)
- **多维度听力场景**：涵盖校园对话、商务社交、科普短文、新闻快讯。
- **单句 Chunk 切割**：包含原声音频、标准英文句子、中文翻译以及关键词提示。

### 2. 盲听与复读控制 (Blind Listening Controls)
- **▶ 播放原声**：高保真神经网络音频播放。
- **🔁 0.7x 慢速复读**：单句死循环播放与慢速朗读。
- **🙈 盲听遮挡**：支持一键遮挡参考字幕，实现纯听力拼写。

### 3. 逐词差异比对引擎 (Word-by-Word Diff Analysis)
- **用户听写输入**：提供响应式输入框，支持快捷键盘输入。
- **实时差异计算**：
  - 正确单词：绿色高亮 (`✓`)；
  - 错漏单词：红色中划线 (`✗`) + 提示正确单词；
  - 实时计算准确率公式：$\text{准确率} = \frac{\text{正确词数}}{\text{总词数}} \times 100\%$。

### 4. 错词归集与打卡积分 (Favorites & Rewards)
- **生词一键收藏**：对听错/漏听的单词提供 `♥️ 收藏` 按钮，加入生词本。
- **打卡结算**：听写完成后结算学习积分 (+50 积分)，并更新每日听力打卡状态。

---

## 🛠️ 实施步骤

1. **创建计划文档**：`docs/plan/listening_dictation_plan.md`。
2. **实现 UI 与比对逻辑**：在 `lib/screens/listening_practice_screen.dart` 中添加 `_buildDictationChallengeTab()`。
3. **数据接入与算法**：实现 `_compareDictationText(String userInput, String targetText)` 逐词 Diff 算法。
4. **编译与分析验证**：运行 `flutter analyze` 确保 0 Error，升级 `pubspec.yaml` 版本。
5. **更新进度文档**：更新 `docs/plan/development-progress.md`。
