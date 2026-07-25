import '../models/word.dart';

class MockWords {
  static List<Word> getWords() {
    return getWordsByCategory('四级核心');
  }

  static List<Word> getWordsByCategory(String category) {
    final now = DateTime.now();

    switch (category) {
      case '六级高频':
        return [
          Word(
            id: 'cet6_1',
            english: 'aesthetic',
            chinese: '美学的；审美的',
            phonetic: '/esˈθetɪk/',
            synonyms: ['artistic', 'tasteful'],
            antonyms: ['unattractive'],
            exampleSentence: 'The building has great aesthetic value.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'cet6_2',
            english: 'bureaucracy',
            chinese: '官僚主义；官僚机构',
            phonetic: '/bjʊəˈrɒkrəsi/',
            synonyms: ['red tape', 'administration'],
            antonyms: ['flexibility'],
            exampleSentence: 'They tried to reduce unnecessary bureaucracy.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'cet6_3',
            english: 'cognitive',
            chinese: '认知的；感知的',
            phonetic: '/ˈkɒɡnətɪv/',
            synonyms: ['intellectual', 'mental'],
            antonyms: ['physical'],
            exampleSentence: 'Puzzles help boost cognitive development.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'cet6_4',
            english: 'dilemma',
            chinese: '困境；进退两难',
            phonetic: '/dɪˈlemə/',
            synonyms: ['predicament', 'quandary'],
            antonyms: ['solution'],
            exampleSentence: 'She faced a difficult ethical dilemma.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'cet6_5',
            english: 'elaborate',
            chinese: '精心制作的；详尽阐述',
            phonetic: '/ɪˈlæbərət/',
            synonyms: ['detailed', 'intricate'],
            antonyms: ['simple', 'plain'],
            exampleSentence: 'He made an elaborate plan for the event.',
            createdAt: now,
            masteryLevel: 0,
          ),
        ];

      case '考研必刷':
        return [
          Word(
            id: 'ky_1',
            english: 'advocate',
            chinese: '提倡；主张；拥护者',
            phonetic: '/ˈædvəkeɪt/',
            synonyms: ['support', 'champion'],
            antonyms: ['oppose', 'criticize'],
            exampleSentence: 'Scientists advocate green energy.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ky_2',
            english: 'blueprint',
            chinese: '蓝图；行动方案',
            phonetic: '/ˈbluːprɪnt/',
            synonyms: ['plan', 'draft'],
            antonyms: ['chaos'],
            exampleSentence: 'They presented a blueprint for economic reform.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ky_3',
            english: 'compensate',
            chinese: '补偿；赔偿',
            phonetic: '/ˈkɒmpenseɪt/',
            synonyms: ['reimburse', 'atone'],
            antonyms: ['deprive'],
            exampleSentence: 'Hard work will compensate for lack of experience.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ky_4',
            english: 'drastic',
            chinese: '激烈的；严厉的',
            phonetic: '/ˈdræstɪk/',
            synonyms: ['extreme', 'severe'],
            antonyms: ['mild', 'slight'],
            exampleSentence: 'The company took drastic measures to cut costs.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ky_5',
            english: 'exaggerate',
            chinese: '夸大；夸张',
            phonetic: '/ɪɡˈzædʒəreɪt/',
            synonyms: ['overstate', 'magnify'],
            antonyms: ['understate'],
            exampleSentence: 'Don\'t exaggerate the problem.',
            createdAt: now,
            masteryLevel: 0,
          ),
        ];

      case '雅思冲刺':
        return [
          Word(
            id: 'ielts_1',
            english: 'ambiguity',
            chinese: '模棱两可；含糊不清',
            phonetic: '/ˌæmbɪˈɡjuːəti/',
            synonyms: ['vagueness', 'uncertainty'],
            antonyms: ['clarity', 'certainty'],
            exampleSentence: 'Avoid ambiguity in formal legal writing.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ielts_2',
            english: 'cohesion',
            chinese: '凝聚力；衔接',
            phonetic: '/kəʊˈhiːʒn/',
            synonyms: ['unity', 'solidarity'],
            antonyms: ['division', 'separation'],
            exampleSentence: 'Social cohesion is crucial for national stability.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ielts_3',
            english: 'fluctuation',
            chinese: '波动；起伏',
            phonetic: '/ˌflʌktʃuˈeɪʃn/',
            synonyms: ['variation', 'oscillation'],
            antonyms: ['stability'],
            exampleSentence: 'Temperature fluctuations affect plant growth.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ielts_4',
            english: 'hypothesis',
            chinese: '假设；假说',
            phonetic: '/haɪˈpɒθəsɪs/',
            synonyms: ['theory', 'assumption'],
            antonyms: ['fact', 'proof'],
            exampleSentence: 'The research confirmed our original hypothesis.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'ielts_5',
            english: 'infrastructure',
            chinese: '基础设施；下层建筑',
            phonetic: '/ˈɪnfrəstrʌktʃə/',
            synonyms: ['foundation', 'framework'],
            antonyms: [],
            exampleSentence: 'Investments in public infrastructure drive growth.',
            createdAt: now,
            masteryLevel: 0,
          ),
        ];

      case '日常基础':
        return [
          Word(
            id: 'base_1',
            english: 'apple',
            chinese: '苹果',
            phonetic: '/ˈæpl/',
            synonyms: ['fruit'],
            antonyms: [],
            exampleSentence: 'An apple a day keeps the doctor away.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'base_2',
            english: 'bread',
            chinese: '面包',
            phonetic: '/bred/',
            synonyms: ['food'],
            antonyms: [],
            exampleSentence: 'I enjoy fresh bread every morning.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'base_3',
            english: 'coffee',
            chinese: '咖啡',
            phonetic: '/ˈkɒfi/',
            synonyms: ['drink'],
            antonyms: [],
            exampleSentence: 'Would you like a hot cup of coffee?',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'base_4',
            english: 'family',
            chinese: '家庭；家人',
            phonetic: '/ˈfæməli/',
            synonyms: ['relatives', 'household'],
            antonyms: [],
            exampleSentence: 'Family is the most important thing in life.',
            createdAt: now,
            masteryLevel: 0,
          ),
          Word(
            id: 'base_5',
            english: 'friend',
            chinese: '朋友',
            phonetic: '/frend/',
            synonyms: ['companion', 'pal'],
            antonyms: ['enemy', 'foe'],
            exampleSentence: 'A friend in need is a friend indeed.',
            createdAt: now,
            masteryLevel: 0,
          ),
        ];

      case '四级核心':
      default:
        return [
          Word(
            id: '1',
            english: 'abandon',
            chinese: '放弃；遗弃',
            phonetic: '/əˈbændən/',
            synonyms: ['give up', 'desert'],
            antonyms: ['keep', 'maintain'],
            exampleSentence: 'Never abandon your dreams.',
            createdAt: now,
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
            createdAt: now,
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
            createdAt: now,
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
            createdAt: now,
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
            createdAt: now,
            masteryLevel: 0,
          ),
        ];
    }
  }

  static Word? getWordById(String id) {
    return getWords().where((w) => w.id == id).firstOrNull;
  }
}
