import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/sm2_service.dart';
import '../theme/lumina_theme.dart';
import 'completion_congratulation_screen.dart';
import 'goal_setting_screen.dart';
import '../mock/mock_words.dart';

class WordPracticeScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  const WordPracticeScreen({super.key, this.onCompleted});

  @override
  State<WordPracticeScreen> createState() => _WordPracticeScreenState();
}

class _WordPracticeScreenState extends State<WordPracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Word> _practiceWords = [];
  final Set<String> _favorites = {};
  int _currentIndex = 0;
  bool _showAnswer = false;
  String? _selectedAnswer;
  // ignore: unused_field
  bool _isCorrect = false;
  StorageService? _storageService;
  final TextEditingController _spellingController = TextEditingController();
  bool _showSpellingAnswer = false;
  bool _isSpellingCorrect = false;
  String _targetWordbook = '四级核心';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storageService = await StorageService.getInstance();
    final wb = _storageService?.getTargetWordbook() ?? '四级核心';
    final words = MockWords.getWordsByCategory(wb);

    if (mounted) {
      setState(() {
        _targetWordbook = wb;
        _practiceWords = words;
        _currentIndex = 0;
        _showAnswer = false;
        _favorites.addAll(_storageService?.getFavorites() ?? {});
      });
      if (_practiceWords.isNotEmpty) {
        AudioService.instance.speak(_practiceWords[0].english);
      }
    }
  }

  void _openGoalSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalSettingScreen(
          currentGoals: const {'words': 500, 'sentences': 200, 'dialogues': 50, 'dailyMinutes': 30},
          onGoalsSaved: (goals) {},
        ),
      ),
    );
    _initStorage();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _tabController.dispose();
    _spellingController.dispose();
    super.dispose();
  }

  void _nextWord() {
    if (_currentIndex < _practiceWords.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _selectedAnswer = null;
        _isCorrect = false;
        _spellingController.clear();
        _showSpellingAnswer = false;
        _isSpellingCorrect = false;
      });
      AudioService.instance.speak(_practiceWords[_currentIndex].english);
    } else {
      _showCompletionDialog();
    }
  }

  void _previousWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
        _selectedAnswer = null;
        _isCorrect = false;
        _spellingController.clear();
        _showSpellingAnswer = false;
        _isSpellingCorrect = false;
      });
      AudioService.instance.speak(_practiceWords[_currentIndex].english);
    }
  }

  void _toggleFavorite(String wordId) async {
    if (_favorites.contains(wordId)) {
      await _storageService?.removeFavorite(wordId);
      setState(() => _favorites.remove(wordId));
    } else {
      await _storageService?.addFavorite(wordId);
      setState(() => _favorites.add(wordId));
    }
  }

  void _showCompletionDialog() {
    widget.onCompleted?.call();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletionCongratulationScreen(
          moduleTitle: '单词练习 ($_targetWordbook)',
          correctCount: _practiceWords.length,
          totalQuestions: _practiceWords.length,
        ),
      ),
    );
  }

  void _rateWordSM2(SM2Rating rating) async {
    if (_practiceWords.isEmpty) return;
    final word = _practiceWords[_currentIndex];
    final existingItem = _storageService?.getSM2Item(word.english) ?? SM2Item.initial(word.english);
    final updatedItem = SM2Service.calculateNextReview(existingItem, rating);

    await _storageService?.saveSM2Item(updatedItem);

    final nextDate = updatedItem.nextReviewAt;
    final dateStr = '${nextDate.month}月${nextDate.day}日';

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已持久化存入 SM-2 排程！下次复习日期：$dateStr (间隔 ${updatedItem.interval} 天)'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.indigo,
        ),
      );
    }

    _nextWord();
  }

  Widget _buildCardMode() {
    if (_practiceWords.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final word = _practiceWords[_currentIndex];
    final isFavorite = _favorites.contains(word.id);

    return Column(
      children: [
        // Header Info Bar with Target Wordbook & Goal Switcher
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _openGoalSettings,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepOrange.shade200),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '目标词库: $_targetWordbook',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.deepOrange.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.tune, size: 14, color: Colors.deepOrange.shade900),
                    ],
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  final currentDay = (_currentIndex ~/ 15) + 1;
                  final dayWordIndex = (_currentIndex % 15) + 1;
                  return Text(
                    '第 $currentDay 天 ($dayWordIndex/15) · ${_currentIndex + 1}/${_practiceWords.length}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  );
                },
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

        // Main Word Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            word.phonetic,
                            style: LuminaTheme.ipaStyle(fontSize: 20, color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Colors.blue),
                            onPressed: () => AudioService.instance.speak(word.english),
                          ),
                        ],
                      ),
                      if (_showAnswer) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          word.chinese,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '例句：${word.exampleSentence}',
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        const SizedBox(height: 32),
                        const Text(
                          '点击卡片显示答案',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // SM-2 Memory Rating Controls (When Answer Revealed)
        if (_showAnswer) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade900),
                    onPressed: () => _rateWordSM2(SM2Rating.again),
                    child: const Text('生疏 (1天)'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100, foregroundColor: Colors.orange.shade900),
                    onPressed: () => _rateWordSM2(SM2Rating.hard),
                    child: const Text('模糊 (3天)'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100, foregroundColor: Colors.blue.shade900),
                    onPressed: () => _rateWordSM2(SM2Rating.good),
                    child: const Text('掌握 (6天)'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100, foregroundColor: Colors.green.shade900),
                    onPressed: () => _rateWordSM2(SM2Rating.easy),
                    child: const Text('熟练 (14天)'),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Bottom Navigation Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _currentIndex > 0 ? _previousWord : null,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              ElevatedButton.icon(
                onPressed: _nextWord,
                icon: const Icon(Icons.arrow_forward),
                label: Text(_currentIndex < _practiceWords.length - 1 ? '下个单词' : '完成本次背诵'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestMode() {
    if (_practiceWords.isEmpty) return const SizedBox();
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                currentWord.english,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                currentWord.phonetic,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('请选择正确的中文翻译:', style: TextStyle(fontSize: 16)),
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
                  textColor = Colors.green.shade900;
                } else if (isSelected) {
                  backgroundColor = Colors.red.shade100;
                  textColor = Colors.red.shade900;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: textColor,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showAnswer
                      ? null
                      : () {
                          setState(() {
                            _selectedAnswer = option;
                            _showAnswer = true;
                            _isCorrect = isCorrectAnswer;
                          });
                        },
                  child: Text(option, style: const TextStyle(fontSize: 16)),
                ),
              );
            },
          ),
        ),
        if (_showAnswer) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(_currentIndex < _practiceWords.length - 1 ? '下一题' : '完成测试'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSpellingMode() {
    if (_practiceWords.isEmpty) return const SizedBox();
    final currentWord = _practiceWords[_currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    currentWord.chinese,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(currentWord.phonetic, style: LuminaTheme.ipaStyle(fontSize: 18, color: Colors.grey.shade700)),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.blue),
                        onPressed: () => AudioService.instance.speak(currentWord.english),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('例句：${currentWord.exampleSentence}', style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _spellingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '请输入英文单词',
              hintText: '输入英文拼写...',
            ),
            onSubmitted: (val) {
              final isMatch = val.trim().toLowerCase() == currentWord.english.toLowerCase();
              setState(() {
                _showSpellingAnswer = true;
                _isSpellingCorrect = isMatch;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final isMatch = _spellingController.text.trim().toLowerCase() == currentWord.english.toLowerCase();
              setState(() {
                _showSpellingAnswer = true;
                _isSpellingCorrect = isMatch;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('提交校验'),
          ),
          if (_showSpellingAnswer) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isSpellingCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isSpellingCorrect ? Colors.green : Colors.red),
              ),
              child: Column(
                children: [
                  Text(
                    _isSpellingCorrect ? '🎉 拼写正确！' : '需要加油，正确拼写为：${currentWord.english}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isSpellingCorrect ? Colors.green.shade900 : Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _nextWord,
                    child: Text(_currentIndex < _practiceWords.length - 1 ? '下一词' : '完成拼写小测'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单词练习'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: InkWell(
                onTap: _showCompletionDialog,
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
                Tab(icon: Icon(Icons.style, size: 20), text: '卡片模式'),
                Tab(icon: Icon(Icons.quiz, size: 20), text: '测试模式'),
                Tab(icon: Icon(Icons.edit, size: 20), text: '拼写小测'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCardMode(),
          _buildTestMode(),
          _buildSpellingMode(),
        ],
      ),
    );
  }
}
