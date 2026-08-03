class Article {
  final String id;
  final String title;
  final String content;
  final String difficulty;
  final List<String> tags;
  final DateTime createdAt;
  final int readTime;
  final String? category;
  final String? bookId;
  final int? unitIndex;
  final String? coverUrl;
  final String? chineseTitle;
  final String? chineseContent;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.difficulty,
    required this.tags,
    required this.createdAt,
    required this.readTime,
    this.category,
    this.bookId,
    this.unitIndex,
    this.coverUrl,
    this.chineseTitle,
    this.chineseContent,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      difficulty: json['difficulty'],
      tags: json['tags'] is List
          ? List<String>.from(json['tags'])
          : (json['tags'] is String && (json['tags'] as String).isNotEmpty)
              ? (json['tags'] as String).split(',')
              : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      readTime: json['readTime'] ?? 5,
      category: json['category'],
      bookId: json['bookId'],
      unitIndex: json['unitIndex'],
      coverUrl: json['coverUrl'],
      chineseTitle: json['chineseTitle'],
      chineseContent: json['chineseContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'difficulty': difficulty,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'readTime': readTime,
      'category': category,
      'bookId': bookId,
      'unitIndex': unitIndex,
      'coverUrl': coverUrl,
      'chineseTitle': chineseTitle,
      'chineseContent': chineseContent,
    };
  }
}
