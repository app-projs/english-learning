import '../models/article.dart';

class MockArticles {
  static List<Article> getArticles() {
    final now = DateTime.now();
    return [
      // --- 短文精读 (6 篇) ---
      Article(
        id: '1',
        title: 'The Benefits of Reading English Books',
        chineseTitle: '阅读英文书籍的诸多益处',
        content: '''Reading books in English can significantly improve your language skills. It helps expand your vocabulary, improves grammar understanding, and enhances comprehension abilities.

When you read regularly, you expose yourself to various writing styles and sentence structures. This helps you develop a natural feel for the language.

Key benefits include:
1. Vocabulary expansion - you learn new words in context.
2. Grammar improvement - you see grammar rules applied in real sentences.
3. Better writing - you absorb good writing patterns.
4. Cultural knowledge - you learn about English-speaking cultures.

Start with books that match your level and gradually progress to more challenging materials.''',
        chineseContent: '''阅读英文书籍可以显著提升你的语言能力。它有助于扩大词汇量，加深语法理解，并增强阅读理解能力。

当您定期阅读时，您会接触到各种写作风格和句子结构。这有助于你培养对该语言的自然感觉。

主要好处包括：
1. 词汇扩展——您在语境中学习新单词。
2. 语法改进——您可以看到应用于真实句子的语法规则。
3. 更好的写作能力——吸收良好的写作模式。
4. 文化知识——了解英语国家的文化。

从符合您水平的书籍开始，逐渐过渡到更有挑战性的材料。''',
        difficulty: 'Intermediate',
        category: '短文精读',
        tags: ['Reading', 'Vocabulary', 'Books'],
        createdAt: now,
        readTime: 5,
      ),
      Article(
        id: '2',
        title: 'How to Improve Your English Speaking',
        chineseTitle: '如何提升你的英语口语表达',
        content: '''Speaking English fluently requires practice and dedication. Here are some effective strategies to improve your spoken English.

1. Practice daily - Speak English every day, even if it is just to yourself.
2. Think in English - Try to think in English instead of translating.
3. Listen and repeat - Watch English videos and repeat after speakers.
4. Find a speaking partner - Practice with native speakers or fellow learners.
5. Do not be afraid of mistakes - Mistakes are part of learning.

Remember, the key to improving your speaking is consistent practice. Set realistic goals and track your progress.''',
        chineseContent: '''流利地说英语需要练习和专注。以下是一些提高口语表达的有效策略。

1. 每日练习 - 每天说英语，即使只是对自己说。
2. 用英语思考 - 尝试用英语思考，而不是先在脑海中翻译。
3. 倾听并重复 - 观看英文视频并跟读发音。
4. 寻找口语伙伴 - 与母语人士或同行学习者练习。
5. 不要害怕犯错 - 错误是学习过程的一部分。

记住，提高口语的关键在于持之以恒的练习。设定切合实际的目标并记录你的进步。''',
        difficulty: 'Beginner',
        category: '短文精读',
        tags: ['Speaking', 'Practice', 'Tips'],
        createdAt: now,
        readTime: 7,
      ),
      Article(
        id: '3',
        title: 'Advanced English Grammar Tips',
        chineseTitle: '高级英语语法突破秘籍',
        content: '''Mastering English grammar takes time and effort. Here are some advanced grammar concepts that will help you sound more natural.

1. Perfect Tenses
   - Present Perfect: I have finished my work.
   - Past Perfect: I had eaten before he arrived.
   - Future Perfect: I will have completed it by tomorrow.

2. Modal Verbs for Probability
   - Must, Could, Might for different levels of certainty.

3. Conditional Sentences
   - Zero: If water boils, it evaporates.
   - First: If it rains, I will stay home.
   - Second: If I won the lottery, I would travel.
   - Third: If I had studied, I would have passed.

Understanding these structures will elevate your English to a more advanced level.''',
        chineseContent: '''掌握英语语法需要时间和努力。以下是一些高级语法概念，它们将帮助你的表达更加自然流利。

1. 完成时态
   - 现在完成时：我已完成工作。
   - 过去完成时：在他到达前我已经吃过了。
   - 将来完成时：截至明天我将已经完成任务。

2. 表示概率的情态动词
   - Must, Could, Might 代表不同的确定性程度。

3. 条件句
   - 零条件句：水沸腾即蒸发。
   - 第一条件句：如果下雨，我就留在家。
   - 第二条件句：如果我中彩票，我就去旅行。
   - 第三条件句：如果我当时好好学了，我就能通过考试。

理解这些句型结构将把你的英语能力提升到更高水平。''',
        difficulty: 'Advanced',
        category: '短文精读',
        tags: ['Grammar', 'Advanced', 'Tips'],
        createdAt: now,
        readTime: 10,
      ),
      Article(
        id: '4',
        title: 'Daily English Phrases for Communication',
        chineseTitle: '日常沟通高频实用美句',
        content: '''Learning common phrases is essential for everyday communication. Here are some useful expressions:

Greetings:
- How are you doing?
- Nice to meet you.
- Long time no see.

Making Conversation:
- What do you do for a living?
- How is everything going?
- What is new?

Expressing Opinions:
- In my opinion...
- I think that...
- From my point of view...

Polite Requests:
- Could you please...?
- Would you mind...?
- I would appreciate it if...

These phrases will help you communicate more naturally in daily situations.''',
        chineseContent: '''学习常用短语对日常沟通至关重要。以下是一些非常实用的表达句型：

问候打招呼：
- 你最近怎么样？
- 很高兴认识你。
- 好久不见。

展开话题交谈：
- 你是做什么工作的？
- 一切都还好吗？
- 有什么新鲜事吗？

表达观点意见：
- 在我看来……
- 我认为……
- 从我的视角来看……

礼貌提出请求：
- 请问你能……吗？
- 你介意……吗？
- 如果你能……我将不胜感激。

这些短语能帮助你在日常情景中更加地道自然地表达。''',
        difficulty: 'Beginner',
        category: '短文精读',
        tags: ['Speaking', 'Phrases', 'Daily'],
        createdAt: now,
        readTime: 6,
      ),
      Article(
        id: '5',
        title: 'Understanding English Idioms',
        chineseTitle: '英语成语与地道俗语解析',
        content: '''Idioms are phrases where the meaning cannot be understood from the individual words. Here are some common English idioms:

1. Break the ice - To start a conversation.
2. Hit the nail on the head - To be exactly right.
3. Cost an arm and a leg - To be very expensive.
4. Under the weather - To feel sick.
5. Once in a blue moon - Rarely.
6. Bite the bullet - To face difficulty courageously.
7. Beat around the bush - To avoid the main topic.

Learning idioms will help you sound more like a native speaker and understand English media better.''',
        chineseContent: '''成语俗语是无法单凭字面意思去理解的固定表达。以下是一些最常见的英语成语：

1. Break the ice - 破冰，打消陌生尴尬。
2. Hit the nail on the head - 一针见血，说得完全正确。
3. Cost an arm and a leg - 极其昂贵，代价高昂。
4. Under the weather - 身体不适，有些小病。
5. Once in a blue moon - 千载难逢，罕见。
6. Bite the bullet - 咬紧牙关，勇敢面对困难。
7. Beat around the bush - 拐弯抹角，回避主题。

掌握这些地道俗语能让你的表达更像母语人士，也能更好地理解英语原版影视作品。''',
        difficulty: 'Intermediate',
        category: '短文精读',
        tags: ['Vocabulary', 'Idioms', 'Culture'],
        createdAt: now,
        readTime: 8,
      ),
      Article(
        id: '6',
        title: 'The Art of Effective Time Management',
        chineseTitle: '高效时间管理的艺术',
        content: '''Managing your time effectively allows you to achieve more in less time.

1. Prioritize tasks - Use the Eisenhower Matrix to classify tasks by urgency and importance.
2. Focus on one task - Avoid multitasking as it reduces cognitive performance.
3. Take regular breaks - The Pomodoro Technique suggests 25 minutes of work followed by a 5-minute break.
4. Set daily goals - Plan your top three priorities every morning.

Mastering time management will reduce stress and bring harmony to your personal and professional life.''',
        chineseContent: '''高效管理时间能让你在更短的时间里取得更多的成果。

1. 安排任务优先级——使用艾森豪威尔矩阵按紧急和重要程度划分任务。
2. 专注于单一任务——避免同时处理多任务，那会降低大脑认知效率。
3. 定期休息休息——番茄工作法建议工作25分钟后休息5分钟。
4. 设定每日目标——每天清晨规划好最重要的三件事。

掌握时间管理不仅能减轻压力，还能为你的生活与事业带来和谐平衡。''',
        difficulty: 'Intermediate',
        category: '短文精读',
        tags: ['Management', 'Productivity', 'Habits'],
        createdAt: now,
        readTime: 6,
      ),

      // --- 新闻美文 (5 篇) ---
      Article(
        id: 'news_1',
        title: 'The Rise of Artificial Intelligence in Daily Life',
        chineseTitle: '人工智能在日常生活中的崛起',
        content: '''Artificial Intelligence is transforming how we live, work, and communicate. From smart home assistants to personalized learning algorithms, AI technology is integrating seamlessly into everyday routines.

Medical professionals use AI to diagnose diseases earlier and with higher precision. Engineers build autonomous vehicles that can navigate complex city streets safely.

As AI continues to evolve, understanding its impact becomes essential for everyone.''',
        chineseContent: '''人工智能正在深刻改变我们的生活、工作与沟通方式。从智能家居语音助手到个性化学习算法，AI 技术正无缝融入日常生活。

医疗专家利用 AI 更早、更精准地诊断疾病。工程师们制造出能在复杂城市街道上安全行驶的自动驾驶汽车。

随着人工智能的持续演进，理解其深远影响已成为每个人的必修课。''',
        difficulty: 'Advanced',
        category: '新闻美文',
        tags: ['Technology', 'AI', 'Future'],
        createdAt: now,
        readTime: 6,
      ),
      Article(
        id: 'news_2',
        title: 'Sustainable Living: Eco-friendly Habits for the Future',
        chineseTitle: '可持续生活：面向未来的绿色环保习惯',
        content: '''Protecting our planet begins with small daily choices. Sustainable living means reducing waste, conserving energy, and supporting renewable resources.

By bringing reusable bags to the market, turning off unnecessary lights, and eating more plant-based foods, individuals can make a massive collective difference.

Green technology and conscious consumerism are creating a cleaner, healthier future for generations to come.''',
        chineseContent: '''保护我们的地球始于日常微小的选择。可持续生活意味着减少浪费、节约能源并支持可再生资源。

通过携带环保购物袋购物、随手关掉不必要的灯光以及多吃植物基食物，个人的微小行动能凝聚成巨大的改观。

绿色科技与有意识的消费观念正为子孙后代缔造更加清洁健康的美好未来。''',
        difficulty: 'Intermediate',
        category: '新闻美文',
        tags: ['Environment', 'Green', 'Lifestyle'],
        createdAt: now,
        readTime: 7,
      ),
      Article(
        id: 'news_3',
        title: 'Exploring Space: The Journey Beyond Earth',
        chineseTitle: '探索太空：走出地球的伟大征途',
        content: '''Humanity’s fascination with space has sparked unprecedented scientific breakthroughs. Modern telescopes capture images of distant galaxies formed billions of years ago.

Space agencies around the world are preparing ambitious missions to establish lunar bases and send human explorers to Mars.

The quest to explore the cosmos pushes the boundaries of technology and inspires dreams across generations.''',
        chineseContent: '''人类对太空的着迷引发了前所未有的科学突破。现代天文望远镜捕捉到了数十亿年前形成的遥远星系照片。

世界各地的航天机构正在规划雄心勃勃的蓝图，以建立月球基地并将人类探险者送往火星。

探索宇宙的征程不断突破科技极限，也点亮了一代代人的梦想。''',
        difficulty: 'Advanced',
        category: '新闻美文',
        tags: ['Science', 'Space', 'Discovery'],
        createdAt: now,
        readTime: 8,
      ),
      Article(
        id: 'news_4',
        title: 'The Magic of Morning Routines for Productivity',
        chineseTitle: '晨间高效习惯的神奇魔力',
        content: '''How you spend the first hour of your morning sets the tone for the entire day. Successful leaders prioritize mindfulness, physical exercise, and focused reading before diving into work.

Waking up early gives you quiet uninterrupted time to reflect on your goals.

A consistent morning routine boosts energy, reduces stress, and fosters sustained mental clarity.''',
        chineseContent: '''你如何度过清晨的第一小时，决定了全天的精神基调。成功的领袖们会在投身工作前优先进行冥想、体育锻炼和专注阅读。

早起为你提供了安安静静、不受打扰的时段来审视与思考目标。

持之以恒的晨间习惯能提升精力、减轻压力，并滋养持久清晰的思维。''',
        difficulty: 'Intermediate',
        category: '新闻美文',
        tags: ['Mindset', 'Productivity', 'Wellness'],
        createdAt: now,
        readTime: 5,
      ),
      Article(
        id: 'news_5',
        title: 'Cultural Diversity and Global Connections',
        chineseTitle: '文化多元性与全球连接',
        content: '''In an interconnected world, cultural diversity enriches our global community. Traveling and learning foreign languages open doorways to new perspectives and empathy.

Sharing traditional music, art, and culinary heritage fosters deep mutual respect among international cultures.

Embracing diversity unites people across borders, building a harmonious world based on shared humanity.''',
        chineseContent: '''在一个互联互通的世界里，文化的多元性丰富了我们的全球社区。旅行和学习外语为新视角与同理心打开了大门。

分享传统音乐、艺术与美食文化遗产，促进了国际文化间深厚的相互尊重。

包容多元文化将跨国界的人们凝聚在一起，基于共同的人性构建出一个和谐的世界。''',
        difficulty: 'Intermediate',
        category: '新闻美文',
        tags: ['Culture', 'Global', 'Society'],
        createdAt: now,
        readTime: 6,
      ),
    ];
  }

  static Article? getArticleById(String id) {
    return getArticles().where((a) => a.id == id).firstOrNull;
  }

  static List<Article> getArticlesByDifficulty(String difficulty) {
    return getArticles().where((a) => a.difficulty == difficulty).toList();
  }

  static List<Article> searchArticles(String query) {
    final lowerQuery = query.toLowerCase();
    return getArticles()
        .where((a) =>
            a.title.toLowerCase().contains(lowerQuery) ||
            a.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)))
        .toList();
  }
}
