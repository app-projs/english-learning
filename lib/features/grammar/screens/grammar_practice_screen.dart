import 'package:flutter/material.dart';
import '../../../core/theme/lumina_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/audio_service.dart';
import '../../../features/review/screens/completion_congratulation_screen.dart';
import '../mock/mock_grammar.dart';

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
    AudioService.instance.stop();
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
                  color: Colors.blue.withValues(alpha: 0.2),
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
        border: Border.all(color: LuminaColors.primary.withValues(alpha: 0.3), width: 1.5),
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

final List<GrammarTopic> _grammarTopics = MockGrammar.getTopics();
