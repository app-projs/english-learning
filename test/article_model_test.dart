import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/article/models/article.dart';

void main() {
  test('Article JSON round-trip preserves paragraphs and read state', () {
    final article = Article(
      id: 'article-1',
      title: 'Persistent article',
      content: 'First paragraph.\n\nSecond paragraph.',
      difficulty: 'Beginner',
      tags: const ['test'],
      createdAt: DateTime(2026, 8, 4),
      readTime: 1,
      isRead: true,
      paragraphs: [
        ParagraphBlock(en: 'First paragraph.', zh: '第一段。'),
        ParagraphBlock(en: 'Second paragraph.', zh: '第二段。'),
      ],
    );

    final storedJson = article.toJson();
    storedJson['paragraphs'] = jsonEncode(storedJson['paragraphs']);
    final restored = Article.fromJson(storedJson);

    expect(restored.isRead, isTrue);
    expect(restored.paragraphs, hasLength(2));
    expect(restored.paragraphs.first.zh, '第一段。');
  });
}
