import 'package:flutter/foundation.dart';

import '../mock/mock_articles.dart';
import '../models/article.dart';
import '../models/book.dart';
import 'book_json_loader.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/database_service.dart';

class ArticleService {
  static const _contentVersion = '30';
  static const _contentVersionKey = 'article_content_version';

  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false;
  Future<void>? _contentSyncFuture;

  ArticleService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    _contentSyncFuture ??= _syncContent();
    try {
      await _contentSyncFuture;
    } catch (_) {
      _contentSyncFuture = null;
      rethrow;
    }
  }

  Future<void> _syncContent() async {
    try {
      final dbBooks = await _database.getAllBooks();
      final dbArticles = await _database.getAllArticles();
      final savedContentVersion =
          await _database.getContentMetadata(_contentVersionKey);
      final allBookChapters = await BookJsonLoader.loadAllBookChapters();
      final mockArticles = MockArticles.getArticles();
      final totalExpectedArticles =
          allBookChapters.length + mockArticles.length;

      final needsSync = savedContentVersion != _contentVersion ||
          dbBooks.isEmpty ||
          dbArticles.length != totalExpectedArticles;
      if (needsSync) {
        if (savedContentVersion != _contentVersion) {
          await _database.clearBookContent();
        }

        final sampleBooks = await BookJsonLoader.loadAllBooks();
        for (final book in sampleBooks) {
          await _database.insertBook(book.toJson());
        }

        for (final article in allBookChapters) {
          await _database.insertArticle(article.toJson());
        }

        for (final article in mockArticles) {
          await _database.insertArticle(article.toJson());
        }
        await _database.setContentMetadata(_contentVersionKey, _contentVersion);
      }
    } catch (error, stackTrace) {
      debugPrint('Article content synchronization failed: $error\n$stackTrace');
      rethrow;
    }
  }

  Future<List<Book>> getBooks() async {
    if (_useMockData) {
      return BookJsonLoader.loadAllBooks();
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbBooks = await _database.getAllBooks();
      if (dbBooks.isEmpty) {
        return BookJsonLoader.loadAllBooks();
      }
      return dbBooks.map((json) => Book.fromJson(json)).toList();
    } catch (error, stackTrace) {
      debugPrint('Failed to load books from the database: $error\n$stackTrace');
      return BookJsonLoader.loadAllBooks();
    }
  }

  Future<List<Article>> getArticlesByBookId(String bookId) async {
    if (_useMockData) {
      return BookJsonLoader.getBookChapters(bookId);
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbArticles = await _database.getArticlesByBookId(bookId);
      if (dbArticles.isEmpty) {
        return BookJsonLoader.getBookChapters(bookId);
      }
      return dbArticles.map((json) => Article.fromJson(json)).toList();
    } catch (error, stackTrace) {
      debugPrint(
          'Failed to load book articles from the database: $error\n$stackTrace');
      return BookJsonLoader.getBookChapters(bookId);
    }
  }

  Future<List<Article>> getArticles() async {
    if (_useMockData) {
      return MockArticles.getArticles();
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbArticles = await _database.getAllArticles();
      if (dbArticles.isEmpty) {
        return MockArticles.getArticles();
      }
      return dbArticles.map((json) => Article.fromJson(json)).toList();
    } catch (error, stackTrace) {
      debugPrint(
          'Failed to load articles from the database: $error\n$stackTrace');
      return MockArticles.getArticles();
    }
  }

  Future<Article?> getArticleById(String id) async {
    if (_useMockData) {
      return MockArticles.getArticleById(id);
    }
    try {
      await _seedDatabaseIfNeeded();
      final json = await _database.getArticleById(id);
      if (json != null) {
        return Article.fromJson(json);
      }
      return MockArticles.getArticleById(id);
    } catch (error, stackTrace) {
      debugPrint(
          'Failed to load an article from the database: $error\n$stackTrace');
      return MockArticles.getArticleById(id);
    }
  }

  Future<List<Article>> getArticlesByDifficulty(String difficulty) async {
    if (_useMockData) {
      return MockArticles.getArticlesByDifficulty(difficulty);
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbArticles = await _database.getArticlesByDifficulty(difficulty);
      return dbArticles.map((json) => Article.fromJson(json)).toList();
    } catch (error, stackTrace) {
      debugPrint('Failed to load articles by difficulty: $error\n$stackTrace');
      return MockArticles.getArticlesByDifficulty(difficulty);
    }
  }

  Future<List<Article>> searchArticles(String query) async {
    if (_useMockData) {
      return MockArticles.searchArticles(query);
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbArticles = await _database.searchArticles(query);
      return dbArticles.map((json) => Article.fromJson(json)).toList();
    } catch (error, stackTrace) {
      debugPrint('Failed to search articles: $error\n$stackTrace');
      return MockArticles.searchArticles(query);
    }
  }

  Future<void> markArticleAsRead(String articleId, {bool isRead = true}) async {
    try {
      await _database.markArticleAsRead(articleId, isRead: isRead);
    } catch (error, stackTrace) {
      debugPrint('Failed to update article read status: $error\n$stackTrace');
      rethrow;
    }
  }

  Future<void> recordReading(int minutes) async {
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }

  Future<void> recordReadingWithId(String articleId, int minutes) async {
    try {
      await _database.addReadingHistory(articleId, minutes);
      await _database.markArticleAsRead(articleId, isRead: true);
    } catch (error, stackTrace) {
      debugPrint(
          'Failed to record article reading history: $error\n$stackTrace');
      rethrow;
    }
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }
}
