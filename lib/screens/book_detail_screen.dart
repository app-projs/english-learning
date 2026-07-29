import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/article.dart';
import '../services/article_service.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../services/audio_service.dart';
import 'article_detail_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  ArticleService? _articleService;
  List<Article> _chapters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  void _initService() async {
    final storage = await StorageService.getInstance();
    final db = await DatabaseService.getInstance();
    _articleService = ArticleService(storage, db);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.chineseTitle.isNotEmpty ? widget.book.chineseTitle : widget.book.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                            width: 110,
                            height: 150,
                            color: Colors.grey.shade300,
                            child: widget.book.coverUrl.startsWith('assets/')
                                ? Image.asset(
                                    widget.book.coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.deepOrange.shade100,
                                        child: const Icon(Icons.book, size: 48, color: Colors.deepOrange),
                                      );
                                    },
                                  )
                                : Image.network(
                                    widget.book.coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.deepOrange.shade100,
                                        child: const Icon(Icons.book, size: 48, color: Colors.deepOrange),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.book.chineseTitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.book.chineseTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepOrange.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                '作者：${widget.book.author}',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: Text(widget.book.category, style: const TextStyle(fontSize: 11)),
                                    backgroundColor: Colors.orange.shade100,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Chip(
                                    label: Text(widget.book.difficulty, style: const TextStyle(fontSize: 11)),
                                    backgroundColor: Colors.blue.shade100,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '书籍简介',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.book.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  // Unit List Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '章节目录 (${_chapters.length} 单元)',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '总字数: ~${widget.book.wordCount} 词',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),

                  // Chapter Units List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _chapters.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final chapter = _chapters[index];
                      final unitNum = chapter.unitIndex ?? (index + 1);

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            foregroundColor: Colors.orange.shade900,
                            child: Text('U$unitNum', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          title: Text(
                            chapter.chineseTitle ?? chapter.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              chapter.title,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${chapter.readTime} 分钟',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(article: chapter),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
