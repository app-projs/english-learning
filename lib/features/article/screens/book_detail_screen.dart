import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/article.dart';
import '../services/article_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/lumina_theme.dart';
import '../../../core/widgets/app_tab_bar.dart';
import 'article_detail_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> with SingleTickerProviderStateMixin {
  ArticleService? _articleService;
  StorageService? _storageService;
  List<Article> _chapters = [];
  bool _isLoading = true;
  int _lastReadUnitIndex = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    AudioService.instance.stop();
    super.dispose();
  }

  void _initService() async {
    _storageService = await StorageService.getInstance();
    final db = await DatabaseService.getInstance();
    _articleService = ArticleService(_storageService!, db);
    
    // Load last read chapter unit index for this book
    final lastUnit = _storageService!.getInt('last_read_unit_${widget.book.id}') ?? 1;
    _lastReadUnitIndex = lastUnit;

    _loadChapters();
  }

  void _loadChapters() async {
    if (_articleService == null) return;
    final chapters = await _articleService!.getArticlesByBookId(widget.book.id);
    if (!mounted) return;
    setState(() {
      _chapters = chapters;
      _isLoading = false;
    });
  }

  Article? _getTargetStartArticle() {
    if (_chapters.isEmpty) return null;
    return _chapters.firstWhere(
      (c) => (c.unitIndex ?? 1) == _lastReadUnitIndex,
      orElse: () => _chapters.first,
    );
  }

  void _openArticle(Article article) {
    if (article.unitIndex != null && _storageService != null) {
      _storageService!.saveInt('last_read_unit_${widget.book.id}', article.unitIndex!);
      setState(() {
        _lastReadUnitIndex = article.unitIndex!;
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(
          article: article,
          onCompleted: () {
            if (article.unitIndex != null && _storageService != null) {
              _storageService!.saveInt('last_read_unit_${widget.book.id}', article.unitIndex!);
            }
          },
        ),
      ),
    ).then((_) {
      // Refresh last read state when returning from article
      if (_storageService != null) {
        final updatedLastUnit = _storageService!.getInt('last_read_unit_${widget.book.id}') ?? 1;
        if (mounted) {
          setState(() {
            _lastReadUnitIndex = updatedLastUnit;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final targetStartArticle = _getTargetStartArticle();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.chineseTitle.isNotEmpty ? widget.book.chineseTitle : widget.book.title),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top Header Banner (Cover & Metadata)
                _buildHeaderBanner(isDark),

                if (_chapters.length > 1) ...[
                  // Unified AppTabBar (内容简介 | 章节目录)
                  AppTabBar(
                    controller: _tabController,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    tabs: [
                      const Tab(text: '内容简介'),
                      Tab(text: '章节目录 (${_chapters.length})'),
                    ],
                  ),
                  // Tab Content Area
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDescriptionTab(isDark),
                        _buildDirectoryTab(isDark),
                      ],
                    ),
                  ),
                ] else ...[
                  // 单章节书籍不展示章节目录，保留简介和底部阅读入口。
                  Expanded(child: _buildDescriptionTab(isDark)),
                ],
              ],
            ),

      // Fixed Bottom Reading Bar Button
      bottomNavigationBar: _isLoading || targetStartArticle == null
          ? null
          : _buildBottomReadingBar(isDark, targetStartArticle),
    );
  }

  Widget _buildHeaderBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Card
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 138,
              color: Colors.grey.shade300,
              child: widget.book.coverUrl.startsWith('assets/')
                  ? Image.asset(
                      widget.book.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.deepOrange.shade100,
                          child: const Icon(Icons.book, size: 44, color: Colors.deepOrange),
                        );
                      },
                    )
                  : Image.network(
                      widget.book.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.deepOrange.shade100,
                          child: const Icon(Icons.book, size: 44, color: Colors.deepOrange),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.book.chineseTitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.book.chineseTitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.deepOrange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '作者：${widget.book.author}',
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.book.category,
                        style: TextStyle(fontSize: 11, color: Colors.orange.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.book.difficulty,
                        style: TextStyle(fontSize: 11, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (widget.book.readerCount.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.book.readerCount,
                          style: TextStyle(fontSize: 11, color: Colors.purple.shade900, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int get _calculatedTotalWordCount {
    if (_chapters.isEmpty) return widget.book.wordCount;
    int sum = 0;
    for (final c in _chapters) {
      final words = c.content.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      sum += words;
    }
    return sum > 0 ? sum : widget.book.wordCount;
  }

  Widget _buildDescriptionTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Badges Row
          Row(
            children: [
              Expanded(
                child: _buildInfoMetricCard(
                  isDark: isDark,
                  icon: Icons.menu_book_rounded,
                  iconColor: Colors.blue,
                  title: '总章节',
                  value: '${_chapters.length} 单元',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoMetricCard(
                  isDark: isDark,
                  icon: Icons.translate_rounded,
                  iconColor: Colors.deepOrange,
                  title: '目标词汇',
                  value: widget.book.targetVocab,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoMetricCard(
                  isDark: isDark,
                  icon: Icons.font_download_rounded,
                  iconColor: Colors.green,
                  title: '预估词数',
                  value: '~$_calculatedTotalWordCount 词',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Description Title
          const Row(
            children: [
              Icon(Icons.auto_stories_rounded, size: 20, color: LuminaColors.primary),
              SizedBox(width: 8),
              Text(
                '名著导读与深度简介',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Description Content Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              widget.book.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoMetricCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDirectoryTab(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: _chapters.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final chapter = _chapters[index];

        return Card(
          elevation: 0,
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            title: Text(
              chapter.chineseTitle ?? chapter.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      chapter.title,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (chapter.isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF10B981).withValues(alpha: 0.15) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF34D399).withValues(alpha: 0.3) : const Color(0xFFA7F3D0),
                          width: 0.8,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 11,
                            color: Color(0xFF059669),
                          ),
                          SizedBox(width: 3),
                          Text(
                            '已读',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${chapter.readTime} 分钟',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
              ],
            ),
            onTap: () => _openArticle(chapter),
          ),
        );
      },
    );
  }

  Widget _buildBottomReadingBar(bool isDark, Article targetArticle) {
    final unitNum = targetArticle.unitIndex ?? 1;
    final isFirstChapter = _lastReadUnitIndex == 1;
    final buttonLabel = isFirstChapter ? '开始阅读' : '阅读第 $unitNum 章';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            foregroundColor: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            elevation: 0,
          ),
          onPressed: () => _openArticle(targetArticle),
          child: Text(
            buttonLabel,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
