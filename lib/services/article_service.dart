import '../mock/mock_articles.dart';
import '../mock/mock_books.dart';
import '../models/article.dart';
import '../models/book.dart';
import 'storage_service.dart';
import 'database_service.dart';

class ArticleService {
  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false;

  ArticleService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    try {
      final dbBooks = await _database.getAllBooks();
      if (dbBooks.isEmpty) {
        final sampleBooks = MockBooks.getSampleBooks();
        for (final book in sampleBooks) {
          await _database.insertBook(book.toJson());
        }

        final allBookChapters = [
          ...MockBooks.getAnneChapters(),
          ...MockBooks.getPrinceChapters(),
          ...MockBooks.getBeautyChapters(),
          ...MockBooks.getNightsChapters(),
          ...MockBooks.getStoneFaceChapters(),
        ];
        for (final article in allBookChapters) {
          await _database.insertArticle(article.toJson());
        }

        final mockArticles = MockArticles.getArticles();
        for (final article in mockArticles) {
          await _database.insertArticle(article.toJson());
        }
      }
    } catch (e) {
      // Graceful fallback on database error
    }
  }

  List<Article> _getMockBookChapters(String bookId) {
    switch (bookId) {
      case 'book_anne':
        return MockBooks.getAnneChapters();
      case 'book_prince':
        return MockBooks.getPrinceChapters();
      case 'book_beauty':
        return MockBooks.getBeautyChapters();
      case 'book_nights':
        return MockBooks.getNightsChapters();
      case 'book_stoneface':
        return MockBooks.getStoneFaceChapters();
      default:
        return MockArticles.getArticles();
    }
  }

  Future<List<Book>> getBooks() async {
    if (_useMockData) {
      return MockBooks.getSampleBooks();
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbBooks = await _database.getAllBooks();
      if (dbBooks.isEmpty) {
        return MockBooks.getSampleBooks();
      }
      return dbBooks.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      return MockBooks.getSampleBooks();
    }
  }

  Future<List<Article>> getArticlesByBookId(String bookId) async {
    if (_useMockData) {
      return _getMockBookChapters(bookId);
    }
    try {
      await _seedDatabaseIfNeeded();
      final dbArticles = await _database.getArticlesByBookId(bookId);
      if (dbArticles.isEmpty) {
        return _getMockBookChapters(bookId);
      }
      return dbArticles.map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      return _getMockBookChapters(bookId);
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

  Future<void> recordReading(int minutes) async {
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }

  Future<void> recordReadingWithId(String articleId, int minutes) async {
    try {
      await _database.addReadingHistory(articleId, minutes);
    } catch (e) {
      // Ignore database history write errors in fallback mode
    }
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }
}
