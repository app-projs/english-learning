import '../mock/mock_articles.dart';
import '../models/article.dart';
import 'storage_service.dart';
import 'database_service.dart';

class ArticleService {
  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false; // Set to false to use SQLite database by default

  ArticleService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    final dbArticles = await _database.getAllArticles();
    if (dbArticles.isEmpty) {
      final mockArticles = MockArticles.getArticles();
      for (final article in mockArticles) {
        await _database.insertArticle(article.toJson());
      }
    }
  }

  Future<List<Article>> getArticles() async {
    if (_useMockData) {
      return MockArticles.getArticles();
    }
    await _seedDatabaseIfNeeded();
    final dbArticles = await _database.getAllArticles();
    return dbArticles.map((json) => Article.fromJson(json)).toList();
  }

  Future<Article?> getArticleById(String id) async {
    if (_useMockData) {
      return MockArticles.getArticleById(id);
    }
    await _seedDatabaseIfNeeded();
    final json = await _database.getArticleById(id);
    if (json != null) {
      return Article.fromJson(json);
    }
    return null;
  }

  Future<List<Article>> getArticlesByDifficulty(String difficulty) async {
    if (_useMockData) {
      return MockArticles.getArticlesByDifficulty(difficulty);
    }
    await _seedDatabaseIfNeeded();
    final dbArticles = await _database.getArticlesByDifficulty(difficulty);
    return dbArticles.map((json) => Article.fromJson(json)).toList();
  }

  Future<List<Article>> searchArticles(String query) async {
    if (_useMockData) {
      return MockArticles.searchArticles(query);
    }
    await _seedDatabaseIfNeeded();
    final dbArticles = await _database.searchArticles(query);
    return dbArticles.map((json) => Article.fromJson(json)).toList();
  }

  Future<void> recordReading(int minutes) async {
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }

  Future<void> recordReadingWithId(String articleId, int minutes) async {
    await _database.addReadingHistory(articleId, minutes);
    await _storage.updateProgress('minutes', minutes);
    await _storage.updateStreak();
  }
}
