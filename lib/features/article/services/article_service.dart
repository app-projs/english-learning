import '../mock/mock_articles.dart';
import '../models/article.dart';
import '../models/book.dart';
import 'book_json_loader.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/database_service.dart';

class ArticleService {
  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false;

  ArticleService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    try {
      final dbBooks = await _database.getAllBooks();
      final dbArticles = await _database.getAllArticles();
      
      final allBookChapters = await BookJsonLoader.loadAllBookChapters();
      final mockArticles = MockArticles.getArticles();
      final totalExpectedArticles = allBookChapters.length + mockArticles.length;

      if (dbBooks.isEmpty || dbArticles.length != totalExpectedArticles) {
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
      }
    } catch (e) {
      // Graceful fallback on database error
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      return MockArticles.searchArticles(query);
    }
  }

  Future<void> markArticleAsRead(String articleId, {bool isRead = true}) async {
    try {
      await _database.markArticleAsRead(articleId, isRead: isRead);
    } catch (e) {
      // Ignore database write errors in fallback mode
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
    } catch (e) {
      // Ignore database history write errors in fallback mode
    }
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }
}
