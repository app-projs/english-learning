class UserProgress {
  final String userId;
  final int totalWordsLearned;
  final int totalArticlesRead;
  final int totalPracticeSessions;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> wordMasteryLevels;
  final List<String> completedArticles;
  final List<String> completedSentences;
  final List<String> completedDialogues;
  final DateTime lastStudyDate;
  final int totalStudyMinutes;

  UserProgress({
    required this.userId,
    required this.totalWordsLearned,
    required this.totalArticlesRead,
    required this.totalPracticeSessions,
    required this.currentStreak,
    required this.longestStreak,
    required this.wordMasteryLevels,
    required this.completedArticles,
    required this.completedSentences,
    required this.completedDialogues,
    required this.lastStudyDate,
    required this.totalStudyMinutes,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      totalWordsLearned: json['totalWordsLearned'] ?? 0,
      totalArticlesRead: json['totalArticlesRead'] ?? 0,
      totalPracticeSessions: json['totalPracticeSessions'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      wordMasteryLevels: Map<String, int>.from(json['wordMasteryLevels'] ?? {}),
      completedArticles: List<String>.from(json['completedArticles'] ?? []),
      completedSentences: List<String>.from(json['completedSentences'] ?? []),
      completedDialogues: List<String>.from(json['completedDialogues'] ?? []),
      lastStudyDate: DateTime.parse(json['lastStudyDate']),
      totalStudyMinutes: json['totalStudyMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalWordsLearned': totalWordsLearned,
      'totalArticlesRead': totalArticlesRead,
      'totalPracticeSessions': totalPracticeSessions,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'wordMasteryLevels': wordMasteryLevels,
      'completedArticles': completedArticles,
      'completedSentences': completedSentences,
      'completedDialogues': completedDialogues,
      'lastStudyDate': lastStudyDate.toIso8601String(),
      'totalStudyMinutes': totalStudyMinutes,
    };
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final String avatar;
  final DateTime joinDate;
  final UserProgress progress;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.joinDate,
    required this.progress,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'] ?? '',
      joinDate: DateTime.parse(json['joinDate']),
      progress: UserProgress.fromJson(json['progress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'joinDate': joinDate.toIso8601String(),
      'progress': progress.toJson(),
    };
  }
}
