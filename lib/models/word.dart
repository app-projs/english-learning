class Word {
  final String id;
  final String english;
  final String chinese;
  final String phonetic;
  final List<String> synonyms;
  final List<String> antonyms;
  final String exampleSentence;
  final DateTime createdAt;
  final int masteryLevel;

  Word({
    required this.id,
    required this.english,
    required this.chinese,
    required this.phonetic,
    required this.synonyms,
    required this.antonyms,
    required this.exampleSentence,
    required this.createdAt,
    required this.masteryLevel,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      english: json['english'],
      chinese: json['chinese'],
      phonetic: json['phonetic'] ?? '',
      synonyms: List<String>.from(json['synonyms'] ?? []),
      antonyms: List<String>.from(json['antonyms'] ?? []),
      exampleSentence: json['exampleSentence'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      masteryLevel: json['masteryLevel'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'chinese': chinese,
      'phonetic': phonetic,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'exampleSentence': exampleSentence,
      'createdAt': createdAt.toIso8601String(),
      'masteryLevel': masteryLevel,
    };
  }
}
