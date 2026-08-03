import 'dart:convert';
import 'dart:io';
import '../models/dictionary_word_model.dart';
import '../services/database_service.dart';
import '../mock/mock_words.dart';

class DictionaryService {
  static final DictionaryService instance = DictionaryService._internal();
  DictionaryService._internal();

  DatabaseService? _dbService;
  bool _isSeeded = false;

  /// 初始化词典服务并自动完成 SQLite 数据库 Seed 校验
  Future<void> _ensureInitialized() async {
    if (_dbService != null && _isSeeded) return;
    _dbService = await DatabaseService.getInstance();

    final count = await _dbService!.getDictionaryCount();
    if (count == 0) {
      // 首次初始化：批量落库静态核心词库与名著专有名词
      final List<Map<String, dynamic>> seedRows = [];
      
      // 1. 批量导入 MockWords 5大核心词汇库
      final mockWords = MockWords.getWords();
      for (final w in mockWords) {
        seedRows.add({
          'id': 'seed_${w.english.toLowerCase()}',
          'word': w.english.toLowerCase(),
          'phonetic': w.phonetic,
          'chinese': w.chinese,
          'pos': _extractPos(w.chinese),
          'example': w.exampleSentence,
          'example_translation': null,
          'source': '核心词汇库',
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
      }

      // 2. 批量导入名著专有名词与特殊词汇
      for (final entry in _properNounsDict.entries) {
        final key = entry.key;
        final info = entry.value;
        seedRows.add({
          'id': 'proper_$key',
          'word': key.toLowerCase(),
          'phonetic': info['phonetic'],
          'chinese': info['chinese'],
          'pos': _extractPos(info['chinese']!),
          'example': null,
          'example_translation': null,
          'source': '名著精选词库',
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
      }

      await _dbService!.bulkInsertDictionaryWords(seedRows);
    }
    _isSeeded = true;
  }

  /// 提取词性 (如 n., v., adj., adv.)
  String? _extractPos(String chinese) {
    final match = RegExp(r'^([a-zA-Z\./]+)\s*').firstMatch(chinese);
    return match?.group(1);
  }

  /// 全局单词查询主入口 (一阶 SQLite 查 -> 二阶词干推导 -> 三阶在线学习落库)
  Future<DictionaryWordModel> lookupWordDetail(
    String rawWord, {
    String? articleTitle,
  }) async {
    await _ensureInitialized();

    final clean = rawWord.replaceAll(RegExp(r'[^\w\-]'), '').trim();
    final lower = clean.toLowerCase();

    if (clean.isEmpty) {
      return DictionaryWordModel(
        id: 'empty',
        word: rawWord,
        phonetic: '',
        chinese: '未查找到有效单词。',
      );
    }

    // ----------------------------------------------------
    // 一阶：本地 SQLite 极速检索 (< 5ms)
    // ----------------------------------------------------
    final sqlMap = await _dbService?.searchDictionaryWord(lower);
    if (sqlMap != null) {
      return DictionaryWordModel.fromMap(sqlMap);
    }

    // ----------------------------------------------------
    // 二阶：智能词干原型推导 (-ing, -ed, -es, -s, -ly)
    // ----------------------------------------------------
    final stemmed = await _tryStemming(clean, lower);
    if (stemmed != null) {
      return stemmed;
    }

    // ----------------------------------------------------
    // 三阶：在线 API 网络查词 + 自动学习写入 SQLite 数据库
    // ----------------------------------------------------
    try {
      final onlineModel = await _fetchOnlineDefinition(clean, articleTitle);
      if (onlineModel != null) {
        // 自动落库 SQLite 数据库 (自动扩充)
        await _dbService?.insertDictionaryWord(onlineModel.toMap());
        return onlineModel;
      }
    } catch (_) {
      // 网络异常时降级处理
    }

    // ----------------------------------------------------
    // 四阶：保底退路模型
    // ----------------------------------------------------
    final fallbackModel = DictionaryWordModel(
      id: 'fallback_$lower',
      word: clean,
      phonetic: '/$lower/',
      chinese: 'n./v. $clean（阅读拓展词汇）',
      source: articleTitle != null ? '《$articleTitle》' : '阅读词库',
    );

    // 将保底结果也持久化落库
    await _dbService?.insertDictionaryWord(fallbackModel.toMap());
    return fallbackModel;
  }

  /// 词干还原检测
  Future<DictionaryWordModel?> _tryStemming(String clean, String lower) async {
    final suffixes = [
      {'suffix': 'ing', 'minLen': 4, 'cut': 3, 'label': '现在分词/动名词'},
      {'suffix': 'ed', 'minLen': 4, 'cut': 2, 'label': '过去式/过去分词'},
      {'suffix': 'es', 'minLen': 4, 'cut': 2, 'label': '复数/单三'},
      {'suffix': 's', 'minLen': 3, 'cut': 1, 'label': '复数/单三'},
      {'suffix': 'ly', 'minLen': 4, 'cut': 2, 'label': '副词形式'},
    ];

    for (final rule in suffixes) {
      final s = rule['suffix'] as String;
      final minLen = rule['minLen'] as int;
      final cut = rule['cut'] as int;
      final label = rule['label'] as String;

      if (lower.endsWith(s) && lower.length > minLen) {
        final base = lower.substring(0, lower.length - cut);
        var baseMap = await _dbService?.searchDictionaryWord(base);
        baseMap ??= await _dbService?.searchDictionaryWord('${base}e');

        if (baseMap != null) {
          final baseModel = DictionaryWordModel.fromMap(baseMap);
          return DictionaryWordModel(
            id: 'stem_$lower',
            word: clean,
            phonetic: baseModel.phonetic,
            chinese: '${baseModel.chinese} ($label)',
            pos: baseModel.pos,
            example: baseModel.example,
            exampleTranslation: baseModel.exampleTranslation,
            source: '词干推导 (${baseModel.word})',
          );
        }
      }
    }
    return null;
  }

  /// 在线 API 查词请求 (基于有道 / 金山词霸开放 API)
  Future<DictionaryWordModel?> _fetchOnlineDefinition(
    String word,
    String? articleTitle,
  ) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final request = await client.getUrl(
        Uri.parse('https://dict.youdao.com/suggest?q=$word&num=1&doctype=json'),
      );
      final response = await request.close();

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body);
        if (data['data'] != null && data['data']['entries'] != null) {
          final entries = data['data']['entries'] as List;
          if (entries.isNotEmpty) {
            final entry = entries[0];
            final explain = entry['explain'] ?? '';
            final entryWord = entry['entry'] ?? word;

            if (explain.toString().isNotEmpty) {
              final explainStr = explain.toString();
              return DictionaryWordModel(
                id: 'online_${word.toLowerCase()}',
                word: entryWord.toString(),
                phonetic: '/$word/',
                chinese: explainStr,
                pos: _extractPos(explainStr),
                source: '在线金牌词典',
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              );
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// 静态名著专有名词词典
  static const Map<String, Map<String, String>> _properNounsDict = {
    'matthew': {'phonetic': '/ˈmæθjuː/', 'chinese': 'n. 马修（人名，《绿山墙的安妮》男主角）'},
    'rachel': {'phonetic': '/ˈreɪtʃəl/', 'chinese': 'n. 雷切尔（人名，林德太太）'},
    'lynde': {'phonetic': '/laɪnd/', 'chinese': 'n. 林德（姓氏，林德太太）'},
    'avonlea': {'phonetic': '/ˈævənliː/', 'chinese': 'n. 阿文莉（加拿大地名，故事发生地）'},
    'cuthbert': {'phonetic': '/ˈkʌθbərt/', 'chinese': 'n. 卡斯伯特（姓氏，卡斯伯特庄园）'},
    'marilla': {'phonetic': '/məˈrɪlə/', 'chinese': 'n. 马里拉（人名，马修的妹妹）'},
    'anne': {'phonetic': '/æn/', 'chinese': 'n. 安妮（人名，红发少女安妮）'},
    'gables': {'phonetic': '/ˈɡeɪblz/', 'chinese': 'n. 三角墙，绿山墙庄园'},
    'nova': {'phonetic': '/ˈnoʊvə/', 'chinese': 'n. 诺瓦（地名，新斯克舍省）'},
    'scotia': {'phonetic': '/ˈskoʊʃə/', 'chinese': 'n. 斯克舍（地名，新斯克舍省）'},
    'sahara': {'phonetic': '/səˈhærə/', 'chinese': 'n. 撒哈拉（非洲大沙漠地名）'},
    'b-612': {'phonetic': '/biː sɪks ˈtwelv/', 'chinese': 'n. B-612（小行星编号，小王子的故乡）'},
    'scheherazade': {'phonetic': '/ʃəˌhɛrəˈzɑːdə/', 'chinese': 'n. 山鲁佐德（人名，《一千零一夜》女主角）'},
    'shahryar': {'phonetic': '/ʃɑːrˈjɑːr/', 'chinese': 'n. 山鲁亚尔（人名，古代波斯苏丹）'},
    'dunyazad': {'phonetic': '/dʊnjɑːˈzɑːd/', 'chinese': 'n. 敦亚佐德（人名，山鲁佐德的妹妹）'},
    'ernest': {'phonetic': '/ˈɜːrnɪst/', 'chinese': 'n. 欧内斯特（人名，《巨石人面像》男主角）'},
    'hawthorne': {'phonetic': '/ˈhɔːθɔːrn/', 'chinese': 'n. 霍桑（人名，美国作家纳撒尼尔·霍桑）'},
    'hollow': {'phonetic': '/ˈhɒloʊ/', 'chinese': 'n. 山谷，洼地；adj. 中空的'},
    'alders': {'phonetic': '/ˈɔːldərz/', 'chinese': 'n. 桤木树（湿地灌木）'},
    'eardrops': {'phonetic': '/ˈɪərˌdrɒps/', 'chinese': 'n. 倒挂金钟（耳坠状花卉）'},
    'traversed': {'phonetic': '/trəˈvɜːrst/', 'chinese': 'v. 穿过，横贯，跨越'},
    'brook': {'phonetic': '/brʊk/', 'chinese': 'n. 小溪，小河'},
    'intricate': {'phonetic': '/ˈɪntrɪkət/', 'chinese': 'adj. 错综复杂的，曲折精细的'},
    'sorrel': {'phonetic': '/ˈsɔːrəl/', 'chinese': 'adj. 栗色的；n. 栗色马'},
    'mare': {'phonetic': '/meər/', 'chinese': 'n. 母马，母驴'},
    'buggy': {'phonetic': '/ˈbʌɡi/', 'chinese': 'n. 轻便单马敞篷车'},
    'harness': {'phonetic': '/ˈhɑːrnɪs/', 'chinese': 'n. 马具，挽具'},
    'errand': {'phonetic': '/ˈerənd/', 'chinese': 'n. 差事，使命'},
    'boa': {'phonetic': '/ˈboʊə/', 'chinese': 'n. 巨蟒，大蟒蛇'},
    'constrictor': {'phonetic': '/kənˈstrɪktər/', 'chinese': 'n. 缠绕者，大蟒蛇'},
    'baobab': {'phonetic': '/ˈbeɪoʊbæb/', 'chinese': 'n. 猴面包树（巨树）'},
    'asylum': {'phonetic': '/əˈsaɪləm/', 'chinese': 'n. 孤儿院；庇护所'},
    'orphan': {'phonetic': '/ˈɔːrfn/', 'chinese': 'n. 孤儿'},
  };
}
