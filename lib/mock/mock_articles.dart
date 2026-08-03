import '../models/article.dart';

class MockArticles {
  static List<Article> getArticles() {
    final now = DateTime.now();
    return [
      // --- 短文精读 (6 篇 - 每篇 8 个完整自然段) ---
      Article(
        id: '1',
        title: 'The Benefits of Reading English Books',
        chineseTitle: '阅读英文书籍的诸多益处',
        content: '''Reading books in English can significantly improve your language skills. It helps expand your vocabulary, improves grammar understanding, and enhances comprehension abilities.

When you read regularly, you expose yourself to various writing styles and sentence structures. This helps you develop a natural feel for the language over time.

One major benefit is vocabulary expansion. By reading words in context, you learn how they are used naturally rather than memorizing isolated definitions.

Another advantage is grammar reinforcement. Seeing grammar rules applied in real-life stories helps solidify your understanding without tedious memorization.

Furthermore, reading exposes you to cultural nuances and idiomatic expressions used by native speakers, broadening your global perspective.

Reading also improves your writing skills. As you absorb well-constructed sentences, your own writing naturally becomes more fluent and expressive.

To get the most out of reading, choose books that match your current language level and interest, starting with graded readers or simple fiction.

Consistency is key. Dedicating even fifteen minutes a day to reading English books will yield remarkable long-term progress.''',
        chineseContent: '''阅读英文书籍可以显著提升你的语言能力。它有助于扩大词汇量，加深语法理解，并增强阅读理解能力。

当您定期阅读时，您会接触到各种写作风格和句子结构。随着时间的推移，这有助于你培养对该语言的自然感觉。

一个主要的好处是词汇扩展。通过在语境中阅读单词，您可以学习它们如何在自然语境中使用，而不是死记硬背孤立的定义。

另一个优势是语法巩固。在真实故事中看到语法规则的应用，有助于在不需要繁琐记忆的情况下巩固您的理解。

此外，阅读能让你接触到母语者使用的文化细微差别和地道表达方式，从而拓宽你的全球视野。

阅读还能提高你的写作技巧。当你吸收了结构良好的句子时，你自己的写作自然会变得更加流利和富有表现力。

为了从阅读中获得最大收益，请选择符合你当前语言水平和兴趣的书籍，从分级读物或简单小说开始。

持之以恒是关键。即使每天花十五分钟阅读英文书籍，也会取得显著的长远进步。''',
        difficulty: 'Intermediate',
        category: '短文精读',
        tags: ['Reading', 'Vocabulary', 'Books'],
        createdAt: now,
        readTime: 8,
      ),

      Article(
        id: '2',
        title: 'How to Improve Your English Speaking',
        chineseTitle: '如何提升你的英语口语表达',
        content: '''Speaking English fluently requires practice and dedication. Many learners feel hesitant due to fear of making mistakes, but practice builds confidence.

Daily conversation practice is essential. Even speaking to yourself in front of a mirror helps improve pronunciation and sentence formation.

Thinking directly in English rather than translating from your native language accelerates your response time during real conversations.

Listening attentively to native speakers through podcasts, movies, and audiobooks helps you absorb natural intonation, rhythm, and stress patterns.

Shadowing—repeating phrases immediately after hearing them—is an exceptionally effective technique for refining your accent and fluency.

Finding a dedicated language partner or joining English discussion groups provides interactive opportunities to apply what you have learned.

Do not be afraid of grammatical errors. Communication is about expressing ideas clearly, and mistakes are natural stepping stones to mastery.

Set achievable daily speaking goals and record your progress to stay motivated on your language journey.''',
        chineseContent: '''流利地说英语需要练习和专注。许多学习者因为害怕犯错而犹豫不决，但练习能建立信心。

日常口语练习至关重要。即使在镜子前对自己说话，也有助于改善发音和句子表达。

直接用英语思考，而不是从母语翻译，可以加快你在真实对话中的反应速度。

通过播客、电影和有声读物专注倾听母语人士的说话，有助于你吸收自然语调、节奏和重音模式。

影子跟读——在听到短语后立即重复——是一种极其有效的改善发音和流利度的技巧。

寻找一个出色的语言伙伴或加入英语讨论小组，可以提供互动机会来应用你所学的知识。

不要害怕语法错误。沟通的核心在于清晰地表达思想，错误是通往精通的自然基石。

设定可实现的每日口语目标并记录你的进步，以在语言学习之旅中保持动力。''',
        difficulty: 'Beginner',
        category: '短文精读',
        tags: ['Speaking', 'Practice', 'Tips'],
        createdAt: now,
        readTime: 7,
      ),

      // --- 新闻美文 (每篇 8 个完整自然段) ---
      Article(
        id: 'news_1',
        title: 'The Rise of Artificial Intelligence in Daily Life',
        chineseTitle: '人工智能在日常生活中的崛起',
        content: '''Artificial Intelligence is transforming how humanity lives, works, and communicates across the globe in ways previously confined to science fiction.

From smart home assistants to personalized learning algorithms, AI technology is integrating seamlessly into everyday routines.

Medical professionals utilize advanced machine learning algorithms to diagnose diseases earlier and with unprecedented precision.

Engineers build autonomous transportation systems that can navigate complex city streets safely, reducing human error.

In education, adaptive AI tutors customize lessons according to individual student learning speeds, democratizing access to quality knowledge.

However, the rapid growth of automation also presents ethical challenges regarding privacy, data security, and workforce transformation.

Governments and technology pioneers must collaborate to establish responsible guidelines that maximize societal benefits while mitigating risks.

Understanding AI technology has become essential for everyone navigating the modern digital landscape.''',
        chineseContent: '''人工智能正在以以往仅限于科幻小说的方式，深刻改变全球人类的生活、工作和沟通方式。

从智能家居助手到个性化学习算法，AI 技术正无缝融入日常生活。

医疗专业人员利用先进的机器学习算法更早、以前所未有的精准度诊断疾病。

工程师们制造出能在复杂城市街道上安全行驶的自动驾驶交通系统，减少了人为失误。

在教育领域，自适应 AI 导师根据每个学生的学习速度定制课程，实现了高质量知识获取的平等化。

然而，自动化的快速增长也带来了关于隐私、数据安全和劳动力转型的伦理挑战。

政府和科技先驱必须合作建立负责任的指导方针，在降低风险的同时最大化社会效益。

对于身处现代数字领域的每个人来说，理解 AI 技术已成为一项必备能力。''',
        difficulty: 'Advanced',
        category: '新闻美文',
        tags: ['Technology', 'AI', 'Future'],
        createdAt: now,
        readTime: 9,
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
