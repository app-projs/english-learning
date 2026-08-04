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

class UserProfile {
  final String id;
  final String name;
  final String? avatar;
  final int totalDays;
  final int totalWords;
  final int totalSentences;
  final int totalDialogues;
  final int totalMinutes;
  final int streakDays;
  final int wordsGoal;
  final int sentencesGoal;
  final int dialoguesGoal;
  final DateTime joinedDate;

  UserProfile({
    required this.id,
    required this.name,
    this.avatar,
    required this.totalDays,
    required this.totalWords,
    required this.totalSentences,
    required this.totalDialogues,
    required this.totalMinutes,
    required this.streakDays,
    required this.wordsGoal,
    required this.sentencesGoal,
    required this.dialoguesGoal,
    required this.joinedDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '1',
      name: json['name'] ?? 'User',
      avatar: json['avatar'],
      totalDays: json['totalDays'] ?? 0,
      totalWords: json['totalWords'] ?? 0,
      totalSentences: json['totalSentences'] ?? 0,
      totalDialogues: json['totalDialogues'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      streakDays: json['streakDays'] ?? 0,
      wordsGoal: json['wordsGoal'] ?? 500,
      sentencesGoal: json['sentencesGoal'] ?? 200,
      dialoguesGoal: json['dialoguesGoal'] ?? 50,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'totalDays': totalDays,
      'totalWords': totalWords,
      'totalSentences': totalSentences,
      'totalDialogues': totalDialogues,
      'totalMinutes': totalMinutes,
      'streakDays': streakDays,
      'wordsGoal': wordsGoal,
      'sentencesGoal': sentencesGoal,
      'dialoguesGoal': dialoguesGoal,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}

class ActivityRecord {
  final String type;
  final String title;
  final int count;
  final String time;

  ActivityRecord({
    required this.type,
    required this.title,
    required this.count,
    required this.time,
  });

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    return ActivityRecord(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      count: json['count'] ?? 0,
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'count': count,
      'time': time,
    };
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool unlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'star',
      unlocked: json['unlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'unlocked': unlocked,
    };
  }
}
