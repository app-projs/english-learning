import '../models/sentence.dart';

class MockSentences {
  static List<Sentence> getSentences() {
    return [
      Sentence(
        id: '1',
        english: 'The sun rises in the east.',
        chinese: '太阳从东方升起。',
        keyWords: [],
        difficulty: 'easy',
        category: 'daily',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '2',
        english: 'She is reading a book in the library.',
        chinese: '她正在图书馆看书。',
        keyWords: [],
        difficulty: 'medium',
        category: 'daily',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '3',
        english: 'If you work hard, you will succeed.',
        chinese: '如果你努力工作，你就会成功。',
        keyWords: [],
        difficulty: 'medium',
        category: 'grammar',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '4',
        english: 'The more you practice, the better you become.',
        chinese: '练习越多，你越好。',
        keyWords: [],
        difficulty: 'hard',
        category: 'grammar',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '5',
        english: 'Learning English takes time and patience.',
        chinese: '学习英语需要时间和耐心。',
        keyWords: [],
        difficulty: 'easy',
        category: 'learning',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '6',
        english: 'I would like to book a table for dinner.',
        chinese: '我想预订一张晚餐桌。',
        keyWords: [],
        difficulty: 'easy',
        category: 'daily',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '7',
        english: 'Could you tell me how to get to the station?',
        chinese: '你能告诉我怎么去车站吗？',
        keyWords: [],
        difficulty: 'medium',
        category: 'daily',
        createdAt: DateTime.now(),
      ),
      Sentence(
        id: '8',
        english: 'It has been raining since early morning.',
        chinese: '从早上开始就一直在下雨。',
        keyWords: [],
        difficulty: 'medium',
        category: 'grammar',
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<Sentence> getSentencesByDifficulty(String difficulty) {
    return getSentences().where((s) => s.difficulty == difficulty).toList();
  }

  static Sentence? getSentenceById(String id) {
    return getSentences().where((s) => s.id == id).firstOrNull;
  }
}
