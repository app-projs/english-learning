class MockUser {
  static Map<String, dynamic> getUserProfile() {
    return {
      'id': '1',
      'name': '英语学习者',
      'avatar': null,
      'totalDays': 15,
      'totalWords': 256,
      'totalSentences': 89,
      'totalDialogues': 12,
      'streakDays': 5,
      'totalMinutes': 320,
      'wordsGoal': 500,
      'sentencesGoal': 200,
      'dialoguesGoal': 50,
      'joinedDate': '2026-01-28',
    };
  }

  static List<Map<String, dynamic>> getRecentActivity() {
    return [
      {'type': 'word', 'title': '单词练习', 'count': 20, 'time': '今天'},
      {'type': 'sentence', 'title': '句子练习', 'count': 10, 'time': '今天'},
      {'type': 'article', 'title': '阅读文章', 'count': 2, 'time': '昨天'},
      {'type': 'dialogue', 'title': '对话练习', 'count': 1, 'time': '昨天'},
      {'type': 'word', 'title': '单词练习', 'count': 15, 'time': '2天前'},
      {'type': 'sentence', 'title': '句子练习', 'count': 8, 'time': '3天前'},
    ];
  }

  static List<Map<String, dynamic>> getAchievements() {
    return [
      {
        'id': '1',
        'name': '初学者',
        'description': '完成首次学习',
        'icon': 'star',
        'unlocked': true
      },
      {
        'id': '2',
        'name': '连续学习',
        'description': '连续学习3天',
        'icon': 'local_fire_department',
        'unlocked': true
      },
      {
        'id': '3',
        'name': '单词达人',
        'description': '学习100个单词',
        'icon': 'translate',
        'unlocked': true
      },
      {
        'id': '4',
        'name': '学而不厌',
        'description': '连续学习7天',
        'icon': 'local_fire_department',
        'unlocked': false
      },
      {
        'id': '5',
        'name': '句子大师',
        'description': '学习200个句子',
        'icon': 'format_quote',
        'unlocked': false
      },
      {
        'id': '6',
        'name': '对话高手',
        'description': '完成50个对话',
        'icon': 'chat',
        'unlocked': false
      },
    ];
  }
}
