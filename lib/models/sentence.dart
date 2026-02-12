import 'word.dart';

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

class Dialogue {
  final String id;
  final String title;
  final List<DialogueLine> lines;
  final String difficulty;
  final String context;
  final DateTime createdAt;

  Dialogue({
    required this.id,
    required this.title,
    required this.lines,
    required this.difficulty,
    required this.context,
    required this.createdAt,
  });

  factory Dialogue.fromJson(Map<String, dynamic> json) {
    return Dialogue(
      id: json['id'],
      title: json['title'],
      lines: (json['lines'] as List)
          .map((line) => DialogueLine.fromJson(line))
          .toList(),
      difficulty: json['difficulty'],
      context: json['context'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lines': lines.map((line) => line.toJson()).toList(),
      'difficulty': difficulty,
      'context': context,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DialogueLine {
  final String speaker;
  final String english;
  final String chinese;

  DialogueLine({
    required this.speaker,
    required this.english,
    required this.chinese,
  });

  factory DialogueLine.fromJson(Map<String, dynamic> json) {
    return DialogueLine(
      speaker: json['speaker'],
      english: json['english'],
      chinese: json['chinese'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'english': english,
      'chinese': chinese,
    };
  }
}
