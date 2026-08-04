/// 对话模型（从 sentence.dart 拆分独立）
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
