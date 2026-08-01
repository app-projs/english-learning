import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import 'completion_congratulation_screen.dart';

class ListeningPracticeScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  const ListeningPracticeScreen({super.key, this.onCompleted});

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
  double _speechRate = 1.0;
  final TextEditingController _dictationController = TextEditingController();
  bool _showDictationAnswer = false;
  bool _isDictationCorrect = false;

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
      'color': Colors.indigo,
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

  int _dictationChallengeIndex = 0;
  bool _isChallengeBlind = true;
  bool _isChallengeSlow = false;
  bool _hasSubmittedChallenge = false;
  final TextEditingController _challengeInputController = TextEditingController();

  final List<Map<String, String>> _challengeSentences = const [
    {
      'title': '校园与学习',
      'english': 'Practice makes perfect, and daily study brings great progress.',
      'chinese': '熟能生巧，每天的学习都会带来巨大的进步。',
      'hint': '提示词: practice, study, progress',
    },
    {
      'title': '科技与未来',
      'english': 'Artificial intelligence is changing the way we live and work every day.',
      'chinese': '人工智能正在改变我们每天生活和工作的方式。',
      'hint': '提示词: intelligence, changing, everyday',
    },
    {
      'title': '商务与职场',
      'english': 'We look forward to establishing a long term business partnership with you.',
      'chinese': '我们非常期待与贵公司建立长期稳定的商业合作伙伴关系。',
      'hint': '提示词: establishing, partnership, business',
    },
    {
      'title': '环境与自然',
      'english': 'Protecting the environment is essential for the future of our planet.',
      'chinese': '保护环境对于我们这个星球的未来至关重要。',
      'hint': '提示词: protecting, environment, essential',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storageService = await StorageService.getInstance();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _tabController.dispose();
    _dictationController.dispose();
    _challengeInputController.dispose();
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
    AudioService.instance.speak(text, speechRate: _speechRate, onComplete: () {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: InkWell(
                onTap: () {
                  widget.onCompleted?.call();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompletionCongratulationScreen(
                        moduleTitle: '听力理解',
                        earnedLp: 50,
                        streakDays: 7,
                      ),
                    ),
                  );
                },
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
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.transparent,
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
                Tab(icon: Icon(Icons.list, size: 20), text: '场景选择'),
                Tab(icon: Icon(Icons.headphones, size: 20), text: '单选练习'),
                Tab(icon: Icon(Icons.edit_note, size: 20), text: '听写填空'),
                Tab(icon: Icon(Icons.repeat, size: 20), text: '逐句精听'),
                Tab(icon: Icon(Icons.spellcheck_rounded, size: 20), text: '断句听写'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScenarioList(),
          _buildPracticeMode(),
          _buildDictationMode(),
          _buildIntensiveRepeatMode(),
          _buildDictationChallengeTab(),
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
                      const SizedBox(height: 12),
                      _buildSpeedSelector(),
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

  Widget _buildSpeedSelector() {
    final speeds = [0.8, 1.0, 1.2, 1.5];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('语速: ', style: TextStyle(fontSize: 13, color: Colors.grey)),
        ...speeds.map((rate) {
          final isSelected = (_speechRate == rate);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text('${rate}x'),
              selected: isSelected,
              selectedColor: Colors.blue.shade100,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _speechRate = rate;
                  });
                }
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDictationMode() {
    final questions = _scenarios[_selectedScenarioIndex]['questions'];
    if (questions.isEmpty) {
      return const Center(child: Text('请先选择一个场景'));
    }

    final currentQuestion = questions[_currentQuestionIndex];
    final targetText = currentQuestion['audioText'] as String;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '听写场景: ${_scenarios[_selectedScenarioIndex]['title']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentQuestionIndex + 1} / ${questions.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.keyboard_voice, size: 48, color: Colors.indigo),
                  const SizedBox(height: 12),
                  const Text(
                    '请听音频并拼写出听到的英文句子/内容',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isPlaying ? null : () => _playAudio(targetText),
                    icon: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                    label: Text(_isPlaying ? '播放中...' : '点击播放音频'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSpeedSelector(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _dictationController,
            enabled: !_showDictationAnswer,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '在此输入听到的英文内容...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 16),
          if (!_showDictationAnswer)
            ElevatedButton(
              onPressed: () {
                final userText = _dictationController.text.trim().toLowerCase();
                final targetClean = targetText.trim().toLowerCase();
                final isCorrect = userText == targetClean;

                if (!isCorrect) {
                  _storageService?.addWrongAnswer({
                    'id': 'dict_${_selectedScenarioIndex}_${_currentQuestionIndex}_${DateTime.now().millisecondsSinceEpoch}',
                    'type': '听力听写',
                    'question': '听写练习: ${currentQuestion['question']}',
                    'context': targetText,
                    'userAnswer': _dictationController.text.trim(),
                    'correctAnswer': targetText,
                    'createdAt': DateTime.now().toIso8601String(),
                    'reviewed': false,
                  });
                }

                setState(() {
                  _showDictationAnswer = true;
                  _isDictationCorrect = isCorrect;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('提交听写'),
            ),
          if (_showDictationAnswer) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDictationCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isDictationCorrect ? Colors.green : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isDictationCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isDictationCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isDictationCorrect ? '听写完美全对!' : '听写文本差异分析',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isDictationCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('单词比对与准确度：', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  _buildWordMatchDiff(_dictationController.text, targetText),
                  const SizedBox(height: 12),
                  const Text('标准原文:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(targetText, style: const TextStyle(fontSize: 15, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  const Text('你的听写:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_dictationController.text, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _dictationController.clear();
                _nextQuestion();
                setState(() {
                  _showDictationAnswer = false;
                });
              },
              child: Text(
                _currentQuestionIndex < questions.length - 1 ? '下一题' : '完成练习',
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _repeatSentenceIndex = -1;
  bool _hideEnglishSubtitle = false;
  bool _isLoopingSingle = false;

  Widget _buildIntensiveRepeatMode() {
    final scenario = _scenarios[_selectedScenarioIndex];
    final questions = scenario['questions'] as List;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: isDark ? const Color(0xFF1E293B) : Colors.blue.shade50,
          child: Row(
            children: [
              Text(
                '场景: ${scenario['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Spacer(),
              ChoiceChip(
                label: Text(_hideEnglishSubtitle ? '🙈 盲听模式 (字幕已遮挡)' : '👁️ 显示字幕'),
                selected: _hideEnglishSubtitle,
                onSelected: (val) {
                  setState(() {
                    _hideEnglishSubtitle = val;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final String audioText = q['audioText'] ?? q['question'];
              final isThisLooping = _repeatSentenceIndex == index && _isLoopingSingle;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isThisLooping
                        ? Colors.blue
                        : (isDark ? Colors.white10 : Colors.grey.shade200),
                    width: isThisLooping ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '句型练习 #${index + 1}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            AudioService.instance.speak(audioText, speechRate: 0.7);
                          },
                          child: const Text('🐢 0.7x 慢速'),
                        ),
                        IconButton(
                          icon: Icon(
                            isThisLooping ? Icons.repeat_one_on : Icons.repeat,
                            color: isThisLooping ? Colors.blue : Colors.grey,
                          ),
                          tooltip: '单句循环复读',
                          onPressed: () {
                            setState(() {
                              if (isThisLooping) {
                                _isLoopingSingle = false;
                                _repeatSentenceIndex = -1;
                              } else {
                                _isLoopingSingle = true;
                                _repeatSentenceIndex = index;
                                _playAudio(audioText);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.blue),
                          onPressed: () => _playAudio(audioText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_hideEnglishSubtitle)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🙈 英文字幕已隐藏 (请盲听尝试复述，点击顶部开关开启字幕)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    else
                      Text(
                        audioText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      '配套问题: ${q['question']}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWordMatchDiff(String userText, String targetText) {
    final targetWords = targetText.replaceAll(RegExp(r'[^\w\s]'), '').split(' ');
    final userWords = userText.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase().split(' ');

    int matchedCount = 0;
    final List<TextSpan> spans = [];

    for (var w in targetWords) {
      if (w.trim().isEmpty) continue;
      final cleanW = w.toLowerCase();
      if (userWords.contains(cleanW)) {
        matchedCount++;
        spans.add(TextSpan(
          text: '$w ',
          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
        ));
      } else {
        spans.add(TextSpan(
          text: '$w ',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: TextDecoration.lineThrough,
          ),
        ));
      }
    }

    final totalTarget = targetWords.where((w) => w.trim().isNotEmpty).length;
    final accuracy = totalTarget > 0 ? ((matchedCount / totalTarget) * 100).toInt() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accuracy >= 80 ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '匹配度: $accuracy%',
                style: TextStyle(
                  color: accuracy >= 80 ? Colors.green.shade900 : Colors.orange.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '匹配词汇: $matchedCount / $totalTarget',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RichText(text: TextSpan(children: spans)),
      ],
    );
  }

  Widget _buildDictationChallengeTab() {
    final item = _challengeSentences[_dictationChallengeIndex];
    final targetEnglish = item['english']!;
    final targetChinese = item['chinese']!;
    final hint = item['hint']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
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
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '第 ${_dictationChallengeIndex + 1} / ${_challengeSentences.length} 关 · ${item['title']}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isChallengeBlind ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          tooltip: _isChallengeBlind ? '盲听遮挡已开启' : '参考显示已开启',
                          onPressed: () {
                            setState(() {
                              _isChallengeBlind = !_isChallengeBlind;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isChallengeSlow ? Icons.slow_motion_video : Icons.speed,
                            color: _isChallengeSlow ? Colors.amberAccent : Colors.white,
                          ),
                          tooltip: _isChallengeSlow ? '当前: 0.7x 慢速' : '当前: 标准语速',
                          onPressed: () {
                            setState(() {
                              _isChallengeSlow = !_isChallengeSlow;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (!_isChallengeBlind) ...[
                  Text(
                    targetEnglish,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    targetChinese,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.white70, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '🙈 盲听专区 · 点击原声盲听并听写完整英文',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(hint, style: const TextStyle(color: Colors.amberAccent, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Audio Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 26),
                  label: Text(_isChallengeSlow ? '▶ 慢速播放 (0.7x)' : '▶ 播放原声 (1.0x)'),
                  onPressed: () {
                    final rate = _isChallengeSlow ? 0.7 : 1.0;
                    AudioService.instance.speak(targetEnglish, speechRate: rate);
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade50,
                  foregroundColor: Colors.purple.shade800,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => AudioService.instance.speak(targetEnglish, speechRate: 0.7),
                child: const Icon(Icons.repeat, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dictation Input Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✏️ 盲听听写输入框',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _challengeInputController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '请输入你听到的完整英文句子...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.purple.shade600, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('清空'),
                      onPressed: () {
                        _challengeInputController.clear();
                        setState(() {
                          _hasSubmittedChallenge = false;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: const Text('提交听写'),
                      onPressed: () {
                        if (_challengeInputController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('请先输入你听到的句子文本')),
                          );
                          return;
                        }
                        setState(() {
                          _hasSubmittedChallenge = true;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dictation Results & Word-by-Word Diff
          if (_hasSubmittedChallenge) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.shade100, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 逐词听写差异比对报告',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple),
                  ),
                  const SizedBox(height: 12),
                  _buildWordMatchDiff(_challengeInputController.text, targetEnglish),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    '中文参考：$targetChinese',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.favorite_border, size: 18),
                        label: const Text('收藏该句'),
                        onPressed: () {
                          _storageService?.addFavorite(targetEnglish);
                          // Optionally store additional metadata elsewhere if needed
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已成功将听写句型加入收藏！')),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(_dictationChallengeIndex < _challengeSentences.length - 1 ? '下一关' : '完成全部关卡'),
                        onPressed: () {
                          if (_dictationChallengeIndex < _challengeSentences.length - 1) {
                            setState(() {
                              _dictationChallengeIndex++;
                              _challengeInputController.clear();
                              _hasSubmittedChallenge = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🎉 恭喜完成全部断句听写挑战关卡！')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
