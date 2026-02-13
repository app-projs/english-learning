import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({super.key});

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  List<Map<String, dynamic>> _wrongAnswers = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  final Set<String> _reviewedIds = {};
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _loadWrongAnswers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错题复习'),
        actions: [
          if (_wrongAnswers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearAll,
              tooltip: '清空错题',
            ),
        ],
      ),
      body: _wrongAnswers.isEmpty ? _buildEmptyState() : _buildReviewMode(),
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
}
