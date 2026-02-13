import '../mock/mock_dialogues.dart';
import '../models/sentence.dart';
import 'storage_service.dart';

class DialogueService {
  final StorageService _storage;
  bool _useMockData = true;

  DialogueService(this._storage);

  Future<List<Dialogue>> getDialogues() async {
    if (_useMockData) {
      return MockDialogues.getDialogues();
    }
    return MockDialogues.getDialogues();
  }

  Future<Dialogue?> getDialogueById(String id) async {
    return MockDialogues.getDialogueById(id);
  }

  Future<List<Dialogue>> getDialoguesByDifficulty(String difficulty) async {
    return MockDialogues.getDialoguesByDifficulty(difficulty);
  }

  Future<void> recordPractice(int dialogueCount) async {
    await _storage.updateProgress('dialogues', dialogueCount);
    await _storage.updateStreak();
  }
}
