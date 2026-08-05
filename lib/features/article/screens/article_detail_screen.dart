import 'package:flutter/material.dart';
import '../models/article.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/database_service.dart';
import '../services/article_service.dart';
import '../../../core/theme/lumina_theme.dart';
import '../services/book_json_loader.dart';
import '../mock/mock_articles.dart';
import '../../../core/services/online_translation_service.dart';
import '../../../features/review/screens/completion_congratulation_screen.dart';
import '../../../core/widgets/word_detail_dialog.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  final VoidCallback? onCompleted;

  const ArticleDetailScreen({super.key, required this.article, this.onCompleted});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _showAllTranslations = false;
  bool _isCompleted = false;
  final double _fontSize = 16.5;

  final Map<int, bool> _activeParagraphTranslations = {};
  // 动态在线翻译 + 数据库离线缓存映射
  final Map<int, String> _translationCache = {};
  final Map<int, bool> _loadingTranslations = {};

  StorageService? _storageService;
  ArticleService? _articleService;

  @override
  void initState() {
    super.initState();
    _initStorage();
    _loadNextArticle();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  Future<void> _initStorage() async {
    _storageService = await StorageService.getInstance();
    final db = await DatabaseService.getInstance();
    _articleService = ArticleService(_storageService!, db);
  }

  /// 按需点击翻译：有原生翻译优先用；没有则优先查 SQLite 数据库；数据库没有则调在线 API 并存库！
  Future<void> _toggleParagraphTrans(int index, ParagraphBlock paragraph) async {
    final bool currentExpanded = _showAllTranslations || (_activeParagraphTranslations[index] ?? false);

    // 1. 如果要收起，直接切换状态
    if (currentExpanded) {
      setState(() {
        _activeParagraphTranslations[index] = false;
      });
      return;
    }

    // 2. 判断当前是否有有效中文
    final bool hasNativeChinese = paragraph.zh.isNotEmpty &&
        RegExp(r'[\u4e00-\u9fa5]').hasMatch(paragraph.zh);

    if (hasNativeChinese || _translationCache.containsKey(index)) {
      setState(() {
        _activeParagraphTranslations[index] = true;
      });
      return;
    }

    // 3. 展开并进入加载状态（查询数据库 / 在线 API 翻译）
    setState(() {
      _activeParagraphTranslations[index] = true;
      _loadingTranslations[index] = true;
    });

    final transKey = '${widget.article.id}_p$index';
    final db = await DatabaseService.getInstance();

    // 优先从 SQLite 数据库缓存中调取
    final cachedDbZh = await db.getCachedTranslation(transKey);
    if (cachedDbZh != null && cachedDbZh.isNotEmpty && mounted) {
      setState(() {
        _translationCache[index] = cachedDbZh;
        _loadingTranslations[index] = false;
      });
      return;
    }

    // 数据库没有，调用免费网络在线 API 实时翻译
    final onlineZh = await OnlineTranslationService.translate(paragraph.en);
    if (onlineZh != null && onlineZh.isNotEmpty) {
      // 成功翻译后自动存入本地 SQLite 数据库中，下次零消耗调出！
      await db.saveCachedTranslation(transKey, paragraph.en, onlineZh);

      if (mounted) {
        setState(() {
          _translationCache[index] = onlineZh;
          _loadingTranslations[index] = false;
        });
      }
    } else if (mounted) {
      setState(() {
        _translationCache[index] = '（网络翻译暂不可用，请稍后重试）';
        _loadingTranslations[index] = false;
      });
    }
  }

  void _toggleAllTranslations() {
    setState(() {
      _showAllTranslations = !_showAllTranslations;
    });
  }

  Article? _nextArticle;

  Future<void> _loadNextArticle() async {
    if (widget.article.bookId != null && widget.article.unitIndex != null) {
      final chapters = await BookJsonLoader.getBookChapters(widget.article.bookId!);
      final nextUnit = widget.article.unitIndex! + 1;
      for (final c in chapters) {
        if (c.unitIndex == nextUnit) {
          if (mounted) {
            setState(() {
              _nextArticle = c;
            });
          }
          return;
        }
      }
    } else {
      final articles = MockArticles.getArticles();
      final idx = articles.indexWhere((a) => a.id == widget.article.id);
      if (idx != -1 && idx + 1 < articles.length) {
        if (mounted) {
          setState(() {
            _nextArticle = articles[idx + 1];
          });
        }
      }
    }
  }

  void _markCompleted() {
    if (_isCompleted) return;
    setState(() {
      _isCompleted = true;
    });
    widget.onCompleted?.call();
    _articleService?.recordReadingWithId(widget.article.id, widget.article.readTime);

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

  void _showWordBubble(BuildContext context, String rawWord, Offset tapPosition, {String sentenceContext = ''}) {
    WordDetailDialog.show(
      context,
      rawWord,
      articleTitle: widget.article.chineseTitle ?? widget.article.title,
      sentenceContext: sentenceContext,
      articleId: widget.article.id.toString(),
    );
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
            tooltip: '更多选项',
            onSelected: (value) {
              if (value == 'translation') {
                _toggleAllTranslations();
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
                      _showAllTranslations ? Icons.visibility_off_outlined : Icons.translate_rounded,
                      size: 18,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    Text(_showAllTranslations ? '隐藏全篇译文' : '展开全篇译文'),
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
      body: _buildArticleContent(isDark),
    );
  }

  Widget _buildMetaHeader(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
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
              fontSize: 17,
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
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMetaChip(
                icon: Icons.menu_book_rounded,
                label: widget.article.category ?? '名著原著',
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetaHeader(isDark),

          // 直接遍历 JSON 原生段落列表，无需任何正则分句，100% 精准对齐
          ...widget.article.paragraphs.asMap().entries.map((entry) {
            final int index = entry.key;
            final ParagraphBlock paragraph = entry.value;
            final bool isTransExpanded = _showAllTranslations || (_activeParagraphTranslations[index] ?? false);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 英文段落内容（首行 2em 缩进） + 段尾独立翻译 Icon
                  _buildParagraphItem(
                    index: index,
                    paragraph: paragraph,
                    favoriteWords: favoriteWords,
                    isTransExpanded: isTransExpanded,
                    isDark: isDark,
                    onToggleTrans: () => _toggleParagraphTrans(index, paragraph),
                  ),

                  // 点按小图标后展开的对应中文段落（原生/离线数据库缓存/在线实时 API）
                  if (isTransExpanded) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.blue.withValues(alpha: 0.2) : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: _loadingTranslations[index] == true
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '在线译文实时解析中...',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              (paragraph.zh.isNotEmpty && RegExp(r'[\u4e00-\u9fa5]').hasMatch(paragraph.zh))
                                  ? paragraph.zh
                                  : (_translationCache[index] ?? paragraph.zh),
                              style: TextStyle(
                                fontSize: 14.5,
                                height: 1.65,
                                color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: 24),
          _buildCompletionFooter(isDark, _nextArticle),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildParagraphItem({
    required int index,
    required ParagraphBlock paragraph,
    required Set<String> favoriteWords,
    required bool isTransExpanded,
    required bool isDark,
    required VoidCallback onToggleTrans,
  }) {
    final words = paragraph.en.split(RegExp(r'\s+'));

    return Wrap(
      spacing: 5,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 段落开头添加 2 em 宽度的首行缩进占位
        const SizedBox(width: 34),
        ...words.map((w) {
          final cleanW = w.replaceAll(RegExp(r'[^\w\-]'), '').toLowerCase();
          final isFav = cleanW.isNotEmpty && favoriteWords.contains(cleanW);
          return GestureDetector(
            onTapUp: (details) {
              _showWordBubble(context, w, details.globalPosition, sentenceContext: paragraph.en);
            },
            child: Text(
              w,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.7,
                letterSpacing: 0.15,
                color: isFav
                    ? (isDark ? Colors.amber.shade300 : const Color(0xFFD97706))
                    : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
                fontWeight: isFav ? FontWeight.bold : FontWeight.w400,
                decoration: isFav ? TextDecoration.underline : TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
                decorationColor: isDark ? Colors.amber.shade400 : const Color(0xFFD97706),
              ),
            ),
          );
        }),

        // 段尾小翻译 Icon
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggleTrans,
              borderRadius: BorderRadius.circular(10),
              splashColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
              highlightColor: Colors.transparent,
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isTransExpanded
                      ? (isDark ? const Color(0xFF2563EB).withValues(alpha: 0.25) : const Color(0xFFDBEAFE))
                      : (isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.g_translate_outlined,
                      size: 13,
                      color: isTransExpanded
                          ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB))
                          : (isDark ? Colors.white60 : const Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '译文',
                      style: TextStyle(
                        fontSize: 11,
                        color: isTransExpanded
                            ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB))
                            : (isDark ? Colors.white60 : const Color(0xFF64748B)),
                        fontWeight: isTransExpanded ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionFooter(bool isDark, Article? nextArticle) {
    return Row(
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
                side: const BorderSide(color: LuminaColors.primary, width: 1.5),
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
    );
  }
}
