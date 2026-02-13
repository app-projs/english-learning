import '../models/article.dart';

class MockArticles {
  static List<Article> getArticles() {
    return [
      Article(
        id: '1',
        title: 'The Benefits of Reading English Books',
        content:
            '''Reading books in English can significantly improve your language skills. It helps expand your vocabulary, improves grammar understanding, and enhances comprehension abilities.

When you read regularly, you expose yourself to various writing styles and sentence structures. This helps you develop a natural feel for the language.

Key benefits include:
1. Vocabulary expansion - you learn new words in context
2. Grammar improvement - you see grammar rules applied in real sentences
3. Better writing - you absorb good writing patterns
4. Cultural knowledge - you learn about English-speaking cultures

Start with books that match your level and gradually progress to more challenging materials.''',
        difficulty: 'Intermediate',
        tags: ['Reading', 'Vocabulary', 'Books'],
        createdAt: DateTime.now(),
        readTime: 5,
      ),
      Article(
        id: '2',
        title: 'How to Improve Your English Speaking',
        content:
            '''Speaking English fluently requires practice and dedication. Here are some effective strategies to improve your spoken English.

1. Practice daily - Speak English every day, even if it's just to yourself
2. Think in English - Try to think in English instead of translating
3. Listen and repeat - Watch English videos and repeat after speakers
4. Find a speaking partner - Practice with native speakers or fellow learners
5. Don't be afraid of mistakes - Mistakes are part of learning

Remember, the key to improving your speaking is consistent practice. Set realistic goals and track your progress.''',
        difficulty: 'Beginner',
        tags: ['Speaking', 'Practice', 'Tips'],
        createdAt: DateTime.now(),
        readTime: 7,
      ),
      Article(
        id: '3',
        title: 'Advanced English Grammar Tips',
        content:
            '''Mastering English grammar takes time and effort. Here are some advanced grammar concepts that will help you sound more natural.

1. Perfect Tenses
   - Present Perfect: I have finished my work
   - Past Perfect: I had eaten before he arrived
   - Future Perfect: I will have completed it by tomorrow

2. Modal Verbs for Probability
   - Must/Could/Might for different levels of certainty

3. Conditional Sentences
   - Zero: If water boils, it evaporates
   - First: If it rains, I will stay home
   - Second: If I won the lottery, I would travel
   - Third: If I had studied, I would have passed

Understanding these structures will elevate your English to a more advanced level.''',
        difficulty: 'Advanced',
        tags: ['Grammar', 'Advanced', 'Tips'],
        createdAt: DateTime.now(),
        readTime: 10,
      ),
      Article(
        id: '4',
        title: 'Daily English Phrases for Communication',
        content:
            '''Learning common phrases is essential for everyday communication. Here are some useful expressions:

Greetings:
- How are you doing?
- Nice to meet you
- Long time no see

Making Conversation:
- What do you do for a living?
- How's everything going?
- What's new?

Expressing Opinions:
- In my opinion...
- I think that...
- From my point of view...

Polite Requests:
- Could you please...?
- Would you mind...?
- I'd appreciate it if...

These phrases will help you communicate more naturally in daily situations.''',
        difficulty: 'Beginner',
        tags: ['Speaking', 'Phrases', 'Daily'],
        createdAt: DateTime.now(),
        readTime: 6,
      ),
      Article(
        id: '5',
        title: 'Understanding English Idioms',
        content:
            '''Idioms are phrases where the meaning cannot be understood from the individual words. Here are some common English idioms:

1. Break the ice - To start a conversation
2. Hit the nail on the head - To be exactly right
3. Cost an arm and a leg - To be very expensive
4. Under the weather - To feel sick
5. Once in a blue moon - Rarely
6. Bite the bullet - To face difficulty
7. Beat around the bush - To avoid the main topic

Learning idioms will help you sound more like a native speaker and understand English media better.''',
        difficulty: 'Intermediate',
        tags: ['Vocabulary', 'Idioms', 'Culture'],
        createdAt: DateTime.now(),
        readTime: 8,
      ),
    ];
  }

  static Article? getArticleById(String id) {
    return getArticles().where((a) => a.id == id).firstOrNull;
  }

  static List<Article> getArticlesByDifficulty(String difficulty) {
    return getArticles().where((a) => a.difficulty == difficulty).toList();
  }

  static List<Article> searchArticles(String query) {
    final lowerQuery = query.toLowerCase();
    return getArticles()
        .where((a) =>
            a.title.toLowerCase().contains(lowerQuery) ||
            a.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)))
        .toList();
  }
}
