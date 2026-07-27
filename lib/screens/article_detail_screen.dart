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
  int _currentParagraphIndex = 0;

  List<String> _paragraphs = [];
  List<String> _chineseParagraphs = [];
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
    _splitParagraphs();
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storageService = await StorageService.getInstance();
  }

  void _splitParagraphs() {
    // 优先按原文换行自然段切分
    final rawLines = widget.article.content
        .split(RegExp(r'\n+'))
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (rawLines.length > 1) {
      _paragraphs = rawLines;
    } else {
      // 若原文没有换行，按 2 句作为一个自然小片段 Chunk 组合
      final sentences = widget.article.content
          .split(RegExp(r'(?<=[.!?])\s+'))
          .where((s) => s.trim().isNotEmpty)
          .toList();

      final List<String> chunks = [];
      for (int i = 0; i < sentences.length; i += 2) {
        if (i + 1 < sentences.length) {
          chunks.add('${sentences[i]} ${sentences[i + 1]}');
        } else {
          chunks.add(sentences[i]);
        }
      }
      _paragraphs = chunks.isEmpty ? [widget.article.content] : chunks;
    }

    if (widget.article.chineseContent != null &&
        widget.article.chineseContent!.isNotEmpty) {
      final zhLines = widget.article.chineseContent!
          .split(RegExp(r'\n+'))
          .where((p) => p.trim().isNotEmpty)
          .toList();

      if (zhLines.length > 1) {
        _chineseParagraphs = zhLines;
      } else {
        final zhSentences = widget.article.chineseContent!
            .split(RegExp(r'(?<=[。！？\n])\s*'))
            .where((s) => s.trim().isNotEmpty)
            .toList();

        final List<String> zhChunks = [];
        for (int i = 0; i < zhSentences.length; i += 2) {
          if (i + 1 < zhSentences.length) {
            zhChunks.add('${zhSentences[i]} ${zhSentences[i + 1]}');
          } else {
            zhChunks.add(zhSentences[i]);
          }
        }
        _chineseParagraphs = zhChunks.isEmpty ? [widget.article.chineseContent!] : zhChunks;
      }
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
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cleanWord,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () => AudioService.instance.speak(cleanWord),
                              icon: const Icon(Icons.volume_up, color: Colors.blue),
                              tooltip: '朗读发音',
                            ),
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

  String _getParagraphTranslation(int index, String paragraph) {
    if (_chineseParagraphs.isNotEmpty && index < _chineseParagraphs.length) {
      return _chineseParagraphs[index];
    }
    return '【段落译文参考】：结合上下文与段落大意进行沉浸式长文理解。';
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
                '分享文章战报',
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
                  final name = item['name'] as String;
                  final icon = item['icon'] as IconData;
                  final color = item['color'] as Color;

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
          const Icon(Icons.article_rounded, size: 18, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.article.title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '按自然段精读 (共 ${_paragraphs.length} 段)',
              style: TextStyle(fontSize: 11, color: Colors.orange.shade900, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: _paragraphs.isEmpty ? 1.0 : (_currentParagraphIndex + 1) / _paragraphs.length,
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
          ..._paragraphs.asMap().entries.map((entry) {
            int index = entry.key;
            String paragraphText = entry.value;
            return _ParagraphBlock(
              paragraphText: paragraphText,
              index: index,
              currentIndex: _currentParagraphIndex,
              fontSize: _fontSize,
              showTranslation: _showTranslation,
              onTapParagraph: () {
                setState(() {
                  _currentParagraphIndex = index;
                });
              },
              onWordTap: (word, pos) => _showWordBubble(context, word, pos),
              translation: _getParagraphTranslation(index, paragraphText),
              totalParagraphs: _paragraphs.length,
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
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F172A)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _currentParagraphIndex > 0
                  ? () {
                      setState(() {
                        _currentParagraphIndex--;
                      });
                      AudioService.instance.speak(_paragraphs[_currentParagraphIndex]);
                    }
                  : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('上一段'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _currentParagraphIndex < _paragraphs.length - 1
                  ? () {
                      setState(() {
                        _currentParagraphIndex++;
                      });
                      AudioService.instance.speak(_paragraphs[_currentParagraphIndex]);
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('下一段'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParagraphBlock extends StatefulWidget {
  final String paragraphText;
  final int index;
  final int currentIndex;
  final double fontSize;
  final bool showTranslation;
  final VoidCallback onTapParagraph;
  final Function(String word, Offset tapPosition) onWordTap;
  final String translation;
  final int totalParagraphs;

  const _ParagraphBlock({
    required this.paragraphText,
    required this.index,
    required this.currentIndex,
    required this.fontSize,
    required this.showTranslation,
    required this.onTapParagraph,
    required this.onWordTap,
    required this.translation,
    required this.totalParagraphs,
  });

  @override
  State<_ParagraphBlock> createState() => _ParagraphBlockState();
}

class _ParagraphBlockState extends State<_ParagraphBlock> {
  bool _localShowTranslation = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.index == widget.currentIndex;
    final words = widget.paragraphText.split(RegExp(r'\s+'));
    final shouldShowTrans = widget.showTranslation || _localShowTranslation;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? (isDark ? const Color(0xFF1E293B) : Colors.amber.shade50)
            : (isDark ? const Color(0xFF0F172A) : Colors.white),
        border: Border.all(
          color: isHighlighted
              ? (isDark ? Colors.amber : Colors.amber.shade400)
              : (isDark ? Colors.white10 : Colors.grey.shade200),
          width: isHighlighted ? 1.8 : 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isHighlighted)
            BoxShadow(
              color: Colors.amber.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 段落 Header (段落序号 + 朗读按钮)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isHighlighted ? Colors.deepOrange : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '第 ${widget.index + 1} 段 / 共 ${widget.totalParagraphs} 段',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted ? Colors.white : Colors.orange.shade900,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  widget.onTapParagraph();
                  AudioService.instance.speak(widget.paragraphText);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.deepOrange : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.volume_up,
                        size: 15,
                        color: isHighlighted ? Colors.white : Colors.deepOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '朗读本段',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isHighlighted ? Colors.white : Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 段落正文 (自然流式分词排版)
          Wrap(
            spacing: 5,
            runSpacing: 6,
            children: words.map((w) {
              return GestureDetector(
                onTapUp: (details) {
                  widget.onTapParagraph();
                  widget.onWordTap(w, details.globalPosition);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text(
                    w,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      height: 1.5,
                      color: isHighlighted
                          ? (isDark ? Colors.amber.shade200 : Colors.indigo.shade900)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // 段落译文显示 & 切换按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (shouldShowTrans)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.translation,
                      style: TextStyle(
                        fontSize: widget.fontSize - 2,
                        color: isDark ? Colors.white60 : Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),

              const SizedBox(width: 8),

              InkWell(
                onTap: () {
                  setState(() {
                    _localShowTranslation = !_localShowTranslation;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        size: 13,
                        color: _localShowTranslation ? Colors.grey.shade700 : Colors.deepOrange.shade900,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _localShowTranslation ? '收起译文' : '段落译文',
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
