import 'dart:convert';
import 'database_service.dart';

class DerivedWordModel {
  final String word;
  final String phonetic;
  final String meaning;
  final String breakdown;

  DerivedWordModel({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.breakdown,
  });

  factory DerivedWordModel.fromJson(Map<String, dynamic> json) {
    return DerivedWordModel(
      word: json['word'] as String? ?? '',
      phonetic: json['phonetic'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      breakdown: json['breakdown'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'phonetic': phonetic,
        'meaning': meaning,
        'breakdown': breakdown,
      };
}

class WordRootModel {
  final String id;
  final String root;
  final String type; // 'root' | 'prefix' | 'suffix'
  final String origin;
  final String meaning;
  final String explanation;
  final List<DerivedWordModel> derivedWords;

  WordRootModel({
    required this.id,
    required this.root,
    required this.type,
    required this.origin,
    required this.meaning,
    required this.explanation,
    required this.derivedWords,
  });

  factory WordRootModel.fromJson(Map<String, dynamic> json) {
    List<DerivedWordModel> dList = [];
    if (json['derivedWords'] is List) {
      dList = (json['derivedWords'] as List)
          .map((e) => e is Map<String, dynamic> ? DerivedWordModel.fromJson(e) : DerivedWordModel.fromJson(jsonDecode(jsonEncode(e))))
          .toList();
    } else if (json['derivedWords'] is String) {
      try {
        final decoded = jsonDecode(json['derivedWords'] as String);
        if (decoded is List) {
          dList = decoded.map((e) => DerivedWordModel.fromJson(Map<String, dynamic>.from(e))).toList();
        }
      } catch (_) {}
    }

    return WordRootModel(
      id: json['id'] as String,
      root: json['root'] as String,
      type: json['type'] as String? ?? 'root',
      origin: json['origin'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      derivedWords: dList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'root': root,
        'type': type,
        'origin': origin,
        'meaning': meaning,
        'explanation': explanation,
        'derivedWords': jsonEncode(derivedWords.map((e) => e.toJson()).toList()),
      };
}

class WordRootService {
  final DatabaseService _database;

  WordRootService(this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    final existing = await _database.getAllWordRoots();
    if (existing.isNotEmpty) return;

    final initialRoots = [
      WordRootModel(
        id: 'r_port',
        root: 'port',
        type: 'root',
        origin: '拉丁语',
        meaning: '拿、运、港口',
        explanation: '源自拉丁语 portare，意为把物品从一处运拿到另一处。',
        derivedWords: [
          DerivedWordModel(word: 'import', phonetic: '/ɪmˈpɔːt/', meaning: '进口、输入', breakdown: 'im- [向内] + port [运] ➔ 运进来'),
          DerivedWordModel(word: 'export', phonetic: '/ˈekspɔːt/', meaning: '出口、输出', breakdown: 'ex- [向外] + port [运] ➔ 运出去'),
          DerivedWordModel(word: 'transport', phonetic: '/ˈtrænspɔːt/', meaning: '运输、交通', breakdown: 'trans- [跨越] + port [运] ➔ 跨地运送'),
          DerivedWordModel(word: 'portable', phonetic: '/ˈpɔːtəbl/', meaning: '手提的、便携的', breakdown: 'port [运] + -able [可...的] ➔ 拿得动的'),
          DerivedWordModel(word: 'reporter', phonetic: '/rɪˈpɔːtə/', meaning: '记者、报导者', breakdown: 're- [回/反复] + port [拿] + -er ➔ 带回消息的人'),
        ],
      ),
      WordRootModel(
        id: 'r_vis',
        root: 'vis / vid',
        type: 'root',
        origin: '拉丁语',
        meaning: '看、看见',
        explanation: '源自拉丁语 videre (看)，衍生出与视力、观察相关的一切词汇。',
        derivedWords: [
          DerivedWordModel(word: 'visit', phonetic: '/ˈvɪzɪt/', meaning: '拜访、参观', breakdown: 'vis [看] + -it ➔ 亲自去看'),
          DerivedWordModel(word: 'visible', phonetic: '/ˈvɪzəbl/', meaning: '可见的、明显的', breakdown: 'vis [看] + -ible [可...的] ➔ 看得见的'),
          DerivedWordModel(word: 'television', phonetic: '/ˈtelɪvɪʒn/', meaning: '电视机', breakdown: 'tele- [远处] + vis [看] + -ion ➔ 远程观看'),
          DerivedWordModel(word: 'video', phonetic: '/ˈvɪdiəʊ/', meaning: '视频、录像', breakdown: 'vid [看] + -eo ➔ 可看的东西'),
        ],
      ),
      WordRootModel(
        id: 'r_tract',
        root: 'tract',
        type: 'root',
        origin: '拉丁语',
        meaning: '拉、抽、引',
        explanation: '源自拉丁语 trahere，意为用力将物体拉动或抽取出来。',
        derivedWords: [
          DerivedWordModel(word: 'attract', phonetic: '/əˈtrækt/', meaning: '吸引、引起', breakdown: 'at- [朝向] + tract [拉] ➔ 把目光拉过来'),
          DerivedWordModel(word: 'extract', phonetic: '/ˈekstrækt/', meaning: '提取、萃取', breakdown: 'ex- [向外] + tract [拉] ➔ 从内部拉出来'),
          DerivedWordModel(word: 'contract', phonetic: '/ˈkɒntrækt/', meaning: '合同、收缩', breakdown: 'con- [一起] + tract [拉] ➔ 拉到一起达成契约'),
        ],
      ),
      WordRootModel(
        id: 'r_bio',
        root: 'bio',
        type: 'root',
        origin: '希腊语',
        meaning: '生命、生物',
        explanation: '源自希腊语 bios (生命)，用于描述与生命科学或个人生平相关的领域。',
        derivedWords: [
          DerivedWordModel(word: 'biology', phonetic: '/baɪˈɒlədʒi/', meaning: '生物学', breakdown: 'bio [生命] + -logy [学科] ➔ 研究生命的学科'),
          DerivedWordModel(word: 'biography', phonetic: '/baɪˈɒɡrəfi/', meaning: '传记', breakdown: 'bio [生命] + graph [写] + -y ➔ 记录个人生命史的书'),
        ],
      ),
      WordRootModel(
        id: 'r_dict',
        root: 'dict',
        type: 'root',
        origin: '拉丁语',
        meaning: '说、言',
        explanation: '源自拉丁语 dicere，表示说话、宣称或口述。',
        derivedWords: [
          DerivedWordModel(word: 'dictionary', phonetic: '/ˈdɪkʃənri/', meaning: '字典、词典', breakdown: 'dict [说] + -ionary ➔ 汇集词言的书'),
          DerivedWordModel(word: 'predict', phonetic: '/prɪˈdɪkt/', meaning: '预测、预言', breakdown: 'pre- [提前] + dict [说] ➔ 提前说出来'),
          DerivedWordModel(word: 'indicate', phonetic: '/ˈɪndɪkeɪt/', meaning: '指示、表明', breakdown: 'in- [向内] + dic [说] + -ate ➔ 指出说明'),
          DerivedWordModel(word: 'contradict', phonetic: '/ˌkɒntrəˈdɪkt/', meaning: '反驳、矛盾', breakdown: 'contra- [相反] + dict [说] ➔ 说相反的话'),
        ],
      ),
      WordRootModel(
        id: 'r_tele',
        root: 'tele',
        type: 'root',
        origin: '希腊语',
        meaning: '远、远距离',
        explanation: '源自希腊语 tele，表示跨越遥远距离的传输与沟通。',
        derivedWords: [
          DerivedWordModel(word: 'telephone', phonetic: '/ˈtelɪfəʊn/', meaning: '电话', breakdown: 'tele [远] + phon [声音] ➔ 传送远方的声音'),
          DerivedWordModel(word: 'telescope', phonetic: '/ˈtelɪskəʊp/', meaning: '望远镜', breakdown: 'tele [远] + scop [观察] ➔ 观察远方的仪器'),
          DerivedWordModel(word: 'telegraph', phonetic: '/ˈtelɪɡrɑːf/', meaning: '电报', breakdown: 'tele [远] + graph [写] ➔ 传送远方文字'),
        ],
      ),
      WordRootModel(
        id: 'p_re',
        root: 're-',
        type: 'prefix',
        origin: '前缀',
        meaning: '重新、再次、回',
        explanation: '最常见的英语前缀，表示动作的重新发生或返回原状。',
        derivedWords: [
          DerivedWordModel(word: 'rewrite', phonetic: '/ˌriːˈraɪt/', meaning: '重写、改写', breakdown: 're- [重新] + write [写]'),
          DerivedWordModel(word: 'return', phonetic: '/rɪˈtɜːn/', meaning: '返回、归还', breakdown: 're- [回] + turn [转] ➔ 转回来'),
        ],
      ),
      WordRootModel(
        id: 'p_un_dis',
        root: 'un- / dis-',
        type: 'prefix',
        origin: '前缀',
        meaning: '不、相反、剥夺',
        explanation: '否定前缀，使基词含义转变为完全相反的对立面。',
        derivedWords: [
          DerivedWordModel(word: 'unhappy', phonetic: '/ʌnˈhæpi/', meaning: '不高兴的', breakdown: 'un- [不] + happy [开心]'),
          DerivedWordModel(word: 'unknown', phonetic: '/ˌʌnˈnəʊn/', meaning: '未知的', breakdown: 'un- [未] + known [已知]'),
          DerivedWordModel(word: 'disagree', phonetic: '/ˌdɪsəˈɡriː/', meaning: '不同意', breakdown: 'dis- [相反] + agree [同意]'),
          DerivedWordModel(word: 'discover', phonetic: '/dɪˈskʌvə/', meaning: '发现、揭开', breakdown: 'dis- [解开] + cover [盖子] ➔ 揭开盖子'),
        ],
      ),
      WordRootModel(
        id: 'p_sub_trans',
        root: 'sub- / trans-',
        type: 'prefix',
        origin: '前缀',
        meaning: '在…下方 / 跨越、穿过',
        explanation: '空间方位前缀，指示位置的偏下、附属或横跨。',
        derivedWords: [
          DerivedWordModel(word: 'subway', phonetic: '/ˈsʌbweɪ/', meaning: '地铁', breakdown: 'sub- [在下方] + way [道路]'),
          DerivedWordModel(word: 'subtitle', phonetic: '/ˈsʌbtaɪtl/', meaning: '副标题、字幕', breakdown: 'sub- [次要] + title [标题]'),
          DerivedWordModel(word: 'translate', phonetic: '/trænzˈleɪt/', meaning: '翻译、转换', breakdown: 'trans- [跨越] + late [携带]'),
        ],
      ),
      WordRootModel(
        id: 's_able',
        root: '-able / -ible',
        type: 'suffix',
        origin: '后缀',
        meaning: '可…的、能…的',
        explanation: '形容词后缀，表示具有某种能力或适合进行某种动作。',
        derivedWords: [
          DerivedWordModel(word: 'readably', phonetic: '/ˈriːdəbli/', meaning: '易读地', breakdown: 'read [读] + -able [可]'),
          DerivedWordModel(word: 'usable', phonetic: '/ˈjuːzəbl/', meaning: '可用的', breakdown: 'use [使用] + -able [能]'),
        ],
      ),
      WordRootModel(
        id: 's_er_or',
        root: '-er / -or',
        type: 'suffix',
        origin: '后缀',
        meaning: '人、从事某种职业者或工具',
        explanation: '名词后缀，附加在动词词尾表示执行该动作的主体。',
        derivedWords: [
          DerivedWordModel(word: 'teacher', phonetic: '/ˈtiːtʃə/', meaning: '教师', breakdown: 'teach [教] + -er [人]'),
          DerivedWordModel(word: 'doctor', phonetic: '/ˈdɒktə/', meaning: '医生', breakdown: 'doc [教导] + -or [人]'),
          DerivedWordModel(word: 'actor', phonetic: '/ˈæktə/', meaning: '演员', breakdown: 'act [表演] + -or [人]'),
        ],
      ),
      WordRootModel(
        id: 's_tion',
        root: '-tion / -sion',
        type: 'suffix',
        origin: '后缀',
        meaning: '动作、过程或状态',
        explanation: '抽象名词后缀，将动词转化为对应的动作或状态名词。',
        derivedWords: [
          DerivedWordModel(word: 'action', phonetic: '/ˈækʃn/', meaning: '行动、作用', breakdown: 'act [做] + -ion [名词后缀]'),
          DerivedWordModel(word: 'education', phonetic: '/ˌedʒuˈkeɪʃn/', meaning: '教育', breakdown: 'educate [教育] + -ion'),
          DerivedWordModel(word: 'decision', phonetic: '/dɪˈsɪʒn/', meaning: '决定、决议', breakdown: 'decide [决定] + -sion'),
        ],
      ),
    ];

    for (final item in initialRoots) {
      await _database.insertWordRoot(item.toJson());
    }
  }

  Future<List<WordRootModel>> getWordRootsByType(String type) async {
    await _seedDatabaseIfNeeded();
    final rows = await _database.getWordRootsByType(type);
    return rows.map((r) => WordRootModel.fromJson(r)).toList();
  }

  Future<List<WordRootModel>> getAllWordRoots() async {
    await _seedDatabaseIfNeeded();
    final rows = await _database.getAllWordRoots();
    return rows.map((r) => WordRootModel.fromJson(r)).toList();
  }
}
