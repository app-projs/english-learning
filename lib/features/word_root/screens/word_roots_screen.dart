import 'package:flutter/material.dart';
import '../../../core/theme/lumina_theme.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/database_service.dart';
import '../services/word_root_service.dart';
import '../../../features/review/screens/completion_congratulation_screen.dart';

class WordRootsScreen extends StatefulWidget {
  const WordRootsScreen({super.key});

  @override
  State<WordRootsScreen> createState() => _WordRootsScreenState();
}

class _WordRootsScreenState extends State<WordRootsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StorageService? _storageService;
  List<WordRootModel> _dbRoots = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initStorage();
  }

  Future<void> _initStorage() async {
    final s = await StorageService.getInstance();
    final db = await DatabaseService.getInstance();
    final service = WordRootService(db);
    final roots = await service.getAllWordRoots();

    if (mounted) {
      setState(() {
        _storageService = s;
        _dbRoots = roots;
      });
    }
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _finishPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CompletionCongratulationScreen(
          moduleTitle: '词根词缀专项',
          earnedLp: 50,
          streakDays: 7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('字词根专项训练', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: InkWell(
                onTap: _finishPractice,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade600, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '完成',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicatorColor: LuminaColors.primary,
            labelColor: LuminaColors.primary,
            unselectedLabelColor: isDark ? Colors.white60 : Colors.grey.shade700,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: LuminaColors.primary),
              insets: EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            tabs: const [
              Tab(text: '核心词根 (Roots)'),
              Tab(text: '高频前缀 (Prefixes)'),
              Tab(text: '常用后缀 (Suffixes)'),
              Tab(text: '派生思维导图树'),
              Tab(text: '拆词连线游戏'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: '🔍 搜索词根/前缀/后缀、义项或衍生词...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRootsList(_filterItems(_dbCoreRoots)),
                _buildRootsList(_filterItems(_dbPrefixes)),
                _buildRootsList(_filterItems(_dbSuffixes)),
                const _EtymologyTreeViewWidget(),
                const _WordRootMatchingGameWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<RootItem> get _dbCoreRoots {
    final dbItems = _dbRoots.where((r) => r.type == 'root').map(_mapModelToItem).toList();
    return dbItems.isNotEmpty ? dbItems : _coreRoots;
  }

  List<RootItem> get _dbPrefixes {
    final dbItems = _dbRoots.where((r) => r.type == 'prefix').map(_mapModelToItem).toList();
    return dbItems.isNotEmpty ? dbItems : _commonPrefixes;
  }

  List<RootItem> get _dbSuffixes {
    final dbItems = _dbRoots.where((r) => r.type == 'suffix').map(_mapModelToItem).toList();
    return dbItems.isNotEmpty ? dbItems : _commonSuffixes;
  }

  RootItem _mapModelToItem(WordRootModel model) {
    return RootItem(
      root: model.root,
      origin: model.origin,
      meaning: model.meaning,
      explanation: model.explanation,
      derivedWords: model.derivedWords
          .map((d) => DerivedWord(
                word: d.word,
                phonetic: d.phonetic,
                meaning: d.meaning,
                breakdown: d.breakdown,
              ))
          .toList(),
    );
  }

  List<RootItem> _filterItems(List<RootItem> items) {
    if (_searchQuery.trim().isEmpty) return items;
    final q = _searchQuery.toLowerCase().trim();
    return items.where((item) {
      final rootMatch = item.root.toLowerCase().contains(q);
      final originMatch = item.origin.toLowerCase().contains(q);
      final meaningMatch = item.meaning.toLowerCase().contains(q);
      final explanationMatch = item.explanation.toLowerCase().contains(q);
      final derivedMatch = item.derivedWords.any((w) =>
          w.word.toLowerCase().contains(q) ||
          w.meaning.toLowerCase().contains(q) ||
          w.breakdown.toLowerCase().contains(q));
      return rootMatch || originMatch || meaningMatch || explanationMatch || derivedMatch;
    }).toList();
  }

  Widget _buildRootsList(List<RootItem> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: LuminaColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.root,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: LuminaColors.primary,
                  ),
                ),
              ),
              title: Text(
                '${item.origin} · ${item.meaning}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                '派生词汇 (${item.derivedWords.length}个): ${item.derivedWords.map((w) => w.word).join(", ")}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 20,
                        indent: 8,
                        endIndent: 8,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '💡 记忆提示: ${item.explanation}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '🌳 联想派生词树：',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...item.derivedWords.map((derived) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : LuminaColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          derived.word,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: LuminaColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          derived.phonetic,
                                          style: LuminaTheme.ipaStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      derived.meaning,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '拆解: ${derived.breakdown}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.volume_up, color: LuminaColors.primary),
                                    onPressed: () {
                                      AudioService.instance.speakWord(derived.word);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _storageService?.getFavorites().contains(derived.word.toLowerCase()) == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _storageService?.getFavorites().contains(derived.word.toLowerCase()) == true
                                          ? Colors.red
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      final clean = derived.word.toLowerCase();
                                      final isFav = _storageService?.getFavorites().contains(clean) == true;
                                      if (isFav) {
                                        await _storageService?.removeFavorite(clean);
                                      } else {
                                        await _storageService?.addFavorite(clean);
                                        await _storageService?.saveFavoriteContext(
                                          derived.word,
                                          articleTitle: '字词根专项: ${item.root}',
                                          sentence: '${derived.word} (${derived.meaning}) - 拆解: ${derived.breakdown}',
                                        );
                                      }
                                      setState(() {});
                                    },
                                    tooltip: '加入生词本',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DerivedWord {
  final String word;
  final String phonetic;
  final String meaning;
  final String breakdown;

  const DerivedWord({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.breakdown,
  });
}

class RootItem {
  final String root;
  final String origin;
  final String meaning;
  final String explanation;
  final List<DerivedWord> derivedWords;

  const RootItem({
    required this.root,
    required this.origin,
    required this.meaning,
    required this.explanation,
    required this.derivedWords,
  });
}

// 核心词根数据
final List<RootItem> _coreRoots = [
  const RootItem(
    root: 'port',
    origin: '拉丁语',
    meaning: '拿、运、港口',
    explanation: '源自拉丁语 portare，意为把物品从一处运拿到另一处。',
    derivedWords: [
      DerivedWord(word: 'import', phonetic: '/ɪmˈpɔːt/', meaning: '进口、输入', breakdown: 'im- [向内] + port [运] ➔ 运进来'),
      DerivedWord(word: 'export', phonetic: '/ˈekspɔːt/', meaning: '出口、输出', breakdown: 'ex- [向外] + port [运] ➔ 运出去'),
      DerivedWord(word: 'transport', phonetic: '/ˈtrænspɔːt/', meaning: '运输、交通', breakdown: 'trans- [跨越] + port [运] ➔ 跨地运送'),
      DerivedWord(word: 'portable', phonetic: '/ˈpɔːtəbl/', meaning: '手提的、便携的', breakdown: 'port [运] + -able [可...的] ➔ 拿得动的'),
      DerivedWord(word: 'reporter', phonetic: '/rɪˈpɔːtə/', meaning: '记者、报导者', breakdown: 're- [回/反复] + port [拿] + -er ➔ 带回消息的人'),
    ],
  ),
  const RootItem(
    root: 'vis / vid',
    origin: '拉丁语',
    meaning: '看、看见',
    explanation: '源自拉丁语 videre (看)，衍生出与视力、观察相关的一切词汇。',
    derivedWords: [
      DerivedWord(word: 'visit', phonetic: '/ˈvɪzɪt/', meaning: '拜访、参观', breakdown: 'vis [看] + -it ➔ 亲自去看'),
      DerivedWord(word: 'visible', phonetic: '/ˈvɪzəbl/', meaning: '可见的、明显的', breakdown: 'vis [看] + -ible [可...的] ➔ 看得见的'),
      DerivedWord(word: 'television', phonetic: '/ˈtelɪvɪʒn/', meaning: '电视机', breakdown: 'tele- [远处] + vis [看] + -ion ➔ 远程观看'),
      DerivedWord(word: 'video', phonetic: '/ˈvɪdiəʊ/', meaning: '视频、录像', breakdown: 'vid [看] + -eo ➔ 可看的东西'),
      DerivedWord(word: 'provide', phonetic: '/prəˈvaɪd/', meaning: '提供、装备', breakdown: 'pro- [向前] + vid [看] ➔ 向前看好准备'),
    ],
  ),
  const RootItem(
    root: 'tract',
    origin: '拉丁语',
    meaning: '拉、抽、引',
    explanation: '源自拉丁语 trahere，意为用力将物体拉动或抽取出来。',
    derivedWords: [
      DerivedWord(word: 'attract', phonetic: '/əˈtrækt/', meaning: '吸引、引起', breakdown: 'at- [朝向] + tract [拉] ➔ 把目光拉过来'),
      DerivedWord(word: 'extract', phonetic: '/ˈekstrækt/', meaning: '提取、萃取', breakdown: 'ex- [向外] + tract [拉] ➔ 从内部拉出来'),
      DerivedWord(word: 'contract', phonetic: '/ˈkɒntrækt/', meaning: '合同、收缩', breakdown: 'con- [一起] + tract [拉] ➔ 拉到一起达成契约'),
      DerivedWord(word: 'tractor', phonetic: '/ˈtræktə/', meaning: '拖拉机', breakdown: 'tract [拉] + -or [机器] ➔ 用于拉重物的机器'),
    ],
  ),
  const RootItem(
    root: 'dict',
    origin: '拉丁语',
    meaning: '说、言',
    explanation: '源自拉丁语 dicere，表示说话、宣称或口述。',
    derivedWords: [
      DerivedWord(word: 'dictionary', phonetic: '/ˈdɪkʃənri/', meaning: '字典、词典', breakdown: 'dict [说/言] + -ionary ➔ 汇集词言的书'),
      DerivedWord(word: 'predict', phonetic: '/prɪˈdɪkt/', meaning: '预测、预言', breakdown: 'pre- [提前] + dict [说] ➔ 提前说出来'),
      DerivedWord(word: 'indicate', phonetic: '/ˈɪndɪkeɪt/', meaning: '指示、表明', breakdown: 'in- [向内] + dic [说] + -ate ➔ 指出说明'),
      DerivedWord(word: 'contradict', phonetic: '/ˌkɒntrəˈdɪkt/', meaning: '反驳、矛盾', breakdown: 'contra- [相反] + dict [说] ➔ 对着干说相反的话'),
    ],
  ),
  const RootItem(
    root: 'bio',
    origin: '希腊语',
    meaning: '生命、生物',
    explanation: '源自希腊语 bios (生命)，用于描述与生命科学或个人生平相关的领域。',
    derivedWords: [
      DerivedWord(word: 'biology', phonetic: '/baɪˈɒlədʒi/', meaning: '生物学', breakdown: 'bio [生命] + -logy [学科] ➔ 研究生命的学科'),
      DerivedWord(word: 'biography', phonetic: '/baɪˈɒɡrəfi/', meaning: '传记', breakdown: 'bio [生命] + graph [写] + -y ➔ 记录个人生命史的书'),
      DerivedWord(word: 'autobiography', phonetic: '/ˌɔːtəbaɪˈɒɡrəfi/', meaning: '自传', breakdown: 'auto- [自己] + bio [生命] + graph [写] ➔ 自己写自己的生命史'),
    ],
  ),
  const RootItem(
    root: 'tele',
    origin: '希腊语',
    meaning: '远、远距离',
    explanation: '源自希腊语 tele，表示跨越遥远距离的传输与沟通。',
    derivedWords: [
      DerivedWord(word: 'telephone', phonetic: '/ˈtelɪfəʊn/', meaning: '电话', breakdown: 'tele [远] + phon [声音] ➔ 传送远方的声音'),
      DerivedWord(word: 'telescope', phonetic: '/ˈtelɪskəʊp/', meaning: '望远镜', breakdown: 'tele [远] + scop [观察] ➔ 观察远方物体的仪器'),
      DerivedWord(word: 'telegraph', phonetic: '/ˈtelɪɡrɑːf/', meaning: '电报', breakdown: 'tele [远] + graph [写] ➔ 传送远方文字的电信号'),
    ],
  ),
];

// 高频前缀数据
final List<RootItem> _commonPrefixes = [
  const RootItem(
    root: 're-',
    origin: '前缀',
    meaning: '重新、再次、回',
    explanation: '最常见的英语前缀，表示动作的重新发生或返回原状。',
    derivedWords: [
      DerivedWord(word: 'rewrite', phonetic: '/ˌriːˈraɪt/', meaning: '重写、改写', breakdown: 're- [重新] + write [写]'),
      DerivedWord(word: 'return', phonetic: '/rɪˈtɜːn/', meaning: '返回、归还', breakdown: 're- [回] + turn [转] ➔ 转回来'),
      DerivedWord(word: 'review', phonetic: '/rɪˈvjuː/', meaning: '复习、回顾', breakdown: 're- [重新] + view [看] ➔ 重新看一遍'),
      DerivedWord(word: 'rebuild', phonetic: '/ˌriːˈbɪld/', meaning: '重建、重构', breakdown: 're- [重新] + build [建造]'),
    ],
  ),
  const RootItem(
    root: 'un- / dis-',
    origin: '前缀',
    meaning: '不、相反、剥夺',
    explanation: '否定前缀，使基词含义转变为完全相反的对立面。',
    derivedWords: [
      DerivedWord(word: 'unhappy', phonetic: '/ʌnˈhæpi/', meaning: '不高兴的', breakdown: 'un- [不] + happy [开心]'),
      DerivedWord(word: 'unknown', phonetic: '/ˌʌnˈnəʊn/', meaning: '未知的', breakdown: 'un- [未] + known [已知的]'),
      DerivedWord(word: 'disagree', phonetic: '/ˌdɪsəˈɡriː/', meaning: '不同意', breakdown: 'dis- [相反] + agree [同意]'),
      DerivedWord(word: 'discover', phonetic: '/dɪˈskʌvə/', meaning: '发现、揭开', breakdown: 'dis- [解开] + cover [盖子] ➔ 揭开盖子'),
    ],
  ),
  const RootItem(
    root: 'sub- / trans-',
    origin: '前缀',
    meaning: '在…下方 / 跨越、穿过',
    explanation: '空间方位前缀，指示位置的偏下、附属或横跨。',
    derivedWords: [
      DerivedWord(word: 'subway', phonetic: '/ˈsʌbweɪ/', meaning: '地铁', breakdown: 'sub- [在下方] + way [道路] ➔ 下方的路'),
      DerivedWord(word: 'subtitle', phonetic: '/ˈsʌbtaɪtl/', meaning: '副标题、字幕', breakdown: 'sub- [次要] + title [标题]'),
      DerivedWord(word: 'translate', phonetic: '/trænzˈleɪt/', meaning: '翻译、转换', breakdown: 'trans- [跨越] + late [携带] ➔ 跨语言传递'),
    ],
  ),
];

// 常用后缀数据
final List<RootItem> _commonSuffixes = [
  const RootItem(
    root: '-able / -ible',
    origin: '形容词后缀',
    meaning: '能够…的、值得…的',
    explanation: '附加在动词后，将其转化为表示能力的形容词。',
    derivedWords: [
      DerivedWord(word: 'readable', phonetic: '/ˈriːdəbl/', meaning: '可读的、通俗易懂的', breakdown: 'read [读] + -able [可...的]'),
      DerivedWord(word: 'enjoyable', phonetic: '/ɪnˈdʒɔɪəbl/', meaning: '令人愉快的', breakdown: 'enjoy [享受] + -able'),
      DerivedWord(word: 'flexible', phonetic: '/ˈfleksəbl/', meaning: '灵活的、柔韧的', breakdown: 'flex [弯曲] + -ible ➔ 能弯曲的'),
    ],
  ),
  const RootItem(
    root: '-tion / -sion',
    origin: '名词后缀',
    meaning: '动作、状态、结果',
    explanation: '最核心的名词后缀，将抽象动词转化为具体名词形态。',
    derivedWords: [
      DerivedWord(word: 'action', phonetic: '/ˈækʃn/', meaning: '行动、作用', breakdown: 'act [行动] + -ion ➔ 行为'),
      DerivedWord(word: 'education', phonetic: '/ˌedʒuˈkeɪʃn/', meaning: '教育、培养', breakdown: 'educate [教育] + -tion'),
      DerivedWord(word: 'decision', phonetic: '/dɪˈsɪʒn/', meaning: '决定、决断', breakdown: 'decide [决定] + -sion'),
    ],
  ),
];

class _WordRootMatchingGameWidget extends StatefulWidget {
  const _WordRootMatchingGameWidget();

  @override
  State<_WordRootMatchingGameWidget> createState() => _WordRootMatchingGameWidgetState();
}

class _WordRootMatchingGameWidgetState extends State<_WordRootMatchingGameWidget> {
  final List<Map<String, String>> _gamePairs = [
    {
      'id': '1',
      'word': 'import',
      'breakdown': 'im- [向内] + port [拿/运]',
      'meaning': '进口、输入（向内运进）',
    },
    {
      'id': '2',
      'word': 'export',
      'breakdown': 'ex- [向外] + port [拿/运]',
      'meaning': '出口、输出（向外运出）',
    },
    {
      'id': '3',
      'word': 'subway',
      'breakdown': 'sub- [在下方] + way [道路]',
      'meaning': '地铁（地下通道）',
    },
    {
      'id': '4',
      'word': 'discover',
      'breakdown': 'dis- [解开] + cover [盖子]',
      'meaning': '发现、揭开盖子',
    },
    {
      'id': '5',
      'word': 'invisible',
      'breakdown': 'in- [否定] + vis [看] + -ible [可...的]',
      'meaning': '隐形的、不可见的',
    },
  ];

  String? _selectedBreakdownId;
  String? _selectedMeaningId;
  final Set<String> _matchedIds = {};
  int _score = 0;

  void _checkMatch() {
    if (_selectedBreakdownId != null && _selectedMeaningId != null) {
      if (_selectedBreakdownId == _selectedMeaningId) {
        final matchedItem = _gamePairs.firstWhere((p) => p['id'] == _selectedBreakdownId);
        AudioService.instance.speak(matchedItem['word']!);

        setState(() {
          _matchedIds.add(_selectedBreakdownId!);
          _selectedBreakdownId = null;
          _selectedMeaningId = null;
          _score += 20;
        });

        if (_matchedIds.length == _gamePairs.length) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('🎉 拆词消除大满贯！'),
              content: Text('恭喜你配对成功全部 5 组词根拆解！\n获得 100 学习积分奖励！'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _matchedIds.clear();
                      _selectedBreakdownId = null;
                      _selectedMeaningId = null;
                      _score = 0;
                    });
                  },
                  child: const Text('再玩一次'),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ 拆解与释义不匹配，请重新思考！'),
            duration: Duration(milliseconds: 1200),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          _selectedBreakdownId = null;
          _selectedMeaningId = null;
        });
      }
    }
  }

  late List<Map<String, String>> _shuffledRightPairs;

  @override
  void initState() {
    super.initState();
    _shuffledRightPairs = List<Map<String, String>>.from(_gamePairs)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.extension_rounded, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '词根连线消消乐',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '得分: $_score / 100 | 已匹配: ${_matchedIds.length} / ${_gamePairs.length}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '👉 左侧选择【词根拆解公式】，右侧选择【正确中文含义】：',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧：拆解公式
              Expanded(
                child: Column(
                  children: _gamePairs.map((item) {
                    final id = item['id']!;
                    final isMatched = _matchedIds.contains(id);
                    final isSelected = _selectedBreakdownId == id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: isMatched
                            ? null
                            : () {
                                setState(() {
                                  _selectedBreakdownId = id;
                                });
                                _checkMatch();
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? Colors.green.shade50
                                : (isSelected
                                    ? Colors.deepOrange.shade100
                                    : (isDark ? const Color(0xFF1E293B) : Colors.white)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isMatched
                                  ? Colors.green
                                  : (isSelected ? Colors.deepOrange : (isDark ? Colors.white10 : Colors.grey.shade300)),
                              width: isSelected || isMatched ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['word']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isMatched ? Colors.green.shade800 : (isSelected ? Colors.deepOrange.shade900 : null),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['breakdown']!,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              // 右侧：中文含义
              Expanded(
                child: Column(
                  children: _shuffledRightPairs.map((item) {
                    final id = item['id']!;
                    final isMatched = _matchedIds.contains(id);
                    final isSelected = _selectedMeaningId == id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: isMatched
                            ? null
                            : () {
                                setState(() {
                                  _selectedMeaningId = id;
                                });
                                _checkMatch();
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? Colors.green.shade50
                                : (isSelected
                                    ? Colors.deepOrange.shade100
                                    : (isDark ? const Color(0xFF1E293B) : Colors.white)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isMatched
                                  ? Colors.green
                                  : (isSelected ? Colors.deepOrange : (isDark ? Colors.white10 : Colors.grey.shade300)),
                              width: isSelected || isMatched ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              item['meaning']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isMatched ? Colors.green.shade800 : (isSelected ? Colors.deepOrange.shade900 : null),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EtymologyTreeViewWidget extends StatefulWidget {
  const _EtymologyTreeViewWidget();

  @override
  State<_EtymologyTreeViewWidget> createState() => _EtymologyTreeViewWidgetState();
}

class _EtymologyTreeViewWidgetState extends State<_EtymologyTreeViewWidget> {
  int _selectedTreeIndex = 0;

  final List<Map<String, dynamic>> _treeData = [
    {
      'root': 'struct',
      'meaning': '建造，构建 (to build)',
      'origin': '🏛️ 拉丁语根 structus',
      'branches': [
        {
          'prefix': 'con- (共同)',
          'word': 'construct',
          'phonetic': '/kənˈstrʌkt/',
          'meaning': 'v. 建设，建造',
          'sentence': 'They plan to construct a new highway.',
        },
        {
          'prefix': 'de- (向下/破坏)',
          'word': 'destruct',
          'phonetic': '/dɪˈstrʌkt/',
          'meaning': 'v. 破坏，摧毁',
          'sentence': 'The missile was ordered to self-destruct.',
        },
        {
          'prefix': 'in- (向内)',
          'word': 'instruct',
          'phonetic': '/ɪnˈstrʌkt/',
          'meaning': 'v. 指导，教授',
          'sentence': 'She will instruct the students in grammar.',
        },
        {
          'prefix': 're- (重新)',
          'word': 'reconstruct',
          'phonetic': '/ˌriːkənˈstrʌkt/',
          'meaning': 'v. 重建，重现',
          'sentence': 'Historians tried to reconstruct the ancient city.',
        },
      ],
    },
    {
      'root': 'port',
      'meaning': '拿，运，携带 (to carry)',
      'origin': '🏛️ 拉丁语根 portare',
      'branches': [
        {
          'prefix': 'im- (向内)',
          'word': 'import',
          'phonetic': '/ˈɪmpɔːt/',
          'meaning': 'v. 进口，输入',
          'sentence': 'The country imports oil from abroad.',
        },
        {
          'prefix': 'ex- (向外)',
          'word': 'export',
          'phonetic': '/ˈekspɔːt/',
          'meaning': 'v. 出口，输出',
          'sentence': 'They export tea to Europe.',
        },
        {
          'prefix': 'trans- (穿过)',
          'word': 'transport',
          'phonetic': '/ˈtrænspɔːt/',
          'meaning': 'v./n. 运输，搬运',
          'sentence': 'Bicycles are a green means of transport.',
        },
        {
          'prefix': 'sup- (在...下方)',
          'word': 'support',
          'phonetic': '/səˈpɔːt/',
          'meaning': 'v. 支持，支撑',
          'sentence': 'I fully support your decision.',
        },
      ],
    },
    {
      'root': 'spect',
      'meaning': '看，观察 (to look)',
      'origin': '🏛️ 拉丁语根 specere',
      'branches': [
        {
          'prefix': 'in- (向内/深入)',
          'word': 'inspect',
          'phonetic': '/ɪnˈspekt/',
          'meaning': 'v. 检查，视察',
          'sentence': 'Officials will inspect the school today.',
        },
        {
          'prefix': 'pro- (向前)',
          'word': 'prospect',
          'phonetic': '/ˈprɒspekt/',
          'meaning': 'n. 前景，展望',
          'sentence': 'The job offers good career prospects.',
        },
        {
          'prefix': 're- (再次/回头)',
          'word': 'respect',
          'phonetic': '/rɪˈspekt/',
          'meaning': 'v./n. 尊重，敬佩',
          'sentence': 'Always treat others with respect.',
        },
        {
          'prefix': 'retro- (向后)',
          'word': 'retrospect',
          'phonetic': '/ˈretrəspekt/',
          'meaning': 'n. 回顾，反思',
          'sentence': 'In retrospect, it was the right choice.',
        },
      ],
    },
    {
      'root': 'form',
      'meaning': '形状，形成 (to shape)',
      'origin': '🏛️ 拉丁语根 forma',
      'branches': [
        {
          'prefix': 'con- (共同/一致)',
          'word': 'conform',
          'phonetic': '/kənˈfɔːm/',
          'meaning': 'v. 符合，遵照',
          'sentence': 'Products must conform to safety standards.',
        },
        {
          'prefix': 'trans- (改变)',
          'word': 'transform',
          'phonetic': '/trænsˈfɔːm/',
          'meaning': 'v. 改变，变形',
          'sentence': 'Technology transformed our daily lives.',
        },
        {
          'prefix': 'uni- (单一/统一)',
          'word': 'uniform',
          'phonetic': '/ˈjuːnɪfɔːm/',
          'meaning': 'n. 制服 a. 统一的',
          'sentence': 'Students wear a school uniform.',
        },
        {
          'prefix': 're- (重新/改造)',
          'word': 'reform',
          'phonetic': '/rɪˈfɔːm/',
          'meaning': 'v./n. 改革，改造',
          'sentence': 'The government plans to reform the tax code.',
        },
      ],
    },
    {
      'root': 'script / scrib',
      'meaning': '写，刻写 (to write)',
      'origin': '🏛️ 拉丁语根 scribere',
      'branches': [
        {
          'prefix': 'sub- (在...下方)',
          'word': 'subscribe',
          'phonetic': '/səbˈskraɪb/',
          'meaning': 'v. 订阅，签署',
          'sentence': 'Subscribe to our channel for daily updates.',
        },
        {
          'prefix': 'de- (向下/详细)',
          'word': 'describe',
          'phonetic': '/dɪˈskraɪb/',
          'meaning': 'v. 描述，描绘',
          'sentence': 'Can you describe what happened?',
        },
        {
          'prefix': 'in- (刻在...上)',
          'word': 'inscribe',
          'phonetic': '/ɪnˈskraɪb/',
          'meaning': 'v. 铭刻，题写',
          'sentence': 'His name was inscribed on the trophy.',
        },
        {
          'prefix': 'trans- (誊写过录)',
          'word': 'transcribe',
          'phonetic': '/trænˈskraɪb/',
          'meaning': 'v. 抄录，录音转写',
          'sentence': 'The speech was transcribed word for word.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTree = _treeData[_selectedTreeIndex];
    final rootName = currentTree['root'] as String;
    final rootMeaning = currentTree['meaning'] as String;
    final rootOrigin = currentTree['origin'] as String;
    final branches = currentTree['branches'] as List<Map<String, String>>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部选择词根 Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _treeData.asMap().entries.map((entry) {
                final idx = entry.key;
                final data = entry.value;
                final isSelected = idx == _selectedTreeIndex;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${data['root']} [${data['meaning'].split(' ')[0]}]'),
                    selected: isSelected,
                    selectedColor: LuminaColors.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? LuminaColors.primary : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedTreeIndex = idx;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 核心词根树中心 Node
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_tree_rounded, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '词根中心源头: -$rootName-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  rootMeaning,
                  style: const TextStyle(color: Colors.amberAccent, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  rootOrigin,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '🌳 派生分支导图 (Branches):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 派生节点树列表
          ...branches.map((b) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.indigo.shade100,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Text(
                          '前缀 ${b['prefix']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        b['word']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: LuminaColors.primary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => AudioService.instance.speakWord(b['word']!),
                        icon: const Icon(Icons.volume_up_rounded, color: Colors.blue),
                        tooltip: '发音',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        b['phonetic']!,
                        style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        b['meaning']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '“${b['sentence']}”',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white60 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

