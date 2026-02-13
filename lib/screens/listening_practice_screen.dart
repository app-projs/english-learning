import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ListeningPracticeScreen extends StatefulWidget {
  const ListeningPracticeScreen({super.key});

  @override
  State<ListeningPracticeScreen> createState() =>
      _ListeningPracticeScreenState();
}

class _ListeningPracticeScreenState extends State<ListeningPracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedScenarioIndex = 0;
  bool _isPlaying = false;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showAnswer = false;
  int _correctCount = 0;
  int _totalQuestions = 0;
  StorageService? _storageService;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': '日常对话',
      'description': '日常生活中的简单对话',
      'icon': Icons.home,
      'color': Colors.blue,
      'difficulty': '简单',
      'questions': [
        {
          'question': 'What time is the meeting?',
          'options': ['9点', '10点', '11点', '12点'],
          'correct': '10点',
          'audioText': 'A: When is the meeting? B: It starts at 10 o\'clock.',
        },
        {
          'question': 'Where is the supermarket?',
          'options': ['左边', '右边', '前面', '后面'],
          'correct': '左边',
          'audioText':
              'A: Excuse me, where is the supermarket? B: It\'s on the left side.',
        },
        {
          'question': 'How much is this book?',
          'options': ['10美元', '20美元', '30美元', '40美元'],
          'correct': '20美元',
          'audioText': 'A: How much is this book? B: It costs 20 dollars.',
        },
      ],
    },
    {
      'title': '餐厅点餐',
      'description': '餐厅场景对话练习',
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'difficulty': '中等',
      'questions': [
        {
          'question': 'What would the man like to order?',
          'options': ['汉堡', '披萨', '面条', '沙拉'],
          'correct': '披萨',
          'audioText':
              'A: What would you like? B: I would like a pizza, please.',
        },
        {
          'question': 'Does the woman want dessert?',
          'options': ['是', '否', '不确定', '还没决定'],
          'correct': '是',
          'audioText':
              'A: Would you like some dessert? B: Yes, I\'d love some ice cream.',
        },
        {
          'question': 'How will they pay?',
          'options': ['现金', '信用卡', '手机支付', '支票'],
          'correct': '信用卡',
          'audioText':
              'A: How would you like to pay? B: We\'ll pay by credit card.',
        },
      ],
    },
    {
      'title': '问路指路',
      'description': '问路和指路场景',
      'icon': Icons.directions,
      'color': Colors.green,
      'difficulty': '中等',
      'questions': [
        {
          'question': 'How far is the station?',
          'options': ['5分钟', '10分钟', '15分钟', '20分钟'],
          'correct': '10分钟',
          'audioText':
              'A: How far is the train station? B: It\'s about 10 minutes walk.',
        },
        {
          'question': 'Should they turn left or right?',
          'options': ['左转', '右转', '直走', '掉头'],
          'correct': '左转',
          'audioText': 'A: Turn left at the second traffic light.',
        },
        {
          'question': 'Is the bank open today?',
          'options': ['是', '否', '不确定', '只开半天'],
          'correct': '是',
          'audioText': 'A: Is the bank open on Saturdays? B: Yes, it is.',
        },
      ],
    },
    {
      'title': '购物场景',
      'description': '商场购物对话',
      'icon': Icons.shopping_bag,
      'color': Colors.purple,
      'difficulty': '简单',
      'questions': [
        {
          'question': 'What size does she need?',
          'options': ['S', 'M', 'L', 'XL'],
          'correct': 'M',
          'audioText': 'A: What size do you need? B: I need a medium size.',
        },
        {
          'question': 'Is there a discount today?',
          'options': ['8折', '9折', '没有', '7折'],
          'correct': '9折',
          'audioText':
              'A: Is there a discount today? B: Yes, we have a 10% discount.',
        },
        {
          'question': 'What color does he prefer?',
          'options': ['红色', '蓝色', '黑色', '白色'],
          'correct': '蓝色',
          'audioText': 'A: Which color do you prefer? B: I prefer blue.',
        },
      ],
    },
    {
      'title': '电话交流',
      'description': '电话对话场景',
      'icon': Icons.phone,
      'color': Colors.red,
      'difficulty': '困难',
      'questions': [
        {
          'question': 'Who is calling?',
          'options': ['Tom', 'John', 'Mike', 'David'],
          'correct': 'John',
          'audioText': 'A: Hello, this is John. May I speak to Mary?',
        },
        {
          'question': 'When will they meet?',
          'options': ['今天', '明天', '后天', '下周'],
          'correct': '明天',
          'audioText': 'A: Can we meet tomorrow? B: Sure, see you tomorrow.',
        },
        {
          'question': 'What is the phone number?',
          'options': ['123-4567', '234-5678', '345-6789', '456-7890'],
          'correct': '234-5678',
          'audioText': 'A: What\'s your phone number? B: It\'s 234-5678.',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storageService = await StorageService.getInstance();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startScenario(int index) {
    setState(() {
      _selectedScenarioIndex = index;
      _currentQuestionIndex = 0;
      _correctCount = 0;
      _totalQuestions = _scenarios[index]['questions'].length;
      _showAnswer = false;
      _selectedAnswer = null;
    });
    _tabController.animateTo(1);
  }

  void _playAudio(String text) {
    setState(() {
      _isPlaying = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _checkAnswer(String answer) {
    final questions = _scenarios[_selectedScenarioIndex]['questions'];
    final currentQuestion = questions[_currentQuestionIndex];
    final correctAnswer = currentQuestion['correct'];
    final isCorrect = answer == correctAnswer;

    if (!isCorrect) {
      _storageService?.addWrongAnswer({
        'id':
            '${_selectedScenarioIndex}_${_currentQuestionIndex}_${DateTime.now().millisecondsSinceEpoch}',
        'type': '听力',
        'question': currentQuestion['question'],
        'context': currentQuestion['audioText'],
        'userAnswer': answer,
        'correctAnswer': correctAnswer,
        'createdAt': DateTime.now().toIso8601String(),
        'reviewed': false,
      });
    }

    setState(() {
      _selectedAnswer = answer;
      _showAnswer = true;
      if (isCorrect) {
        _correctCount++;
      }
    });
  }

  void _nextQuestion() {
    final questions = _scenarios[_selectedScenarioIndex]['questions'];
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showAnswer = false;
        _selectedAnswer = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('练习完成!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _correctCount == _totalQuestions
                  ? Icons.star
                  : Icons.emoji_events,
              size: 64,
              color: _correctCount == _totalQuestions
                  ? Colors.amber
                  : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              '正确: $_correctCount / $_totalQuestions',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _correctCount == _totalQuestions
                  ? '太棒了! 全对!'
                  : _correctCount >= _totalQuestions * 0.7
                      ? '做得不错!'
                      : '继续加油!',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
            child: const Text('返回'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startScenario(_selectedScenarioIndex);
            },
            child: const Text('再试一次'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('听力练习'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: '场景选择'),
            Tab(icon: Icon(Icons.headphones), text: '开始练习'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScenarioList(),
          _buildPracticeMode(),
        ],
      ),
    );
  }

  Widget _buildScenarioList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scenarios.length,
      itemBuilder: (context, index) {
        final scenario = _scenarios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _startScenario(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: scenario['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      scenario['icon'],
                      color: scenario['color'],
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scenario['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt,
                              size: 16,
                              color:
                                  _getDifficultyColor(scenario['difficulty']),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              scenario['difficulty'],
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    _getDifficultyColor(scenario['difficulty']),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.quiz,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${scenario['questions'].length} 题',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '简单':
        return Colors.green;
      case '中等':
        return Colors.orange;
      case '困难':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPracticeMode() {
    final questions = _scenarios[_selectedScenarioIndex]['questions'];
    if (questions.isEmpty) {
      return const Center(child: Text('请先选择一个场景'));
    }

    final currentQuestion = questions[_currentQuestionIndex];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '场景: ${_scenarios[_selectedScenarioIndex]['title']}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentQuestionIndex + 1} / ${questions.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / questions.length,
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.hearing, size: 48, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  '听力题目',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentQuestion['question'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isPlaying
                            ? null
                            : () => _playAudio(currentQuestion['audioText']),
                        icon: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                        label: Text(_isPlaying ? '播放中...' : '播放听力'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      if (_isPlaying) ...[
                        const SizedBox(height: 8),
                        const Text(
                          '🔊 正在播放听力材料...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '请选择正确答案:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: (currentQuestion['options'] as List).length,
            itemBuilder: (context, index) {
              final option = currentQuestion['options'][index];
              final isSelected = _selectedAnswer == option;
              final isCorrect = option == currentQuestion['correct'];

              Color? backgroundColor;
              Color? borderColor;

              if (_showAnswer) {
                if (isCorrect) {
                  backgroundColor = Colors.green.shade100;
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrect) {
                  backgroundColor = Colors.red.shade100;
                  borderColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: _showAnswer ? null : () => _checkAnswer(option),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor ?? Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? (borderColor ??
                                    Theme.of(context).colorScheme.primary)
                                : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (_showAnswer && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_showAnswer && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_showAnswer) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _selectedAnswer == currentQuestion['correct'] ? '正确!' : '错误!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _selectedAnswer == currentQuestion['correct']
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentQuestionIndex < questions.length - 1
                        ? '下一题'
                        : '查看结果',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
