import '../mock/mock_sentences.dart';
import '../models/sentence.dart';
import 'storage_service.dart';
import 'database_service.dart';

class SentenceService {
  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false; // Set to false to use SQLite database by default

  SentenceService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    final dbSentences = await _database.getAllSentences();
    if (dbSentences.isEmpty) {
      final mockSentences = MockSentences.getSentences();
      for (final sentence in mockSentences) {
        await _database.insertSentence(sentence.toJson());
      }
    }
  }

  Future<List<Sentence>> getSentences() async {
    if (_useMockData) {
      return MockSentences.getSentences();
    }
    await _seedDatabaseIfNeeded();
    final dbSentences = await _database.getAllSentences();
    return dbSentences.map((json) => Sentence.fromJson(json)).toList();
  }

  Future<List<Sentence>> getSentencesByDifficulty(String difficulty) async {
    if (_useMockData) {
      return MockSentences.getSentencesByDifficulty(difficulty);
    }
    await _seedDatabaseIfNeeded();
    final dbSentences = await _database.getSentencesByDifficulty(difficulty);
    return dbSentences.map((json) => Sentence.fromJson(json)).toList();
  }

  Future<Sentence?> getSentenceById(String id) async {
    if (_useMockData) {
      return MockSentences.getSentenceById(id);
    }
    await _seedDatabaseIfNeeded();
    final json = await _database.getSentenceById(id);
    if (json != null) {
      return Sentence.fromJson(json);
    }
    return null;
  }

  Future<void> recordPractice(int sentenceCount) async {
    await _storage.updateProgress('sentences', sentenceCount);
    await _storage.updateStreak();
  }
}
