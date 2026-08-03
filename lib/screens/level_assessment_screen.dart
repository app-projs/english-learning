import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';
import '../services/storage_service.dart';

class LevelAssessmentScreen extends StatefulWidget {
  const LevelAssessmentScreen({super.key});

  @override
  State<LevelAssessmentScreen> createState() => _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState extends State<LevelAssessmentScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _selectedOption = -1;
  bool _isFinished = false;

  final List<_DiagnosticQuestion> _questions = const [
    _DiagnosticQuestion(
      levelTag: '基础词汇 (Level 1)',
      question: 'What is the closest meaning of the word "Ambition"?',
      options: ['A. 雄心、野心', 'B. 犹豫、迟疑', 'C. 礼貌、教养', 'D. 恐惧、害怕'],
      correctIndex: 0,
      targetDictionary: '日常基础',
    ),
    _DiagnosticQuestion(
      levelTag: '进阶词汇 (Level 2)',
      question: 'Choose the best synonym for "Meticulous":',
      options: ['A. 粗心的', 'B. 严谨一丝不苟的', 'C. 慷慨大方的', 'D. 冲动的'],
      correctIndex: 1,
      targetDictionary: '四级核心',
    ),
    _DiagnosticQuestion(
      levelTag: '高频学术词 (Level 3)',
      question: 'What does "Ubiquitous" mean in sentence context?',
      options: ['A. 无所不在的、普遍的', 'B. 极其罕见的', 'C. 充满争议的', 'D. 历史悠久的'],
      correctIndex: 0,
      targetDictionary: '六级高频',
    ),
    _DiagnosticQuestion(
      levelTag: '长难句语法 (Level 4)',
      question: 'Identify the sentence with Subjunctive Mood (虚拟语气):',
      options: [
        'A. If it rains, I will take an umbrella.',
        'B. If I were you, I would take the offer.',
        'C. She said that she was going home.',
        'D. Although he is young, he is smart.'
      ],
      correctIndex: 1,
      targetDictionary: '考研必刷',
    ),
    _DiagnosticQuestion(
      levelTag: '雅思学术阅读 (Level 5)',
      question: 'Select the phrase indicating "Surpass or Exceed" (超越):',
      options: ['A. Outweigh', 'B. Undermine', 'C. Contradict', 'D. Deteriorate'],
      correctIndex: 0,
      targetDictionary: '雅思冲刺',
    ),
  ];

  void _submitAnswer() {
    if (_selectedOption == _questions[_currentIndex].correctIndex) {
      _score += 20;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = -1;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
    }
  }

  String get _recommendedDictionary {
    if (_score <= 20) return '日常基础';
    if (_score <= 40) return '四级核心';
    if (_score <= 60) return '六级高频';
    if (_score <= 80) return '考研必刷';
    return '雅思冲刺';
  }

  String get _recommendedLevelTitle {
    if (_score <= 20) return '🌱 英语初学者 (A1 入门级)';
    if (_score <= 40) return '📖 英语进修者 (A2/B1 四级水平)';
    if (_score <= 60) return '🎓 六级进阶者 (B2 中高级)';
    if (_score <= 80) return '🚀 考研学术精英 (C1 高级)';
    return '🏆 雅思/托福大师 (C2 专家级)';
  }

  Future<void> _applyRecommendation() async {
    final storage = await StorageService.getInstance();
    await storage.saveTargetWordbook(_recommendedDictionary);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已为你成功切换目标词库为【$_recommendedDictionary】！'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('英语水平测评与定级诊断', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: _isFinished ? _buildResultView(isDark) : _buildQuizView(isDark),
      ),
    );
  }

  Widget _buildQuizView(bool isDark) {
    final q = _questions[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 进度指示器
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(LuminaColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 16),
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
                  q.levelTag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: LuminaColors.primary,
                  ),
                ),
              ),
              Text(
                '第 ${_currentIndex + 1} / ${_questions.length} 题',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 题目卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              q.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
            ),
          ),

          const SizedBox(height: 24),

          // 选项列表
          Expanded(
            child: ListView.builder(
              itemCount: q.options.length,
              itemBuilder: (context, idx) {
                final isSelected = _selectedOption == idx;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedOption = idx;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? LuminaColors.primaryContainer
                            : (isDark ? const Color(0xFF1E293B) : Colors.white),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? LuminaColors.primary
                              : (isDark ? Colors.white10 : Colors.grey.shade300),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: isSelected
                                ? LuminaColors.primary
                                : (isDark ? Colors.white24 : Colors.grey.shade300),
                            child: Text(
                              String.fromCharCode(65 + idx),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              q.options[idx],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? LuminaColors.primary : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption == -1 ? null : _submitAnswer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentIndex == _questions.length - 1 ? '查看诊断诊断报告' : '下一题',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.stars_rounded, size: 72, color: Colors.amber),
          const SizedBox(height: 12),
          const Text(
            '测评诊断完成！',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '得分：$_score / 100 分',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: LuminaColors.primary,
            ),
          ),
          const SizedBox(height: 24),

          // 定级评估结果卡片
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _recommendedLevelTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.recommend, color: Colors.amberAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '推荐同步词库：【$_recommendedDictionary】',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '系统已为你自动定制当前阶段的学习路径与每日背词难度。点击下方按钮即可一键应用设置！',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('一键应用推荐词库并返回'),
              style: ElevatedButton.styleFrom(
                backgroundColor: LuminaColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _applyRecommendation,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _selectedOption = -1;
                _isFinished = false;
              });
            },
            child: const Text('重新诊断测评'),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticQuestion {
  final String levelTag;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String targetDictionary;

  const _DiagnosticQuestion({
    required this.levelTag,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.targetDictionary,
  });
}
