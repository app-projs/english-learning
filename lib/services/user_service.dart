import '../mock/mock_user.dart';
import '../models/user.dart';
import 'storage_service.dart';

class UserService {
  final StorageService _storage;
  bool _useMockData = true;

  UserService(this._storage);

  Future<UserProfile> getUserProfile() async {
    if (_useMockData) {
      final mockData = MockUser.getUserProfile();
      final progress = _storage.getLearningProgress();
      final streak = _storage.getStreakDays();

      return UserProfile(
        id: mockData['id'],
        name: mockData['name'],
        avatar: mockData['avatar'],
        totalDays: progress['totalDays'] ?? mockData['totalDays'],
        totalWords: progress['totalWords'] ?? mockData['totalWords'],
        totalSentences:
            progress['totalSentences'] ?? mockData['totalSentences'],
        totalDialogues:
            progress['totalDialogues'] ?? mockData['totalDialogues'],
        totalMinutes: progress['totalMinutes'] ?? mockData['totalMinutes'],
        streakDays: streak,
        wordsGoal: mockData['wordsGoal'],
        sentencesGoal: mockData['sentencesGoal'],
        dialoguesGoal: mockData['dialoguesGoal'],
        joinedDate: DateTime.parse(mockData['joinedDate']),
      );
    }
    // Future: fetch from API or local DB
    final mockData = MockUser.getUserProfile();
    return UserProfile.fromJson(mockData);
  }

  Future<List<ActivityRecord>> getRecentActivity() async {
    if (_useMockData) {
      final mockData = MockUser.getRecentActivity();
      return mockData.map((e) => ActivityRecord.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Achievement>> getAchievements() async {
    if (_useMockData) {
      final mockData = MockUser.getAchievements();
      return mockData.map((e) => Achievement.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> updateUserName(String name) async {
    // TODO: Save to storage
  }

  Future<Map<String, dynamic>> getSettings() async {
    return _storage.getSettings();
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    await _storage.saveSettings(settings);
  }

  Future<void> updateSetting(String key, dynamic value) async {
    await _storage.updateSetting(key, value);
  }
}
