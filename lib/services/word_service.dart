import '../mock/mock_words.dart';
import '../models/word.dart';
import 'storage_service.dart';

class WordService {
  final StorageService _storage;
  bool _useMockData = true;

  WordService(this._storage);

  Future<List<Word>> getWords() async {
    if (_useMockData) {
      return MockWords.getWords();
    }
    // Future: fetch from API or local DB
    return MockWords.getWords();
  }

  Future<Word?> getWordById(String id) async {
    if (_useMockData) {
      return MockWords.getWordById(id);
    }
    return MockWords.getWordById(id);
  }

  Future<Set<String>> getFavorites() async {
    return _storage.getFavorites();
  }

  Future<void> addFavorite(String wordId) async {
    await _storage.addFavorite(wordId);
  }

  Future<void> removeFavorite(String wordId) async {
    await _storage.removeFavorite(wordId);
  }

  Future<bool> isFavorite(String wordId) async {
    return _storage.isFavorite(wordId);
  }

  Future<void> recordPractice(int wordCount) async {
    await _storage.updateProgress('words', wordCount);
    await _storage.updateStreak();
  }
}
