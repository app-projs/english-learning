import '../../../features/word/models/word.dart';

class Sentence {
  final String id;
  final String english;
  final String chinese;
  final List<Word> keyWords;
  final String difficulty;
  final String category;
  final DateTime createdAt;

  Sentence({
    required this.id,
    required this.english,
    required this.chinese,
    required this.keyWords,
    required this.difficulty,
    required this.category,
    required this.createdAt,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'],
      english: json['english'],
      chinese: json['chinese'],
      keyWords: (json['keyWords'] as List?)
              ?.map((word) => Word.fromJson(word))
              .toList() ??
          [],
      difficulty: json['difficulty'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'chinese': chinese,
      'keyWords': keyWords.map((word) => word.toJson()).toList(),
      'difficulty': difficulty,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
