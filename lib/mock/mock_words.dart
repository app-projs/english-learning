import '../models/word.dart';

class MockWords {
  static List<Word> getWords() {
    return [
      Word(
        id: '1',
        english: 'abandon',
        chinese: '放弃；遗弃',
        phonetic: '/əˈbændən/',
        synonyms: ['give up', 'desert'],
        antonyms: ['keep', 'maintain'],
        exampleSentence: 'Never abandon your dreams.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '2',
        english: 'benefit',
        chinese: '利益；好处',
        phonetic: '/ˈbenɪfɪt/',
        synonyms: ['advantage', 'profit'],
        antonyms: ['harm', 'loss'],
        exampleSentence: 'Exercise has many health benefits.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '3',
        english: 'challenge',
        chinese: '挑战',
        phonetic: '/ˈtʃælɪndʒ/',
        synonyms: ['difficulty', 'test'],
        antonyms: ['ease', 'simpleness'],
        exampleSentence: 'I accept the challenge.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '4',
        english: 'determine',
        chinese: '决定；确定',
        phonetic: '/dɪˈtɜːrmɪn/',
        synonyms: ['decide', 'resolve'],
        antonyms: ['hesitate', 'uncertain'],
        exampleSentence: 'She determined to finish the project.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '5',
        english: 'essential',
        chinese: '必要的；本质的',
        phonetic: '/ɪˈsenʃl/',
        synonyms: ['necessary', 'vital'],
        antonyms: ['unnecessary', 'trivial'],
        exampleSentence: 'Water is essential for life.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '6',
        english: 'foundation',
        chinese: '基础；地基',
        phonetic: '/faʊnˈdeɪʃn/',
        synonyms: ['basis', 'ground'],
        antonyms: ['top', 'superstructure'],
        exampleSentence: 'Education is the foundation of society.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '7',
        english: 'generate',
        chinese: '产生；生成',
        phonetic: '/ˈdʒenəreɪt/',
        synonyms: ['produce', 'create'],
        antonyms: ['destroy', 'eliminate'],
        exampleSentence: 'This project will generate new jobs.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
      Word(
        id: '8',
        english: 'implement',
        chinese: '实施；工具',
        phonetic: '/ˈɪmplɪment/',
        synonyms: ['execute', 'tool'],
        antonyms: ['neglect', 'abandon'],
        exampleSentence: 'We need to implement the new policy.',
        createdAt: DateTime.now(),
        masteryLevel: 0,
      ),
    ];
  }

  static Word? getWordById(String id) {
    return getWords().where((w) => w.id == id).firstOrNull;
  }
}
