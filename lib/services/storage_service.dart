import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys
  static const String _keyUserProfile = 'user_profile';
  static const String _keyFavorites = 'favorites';
  static const String _keyLearningProgress = 'learning_progress';
  static const String _keyStreakDays = 'streak_days';
  static const String _keyLastPracticeDate = 'last_practice_date';
  static const String _keySettings = 'settings';
  static const String _keyWrongAnswers = 'wrong_answers';

  // User Profile
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _prefs?.setString(_keyUserProfile, jsonEncode(profile));
  }

  Map<String, dynamic>? getUserProfile() {
    final data = _prefs?.getString(_keyUserProfile);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  // Favorites (for words)
  Future<void> saveFavorites(Set<String> favoriteIds) async {
    await _prefs?.setStringList(_keyFavorites, favoriteIds.toList());
  }

  Set<String> getFavorites() {
    final list = _prefs?.getStringList(_keyFavorites) ?? [];
    return list.toSet();
  }

  Future<void> addFavorite(String id) async {
    final favorites = getFavorites();
    favorites.add(id);
    await saveFavorites(favorites);
  }

  Future<void> removeFavorite(String id) async {
    final favorites = getFavorites();
    favorites.remove(id);
    await saveFavorites(favorites);
  }

  bool isFavorite(String id) {
    return getFavorites().contains(id);
  }

  // Learning Progress
  Future<void> saveLearningProgress(Map<String, dynamic> progress) async {
    await _prefs?.setString(_keyLearningProgress, jsonEncode(progress));
  }

  Map<String, dynamic> getLearningProgress() {
    final data = _prefs?.getString(_keyLearningProgress);
    if (data != null) {
      return jsonDecode(data);
    }
    return {
      'totalWords': 0,
      'totalSentences': 0,
      'totalDialogues': 0,
      'totalMinutes': 0,
      'totalDays': 0,
    };
  }

  Future<void> updateProgress(String type, int count) async {
    final progress = getLearningProgress();
    final key = 'total${type[0].toUpperCase()}${type.substring(1)}s';
    if (progress.containsKey(key)) {
      progress[key] = (progress[key] ?? 0) + count;
    }
    await saveLearningProgress(progress);
  }

  // Streak tracking
  Future<void> updateStreak() async {
    final lastDateStr = _prefs?.getString(_keyLastPracticeDate);
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    int streakDays = _prefs?.getInt(_keyStreakDays) ?? 0;

    if (lastDateStr == null) {
      streakDays = 1;
    } else if (lastDateStr != todayStr) {
      final lastDate = DateTime.parse(lastDateStr);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        streakDays += 1;
      } else if (difference > 1) {
        streakDays = 1;
      }
    }

    await _prefs?.setInt(_keyStreakDays, streakDays);
    await _prefs?.setString(_keyLastPracticeDate, todayStr);
  }

  int getStreakDays() {
    return _prefs?.getInt(_keyStreakDays) ?? 0;
  }

  // Settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _prefs?.setString(_keySettings, jsonEncode(settings));
  }

  Map<String, dynamic> getSettings() {
    final data = _prefs?.getString(_keySettings);
    if (data != null) {
      return jsonDecode(data);
    }
    return {
      'darkMode': false,
      'fontSize': 'medium',
      'notificationsEnabled': true,
    };
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final settings = getSettings();
    settings[key] = value;
    await saveSettings(settings);
  }

  // Wrong Answers
  Future<void> saveWrongAnswers(List<Map<String, dynamic>> wrongAnswers) async {
    await _prefs?.setString(_keyWrongAnswers, jsonEncode(wrongAnswers));
  }

  List<Map<String, dynamic>> getWrongAnswers() {
    final data = _prefs?.getString(_keyWrongAnswers);
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<void> addWrongAnswer(Map<String, dynamic> wrongAnswer) async {
    final wrongAnswers = getWrongAnswers();
    wrongAnswers.add(wrongAnswer);
    await saveWrongAnswers(wrongAnswers);
  }

  Future<void> removeWrongAnswer(String id) async {
    final wrongAnswers = getWrongAnswers();
    wrongAnswers.removeWhere((item) => item['id'] == id);
    await saveWrongAnswers(wrongAnswers);
  }

  Future<void> clearWrongAnswers() async {
    await _prefs?.remove(_keyWrongAnswers);
  }

  Future<void> markWrongAnswerReviewed(String id) async {
    final wrongAnswers = getWrongAnswers();
    for (var i = 0; i < wrongAnswers.length; i++) {
      if (wrongAnswers[i]['id'] == id) {
        wrongAnswers[i]['reviewed'] = true;
        wrongAnswers[i]['lastReviewDate'] = DateTime.now().toIso8601String();
        break;
      }
    }
    await saveWrongAnswers(wrongAnswers);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
