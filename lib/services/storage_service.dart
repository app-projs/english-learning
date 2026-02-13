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
  static const String _keyPracticeStats = 'practice_stats';
  static const String _keyDailyPractice = 'daily_practice';

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

  // Practice Statistics
  Future<void> savePracticeStats(Map<String, dynamic> stats) async {
    await _prefs?.setString(_keyPracticeStats, jsonEncode(stats));
  }

  Map<String, dynamic> getPracticeStats() {
    final data = _prefs?.getString(_keyPracticeStats);
    if (data != null) {
      return jsonDecode(data);
    }
    return {
      'totalPracticeCount': 0,
      'correctCount': 0,
      'wrongCount': 0,
      'totalTimeMinutes': 0,
      'wordsPracticed': 0,
      'sentencesPracticed': 0,
      'dialoguesPracticed': 0,
      'listeningPracticed': 0,
    };
  }

  Future<void> recordPractice({
    required String practiceType,
    required int correctCount,
    required int wrongCount,
    required int timeMinutes,
  }) async {
    final stats = getPracticeStats();
    stats['totalPracticeCount'] = (stats['totalPracticeCount'] ?? 0) + 1;
    stats['correctCount'] = (stats['correctCount'] ?? 0) + correctCount;
    stats['wrongCount'] = (stats['wrongCount'] ?? 0) + wrongCount;
    stats['totalTimeMinutes'] = (stats['totalTimeMinutes'] ?? 0) + timeMinutes;

    switch (practiceType) {
      case '单词':
        stats['wordsPracticed'] =
            (stats['wordsPracticed'] ?? 0) + correctCount + wrongCount;
        break;
      case '句子':
        stats['sentencesPracticed'] =
            (stats['sentencesPracticed'] ?? 0) + correctCount + wrongCount;
        break;
      case '对话':
        stats['dialoguesPracticed'] =
            (stats['dialoguesPracticed'] ?? 0) + correctCount + wrongCount;
        break;
      case '听力':
        stats['listeningPracticed'] =
            (stats['listeningPracticed'] ?? 0) + correctCount + wrongCount;
        break;
    }

    await savePracticeStats(stats);
    await _recordDailyPractice(practiceType, correctCount + wrongCount);
  }

  // Daily Practice Tracking
  Future<void> _recordDailyPractice(String type, int count) async {
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final dailyData = _prefs?.getString(_keyDailyPractice);
    Map<String, dynamic> dailyMap = {};

    if (dailyData != null) {
      dailyMap = jsonDecode(dailyData);
    }

    if (!dailyMap.containsKey(dateKey)) {
      dailyMap[dateKey] = {
        'words': 0,
        'sentences': 0,
        'dialogues': 0,
        'listening': 0,
        'total': 0,
      };
    }

    dailyMap[dateKey][type] = (dailyMap[dateKey][type] ?? 0) + count;
    dailyMap[dateKey]['total'] = (dailyMap[dateKey]['total'] ?? 0) + count;

    // Keep only last 30 days
    final keysToRemove = <String>[];
    for (var key in dailyMap.keys) {
      final date = DateTime.parse(key);
      if (today.difference(date).inDays > 30) {
        keysToRemove.add(key);
      }
    }
    for (var key in keysToRemove) {
      dailyMap.remove(key);
    }

    await _prefs?.setString(_keyDailyPractice, jsonEncode(dailyMap));
  }

  Map<String, dynamic> getDailyPractice() {
    final data = _prefs?.getString(_keyDailyPractice);
    if (data != null) {
      return jsonDecode(data);
    }
    return {};
  }

  List<Map<String, dynamic>> getWeeklyPracticeData() {
    final dailyData = getDailyPractice();
    final today = DateTime.now();
    final result = <Map<String, dynamic>>[];

    for (var i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (dailyData.containsKey(dateKey)) {
        result.add({
          'date': dateKey,
          'total': dailyData[dateKey]['total'] ?? 0,
          'words': dailyData[dateKey]['words'] ?? 0,
          'sentences': dailyData[dateKey]['sentences'] ?? 0,
          'dialogues': dailyData[dateKey]['dialogues'] ?? 0,
          'listening': dailyData[dateKey]['listening'] ?? 0,
        });
      } else {
        result.add({
          'date': dateKey,
          'total': 0,
          'words': 0,
          'sentences': 0,
          'dialogues': 0,
          'listening': 0,
        });
      }
    }

    return result;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
