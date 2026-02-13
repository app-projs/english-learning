import 'package:flutter/material.dart';
import '../models/sentence.dart';

class SentencePracticeScreen extends StatefulWidget {
  const SentencePracticeScreen({super.key});

  @override
  State<SentencePracticeScreen> createState() => _SentencePracticeScreenState();
}

class _SentencePracticeScreenState extends State<SentencePracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Sentence> _practiceSentences = _generateSampleSentences();
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static List<Sentence> _generateSampleSentences() {
    return [
      Sentence(
        id: '1',
        english: 'The sun rises in the east.',
        chinese: '太阳从东方升起。',
        keyWords: [],
        difficulty: 'easy',
        category: 'daily',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '2',
        english: 'She is reading a book in the library.',
        chinese: '她正在图书馆看书。',
        keyWords: [],
        difficulty: 'medium',
        category: 'daily',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '3',
        english: 'If you work hard, you will succeed.',
        chinese: '如果你努力工作，你就会成功。',
        keyWords: [],
        difficulty: 'medium',
        category: 'grammar',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '4',
        english: 'The more you practice, the better you become.',
        chinese: '练习越多，你越好。',
        keyWords: [],
        difficulty: 'hard',
        category: 'grammar',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '5',
        english: 'Learning English takes time and patience.',
        chinese: '学习英语需要时间和耐心。',
        keyWords: [],
        difficulty: 'easy',
        category: 'learning',
        createdAt: DateTime.now(),
      ),
    ];
  }

  void _nextSentence() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _practiceSentences.length;
      _showAnswer = false;
    });
  }

  void _previousSentence() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _practiceSentences.length) %
          _practiceSentences.length;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('句子练习'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.text_fields), text: '填空练习'),
            Tab(icon: Icon(Icons.sort), text: '排序练习'),
            Tab(icon: Icon(Icons.translate), text: '翻译练习'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClozeMode(),
          _buildSortMode(),
          _buildTranslateMode(),
        ],
      ),
    );
  }

  Widget _buildClozeMode() {
    final sentence = _practiceSentences[_currentIndex];
    final words = sentence.english.split(' ');
    final blankIndex = words.length ~/ 2;
    final blankWord = words[blankIndex];
    final displayWords = [...words];
    displayWords[blankIndex] = '_____';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${_currentIndex + 1} / ${_practiceSentences.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '请填写空缺的单词:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 12,
                      children: displayWords.asMap().entries.map((entry) {
                        final isBlank = entry.key == blankIndex;
                        return Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                isBlank ? FontWeight.bold : FontWeight.normal,
                            color: isBlank
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black87,
                            decoration:
                                isBlank ? TextDecoration.underline : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    if (_showAnswer) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '答案: $blankWord',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sentence.chinese,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _showAnswer = true),
                        icon: const Icon(Icons.visibility),
                        label: const Text('显示答案'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: _previousSentence,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton.filled(
                onPressed: _nextSentence,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortMode() {
    final sentence = _practiceSentences[_currentIndex];
    final words = sentence.english.split(' ');
    final shuffledWords = [...words]..shuffle();
    final List<String> availableWords = [...shuffledWords];

    return _SortModeWidget(
      key: ValueKey('sort_$_currentIndex'),
      sentence: sentence,
      availableWords: availableWords,
      onNext: _nextSentence,
      onPrevious: _previousSentence,
      currentIndex: _currentIndex,
      totalCount: _practiceSentences.length,
    );
  }

  Widget _buildTranslateMode() {
    final sentence = _practiceSentences[_currentIndex];
    final wrongAnswers = _practiceSentences
        .where((s) => s.id != sentence.id)
        .map((s) => s.chinese)
        .take(3)
        .toList();
    final options = [sentence.chinese, ...wrongAnswers]..shuffle();

    return _TranslateModeWidget(
      key: ValueKey('translate_$_currentIndex'),
      sentence: sentence,
      options: options,
      onNext: _nextSentence,
      onPrevious: _previousSentence,
      currentIndex: _currentIndex,
      totalCount: _practiceSentences.length,
    );
  }
}

class _SortModeWidget extends StatefulWidget {
  final Sentence sentence;
  final List<String> availableWords;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int currentIndex;
  final int totalCount;

  const _SortModeWidget({
    super.key,
    required this.sentence,
    required this.availableWords,
    required this.onNext,
    required this.onPrevious,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  State<_SortModeWidget> createState() => _SortModeWidgetState();
}

class _SortModeWidgetState extends State<_SortModeWidget> {
  late List<String> _userAnswer;
  late List<String> _availableWords;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _userAnswer = [];
    _availableWords = [...widget.availableWords];
  }

  void _addWord(String word) {
    setState(() {
      _availableWords.remove(word);
      _userAnswer.add(word);
    });
  }

  void _removeWord(int index) {
    setState(() {
      final word = _userAnswer.removeAt(index);
      _availableWords.add(word);
    });
  }

  void _checkAnswer() {
    final correctAnswer = widget.sentence.english.split(' ');
    final isCorrect = _userAnswer.length == correctAnswer.length &&
        _userAnswer.every((word) => correctAnswer.contains(word)) &&
        correctAnswer.every((word) => _userAnswer.contains(word));

    setState(() {
      _showResult = true;
    });

    if (!isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('正确答案是: ${widget.sentence.english}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      _userAnswer = [];
      _availableWords = [...widget.availableWords];
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${widget.currentIndex + 1} / ${widget.totalCount}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            '请将单词排成正确的句子:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _userAnswer.asMap().entries.map((entry) {
                    return ActionChip(
                      label: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          _showResult ? null : () => _removeWord(entry.key),
                    );
                  }).toList(),
                ),
                if (_userAnswer.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '点击下方单词添加到句子中',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('可选单词:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _availableWords.map((word) {
            return ActionChip(
              label: Text(word, style: const TextStyle(fontSize: 14)),
              onPressed: _showResult ? null : () => _addWord(word),
            );
          }).toList(),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_showResult)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _userAnswer.join(' ') == widget.sentence.english
                            ? '正确!'
                            : '错误!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              _userAnswer.join(' ') == widget.sentence.english
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.sentence.chinese,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    onPressed: widget.onPrevious,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  if (!_showResult)
                    ElevatedButton(
                      onPressed: _userAnswer.isEmpty ? null : _checkAnswer,
                      child: const Text('检查答案'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _reset,
                      child: const Text('重新排序'),
                    ),
                  IconButton.filled(
                    onPressed: widget.onNext,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TranslateModeWidget extends StatefulWidget {
  final Sentence sentence;
  final List<String> options;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int currentIndex;
  final int totalCount;

  const _TranslateModeWidget({
    super.key,
    required this.sentence,
    required this.options,
    required this.onNext,
    required this.onPrevious,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  State<_TranslateModeWidget> createState() => _TranslateModeWidgetState();
}

class _TranslateModeWidgetState extends State<_TranslateModeWidget> {
  String? _selectedAnswer;
  bool _showResult = false;

  void _checkAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });
  }

  void _reset() {
    setState(() {
      _selectedAnswer = null;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedAnswer == widget.sentence.chinese;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                '请选择正确的中文翻译:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.sentence.english,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              final option = widget.options[index];
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = option == widget.sentence.chinese;

              Color? backgroundColor;
              Color? textColor;

              if (_showResult) {
                if (isCorrectAnswer) {
                  backgroundColor = Colors.green.shade100;
                  textColor = Colors.green.shade800;
                } else if (isSelected && !isCorrectAnswer) {
                  backgroundColor = Colors.red.shade100;
                  textColor = Colors.red.shade800;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: _showResult ? null : () => _checkAnswer(option),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor ?? Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_showResult) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  isCorrect ? '正确!' : '错误!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('再试一次'),
                ),
              ],
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: widget.onPrevious,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton.filled(
                onPressed: widget.onNext,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
