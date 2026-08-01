import '../models/word.dart';
import 'words_data/cet4_words.dart';
import 'words_data/cet6_words.dart';
import 'words_data/kaoyan_words.dart';
import 'words_data/ielts_words.dart';
import 'words_data/daily_words.dart';

class MockWords {
  static List<Word> getWords() {
    return getWordsByCategory('四级核心');
  }

  static List<Word> getWordsByCategory(String category) {
    switch (category) {
      case '六级高频':
        return getCet6Words();
      case '考研必刷':
        return getKaoyanWords();
      case '雅思冲刺':
        return getIeltsWords();
      case '日常基础':
        return getDailyWords();
      case '四级核心':
      default:
        return getCet4Words();
    }
  }

  static Word? getWordById(String id) {
    final allWords = [
      ...getCet4Words(),
      ...getCet6Words(),
      ...getKaoyanWords(),
      ...getIeltsWords(),
      ...getDailyWords(),
    ];
    return allWords.where((w) => w.id == id || w.english.toLowerCase() == id.toLowerCase()).firstOrNull;
  }
}
