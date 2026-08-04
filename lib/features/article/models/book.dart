class Book {
  final String id;
  final String title;
  final String chineseTitle;
  final String author;
  final String coverUrl;
  final String description;
  final String category;
  final String difficulty;
  final int totalUnits;
  final int wordCount;
  final String readerCount;
  final String targetVocab;
  final String tagLabel;
  final String coverBadge;

  Book({
    required this.id,
    required this.title,
    required this.chineseTitle,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.totalUnits,
    required this.wordCount,
    this.readerCount = '10万+人在读',
    this.targetVocab = '1000-3500词',
    this.tagLabel = '名著小说',
    this.coverBadge = '精读 · 经典好书',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      chineseTitle: json['chineseTitle'] ?? '',
      author: json['author'] ?? 'Unknown',
      coverUrl: json['coverUrl'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '经典好书',
      difficulty: json['difficulty'] ?? '中级',
      totalUnits: json['totalUnits'] ?? 12,
      wordCount: json['wordCount'] ?? 12000,
      readerCount: json['readerCount'] ?? '10万+人在读',
      targetVocab: json['targetVocab'] ?? '1000-3500词',
      tagLabel: json['tagLabel'] ?? '名著小说',
      coverBadge: json['coverBadge'] ?? '精读 · 经典好书',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'chineseTitle': chineseTitle,
      'author': author,
      'coverUrl': coverUrl,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'totalUnits': totalUnits,
      'wordCount': wordCount,
      'readerCount': readerCount,
      'targetVocab': targetVocab,
      'tagLabel': tagLabel,
      'coverBadge': coverBadge,
    };
  }
}
