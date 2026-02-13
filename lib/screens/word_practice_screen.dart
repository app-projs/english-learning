import 'package:flutter/material.dart';
import '../models/word.dart';

class WordPracticeScreen extends StatefulWidget {
  const WordPracticeScreen({super.key});

  @override
  State<WordPracticeScreen> createState() => _WordPracticeScreenState();
}

class _WordPracticeScreenState extends State<WordPracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Word> _practiceWords = _generateSampleWords();
  final Set<String> _favorites = {};
  int _currentIndex = 0;
  bool _showAnswer = false;
  String? _selectedAnswer;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static List<Word> _generateSampleWords() {
    return [
      Word(
        id: '1',
        english: 'abandon',
        chinese: '放弃；遗弃',
        phonetic: '/əˈbændən/',
        synonyms: ['give up', 'desert'],
        antonyms: ['keep', 'maintain'],
        exampleSentence: 'Never abandon your dreams.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '2',
        english: 'benefit',
        chinese: '利益；好处',
        phonetic: '/ˈbenɪfɪt/',
        synonyms: ['advantage', 'profit'],
        antonyms: ['harm', 'loss'],
        exampleSentence: 'Exercise has many health benefits.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '3',
        english: 'challenge',
        chinese: '挑战',
        phonetic: '/ˈtʃælɪndʒ/',
        synonyms: ['difficulty', 'test'],
        antonyms: ['ease', 'simpleness'],
        exampleSentence: 'I accept the challenge.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '4',
        english: 'determine',
        chinese: '决定；确定',
        phonetic: '/dɪˈtɜːrmɪn/',
        synonyms: ['decide', 'resolve'],
        antonyms: ['hesitate', 'uncertain'],
        exampleSentence: 'She determined to finish the project.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '5',
        english: 'essential',
        chinese: '必要的；本质的',
        phonetic: '/ɪˈsenʃl/',
        synonyms: ['necessary', 'vital'],
        antonyms: ['unnecessary', 'trivial'],
        exampleSentence: 'Water is essential for life.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
    ];
  }

  void _toggleFavorite(String wordId) {
    setState(() {
      if (_favorites.contains(wordId)) {
        _favorites.remove(wordId);
      } else {
        _favorites.add(wordId);
      }
    });
  }

  void _nextWord() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _practiceWords.length;
      _showAnswer = false;
      _selectedAnswer = null;
      _isCorrect = false;
    });
  }

  void _previousWord() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _practiceWords.length) % _practiceWords.length;
      _showAnswer = false;
      _selectedAnswer = null;
      _isCorrect = false;
    });
  }

  void _checkAnswer(String answer) {
    final currentWord = _practiceWords[_currentIndex];
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == currentWord.chinese;
      _showAnswer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单词练习'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.style), text: '卡片模式'),
            Tab(icon: Icon(Icons.quiz), text: '测试模式'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCardMode(),
          _buildTestMode(),
        ],
      ),
    );
  }

  Widget _buildCardMode() {
    final word = _practiceWords[_currentIndex];
    final isFavorite = _favorites.contains(word.id);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${_practiceWords.length}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _toggleFavorite(word.id),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              ),
            ],
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
              child: InkWell(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        word.english,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        word.phonetic,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      if (_showAnswer) ...[
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          word.chinese,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '例句: ${word.exampleSentence}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        const SizedBox(height: 32),
                        const Text(
                          '点击显示答案',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
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
                onPressed: _previousWord,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton.filled(
                onPressed: _nextWord,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestMode() {
    final currentWord = _practiceWords[_currentIndex];
    final wrongAnswers = _practiceWords
        .where((w) => w.id != currentWord.id)
        .map((w) => w.chinese)
        .take(3)
        .toList();

    final options = [currentWord.chinese, ...wrongAnswers]..shuffle();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                currentWord.english,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentWord.phonetic,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                currentWord.exampleSentence,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            '请选择正确的中文翻译:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = option == currentWord.chinese;

              Color? backgroundColor;
              Color? textColor;

              if (_showAnswer) {
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
                  onTap: _showAnswer ? null : () => _checkAnswer(option),
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
        if (_showAnswer) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  _isCorrect ? '正确!' : '错误!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _nextWord,
                  child: const Text('下一题'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
