import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../theme/lumina_theme.dart';
import '../mock/mock_words.dart';
import 'completion_congratulation_screen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  final VoidCallback? onCompleted;

  const ArticleDetailScreen({super.key, required this.article, this.onCompleted});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _showTranslation = false;
  double _fontSize = 16.0;
  int _currentSentenceIndex = 0;

  List<String> _sentences = [];
  List<String> _chineseSentences = [];
  StorageService? _storageService;

  String _getPhoneticForWord(String word) {
    final clean = word.toLowerCase().trim();
    for (var w in MockWords.getWords()) {
      if (w.english.toLowerCase() == clean) {
        return w.phonetic;
      }
    }
    return '/$clean/';
  }

  @override
  void initState() {
    super.initState();
    _splitSentences();
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storageService = await StorageService.getInstance();
  }

  void _splitSentences() {
    _sentences = widget.article.content
        .split(RegExp(r'(?<=[.!?])\s+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    if (widget.article.chineseContent != null &&
        widget.article.chineseContent!.isNotEmpty) {
      _chineseSentences = widget.article.chineseContent!
          .split(RegExp(r'(?<=[。！？\n])\s*'))
          .where((s) => s.trim().isNotEmpty)
          .toList();
    }
  }

  void _toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void _adjustFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(12.0, 24.0);
    });
  }

  void _showWordBubble(BuildContext context, String rawWord, Offset tapPosition) {
    final cleanWord = rawWord.replaceAll(RegExp(r'[^\w\-]'), '');
    if (cleanWord.isEmpty) return;

    AudioService.instance.speak(cleanWord);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        bool isFavorited = _storageService?.getFavorites().contains(cleanWord) ?? false;
        return StatefulBuilder(
          builder: (context, setBubbleState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.deepOrange.shade100, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cleanWord,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange.shade900,
                                    ),
                                  ),
                                  Text(
                                    _getPhoneticForWord(cleanWord),
                                    style: LuminaTheme.ipaStyle(
                                      fontSize: 13,
                                      color: Colors.deepOrange.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => AudioService.instance.speak(cleanWord),
                              icon: const Icon(Icons.volume_up, color: Colors.deepOrange),
                              tooltip: '朗读发音',
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () async {
                                if (isFavorited) {
                                  await _storageService?.removeFavorite(cleanWord);
                                } else {
                                  await _storageService?.addFavorite(cleanWord);
                                }
                                setBubbleState(() {
                                  isFavorited = !isFavorited;
                                });
                              },
                              icon: Icon(
                                isFavorited ? Icons.favorite : Icons.favorite_border,
                                color: isFavorited ? Colors.red : Colors.grey,
                              ),
                              tooltip: '加入生词本',
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '/${cleanWord.toLowerCase()}/',
                          style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('释义：', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                            Expanded(
                              child: Text(
                                'n. [精选生词] $cleanWord 核心词汇解构与常见用法。',
                                style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('知道了'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getSentenceTranslation(int index, String sentence) {
    if (_chineseSentences.isNotEmpty && index < _chineseSentences.length) {
      return _chineseSentences[index];
    }
    Map<String, String> translations = {
      'Reading books in English can significantly improve your language skills...':
          '阅读英文书籍可以显著提高你的语言技能...',
      'Speaking English fluently requires practice and dedication...':
          '流利地说英语需要练习和专注...',
      'Mastering English grammar takes time and effort...': '掌握英语语法需要时间和努力...',
    };
    return translations[sentence] ?? '对照译文：阅读此句帮助强化语感与词汇理解。';
  }

  void _showDomesticShareSheet(BuildContext context, Article article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final platforms = [
          {'name': '微信好友', 'icon': Icons.chat_bubble, 'color': const Color(0xFF07C160)},
          {'name': '微信朋友圈', 'icon': Icons.motion_photos_on, 'color': const Color(0xFF07C160)},
          {'name': '新浪微博', 'icon': Icons.public, 'color': const Color(0xFFE6162D)},
          {'name': 'QQ好友', 'icon': Icons.people_alt, 'color': const Color(0xFF1296DB)},
          {'name': 'QQ空间', 'icon': Icons.star, 'color': const Color(0xFFFFB800)},
          {'name': '保存打卡海报', 'icon': Icons.camera_alt, 'color': const Color(0xFFFF6B00)},
        ];

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '分享精读文章至国内社交平台',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: platforms.length,
                itemBuilder: (context, index) {
                  final item = platforms[index];
                  final color = item['color'] as Color;
                  final name = item['name'] as String;
                  final icon = item['icon'] as IconData;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            index == 5 ? '🎉 成功保存打卡海报至系统相册！' : '🚀 已调起【$name】进行分享！',
                          ),
                          backgroundColor: Colors.green.shade700,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(icon, color: color, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.chineseTitle ?? widget.article.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: '分享文章',
            onPressed: () => _showDomesticShareSheet(context, widget.article),
          ),
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
                        moduleTitle: '文章精读',
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
      ),
      body: Column(
        children: [
          _buildArticleHeader(),
          _buildProgressBar(),
          Expanded(
            child: _buildArticleContent(),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E293B)
          : const Color(0xFFFFF7ED),
      child: Row(
        children: [
          const Icon(Icons.menu_book, size: 18, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.article.title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Chip(
            label: Text('${widget.article.readTime} 分钟', style: const TextStyle(fontSize: 10)),
            backgroundColor: Colors.orange.shade100,
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentSentenceIndex + 1) / _sentences.length,
      backgroundColor: Colors.grey.shade200,
      color: Colors.deepOrange,
    );
  }

  Widget _buildArticleContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.article.chineseTitle ?? widget.article.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._sentences.asMap().entries.map((entry) {
            int index = entry.key;
            String sentence = entry.value;
            return _SentenceBlock(
              sentence: sentence,
              index: index,
              currentIndex: _currentSentenceIndex,
              fontSize: _fontSize,
              showTranslation: _showTranslation,
              onTapSentence: () {
                setState(() {
                  _currentSentenceIndex = index;
                });
              },
              onWordTap: (word, pos) => _showWordBubble(context, word, pos),
              translation: _getSentenceTranslation(index, sentence),
            );
          }).toList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentSentenceIndex > 0
                  ? () {
                      setState(() {
                        _currentSentenceIndex--;
                      });
                      AudioService.instance.speak(_sentences[_currentSentenceIndex]);
                    }
                  : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('上一句'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentSentenceIndex < _sentences.length - 1
                  ? () {
                      setState(() {
                        _currentSentenceIndex++;
                      });
                      AudioService.instance.speak(_sentences[_currentSentenceIndex]);
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('下一句'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentenceBlock extends StatefulWidget {
  final String sentence;
  final int index;
  final int currentIndex;
  final double fontSize;
  final bool showTranslation;
  final VoidCallback onTapSentence;
  final Function(String word, Offset tapPosition) onWordTap;
  final String translation;

  const _SentenceBlock({
    required this.sentence,
    required this.index,
    required this.currentIndex,
    required this.fontSize,
    required this.showTranslation,
    required this.onTapSentence,
    required this.onWordTap,
    required this.translation,
  });

  @override
  State<_SentenceBlock> createState() => _SentenceBlockState();
}

class _SentenceBlockState extends State<_SentenceBlock> {
  bool _localShowTranslation = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.index == widget.currentIndex;
    final words = widget.sentence.split(RegExp(r'\s+'));
    final shouldShowTrans = widget.showTranslation || _localShowTranslation;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.amber.shade50 : Colors.transparent,
        border: Border.all(
          color: isHighlighted ? Colors.amber.shade400 : Colors.grey.shade200,
          width: isHighlighted ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sentence Start Audio Play Button (句首语音朗读图标)
              InkWell(
                onTap: () {
                  widget.onTapSentence();
                  AudioService.instance.speak(widget.sentence);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.deepOrange : Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volume_up,
                    size: 16,
                    color: isHighlighted ? Colors.white : Colors.deepOrange.shade900,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Sentence Text Words Wrap
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: words.map((w) {
                    return GestureDetector(
                      onTapUp: (details) {
                        widget.onTapSentence();
                        widget.onWordTap(w, details.globalPosition);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          w,
                          style: TextStyle(
                            fontSize: widget.fontSize,
                            height: 1.4,
                            color: isHighlighted ? Colors.indigo.shade900 : Colors.black87,
                            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // Sentence End Chinese Translation Toggle & Text
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (shouldShowTrans)
                Expanded(
                  child: Text(
                    widget.translation,
                    style: TextStyle(
                      fontSize: widget.fontSize - 2,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                )
              else
                const Spacer(),

              // Inline Translation Toggle Chip at Sentence End ([译文])
              InkWell(
                onTap: () {
                  setState(() {
                    _localShowTranslation = !_localShowTranslation;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _localShowTranslation ? Colors.grey.shade200 : Colors.deepOrange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _localShowTranslation ? Colors.grey.shade300 : Colors.deepOrange.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _localShowTranslation ? Icons.visibility_off : Icons.translate,
                        size: 12,
                        color: _localShowTranslation ? Colors.grey.shade700 : Colors.deepOrange.shade900,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _localShowTranslation ? '收起' : '译文',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _localShowTranslation ? Colors.grey.shade700 : Colors.deepOrange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
