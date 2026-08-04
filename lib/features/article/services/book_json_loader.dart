import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/article.dart';
import '../models/book.dart';

class BookJsonLoader {
  static const List<String> bookIds = [
    'book_anne',
    'book_prince',
    'book_alice',
    'book_oz',
    'book_treasure',
    'book_sea',
    'book_gatsby',
    'book_sherlock',
    'book_pride',
    'book_twocities',
    'book_jane',
    'book_beauty',
    'book_nights',
    'book_stoneface',
  ];

  static Future<Map<String, dynamic>?> loadBookJson(String bookId) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/books/$bookId.json');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Book>> loadAllBooks() async {
    final List<Book> books = [];
    for (final id in bookIds) {
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
    final map = await loadBookJson(bookId);
    if (map != null && map['chapters'] is List) {
      final chaptersList = map['chapters'] as List;
      return chaptersList.map((c) {
        final cMap = Map<String, dynamic>.from(c);
        cMap['id'] = '${bookId}_u${cMap['unitIndex']}';
        cMap['bookId'] = bookId;
        cMap['difficulty'] = map['difficulty'] ?? 'Intermediate';
        cMap['category'] = map['category'] ?? '经典名著';
        cMap['coverUrl'] = map['coverUrl'] ?? '';
        return Article.fromJson(cMap);
      }).toList();
    }
    return [];
  }

  static Future<List<Article>> loadAllBookChapters() async {
    final List<Article> allArticles = [];
    for (final id in bookIds) {
      final chapters = await getBookChapters(id);
      allArticles.addAll(chapters);
    }
    return allArticles;
  }
}
