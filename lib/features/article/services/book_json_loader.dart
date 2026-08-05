import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/article.dart';
import '../models/book.dart';

class BookJsonLoader {
  static const _booksRoot = 'assets/data/books';

  static Future<Map<String, dynamic>> _loadCatalog() async {
    final jsonString = await rootBundle.loadString('$_booksRoot/catalog.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> _findCatalogEntry(String bookId) async {
    final catalog = await _loadCatalog();
    final books = catalog['books'];
    if (books is! List) return null;

    for (final item in books) {
      if (item is Map && item['id']?.toString() == bookId) {
        return Map<String, dynamic>.from(item);
      }
    }
    return null;
  }

  static String _bookDirectory(Map<String, dynamic> catalogEntry) {
    return catalogEntry['path']?.toString() ?? catalogEntry['id'].toString();
  }

  static Future<Map<String, dynamic>?> _loadBookManifest(String bookId) async {
    final entry = await _findCatalogEntry(bookId);
    if (entry == null) return null;

    final manifestPath =
        entry['manifest']?.toString() ?? '${_bookDirectory(entry)}/book.json';
    try {
      final jsonString =
          await rootBundle.loadString('$_booksRoot/$manifestPath');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> loadBookJson(String bookId) async {
    return _loadBookManifest(bookId);
  }

  static Future<List<Book>> loadAllBooks() async {
    final List<Book> books = [];
    final catalog = await _loadCatalog();
    final catalogBooks = catalog['books'];
    if (catalogBooks is! List) return books;

    for (final item in catalogBooks) {
      if (item is! Map) continue;
      final id = item['id']?.toString();
      if (id == null || id.isEmpty) continue;
      final book = await getBook(id);
      if (book != null) {
        books.add(book);
      }
    }
    return books;
  }

  static Future<Book?> getBook(String bookId) async {
    final map = await loadBookJson(bookId);
    if (map != null) {
      return Book.fromJson(map);
    }
    return null;
  }

  static Future<List<Article>> getBookChapters(String bookId) async {
    final entry = await _findCatalogEntry(bookId);
    final book = await loadBookJson(bookId);
    if (entry == null || book == null) return [];

    final directory = _bookDirectory(entry);
    try {
      final indexString =
          await rootBundle.loadString('$_booksRoot/$directory/chapters.json');
      final index = jsonDecode(indexString) as Map<String, dynamic>;
      final chaptersList = index['chapters'];
      if (chaptersList is! List) return [];

      final chapters = <Article>[];
      for (final item in chaptersList) {
        if (item is! Map) continue;
        final chapterIndex = Map<String, dynamic>.from(item);
        final chapterPath = chapterIndex['path']?.toString();
        if (chapterPath == null || chapterPath.isEmpty) continue;

        final chapterString =
            await rootBundle.loadString('$_booksRoot/$directory/$chapterPath');
        final chapter = Map<String, dynamic>.from(jsonDecode(chapterString));
        chapter['id'] = chapter['id'] ?? '${bookId}_u${chapter['unitIndex']}';
        chapter['bookId'] = bookId;
        chapter['difficulty'] = book['difficulty'] ?? 'Intermediate';
        chapter['category'] = book['category'] ?? '经典名著';
        chapter['coverUrl'] = book['coverUrl'] ?? '';
        chapters.add(Article.fromJson(chapter));
      }
      return chapters;
    } catch (_) {
      return [];
    }
  }

  static Future<List<Article>> loadAllBookChapters() async {
    final List<Article> allArticles = [];
    final catalog = await _loadCatalog();
    final catalogBooks = catalog['books'];
    if (catalogBooks is! List) return allArticles;

    for (final item in catalogBooks) {
      if (item is! Map) continue;
      final id = item['id']?.toString();
      if (id == null || id.isEmpty) continue;
      final chapters = await getBookChapters(id);
      allArticles.addAll(chapters);
    }
    return allArticles;
  }
}
