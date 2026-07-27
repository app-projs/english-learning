import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';
import '../services/storage_service.dart';
import 'completion_congratulation_screen.dart';

class GrammarPracticeScreen extends StatefulWidget {
  const GrammarPracticeScreen({super.key});

  @override
  State<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends State<GrammarPracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedOptionIndex = -1;
  bool _hasSubmitted = false;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _grammarTopics.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _finishPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CompletionCongratulationScreen(
          moduleTitle: '语法专项测试',
          earnedLp: 60,
          streakDays: 7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('语法句型专项训练', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: InkWell(
                onTap: _finishPractice,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade600, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '完成',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicatorColor: LuminaColors.primary,
            labelColor: LuminaColors.primary,
            unselectedLabelColor: isDark ? Colors.white60 : Colors.grey.shade700,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: LuminaColors.primary),
              insets: EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            tabs: _grammarTopics.map((t) => Tab(text: t.title)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _grammarTopics.map((topic) => _buildTopicView(topic)).toList(),
      ),
    );
  }

  Widget _buildTopicView(GrammarTopic topic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 语法核心法则卡片
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${topic.title} · 核心口诀',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  topic.ruleSummary,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 核心例句解析
          const Text(
            '📌 结构图解例句：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...topic.examples.map((ex) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ex.english,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: LuminaColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ex.chinese,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '解析: ${ex.breakdown}',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // 专项刷题测试
          const Text(
            '✏️ 语法考点精练：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildQuizCard(topic.questions),
        ],
      ),
    );
  }

  Widget _buildQuizCard(List<GrammarQuestion> questions) {
    if (questions.isEmpty) return const SizedBox.shrink();
    final q = questions[_currentQuestionIndex % questions.length];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LuminaColors.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: LuminaColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '第 ${_currentQuestionIndex + 1} / ${questions.length} 题',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: LuminaColors.primary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex = (_currentQuestionIndex + 1) % questions.length;
                    _selectedOptionIndex = -1;
                    _hasSubmitted = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q.questionText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 16),

          ...List.generate(q.options.length, (optIdx) {
            final opt = q.options[optIdx];
            final isSelected = _selectedOptionIndex == optIdx;
            final isCorrect = optIdx == q.correctIndex;

            Color borderColor = isDark ? Colors.white10 : Colors.grey.shade300;
            Color bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade50;

            if (_hasSubmitted) {
              if (isCorrect) {
                borderColor = Colors.green.shade600;
                bgColor = Colors.green.shade50;
              } else if (isSelected) {
                borderColor = Colors.red.shade600;
                bgColor = Colors.red.shade50;
              }
            } else if (isSelected) {
              borderColor = LuminaColors.primary;
              bgColor = LuminaColors.primaryContainer;
            }

            return InkWell(
              onTap: _hasSubmitted
                  ? null
                  : () {
                      setState(() {
                        _selectedOptionIndex = optIdx;
                      });
                    },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: borderColor,
                      child: Text(
                        String.fromCharCode(65 + optIdx),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opt,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),
          if (!_hasSubmitted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedOptionIndex == -1
                    ? null
                    : () {
                        setState(() {
                          _hasSubmitted = true;
                        });
                        if (_selectedOptionIndex != q.correctIndex) {
                          // 保存至错题本
                          StorageService.getInstance().then(
                            (s) => s.addWrongAnswer({
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'question': q.questionText,
                              'correctAnswer': q.options[q.correctIndex],
                            }),
                          );
                        }
                      },
                child: const Text('确认提交'),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedOptionIndex == q.correctIndex
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedOptionIndex == q.correctIndex
                      ? Colors.green.shade300
                      : Colors.red.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _selectedOptionIndex == q.correctIndex
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _selectedOptionIndex == q.correctIndex
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedOptionIndex == q.correctIndex ? '回答正确！🎉' : '回答错误 ❌',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedOptionIndex == q.correctIndex
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '💡 考点详解: ${q.explanation}',
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedOptionIndex == q.correctIndex
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

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

final List<GrammarTopic> _grammarTopics = [
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
        explanation: '主语 the doctor 与动词 work 是主动进行关系，用现分词 Working 作时间状语。',
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
