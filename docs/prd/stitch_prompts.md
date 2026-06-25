# Google Stitch 极速生成设计稿 - 提示词与规范指南 (温润极简风格)

本指南为您提供了专门针对 **Google Stitch**（基于 AI 的原生设计画布）优化编写的自然语言提示词。您可以直接将这些提示词复制并输入到 Stitch 的 AI 文本生成框中，用以一键产出符合中国用户审美倾向、温润极简风格的高保真设计 Mockup。

---

## 📐 画布排版与规整指南 (Canvas Layout Rules)

为了保持 Stitch 无限画布（Infinite Canvas）的整洁与专业度，避免页面零散杂乱，请遵循以下**分行对齐排版规则**：

1.  **分行归类**：以底部 Tab 页及功能大类为基准进行横向分行摆放。
    *   **第一行 (Row 1) - 学习首页及练习流**：从左至右依次摆放首页、单词卡片页、单词测试页、句子练习页、文章精读页。
    *   **第二行 (Row 2) - 专项突破及子关卡**：从左至右依次摆放专项书架首页、音标学习板、词根思维导图页、精听播放器页。
    *   **第三行 (Row 3) - 学习榜单及互动**：从左至右依次摆放周排行榜主页、好友打卡排行页、晋升段位庆祝弹窗。
    *   **第四行 (Row 4) - 个人中心及统计**：从左至右依次摆放“我”的主页、能力雷达图详情页、学习曲线大图、成就徽章展示板。
2.  **间距对齐**：
    *   **横向间距**：同一行内相邻的 UI 屏幕卡片（Frames）之间保持 `100px` 的等宽间距，并水平均匀对齐。
    *   **纵向间距**：不同大类（行与行之间）保持 `200px` 的垂直间距，保持各行开头对齐，形成完美的网格结构。

---

## 🎨 步骤 1：在 Stitch 中初始化设计规范 (Design Token)

在画布左侧的配置区或提示词输入框中，先输入**设计系统与全局风格指令**，奠定应用基调：

```text
Create a premium mobile app design system named "English Learning App". 
Style: "Warm Minimalism", highly visual, clean, friendly, and premium look tailored for Chinese users.

Theme Colors (Light Mode Default):
- Background: Soft Light Grey-White (#F8F9FA) for eye-comfort.
- Container Cards: Pure White (#FFFFFF) with a very subtle 1px border (#E9ECEF) and a soft diffuse shadow (rgba(0,0,0,0.015)).
- Card Corners: Rounded corners (16px).
- Primary Accent Gradient (Growth): Fresh Emerald Green to Mint Green (#2B8A3E to #40C057).
- Secondary Accent Gradient (Specialized): Warm Teal to Ice Blue (#0C8599 to #15AABF).
- Alert/Streak Accent Gradient (Energy): Sunset Orange to Peach (#F76707 to #FF922B).
- Typography Colors: Graphite Slate (#212529 for headers/bold text, #495057 for readable body text).

Typography:
- Headers: Plus Jakarta Sans or Outfit (bold, sans-serif).
- Body texts & Chinese labels: Inter, PingFang SC, and Microsoft YaHei (clean, highly legible).

Atmosphere: Flat cards, generous spacing, clear text alignment, friendly illustrations, haptic-style buttons.
```

---

## 📱 步骤 2：生成各个 Tab 页面 (在 Stitch 中输入以下指令)

### 提示词 1：【每日学习】首页 Tab (Tab 1: Daily / Home)
复制以下描述放入 Stitch 文本生成框：

```text
Generate a mobile app home screen for "English Learning App", warm minimalist theme.

Top Header:
- Left: Circular cartoon user avatar. Next to avatar, text "你好，Alex！" and a small target subtitle "学习目标：大学英语四级" in grey.
- Right: A glowing orange Flame Icon with text "连续打卡 7天".

Main Content Card (今日学习任务舱):
- A large card with a soft forest green gradient background.
- Left side of card: A beautiful circular progress ring drawing 50% completion, with text "已完成 2/4" in the center.
- Right side of card: A 2x2 grid showing 4 step nodes:
  (1) 每日单词 (with a green checkmark check icon)
  (2) 每日听力 (with a green checkmark check icon)
  (3) 每日句子 (highlighted as [进行中] active state)
  (4) 每日文章 (greyed out as [未开始] disabled state)
- Bottom of card: A wide, white pill-shaped button with green text "继续今日学习".

Below Main Card:
- A warm light-yellow box (#FFF9DB) with a small orange lightning icon and text: "⚡ 温故知新：还有5个生词需要复习，点击立即消灭！".
- A white card displaying Daily Quote: "每日金句" and bilingual text "The limits of my language mean the limits of my world." and "语言的边界，就是世界的边界。" with a small speaker icon on the right.

Bottom Navigation:
- A flat white bottom bar with 4 tabs with clear icons and Chinese text labels underneath: [学习 (Active green icon)], [专项], [榜单], [我].
```

---

### 提示词 2：【专项突破】Tab (Tab 2: Specialized Practice / Library)
复制以下描述放入 Stitch 文本生成框：

```text
Generate a mobile screen for "Specialized Practice / Library", warm minimalist theme.

Top Header:
- Text "专项突破" in bold Chinese font.
- A modern search input bar below the header: "搜索词库、单词、文章..." with a light grey background.

Horizontal Category bar:
- "音标", "字词根", "词汇", "语法", "阅读", "听力" with "词汇" selected in a green underline pill.

Main Grid Layout (2x3 Specialty Book Cards):
- 6 white cards with subtle shadow and round corners (16px):
  1. "音标纠音": Blue icon, progress badge "已学习 12/48".
  2. "字词根记忆": Orange icon, count badge "已解锁 35 个".
  3. "词汇积累": Purple icon, active dictionary progress "四级: 1,200/4,500".
  4. "句子语法": Green icon, grammar level badge "定语从句 关卡3".
  5. "长文精读": Teal icon, stats badge "已读 18 篇".
  6. "精听磨耳朵": Pink icon, stats badge "累计 12.5 小时".

Bottom Navigation:
- Same flat bottom bar with [专项 (Active green icon)] highlighted.
```

---

### 提示词 3：【学习榜单】Tab (Tab 3: Leaderboard)
复制以下描述放入 Stitch 文本生成框：

```text
Generate a mobile screen for "Weekly Leaderboard", warm minimalist theme.

Top Header Card (User Info):
- A clean white card showing user's current standing: Rank "#12", user avatar, nickname "Alex", score "2,450 LP", and badge title "白银极光".

Leaderboard List (Scrollable list):
- Rank 1: Soft golden background card, avatar, name "Sarah", score "4,820 LP", streak icon 🔥 45天, gold crown badge 🥇.
- Rank 2: Soft silver card, name "Ryan", score "4,210 LP", streak icon 🔥 30天, silver badge 🥈.
- Rank 3: Soft bronze card, name "Emma", score "3,980 LP", streak icon 🔥 21天, bronze badge 🥉.
- Rank 4-8: Standard white list rows with user details, scores, and a small "点赞" 👍 hand icon on the right edge.

Bottom Navigation:
- Same flat bottom bar with [榜单 (Active green icon)] highlighted.
```

---

### 提示词 4：【个人中心】Tab (Tab 4: Profile / Settings)
复制以下描述放入 Stitch 文本生成框：

```text
Generate a mobile screen for "User Profile & Statistics", warm minimalist theme.

Top Section:
- Large circular user profile picture. Username "Alex" and current target "大学英语四级".
- A 2x2 grid of key learning metric chips (战报):
  - "累计学习: 42小时" | "掌握单词: 1,840个"
  - "精读文章: 36篇"   | "精听时长: 18小时"

Middle Visual Analytics:
- A beautiful 5-dimensional capability radar chart with labels: "词汇力", "语法力", "阅读力", "听力", "发音". The filled polygon area is a semi-transparent green gradient.
- Below it: A horizontal slider showing Badge Cabinet (成就徽章柜) containing 3 unlocked colored badges ("自律狂魔", "黄金词霸", "听觉觉醒") and 3 greyed-out locked badges.

Bottom Settings Panel:
- Setting rows: "修改学习目标", "深色模式", "每日提醒设置".

Bottom Navigation:
- Same flat bottom bar with [我 (Active green icon)] highlighted.
```
