import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/article.dart';
import '../services/article_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/lumina_theme.dart';
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

                // Custom TabBar (内容简介 | 章节目录)
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                        width: 1,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: LuminaColors.primary,
                    unselectedLabelColor: isDark ? Colors.white54 : const Color(0xFF64748B),
                    labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    indicatorColor: LuminaColors.primary,
                    indicatorWeight: 3,
                    tabs: [
                      const Tab(text: '内容简介'),
                      Tab(text: '章节目录 (${_chapters.length})'),
                    ],
                  ),
                ),

                // Tab Content Area
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: 内容简介
                      _buildDescriptionTab(isDark),

                      // Tab 2: 章节目录
                      _buildDirectoryTab(isDark),
                    ],
                  ),
                ),
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
                  value: '~${widget.book.wordCount} 词',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Description Title
          Row(
            children: [
              const Icon(Icons.auto_stories_rounded, size: 20, color: LuminaColors.primary),
              const SizedBox(width: 8),
              const Text(
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
        final unitNum = chapter.unitIndex ?? (index + 1);
        final isCurrentUnit = unitNum == _lastReadUnitIndex;

        return Card(
          elevation: 0,
          color: isCurrentUnit
              ? (isDark ? LuminaColors.primary.withValues(alpha: 0.15) : const Color(0xFFEFF6FF))
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isCurrentUnit
                  ? LuminaColors.primary
                  : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
              width: isCurrentUnit ? 1.5 : 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: isCurrentUnit
                  ? LuminaColors.primary
                  : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.orange.shade100),
              foregroundColor: isCurrentUnit
                  ? Colors.white
                  : (isDark ? Colors.orange.shade300 : Colors.orange.shade900),
              child: Text(
                'U$unitNum',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    chapter.chineseTitle ?? chapter.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isCurrentUnit ? LuminaColors.primary : null,
                    ),
                  ),
                ),
                if (isCurrentUnit)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: LuminaColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '上次学到',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                chapter.title,
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                  color: isCurrentUnit ? LuminaColors.primary : (isDark ? Colors.white38 : Colors.grey.shade400),
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
    final buttonLabel = isFirstChapter
        ? '开始阅读：第 1 章'
        : '继续阅读：第 $unitNum 章 (${targetArticle.chineseTitle ?? targetArticle.title})';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: LuminaColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            shadowColor: LuminaColors.primary.withValues(alpha: 0.4),
          ),
          onPressed: () => _openArticle(targetArticle),
          icon: const Icon(Icons.play_arrow_rounded, size: 24),
          label: Text(
            buttonLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
