import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/book.dart';
import '../services/article_service.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import 'article_detail_screen.dart';
import 'book_detail_screen.dart';

class ReadingTab extends StatefulWidget {
  const ReadingTab({super.key});

  @override
  State<ReadingTab> createState() => _ReadingTabState();
}

class _ReadingTabState extends State<ReadingTab> {
  ArticleService? _articleService;
  List<Book> _books = [];
  List<Article> _articles = [];
  bool _isLoading = true;
  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '经典名著', '短文精读', '新闻美文'];

  @override
  void initState() {
    super.initState();
    _initService();
  }

  void _initService() async {
    try {
      final storage = await StorageService.getInstance();
      final db = await DatabaseService.getInstance();
      _articleService = ArticleService(storage, db);
      _loadData();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadData() async {
    if (_articleService == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }
    try {
      final books = await _articleService!.getBooks();
      final articles = await _articleService!.getArticles();
      if (!mounted) return;
      setState(() {
        _books = books;
        _articles = articles;
      });
    } catch (e) {
      // Error fallback
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Book> get _filteredBooks {
    if (_selectedCategory == '全部' || _selectedCategory == '经典名著') {
      return _books;
    }
    return _books.where((b) => b.category == _selectedCategory).toList();
  }

  List<Article> get _filteredArticles {
    if (_selectedCategory == '全部') {
      return _articles.where((a) => a.bookId == null).toList();
    }
    if (_selectedCategory == '经典名著') {
      return [];
    }
    return _articles.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读文章'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter Smooth Sliding Pill Tab Bar
                  _SmoothCategoryTabBar(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onSelectCategory: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Book Shelf Section (Render if category has books)
                  if (_filteredBooks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '📖 经典名著书架',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_filteredBooks.length} 本精选名著',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredBooks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return YoudaoBookCard(
                          book: book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailScreen(book: book),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Short Articles / News Articles Section (Render if category has articles)
                  if (_filteredArticles.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        _selectedCategory == '新闻美文'
                            ? '📰 新闻美文合集'
                            : (_selectedCategory == '短文精读' ? '📄 短文精读合集' : '📄 推荐短文精读'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredArticles.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final article = _filteredArticles[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(article: article),
                                ),
                              );
                            },
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _selectedCategory == '新闻美文' ? '📰' : '📄',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            title: Text(
                              article.chineseTitle ?? article.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: [
                                  Chip(
                                    label: Text(article.difficulty, style: const TextStyle(fontSize: 10)),
                                    backgroundColor: Colors.blue.shade50,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${article.readTime} 分钟', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}

// Youdao Dictionary Inspired Book Card
class YoudaoBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const YoudaoBookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Book Cover Stack (3:4 ratio + badges)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 90,
                      height: 124,
                      child: book.coverUrl.startsWith('assets/')
                          ? Image.asset(
                              book.coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.deepOrange.shade100,
                                  child: const Center(
                                    child: Icon(Icons.book, size: 36, color: Colors.deepOrange),
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              book.coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.deepOrange.shade100,
                                  child: const Center(
                                    child: Icon(Icons.book, size: 36, color: Colors.deepOrange),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  // Top-Left Badge (精读 · 经典好书)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD97706), Color(0xFFB45309)],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        book.coverBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Bottom-Left Status Badge (12单元)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${book.totalUnits} 单元',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Right Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      book.chineseTitle.isNotEmpty ? book.chineseTitle : book.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tag Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            book.tagLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        // Reader Heat
                        Text(
                          book.readerCount,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmoothCategoryTabBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const _SmoothCategoryTabBar({
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = categories.indexOf(selectedCategory).clamp(0, categories.length - 1);
    final count = categories.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth) / count;
          final pillXAlignment = -1.0 + (selectedIndex * 2.0 / (count - 1));

          return Stack(
            children: [
              // Smooth Sliding Pill Indicator (白色/深灰平滑滑块)
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment(pillXAlignment, 0.0),
                child: Container(
                  width: itemWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Text Labels Row
              Row(
                children: categories.map((cat) {
                  final isSelected = cat == selectedCategory;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onSelectCategory(cat),
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Colors.deepOrange.shade700
                                : (isDark ? Colors.white60 : Colors.grey.shade600),
                          ),
                          child: Text(cat),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

