class Article {
  final String id;
  final String title;
  final String content;
  final String difficulty;
  final List<String> tags;
  final DateTime createdAt;
  final int readTime;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.difficulty,
    required this.tags,
    required this.createdAt,
    required this.readTime,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      difficulty: json['difficulty'],
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['createdAt']),
      readTime: json['readTime'],
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
    };
  }
}
