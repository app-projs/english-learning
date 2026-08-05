import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/article.dart';
import '../models/book.dart';

/// 完全遵照 docs/tools/epub-book-import.md 标准规范实现的书籍 JSON 加载服务：
/// 1. 从 catalog.json 读取所有书籍索引与目录路径
/// 2. 从每本书的目录（如 Anne_of_Green_Gables/）读取 book.json 获取书籍元数据
/// 3. 从 chapters.json 读取章节目录，并按需加载 chapters/001.json 等单章规范双语正文
class BookJsonLoader {
  static const _booksRoot = 'assets/data/books';

  /// 加载 catalog.json 入口
  static Future<Map<String, dynamic>> _loadCatalog() async {
    try {
      final jsonString = await rootBundle.loadString('$_booksRoot/catalog.json');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading catalog.json: $e');
      return {'books': []};
    }
  }

  /// 查找 catalog 中指定 bookId 的条目配置
  static Future<Map<String, dynamic>?> _findCatalogEntry(String bookId) async {
    final catalog = await _loadCatalog();
    final books = catalog['books'];
    if (books is! List) return null;

    for (final item in books) {
      if (item is Map) {
        final id = item['id']?.toString();
        if (id == bookId || id?.toLowerCase() == bookId.toLowerCase()) {
          return Map<String, dynamic>.from(item);
        }
      }
    }
    return null;
  }

  static String _bookDirectory(Map<String, dynamic> catalogEntry) {
    return catalogEntry['path']?.toString() ?? catalogEntry['id'].toString();
  }

  /// 加载书籍的主配置清单（book.json）
  static Future<Map<String, dynamic>?> loadBookJson(String bookId) async {
    final entry = await _findCatalogEntry(bookId);
    if (entry == null) return null;

    final directory = _bookDirectory(entry);
    final manifestPath =
        entry['manifest']?.toString() ?? '$directory/book.json';

    try {
      final jsonString = await rootBundle.loadString('$_booksRoot/$manifestPath');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading book manifest for $bookId ($manifestPath): $e');
      return null;
    }
  }

  /// 加载所有书籍信息列表
  static Future<List<Book>> loadAllBooks() async {
    final List<Book> books = [];
    final catalog = await _loadCatalog();
    final catalogBooks = catalog['books'];
    if (catalogBooks is! List) return books;

    for (final item in catalogBooks) {
      if (item is! Map) continue;
      final id = item['id']?.toString();
      if (id == null || id.isEmpty) continue;
      try {
        final book = await getBook(id);
        if (book != null) {
          books.add(book);
        }
      } catch (e) {
        debugPrint('Failed to load book $id: $e');
      }
    }
    return books;
  }

  /// 获取指定 ID 的书籍模型
  static Future<Book?> getBook(String bookId) async {
    final map = await loadBookJson(bookId);
    if (map != null) {
      return Book.fromJson(map);
    }
    return null;
  }

  /// 获取指定书籍的所有章节文章（标准 EPUB 架构，读取 chapters.json 及单章 json）
  static Future<List<Article>> getBookChapters(String bookId) async {
    final entry = await _findCatalogEntry(bookId);
    final bookData = await loadBookJson(bookId);
    if (entry == null || bookData == null) return [];

    final directory = _bookDirectory(entry);
    final realBookId = bookData['id']?.toString() ?? bookId;

    try {
      final indexString =
          await rootBundle.loadString('$_booksRoot/$directory/chapters.json');
      final index = jsonDecode(indexString) as Map<String, dynamic>;
      final chaptersList = index['chapters'];
      if (chaptersList is! List) return [];

      final chapters = <Article>[];
      final difficulty = bookData['difficulty']?.toString() ?? '中级难度';
      final category = bookData['category']?.toString() ?? '经典名著';
      final coverUrl = bookData['coverUrl']?.toString() ?? '';

      for (final item in chaptersList) {
        if (item is! Map) continue;
        final chapterIndex = Map<String, dynamic>.from(item);
        final chapterPath = chapterIndex['path']?.toString();
        if (chapterPath == null || chapterPath.isEmpty) continue;

        try {
          final chapterString =
              await rootBundle.loadString('$_booksRoot/$directory/$chapterPath');
          final chapter = Map<String, dynamic>.from(jsonDecode(chapterString));

          chapter['id'] = chapter['id'] ?? '${realBookId}_u${chapter['unitIndex']}';
          chapter['bookId'] = realBookId;
          chapter['chineseTitle'] = (chapter['chineseTitle'] != null && chapter['chineseTitle'].toString().isNotEmpty)
              ? chapter['chineseTitle']
              : chapterIndex['chineseTitle'];
          chapter['difficulty'] = chapter['difficulty'] ?? difficulty;
          chapter['category'] = chapter['category'] ?? category;
          chapter['coverUrl'] = chapter['coverUrl'] ?? coverUrl;

          // 补全文章纯文本 content
          if (chapter['content'] == null && chapter['paragraphs'] is List) {
            final pList = chapter['paragraphs'] as List;
            final buf = StringBuffer();
            for (final p in pList) {
              if (p is Map && p['en'] != null) {
                buf.writeln(p['en']);
              }
            }
            chapter['content'] = buf.toString();
          }

          chapters.add(Article.fromJson(chapter));
        } catch (err) {
          debugPrint('Error loading single chapter $chapterPath: $err');
        }
      }
      return chapters;
    } catch (e) {
      debugPrint('Error loading chapters.json for $bookId: $e');
      return [];
    }
  }

  /// 加载所有书籍的完全章节列表
  static Future<List<Article>> loadAllBookChapters() async {
    final List<Article> allArticles = [];
    final catalog = await _loadCatalog();
    final catalogBooks = catalog['books'];
    if (catalogBooks is! List) return allArticles;

    for (final item in catalogBooks) {
      if (item is! Map) continue;
      final id = item['id']?.toString();
      if (id == null || id.isEmpty) continue;
      try {
        final chapters = await getBookChapters(id);
        allArticles.addAll(chapters);
      } catch (e) {
        debugPrint('Failed to load chapters for book $id: $e');
      }
    }
    return allArticles;
  }
}
