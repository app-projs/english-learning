import '../mock/mock_articles.dart';
import '../models/article.dart';

class ArticleService {
  bool _useMockData = true;

  Future<List<Article>> getArticles() async {
    if (_useMockData) {
      return MockArticles.getArticles();
    }
    return MockArticles.getArticles();
  }

  Future<Article?> getArticleById(String id) async {
    return MockArticles.getArticleById(id);
  }

  Future<List<Article>> getArticlesByDifficulty(String difficulty) async {
    return MockArticles.getArticlesByDifficulty(difficulty);
  }

  Future<List<Article>> searchArticles(String query) async {
    return MockArticles.searchArticles(query);
  }

  Future<void> recordReading(int minutes) async {
    // Future: save reading time to storage
  }
}
