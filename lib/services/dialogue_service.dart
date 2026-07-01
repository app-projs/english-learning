import '../mock/mock_dialogues.dart';
import '../models/sentence.dart';
import 'storage_service.dart';
import 'database_service.dart';

class DialogueService {
  final StorageService _storage;
  final DatabaseService _database;
  final bool _useMockData = false; // Set to false to use SQLite database by default

  DialogueService(this._storage, this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    final dbDialogues = await _database.getAllDialogues();
    if (dbDialogues.isEmpty) {
      final mockDialogues = MockDialogues.getDialogues();
      for (final dialogue in mockDialogues) {
        await _database.insertDialogue(dialogue.toJson());
      }
    }
  }

  Future<List<Dialogue>> getDialogues() async {
    if (_useMockData) {
      return MockDialogues.getDialogues();
    }
    await _seedDatabaseIfNeeded();
    final dbDialogues = await _database.getAllDialogues();
    return dbDialogues.map((json) => Dialogue.fromJson(json)).toList();
  }

  Future<Dialogue?> getDialogueById(String id) async {
    if (_useMockData) {
      return MockDialogues.getDialogueById(id);
    }
    await _seedDatabaseIfNeeded();
    final json = await _database.getDialogueById(id);
    if (json != null) {
      return Dialogue.fromJson(json);
    }
    return null;
  }

  Future<List<Dialogue>> getDialoguesByDifficulty(String difficulty) async {
    if (_useMockData) {
      return MockDialogues.getDialoguesByDifficulty(difficulty);
    }
    await _seedDatabaseIfNeeded();
    final dbDialogues = await _database.getDialoguesByDifficulty(difficulty);
    return dbDialogues.map((json) => Dialogue.fromJson(json)).toList();
  }

  Future<void> recordPractice(int dialogueCount) async {
    await _storage.updateProgress('dialogues', dialogueCount);
    await _storage.updateStreak();
  }
}
