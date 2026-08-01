import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/sm2_service.dart';
import 'completion_congratulation_screen.dart';

class SmartReviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? customQueue;
  final VoidCallback? onReviewCompleted;

  const SmartReviewScreen({
    super.key,
    this.customQueue,
    this.onReviewCompleted,
  });

  @override
  State<SmartReviewScreen> createState() => _SmartReviewScreenState();
}

class _SmartReviewScreenState extends State<SmartReviewScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _dueItems = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _reviewedCount = 0;
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _loadDueReviewItems();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  Future<void> _loadDueReviewItems() async {
    _storageService = await StorageService.getInstance();
    final List<Map<String, dynamic>> items = [];

    if (widget.customQueue != null && widget.customQueue!.isNotEmpty) {
      for (var q in widget.customQueue!) {
        items.add({
          'id': q['id'] ?? '',
          'type': _getDisplayType(q['type']),
          'title': q['title'] ?? '',
          'subTitle': q['subtitle'] ?? '核心巩固复习项',
          'answer': q['answer'] ?? '点击看详细释义与记忆考点',
          'example': q['example'] ?? '建议配合原声朗读复述。',
          'raw': q,
        });
      }
    } else {
      final queue = _storageService?.getUnifiedReviewQueue() ?? [];
      for (var q in queue) {
        items.add({
          'id': q['id'] ?? '',
          'type': _getDisplayType(q['type']),
          'title': q['title'] ?? '',
          'subTitle': q['subtitle'] ?? '遗忘曲线复习',
          'answer': '点击看详细释义与记忆考点',
          'example': '建议结合例句语境强化记忆。',
          'raw': q,
        });
      }
    }

    if (items.isEmpty) {
      items.addAll([
        {
          'id': 'ephemeral',
          'type': 'SM-2 单词复习',
          'title': 'ephemeral',
          'subTitle': '/ɪˈfemərəl/',
          'answer': 'adj. 转瞬即逝的，短暂的',
          'example': 'Fame in the modern world is ephemeral.',
        },
        {
          'id': 'If you work hard, you will succeed.',
          'type': 'SM-2 长难句复习',
          'title': 'If you work hard, you will succeed.',
          'subTitle': '条件状语从句',
          'answer': '中文翻译：如果你努力工作，你就会成功。',
          'example': '结构分析：If 引导从句，will 表示将来时。',
        },
        {
          'id': 'invisible',
          'type': 'SM-2 词根复习',
          'title': 'invisible',
          'subTitle': 'in- [否定] + vis [看]',
          'answer': 'adj. 隐形的，不可见的',
          'example': 'Light from the sun contains invisible rays.',
        },
      ]);
    }

    if (mounted) {
      setState(() {
        _dueItems = items;
        _isLoading = false;
      });
    }
  }

  String _getDisplayType(dynamic type) {
    if (type == 'sm2_due') return 'SM-2 算法复习';
    if (type == 'wrong_answer') return '错题消灭';
    if (type == 'favorite') return '生词本高频词';
    return (type ?? '遗忘曲线复习').toString();
  }

  Future<void> _rateMemory(int intervalDays, {SM2Rating rating = SM2Rating.good}) async {
    if (_dueItems.isEmpty) return;
    final item = _dueItems[_currentIndex];
    final title = (item['title'] ?? '').toString();

    if (title.isNotEmpty) {
      AudioService.instance.speak(title);
    }

    // 持久化 SM-2 计算与错题消除
    if (_storageService != null && title.isNotEmpty) {
      final existing = _storageService!.getSM2Item(title) ?? SM2Item.initial(title);
      final updated = SM2Service.calculateNextReview(existing, rating);
      await _storageService!.saveSM2Item(updated);

      final rawId = (item['id'] ?? item['title'] ?? '').toString();
      if (rawId.isNotEmpty) {
        await _storageService!.markWrongAnswerReviewed(rawId);
      }
    }

    _reviewedCount++;

    if (_currentIndex < _dueItems.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      widget.onReviewCompleted?.call();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompletionCongratulationScreen(
              moduleTitle: '艾宾浩斯智能复习中心',
              earnedLp: 50,
              streakDays: 7,
              correctCount: _reviewedCount,
              totalQuestions: _dueItems.length,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('艾宾浩斯智能复习中心', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 艾宾浩斯记忆保留率卡片
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.psychology_rounded, color: Colors.amberAccent, size: 28),
                            const SizedBox(width: 10),
                            const Text(
                              'SM-2 遗忘曲线实时预测',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '今日待复习: ${_dueItems.length} 项',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '艾宾浩斯记忆保留率：20分钟(58%) ➔ 1天(33%) ➔ 6天(25%) ➔ 31天(21%)',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 复习卡片主体
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '复习进度: ${_currentIndex + 1} / ${_dueItems.length}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.blue),
                        onPressed: () => AudioService.instance.speak(_dueItems[_currentIndex]['title']!),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _dueItems[_currentIndex]['type']!,
                              style: TextStyle(fontSize: 12, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _dueItems[_currentIndex]['title']!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dueItems[_currentIndex]['subTitle']!,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                          const Divider(height: 32),

                          if (_showAnswer) ...[
                            Text(
                              _dueItems[_currentIndex]['answer']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _dueItems[_currentIndex]['example']!,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                            ),
                          ] else ...[
                            Center(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade50,
                                  foregroundColor: Colors.blue.shade900,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showAnswer = true;
                                  });
                                },
                                icon: const Icon(Icons.visibility_rounded),
                                label: const Text('点击看答案释义'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SM-2 反馈评价控制按钮
                  if (_showAnswer) ...[
                    const Text(
                      '请根据回忆难度评价 (SM-2 自动计算下次复习周期)：',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade900),
                            onPressed: () => _rateMemory(1, rating: SM2Rating.again),
                            child: const Text('生疏 (1天后)'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100, foregroundColor: Colors.orange.shade900),
                            onPressed: () => _rateMemory(3, rating: SM2Rating.hard),
                            child: const Text('模糊 (3天后)'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100, foregroundColor: Colors.blue.shade900),
                            onPressed: () => _rateMemory(6, rating: SM2Rating.good),
                            child: const Text('掌握 (6天后)'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100, foregroundColor: Colors.green.shade900),
                            onPressed: () => _rateMemory(14, rating: SM2Rating.easy),
                            child: const Text('熟练 (14天后)'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
