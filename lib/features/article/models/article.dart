import 'dart:convert';

class ParagraphBlock {
  final String en;
  final String zh;

  ParagraphBlock({
    required this.en,
    required this.zh,
  });

  factory ParagraphBlock.fromJson(Map<String, dynamic> json) {
    return ParagraphBlock(
      en: json['en']?.toString() ?? '',
      zh: json['zh']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'zh': zh,
    };
  }
}

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
  final List<ParagraphBlock> paragraphs;

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
    List<ParagraphBlock>? paragraphs,
  }) : paragraphs = paragraphs ?? _buildParagraphsFromText(content, chineseContent);

  static List<ParagraphBlock> _buildParagraphsFromText(String enText, String? zhText) {
    final enParas = enText.split(RegExp(r'\n+')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final zhParas = (zhText ?? '').split(RegExp(r'\n+')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    List<ParagraphBlock> blocks = [];
    for (int i = 0; i < enParas.length; i++) {
      final en = enParas[i];
      final zh = i < zhParas.length ? zhParas[i] : '';
      blocks.add(ParagraphBlock(en: en, zh: zh));
    }
    return blocks;
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    List<ParagraphBlock>? parsedParagraphs;
    if (json['paragraphs'] != null) {
      if (json['paragraphs'] is List) {
        parsedParagraphs = (json['paragraphs'] as List)
            .map((item) => ParagraphBlock.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else if (json['paragraphs'] is String && (json['paragraphs'] as String).isNotEmpty) {
        try {
          final List list = jsonDecode(json['paragraphs']);
          parsedParagraphs = list.map((item) => ParagraphBlock.fromJson(Map<String, dynamic>.from(item))).toList();
        } catch (_) {}
      }
    }

    final rawContent = json['content']?.toString() ?? '';
    final rawZhContent = json['chineseContent']?.toString();

    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: rawContent.isNotEmpty
          ? rawContent
          : (parsedParagraphs != null ? parsedParagraphs.map((p) => p.en).join('\n\n') : ''),
      difficulty: json['difficulty']?.toString() ?? 'Medium',
      tags: json['tags'] is List
          ? List<String>.from(json['tags'])
          : (json['tags'] is String && (json['tags'] as String).isNotEmpty)
              ? (json['tags'] as String).split(',')
              : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      readTime: json['readTime'] ?? 5,
      category: json['category']?.toString(),
      bookId: json['bookId']?.toString(),
      unitIndex: json['unitIndex'] is int ? json['unitIndex'] : int.tryParse(json['unitIndex']?.toString() ?? ''),
      coverUrl: json['coverUrl']?.toString(),
      chineseTitle: json['chineseTitle']?.toString(),
      chineseContent: rawZhContent ?? (parsedParagraphs != null ? parsedParagraphs.map((p) => p.zh).join('\n\n') : null),
      paragraphs: parsedParagraphs,
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
      'paragraphs': paragraphs.map((p) => p.toJson()).toList(),
    };
  }
}
