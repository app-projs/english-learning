import '../mock/mock_words.dart';
import '../models/word.dart';
import 'storage_service.dart';
import 'database_service.dart';

class WordService {
  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false; // Set to false to use SQLite database by default

  WordService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    final dbWords = await _database.getAllWords();
    if (dbWords.isEmpty) {
      final mockWords = MockWords.getWords();
      for (final word in mockWords) {
        await _database.insertWord(word.toJson());
      }
    }
  }

  Future<List<Word>> getWords() async {
    if (_useMockData) {
      return MockWords.getWords();
    }
    await _seedDatabaseIfNeeded();
    final dbWords = await _database.getAllWords();
    return dbWords.map((json) => Word.fromJson(json)).toList();
  }

  Future<Word?> getWordById(String id) async {
    if (_useMockData) {
      return MockWords.getWordById(id);
    }
    await _seedDatabaseIfNeeded();
    final json = await _database.getWordById(id);
    if (json != null) {
      return Word.fromJson(json);
    }
    return null;
  }

  Future<Set<String>> getFavorites() async {
    return _storage.getFavorites();
  }

  Future<void> addFavorite(String wordId) async {
    await _storage.addFavorite(wordId);
    await _database.updateWordFavorite(wordId, true);
  }

  Future<void> removeFavorite(String wordId) async {
    await _storage.removeFavorite(wordId);
    await _database.updateWordFavorite(wordId, false);
  }

  Future<bool> isFavorite(String wordId) async {
    return _storage.isFavorite(wordId);
  }

  Future<void> recordPractice(int wordCount) async {
    await _storage.updateProgress('words', wordCount);
    await _storage.updateStreak();
  }
}
