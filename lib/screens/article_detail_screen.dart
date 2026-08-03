import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/word.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/dictionary_service.dart';
import '../theme/lumina_theme.dart';
import '../mock/mock_words.dart';
import '../mock/mock_books.dart';
import '../mock/mock_articles.dart';
import 'completion_congratulation_screen.dart';
import '../widgets/word_detail_dialog.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  final VoidCallback? onCompleted;

  const ArticleDetailScreen({super.key, required this.article, this.onCompleted});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _showTranslation = false;
  bool _isCompleted = false;
  final double _fontSize = 16.5;
  int _currentParagraphIndex = 0;

  List<String> _paragraphs = [];
  List<String> _chineseParagraphs = [];
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _splitParagraphs();
    _initStorage();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
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

  Article? _getNextArticle() {
    if (widget.article.bookId != null) {
      final bookId = widget.article.bookId!;
      List<Article> chapters = [];
      if (bookId == 'book_anne') chapters = MockBooks.getAnneChapters();
      if (bookId == 'book_prince') chapters = MockBooks.getPrinceChapters();
      if (bookId == 'book_beauty') chapters = MockBooks.getBeautyChapters();
      if (bookId == 'book_nights') chapters = MockBooks.getNightsChapters();
      if (bookId == 'book_stoneface') chapters = MockBooks.getStoneFaceChapters();

      if (widget.article.unitIndex != null) {
        final nextUnit = widget.article.unitIndex! + 1;
        for (final c in chapters) {
          if (c.unitIndex == nextUnit) return c;
        }
      }
    } else {
      final articles = MockArticles.getArticles();
      final idx = articles.indexWhere((a) => a.id == widget.article.id);
      if (idx != -1 && idx + 1 < articles.length) {
        return articles[idx + 1];
      }
    }
    return null;
  }

  void _markCompleted() {
    if (_isCompleted) return;
    setState(() {
      _isCompleted = true;
    });
    widget.onCompleted?.call();

    // 点击完成阅读时，弹出庆祝通关弹窗
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletionCongratulationScreen(
          moduleTitle: '文章精读',
          earnedLp: 50,
          streakDays: 7,
          onContinue: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showWordBubble(BuildContext context, String rawWord, Offset tapPosition, {String paragraphText = ''}) {
    WordDetailDialog.show(
      context,
      rawWord,
      articleTitle: widget.article.chineseTitle ?? widget.article.title,
      sentenceContext: paragraphText,
      articleId: widget.article.id.toString(),
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
                            color: color.withValues(alpha: 0.12),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.article.chineseTitle ?? widget.article.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.article.chineseTitle != null)
              Text(
                widget.article.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: '更多',
            onSelected: (value) {
              if (value == 'translation') {
                _toggleTranslation();
              } else if (value == 'share') {
                _showDomesticShareSheet(context, widget.article);
              } else if (value == 'complete') {
                _markCompleted();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'translation',
                child: Row(
                  children: [
                    Icon(
                      _showTranslation ? Icons.visibility_off_outlined : Icons.translate_rounded,
                      size: 18,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    Text(_showTranslation ? '隐藏译文' : '展开译文'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    const Text('分享文章'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'complete',
                enabled: !_isCompleted,
                child: Row(
                  children: [
                    Icon(
                      _isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      size: 18,
                      color: _isCompleted ? Colors.grey : Colors.green.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCompleted ? '已完成阅读' : '完成阅读',
                      style: TextStyle(
                        color: _isCompleted ? Colors.grey : Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: _buildArticleContent(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: _paragraphs.isEmpty ? 1.0 : (_currentParagraphIndex + 1) / _paragraphs.length,
      backgroundColor: Colors.grey.shade200,
      color: LuminaColors.primary,
      minHeight: 3,
    );
  }

  Widget _buildMetaHeader(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.article.chineseTitle ?? widget.article.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          if (widget.article.chineseTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.article.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMetaChip(
                icon: Icons.menu_book_rounded,
                label: '名著原著',
                color: const Color(0xFF2563EB),
                isDark: isDark,
              ),
              _buildMetaChip(
                icon: Icons.timer_outlined,
                label: '约 ${widget.article.readTime} 分钟',
                color: const Color(0xFF0F766E),
                isDark: isDark,
              ),
              _buildMetaChip(
                icon: Icons.bar_chart_rounded,
                label: widget.article.difficulty,
                color: const Color(0xFFD97706),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent(bool isDark) {
    final favoriteWords = _storageService?.getFavorites() ?? {};
    final nextArticle = _getNextArticle();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetaHeader(isDark),
          ..._paragraphs.asMap().entries.map((entry) {
            int index = entry.key;
            String paragraphText = entry.value;
            return _ParagraphBlock(
              paragraphText: paragraphText,
              index: index,
              currentIndex: _currentParagraphIndex,
              fontSize: _fontSize,
              showTranslation: _showTranslation,
              favoriteWords: favoriteWords,
              onTapParagraph: () {
                setState(() {
                  _currentParagraphIndex = index;
                });
              },
              onWordTap: (word, pos) => _showWordBubble(context, word, pos, paragraphText: paragraphText),
              translation: _getParagraphTranslation(index, paragraphText),
              totalParagraphs: _paragraphs.length,
            );
          }),

          const SizedBox(height: 16),

          _buildCompletionFooter(isDark, nextArticle),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // 底部单独简洁按钮（完成阅读 / 已完成阅读 + 下一章节）
  Widget _buildCompletionFooter(bool isDark, Article? nextArticle) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCompleted
                    ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                    : Colors.green.shade600,
                foregroundColor: _isCompleted
                    ? (isDark ? Colors.white38 : const Color(0xFF94A3B8))
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: _isCompleted ? 0 : 2,
              ),
              onPressed: _isCompleted ? null : _markCompleted,
              icon: Icon(
                _isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                size: 20,
              ),
              label: Text(
                _isCompleted ? '已完成阅读' : '完成阅读',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (nextArticle != null) ...[
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: LuminaColors.primary,
                  side: BorderSide(color: LuminaColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        article: nextArticle,
                        onCompleted: widget.onCompleted,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text(
                  '下一章节',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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
  final Set<String> favoriteWords;
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
    required this.favoriteWords,
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

    return GestureDetector(
      onTap: widget.onTapParagraph,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFFAFAFA)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted
                ? (isDark ? Colors.white24 : const Color(0xFFCBD5E1))
                : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
            width: 1.0,
          ),
          boxShadow: [
            if (isHighlighted)
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.07),
                blurRadius: 12,
                spreadRadius: 0,
                offset: Offset.zero,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? (isDark ? const Color(0xFF2563EB).withValues(alpha: 0.15) : const Color(0xFFEFF6FF))
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'P.${widget.index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isHighlighted
                          ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB))
                          : (isDark ? Colors.white54 : const Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 5,
              runSpacing: 7,
              children: words.map((w) {
                final cleanW = w.replaceAll(RegExp(r'[^\w\-]'), '').toLowerCase();
                final isFav = cleanW.isNotEmpty && widget.favoriteWords.contains(cleanW);
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
                        height: 1.75,
                        letterSpacing: 0.15,
                        color: isFav
                            ? (isDark ? Colors.amber.shade300 : const Color(0xFFD97706))
                            : (isHighlighted
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : (isDark ? Colors.white70 : const Color(0xFF334155))),
                        fontWeight: isFav
                            ? FontWeight.bold
                            : (isHighlighted ? FontWeight.w500 : FontWeight.w400),
                        decoration: isFav ? TextDecoration.underline : TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                        decorationColor: isDark ? Colors.amber.shade400 : const Color(0xFFD97706),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _localShowTranslation = !_localShowTranslation;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: shouldShowTrans
                        ? (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9))
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: shouldShowTrans
                          ? (isDark ? Colors.white24 : const Color(0xFFCBD5E1))
                          : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        shouldShowTrans ? Icons.visibility_off_outlined : Icons.translate,
                        size: 13,
                        color: shouldShowTrans
                            ? (isDark ? Colors.white70 : const Color(0xFF64748B))
                            : const Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        shouldShowTrans ? '收起译文' : '查看段落译文',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: shouldShowTrans
                              ? (isDark ? Colors.white70 : const Color(0xFF64748B))
                              : const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (shouldShowTrans) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 18,
                      margin: const EdgeInsets.only(top: 2, right: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.translation,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.65,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
