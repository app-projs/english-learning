class GrammarExample {
  final String english;
  final String chinese;
  final String breakdown;

  const GrammarExample({
    required this.english,
    required this.chinese,
    required this.breakdown,
  });
}

class GrammarQuestion {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const GrammarQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class GrammarTopic {
  final String title;
  final String ruleSummary;
  final List<GrammarExample> examples;
  final List<GrammarQuestion> questions;

  const GrammarTopic({
    required this.title,
    required this.ruleSummary,
    required this.examples,
    required this.questions,
  });
}

class MockGrammar {
  static List<GrammarTopic> getTopics() {
    return [
      const GrammarTopic(
        title: '定语从句 (Attributive Clauses)',
        ruleSummary: '修饰名词或代词的从句。先行词是人用 who/that，先行词是物用 which/that，表示所属关系用 whose，表示地点用 where。',
        examples: [
          GrammarExample(
            english: 'The girl who is reading a book is my sister.',
            chinese: '那个正在看书的女孩是我的妹妹。',
            breakdown: '先行词 The girl (人) ➔ 关系代词 who 在从句中充当主语。',
          ),
          GrammarExample(
            english: 'This is the city where I was born.',
            chinese: '这就是我出生的城市。',
            breakdown: '先行词 the city (地点) ➔ 关系副词 where 作地点状语。',
          ),
        ],
        questions: [
          GrammarQuestion(
            questionText: 'The man _______ helped us yesterday is a famous doctor.',
            options: ['who', 'which', 'where', 'whose'],
            correctIndex: 0,
            explanation: '先行词是 The man (人)，引导定语从句并在从句中作主语，故用 who。',
          ),
          GrammarQuestion(
            questionText: 'I lost the book _______ my father bought for me.',
            options: ['who', 'which', 'where', 'whose'],
            correctIndex: 1,
            explanation: '先行词是 the book (物)，故用 relation pronoun which。',
          ),
        ],
      ),
      const GrammarTopic(
        title: '非谓语动词 (Non-finite Verbs)',
        ruleSummary: '动词不做谓语时的三种形态：Doing (主动/进行)、Done (被动/完成)、To do (目的/将来)。',
        examples: [
          GrammarExample(
            english: 'Seeing the teacher, the boys stopped talking.',
            chinese: '一看到老师，男孩们就停止了说话。',
            breakdown: 'Seeing 作伴随状语，与主语 the boys 是主动关系。',
          ),
          GrammarExample(
            english: 'I have a lot of homework to do tonight.',
            chinese: '我今晚有许多作业要做。',
            breakdown: 'to do (不定式) 作后置定语，表示未发生的动作目的。',
          ),
        ],
        questions: [
          GrammarQuestion(
            questionText: '_______ for two hours, the tired doctor finally sat down.',
            options: ['Working', 'Worked', 'To work', 'Having work'],
            correctIndex: 0,
            explanation: '主语 the doctor 与动词 work 是主动进行关系，用现在分词 Working 作时间状语。',
          ),
        ],
      ),
      const GrammarTopic(
        title: '虚拟语气 (Subjunctive Mood)',
        ruleSummary: '表达假设、愿望或与事实相反的情况。与现在事实相反：从句过去式 (did/were)，主句 would/could + do。',
        examples: [
          GrammarExample(
            english: 'If I were you, I would accept the job offer.',
            chinese: '如果我是你，我就会接受这份工作邀请。',
            breakdown: '与现在事实相反，be 动词统一用 were，主句用 would accept。',
          ),
        ],
        questions: [
          GrammarQuestion(
            questionText: 'If it _______ tomorrow, we would stay at home.',
            options: ['rained', 'rains', 'will rain', 'rain'],
            correctIndex: 0,
            explanation: '主句是 would stay，表示对将来的假设，从句动词用过去式 rained。',
          ),
        ],
      ),
    ];
  }
}
