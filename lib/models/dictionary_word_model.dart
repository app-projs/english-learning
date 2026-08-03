class DictionaryWordModel {
  final String id;
  final String word;
  final String phonetic;
  final String chinese;
  final String? pos;
  final String? example;
  final String? exampleTranslation;
  final String? source;
  final int? updatedAt;

  DictionaryWordModel({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.chinese,
    this.pos,
    this.example,
    this.exampleTranslation,
    this.source,
    this.updatedAt,
  });

  factory DictionaryWordModel.fromMap(Map<String, dynamic> map) {
    return DictionaryWordModel(
      id: map['id']?.toString() ?? map['word']?.toString() ?? '',
      word: map['word']?.toString() ?? '',
      phonetic: map['phonetic']?.toString() ?? '',
      chinese: map['chinese']?.toString() ?? '',
      pos: map['pos']?.toString(),
      example: map['example']?.toString(),
      exampleTranslation: map['example_translation']?.toString() ?? map['exampleTranslation']?.toString(),
      source: map['source']?.toString(),
      updatedAt: map['updated_at'] is int ? map['updated_at'] as int : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word.toLowerCase(),
      'phonetic': phonetic,
      'chinese': chinese,
      'pos': pos,
      'example': example,
      'example_translation': exampleTranslation,
      'source': source,
      'updated_at': updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }
}
