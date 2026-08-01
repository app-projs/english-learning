import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({super.key});

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _wrongAnswers = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  final Set<String> _reviewedIds = {};
  StorageService? _storageService;
  final TextEditingController _eliminateInputController = TextEditingController();
  bool _showEliminateFeedback = false;
  bool _isEliminated = false;
  bool _isAutoLooping = false;
  int _autoLoopIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWrongAnswers();
  }

  @override
  void dispose() {
    _isAutoLooping = false;
    AudioService.instance.stop();
    _tabController.dispose();
    _eliminateInputController.dispose();
    super.dispose();
  }

  void _toggleAutoLoop() {
    if (_wrongAnswers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无错题可连播')),
      );
      return;
    }
    setState(() {
      _isAutoLooping = !_isAutoLooping;
      if (_isAutoLooping) {
        _autoLoopIndex = 0;
        _startAutoLoopNext();
      } else {
        AudioService.instance.stop();
      }
    });
  }

  Future<void> _startAutoLoopNext() async {
    if (!_isAutoLooping || !mounted || _wrongAnswers.isEmpty) return;

    if (_autoLoopIndex >= _wrongAnswers.length) {
      _autoLoopIndex = 0;
    }

    final item = _wrongAnswers[_autoLoopIndex];
    final text = (item['question'] ?? item['word'] ?? '').toString();

    setState(() {
      _currentIndex = _autoLoopIndex;
    });

    if (text.isNotEmpty) {
      AudioService.instance.speak(text);
    }

    await Future.delayed(const Duration(seconds: 4));
    if (!_isAutoLooping || !mounted) return;

    _autoLoopIndex++;
    _startAutoLoopNext();
  }

  Future<void> _loadWrongAnswers() async {
    _storageService = await StorageService.getInstance();
    final answers = _storageService!.getWrongAnswers();
    setState(() {
      _wrongAnswers = answers;
    });
  }

  Future<void> _markAsReviewed(String id) async {
    await _storageService?.markWrongAnswerReviewed(id);
    setState(() {
      _reviewedIds.add(id);
    });
  }

  Future<void> _removeWrongAnswer(String id) async {
    await _storageService?.removeWrongAnswer(id);
    setState(() {
      _wrongAnswers.removeWhere((item) => item['id'] == id);
      if (_currentIndex >= _wrongAnswers.length && _currentIndex > 0) {
        _currentIndex--;
      }
      _showAnswer = false;
    });
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空错题'),
        content: const Text('确定要清空所有错题记录吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('清空'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService?.clearWrongAnswers();
      setState(() {
        _wrongAnswers = [];
        _currentIndex = 0;
        _showAnswer = false;
      });
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _wrongAnswers.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  void _exportWrongAnswers() {
    if (_wrongAnswers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无错题记录')),
      );
      return;
    }

    final dateStr = DateTime.now().toString().split(' ')[0];
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('==========================================');
    buffer.writeln('  Lumina English · 英语错题巩固打印清单');
    buffer.writeln('  生成日期: $dateStr  |  错题数量: ${_wrongAnswers.length} 道');
    buffer.writeln('==========================================\n');

    for (int i = 0; i < _wrongAnswers.length; i++) {
      final item = _wrongAnswers[i];
      buffer.writeln('${(i + 1).toString().padLeft(2, '0')}. 题目: ${item['question']}');
      buffer.writeln('    解题分析: 正确答案【 ${item['correctAnswer']} 】');
      if (item['userAnswer'] != null) {
        buffer.writeln('    我的答案: ${item['userAnswer']}');
      }
      buffer.writeln('------------------------------------------');
    }

    final text = buffer.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text('错题巩固清单导出'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.print_rounded, color: Colors.deepOrange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '标准错题打印单已生成 ($dateStr)，支持 TXT 导出与剪贴板复制。',
                          style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  text,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace', height: 1.4),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('保存为 TXT/PDF'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📄 错题巩固清单已导出并成功保存至本地文件目录！'),
                  backgroundColor: Colors.deepOrange,
                ),
              );
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('一键复制'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制错题清单到剪贴板！')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错题复习'),
        actions: [
          IconButton(
            onPressed: _toggleAutoLoop,
            icon: Icon(
              _isAutoLooping ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: _isAutoLooping ? Colors.amberAccent : null,
            ),
            tooltip: _isAutoLooping ? '暂停错题连播' : '错题发音连播',
          ),
          IconButton(
            icon: const Icon(Icons.output_rounded),
            onPressed: _exportWrongAnswers,
            tooltip: '导出错题清单',
          ),
          if (_wrongAnswers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearAll,
              tooltip: '清空错题',
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: Colors.blue),
              insets: EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            tabs: const [
              Tab(icon: Icon(Icons.style, size: 20), text: '浏览卡片'),
              Tab(icon: Icon(Icons.local_fire_department, size: 20), text: '消灭错题'),
            ],
          ),
        ),
      ),
      body: _wrongAnswers.isEmpty
          ? _buildEmptyState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildReviewMode(),
                _buildEliminateMode(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 24),
          const Text(
            '太棒了！',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '暂无错题记录',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '继续练习，错了的题目会在这里显示',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewMode() {
    final currentWrong = _wrongAnswers[_currentIndex];
    final isReviewed = _reviewedIds.contains(currentWrong['id']) ||
        currentWrong['reviewed'] == true;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '题目类型: ${currentWrong['type'] ?? '练习'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentIndex + 1} / ${_wrongAnswers.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _wrongAnswers.length,
          backgroundColor: Colors.grey.shade200,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          currentWrong['question'] ?? '请选择正确含义',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (currentWrong['context'] != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentWrong['context'],
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        InkWell(
                          onTap: () =>
                              setState(() => _showAnswer = !_showAnswer),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _showAnswer
                                  ? Colors.red.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _showAnswer
                                    ? Colors.red.shade200
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _showAnswer
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _showAnswer ? '隐藏答案' : '显示答案',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_showAnswer) ...[
                                  const Divider(height: 24),
                                  Text(
                                    '你的答案: ${currentWrong['userAnswer']}',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '正确答案: ${currentWrong['correctAnswer']}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showAnswer && !isReviewed) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _markAsReviewed(currentWrong['id']),
                    icon: const Icon(Icons.check),
                    label: const Text('标记为已复习'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
                if (isReviewed) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          '已复习',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _removeWrongAnswer(currentWrong['id']),
                  icon: const Icon(Icons.delete),
                  label: const Text('移除此题'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _currentIndex > 0 ? _previousQuestion : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('上一题'),
              ),
              ElevatedButton.icon(
                onPressed: _currentIndex < _wrongAnswers.length - 1
                    ? _nextQuestion
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('下一题'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEliminateMode() {
    if (_wrongAnswers.isEmpty) return _buildEmptyState();

    final currentWrong = _wrongAnswers[_currentIndex];
    final correctAnswer = (currentWrong['correctAnswer'] as String? ?? '').trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade700, Colors.red.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '消灭错题挑战',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '再次回答正确即可自动从错题本中移除',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '类型: ${currentWrong['type'] ?? '错题'}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentWrong['question'] ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (currentWrong['context'] != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentWrong['context'],
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _eliminateInputController,
            enabled: !_showEliminateFeedback,
            decoration: InputDecoration(
              hintText: '请输入正确的答案/单词...',
              prefixIcon: const Icon(Icons.bolt, color: Colors.amber),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 16),
          if (!_showEliminateFeedback)
            ElevatedButton(
              onPressed: () {
                final userInput = _eliminateInputController.text.trim().toLowerCase();
                final targetInput = correctAnswer.toLowerCase();
                final isMatch = userInput == targetInput;

                setState(() {
                  _showEliminateFeedback = true;
                  _isEliminated = isMatch;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('挑战消灭', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          if (_showEliminateFeedback) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isEliminated ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isEliminated ? Colors.green : Colors.red),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isEliminated ? Icons.workspace_premium : Icons.dangerous,
                        color: _isEliminated ? Colors.green : Colors.red,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEliminated ? '🎉 挑战成功！错题已被消灭！' : '❌ 答案不符',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isEliminated ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('标准答案: $correctAnswer', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final targetId = currentWrong['id'];
                if (_isEliminated && targetId != null) {
                  await _removeWrongAnswer(targetId);
                }
                _eliminateInputController.clear();
                setState(() {
                  _showEliminateFeedback = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              child: Text(_isEliminated ? '移除此题并继续' : '重新尝试'),
            ),
          ],
        ],
      ),
    );
  }
}
