import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';
import '../services/audio_service.dart';
import 'completion_congratulation_screen.dart';

class WordRootsScreen extends StatefulWidget {
  const WordRootsScreen({super.key});

  @override
  State<WordRootsScreen> createState() => _WordRootsScreenState();
}

class _WordRootsScreenState extends State<WordRootsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
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
              Tab(text: '拆词连线游戏'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRootsList(_coreRoots),
          _buildRootsList(_commonPrefixes),
          _buildRootsList(_commonSuffixes),
          const _WordRootMatchingGameWidget(),
        ],
      ),
    );
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
                color: Colors.black.withOpacity(0.03),
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
                      const Divider(),
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
                              IconButton(
                                icon: const Icon(Icons.volume_up, color: LuminaColors.primary),
                                onPressed: () {
                                  AudioService.instance.speakWord(derived.word);
                                },
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
              content: Text('恭喜你配对成功全部 5 组词根拆解！\n获得 100 LP 积分奖励！'),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final leftItems = List<Map<String, String>>.from(_gamePairs)..shuffle();
    final rightItems = List<Map<String, String>>.from(_gamePairs)..shuffle();

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
                  children: _gamePairs.map((item) {
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
