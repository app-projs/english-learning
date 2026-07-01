import '../mock/mock_user.dart';
import '../models/user.dart';
import 'storage_service.dart';

class UserService {
  final StorageService _storage;
  bool _useMockData = true;

  UserService(this._storage);

  Future<UserProfile> getUserProfile() async {
    Map<String, dynamic>? profileMap = _storage.getUserProfile();
    if (profileMap == null) {
      profileMap = MockUser.getUserProfile();
      await _storage.saveUserProfile(profileMap);
    }

    final progress = _storage.getLearningProgress();
    final streak = _storage.getStreakDays();

    return UserProfile(
      id: profileMap['id'] ?? '1',
      name: profileMap['name'] ?? '英语学习者',
      avatar: profileMap['avatar'],
      totalDays: progress['totalDays'] ?? profileMap['totalDays'] ?? 15,
      totalWords: progress['totalWords'] ?? profileMap['totalWords'] ?? 256,
      totalSentences:
          progress['totalSentences'] ?? profileMap['totalSentences'] ?? 89,
      totalDialogues:
          progress['totalDialogues'] ?? profileMap['totalDialogues'] ?? 12,
      totalMinutes: progress['totalMinutes'] ?? profileMap['totalMinutes'] ?? 320,
      streakDays: streak,
      wordsGoal: profileMap['wordsGoal'] ?? 500,
      sentencesGoal: profileMap['sentencesGoal'] ?? 200,
      dialoguesGoal: profileMap['dialoguesGoal'] ?? 50,
      joinedDate: DateTime.parse(profileMap['joinedDate'] ?? '2026-01-28'),
    );
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
      final progress = _storage.getLearningProgress();
      final streak = _storage.getStreakDays();
      
      final totalWords = progress['totalWords'] ?? 256;
      final totalSentences = progress['totalSentences'] ?? 89;
      final totalDialogues = progress['totalDialogues'] ?? 12;

      return mockData.map((e) {
        bool unlocked = e['unlocked'] ?? false;
        final id = e['id'];
        if (id == '1') {
          unlocked = true; // Complete first study (always unlocked)
        } else if (id == '2') {
          unlocked = streak >= 3; // Streak 3 days
        } else if (id == '3') {
          unlocked = totalWords >= 100; // Words >= 100
        } else if (id == '4') {
          unlocked = streak >= 7; // Streak 7 days
        } else if (id == '5') {
          unlocked = totalSentences >= 200; // Sentences >= 200
        } else if (id == '6') {
          unlocked = totalDialogues >= 50; // Dialogues >= 50
        }
        return Achievement(
          id: id,
          name: e['name'],
          description: e['description'],
          icon: e['icon'],
          unlocked: unlocked,
        );
      }).toList();
    }
    return [];
  }

  Future<void> updateUserName(String name) async {
    Map<String, dynamic>? profileMap = _storage.getUserProfile();
    if (profileMap == null) {
      profileMap = MockUser.getUserProfile();
    }
    profileMap['name'] = name;
    await _storage.saveUserProfile(profileMap);
  }

  Future<void> updateUserGoals({
    required int wordsGoal,
    required int sentencesGoal,
    required int dialoguesGoal,
  }) async {
    Map<String, dynamic>? profileMap = _storage.getUserProfile();
    if (profileMap == null) {
      profileMap = MockUser.getUserProfile();
    }
    profileMap['wordsGoal'] = wordsGoal;
    profileMap['sentencesGoal'] = sentencesGoal;
    profileMap['dialoguesGoal'] = dialoguesGoal;
    await _storage.saveUserProfile(profileMap);
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

