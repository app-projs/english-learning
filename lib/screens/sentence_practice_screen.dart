import 'package:flutter/material.dart';
import '../models/sentence.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import 'completion_congratulation_screen.dart';

class SentencePracticeScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  const SentencePracticeScreen({super.key, this.onCompleted});

  @override
  State<SentencePracticeScreen> createState() => _SentencePracticeScreenState();
}

class _SentencePracticeScreenState extends State<SentencePracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Sentence> _practiceSentences = _generateSampleSentences();
  int _currentIndex = 0;
  bool _showAnswer = false;
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initStorage();
  }

  void _initStorage() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _storageService = storage;
    });
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
                        moduleTitle: '长难句剖析',
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
              isScrollable: true,
              dividerColor: Colors.transparent,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3, color: Colors.blue),
                insets: EdgeInsets.symmetric(horizontal: 16),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              tabs: const [
                Tab(icon: Icon(Icons.text_fields, size: 20), text: '填空练习'),
                Tab(icon: Icon(Icons.sort, size: 20), text: '排序练习'),
                Tab(icon: Icon(Icons.translate, size: 20), text: '翻译练习'),
              ],
            ),
          ),
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

    return _ClozeModeWidget(
      key: ValueKey('cloze_$_currentIndex'),
      sentence: sentence,
      storageService: _storageService,
      onNext: _nextSentence,
      onPrevious: _previousSentence,
      currentIndex: _currentIndex,
      totalCount: _practiceSentences.length,
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

class _ClozeModeWidget extends StatefulWidget {
  final Sentence sentence;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int currentIndex;
  final int totalCount;
  final StorageService? storageService;

  const _ClozeModeWidget({
    super.key,
    required this.sentence,
    required this.onNext,
    required this.onPrevious,
    required this.currentIndex,
    required this.totalCount,
    this.storageService,
  });

  @override
  State<_ClozeModeWidget> createState() => _ClozeModeWidgetState();
}

class _ClozeModeWidgetState extends State<_ClozeModeWidget> {
  String _userEnteredText = '';
  bool _submitted = false;
  bool _isCorrect = false;

  void _showFillInputBottomSheet(String targetBlankWord) {
    final controller = TextEditingController(text: _userEnteredText);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '填空输入',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '中文译义：${widget.sentence.chinese}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (val) {
                    Navigator.pop(ctx);
                    _submitAnswer(val, targetBlankWord);
                  },
                  decoration: InputDecoration(
                    hintText: '请输入下划线处缺失的单词...',
                    prefixIcon: const Icon(Icons.edit, color: Colors.blue),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.blue),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _submitAnswer(controller.text, targetBlankWord);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _submitAnswer(controller.text, targetBlankWord);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('填入并校验', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitAnswer(String val, String targetBlankWord) {
    final input = val.trim();
    if (input.isEmpty) return;

    final cleanTarget = targetBlankWord.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
    final cleanInput = input.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
    final correct = cleanInput == cleanTarget;

    if (!correct) {
      widget.storageService?.addWrongAnswer({
        'id': '${widget.sentence.id}_${DateTime.now().millisecondsSinceEpoch}',
        'type': '句子填空',
        'question': widget.sentence.english,
        'context': widget.sentence.chinese,
        'userAnswer': input,
        'correctAnswer': targetBlankWord,
        'createdAt': DateTime.now().toIso8601String(),
        'reviewed': false,
      });
    }

    setState(() {
      _userEnteredText = input;
      _submitted = true;
      _isCorrect = correct;
    });

    if (correct) {
      AudioService.instance.speak(widget.sentence.english);
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.sentence.english.split(' ');
    final blankIndex = words.length ~/ 2;
    final blankWord = words[blankIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.currentIndex + 1} / ${widget.totalCount}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.blue),
                onPressed: () => AudioService.instance.speak(widget.sentence.english),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    '点击下方【下划线】填入缺少的单词：',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '中文释义：${widget.sentence.chinese}',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 12,
                    children: words.asMap().entries.map((entry) {
                      final index = entry.key;
                      final word = entry.value;
                      if (index != blankIndex) {
                        return Text(
                          word,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        );
                      }

                      Color bg;
                      Color border;
                      Color textCol;
                      IconData? icon;

                      if (!_submitted) {
                        if (_userEnteredText.isEmpty) {
                          bg = Colors.blue.shade50;
                          border = Colors.blue.shade400;
                          textCol = Colors.blue.shade700;
                        } else {
                          bg = Colors.blue.shade100;
                          border = Colors.blue.shade600;
                          textCol = Colors.blue.shade900;
                        }
                      } else {
                        if (_isCorrect) {
                          bg = Colors.green.shade50;
                          border = Colors.green;
                          textCol = Colors.green.shade800;
                          icon = Icons.check_circle;
                        } else {
                          bg = Colors.red.shade50;
                          border = Colors.red;
                          textCol = Colors.red.shade800;
                          icon = Icons.cancel;
                        }
                      }

                      final displayText = _userEnteredText.isEmpty ? '  _____  ' : ' $_userEnteredText ';

                      return InkWell(
                        onTap: () => _showFillInputBottomSheet(blankWord),
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: border, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayText,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textCol,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              if (icon != null) ...[
                                const SizedBox(width: 4),
                                Icon(icon, size: 18, color: textCol),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  if (_submitted) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _isCorrect ? Colors.green : Colors.red),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isCorrect ? Icons.check_circle : Icons.cancel,
                                color: _isCorrect ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isCorrect ? '填空正确！🎉' : '填空不正确，正确单词为："$blankWord"',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '完整句子：${widget.sentence.english}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          if (!_isCorrect) ...[
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: () => _showFillInputBottomSheet(blankWord),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('重新填空'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app, size: 18, color: Colors.blue.shade400),
                        const SizedBox(width: 6),
                        Text(
                          '点击上面的下划线区域进行填空',
                          style: TextStyle(fontSize: 13, color: Colors.blue.shade600),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: widget.currentIndex > 0 ? widget.onPrevious : null,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton.filled(
                onPressed: widget.onNext,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
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
