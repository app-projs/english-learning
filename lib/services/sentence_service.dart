import '../mock/mock_sentences.dart';
import '../models/sentence.dart';
import 'storage_service.dart';

class SentenceService {
  final StorageService _storage;
  bool _useMockData = true;

  SentenceService(this._storage);

  Future<List<Sentence>> getSentences() async {
    if (_useMockData) {
      return MockSentences.getSentences();
    }
    return MockSentences.getSentences();
  }

  Future<List<Sentence>> getSentencesByDifficulty(String difficulty) async {
    if (_useMockData) {
      return MockSentences.getSentencesByDifficulty(difficulty);
    }
    return MockSentences.getSentencesByDifficulty(difficulty);
  }

  Future<Sentence?> getSentenceById(String id) async {
    return MockSentences.getSentenceById(id);
  }

  Future<void> recordPractice(int sentenceCount) async {
    await _storage.updateProgress('sentences', sentenceCount);
    await _storage.updateStreak();
  }
}
