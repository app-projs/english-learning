import 'dart:convert';

class WordDefinition {
  final String pos; // 词性, e.g. n., v., adj., adv.
  final String meaning; // 中文释义
  final String? example; // 例句
  final String? exampleTranslation; // 例句翻译

  WordDefinition({
    required this.pos,
    required this.meaning,
    this.example,
    this.exampleTranslation,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    return WordDefinition(
      pos: json['pos'] ?? '',
      meaning: json['meaning'] ?? '',
      example: json['example'],
      exampleTranslation: json['exampleTranslation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pos': pos,
      'meaning': meaning,
      if (example != null) 'example': example,
      if (exampleTranslation != null) 'exampleTranslation': exampleTranslation,
    };
  }

  @override
  String toString() => pos.isNotEmpty ? '$pos $meaning' : meaning;
}

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
  final List<WordDefinition> definitions; // 详细多义释义列表

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
    this.definitions = const [],
  });

  /// 获取格式化的多行释义文本（每种解释换行）
  String get formattedDefinitions {
    if (definitions.isNotEmpty) {
      return definitions.map((d) => d.toString()).join('\n');
    }
    // 如果没有结构化 definitions，对 chinese 文本按分号/换行拆分并排版
    final parts = chinese.split(RegExp(r'[；;\n]')).where((s) => s.trim().isNotEmpty).toList();
    if (parts.length > 1) {
      return parts.map((p) => p.trim()).join('\n');
    }
    return chinese;
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    List<WordDefinition> defs = [];
    if (json['definitions'] != null) {
      if (json['definitions'] is List) {
        defs = (json['definitions'] as List)
            .map((e) => e is Map<String, dynamic> ? WordDefinition.fromJson(e) : WordDefinition.fromJson(jsonDecode(e)))
            .toList();
      } else if (json['definitions'] is String && (json['definitions'] as String).isNotEmpty) {
        try {
          final List parsed = jsonDecode(json['definitions']);
          defs = parsed.map((e) => WordDefinition.fromJson(e)).toList();
        } catch (_) {}
      }
    }

    // 解析 synonyms & antonyms (可能为 JSON 字符串或 List)
    List<String> parseStringList(dynamic val) {
      if (val is List) return val.map((e) => e.toString()).toList();
      if (val is String && val.isNotEmpty) {
        try {
          final List p = jsonDecode(val);
          return p.map((e) => e.toString()).toList();
        } catch (_) {
          return val.split(',').map((s) => s.trim()).toList();
        }
      }
      return [];
    }

    return Word(
      id: json['id'] ?? '',
      english: json['english'] ?? '',
      chinese: json['chinese'] ?? '',
      phonetic: json['phonetic'] ?? '',
      synonyms: parseStringList(json['synonyms']),
      antonyms: parseStringList(json['antonyms']),
      exampleSentence: json['exampleSentence'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      masteryLevel: json['masteryLevel'] ?? 0,
      definitions: defs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'chinese': chinese,
      'phonetic': phonetic,
      'synonyms': jsonEncode(synonyms),
      'antonyms': jsonEncode(antonyms),
      'exampleSentence': exampleSentence,
      'createdAt': createdAt.toIso8601String(),
      'masteryLevel': masteryLevel,
      'definitions': jsonEncode(definitions.map((d) => d.toJson()).toList()),
    };
  }
}
