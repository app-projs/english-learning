import 'package:flutter/material.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/lumina_theme.dart';
import '../../../core/widgets/app_tab_bar.dart';
import '../../../features/review/screens/completion_congratulation_screen.dart';

class PhoneticsPracticeScreen extends StatefulWidget {
  const PhoneticsPracticeScreen({super.key});

  @override
  State<PhoneticsPracticeScreen> createState() => _PhoneticsPracticeScreenState();
}

class _PhoneticsPracticeScreenState extends State<PhoneticsPracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _tabController.dispose();
    super.dispose();
  }

  void _finishPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CompletionCongratulationScreen(
          moduleTitle: '音标发音专项',
          correctCount: 48,
          totalQuestions: 48,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('48 国际音标专项', style: TextStyle(fontWeight: FontWeight.bold)),
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
        bottom: AppTabBar(
          controller: _tabController,
          indicatorColor: Colors.deepOrange,
          labelColor: Colors.deepOrange,
          tabs: const [
            Tab(text: '音标点读卡'),
            Tab(text: '听音辨音测试'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PhoneticsGridView(),
          PhoneticsQuizView(),
        ],
      ),
    );
  }
}

// Data Model for Phonetic Item
class PhoneticItem {
  final String symbol;
  final String category; // e.g. 单元音 (前元音)
  final String tips; // 口型发音要领
  final List<String> examples; // 例词

  const PhoneticItem({
    required this.symbol,
    required this.category,
    required this.tips,
    required this.examples,
  });
}

// 48 International Phonetic Alphabet Dataset
const List<PhoneticItem> monophthongs = [
  PhoneticItem(symbol: '[i:]', category: '单元音 (前元音)', tips: '双唇微张，舌尖抵住下齿，发长音 i，发音像开心的微笑。', examples: ['sheep [ʃiːp]', 'see [siː]', 'meet [miːt]']),
  PhoneticItem(symbol: '[ɪ]', category: '单元音 (前元音)', tips: '口型比 [i:] 略大，舌位稍低，短促有力。', examples: ['ship [ʃɪp]', 'sit [sɪt]', 'big [bɪɡ]']),
  PhoneticItem(symbol: '[e]', category: '单元音 (前元音)', tips: '嘴唇向两侧张开呈扁平状，上下齿间可容纳一手指。', examples: ['bed [bed]', 'red [red]', 'pen [pen]']),
  PhoneticItem(symbol: '[æ]', category: '单元音 (前元音)', tips: '夸张大张嘴，嘴唇向两旁咧开，舌尖抵下齿。', examples: ['cat [kæt]', 'apple [ˈæpl]', 'bag [bæɡ]']),
  PhoneticItem(symbol: '[ɜ:]', category: '单元音 (中元音)', tips: '嘴唇微张呈圆形，舌身平放，发长音“呃”。', examples: ['bird [bɜːd]', 'girl [ɡɜːl]', 'nurse [nɜːs]']),
  PhoneticItem(symbol: '[ə]', category: '单元音 (中元音)', tips: '口唇自然放松微开，发音极短而轻。', examples: ['ago [əˈɡəʊ]', 'teacher [ˈtiːtʃə]', 'banana [bəˈnɑːnə]']),
  PhoneticItem(symbol: '[ʌ]', category: '单元音 (中元音)', tips: '口型半开，舌尖离开下齿，声音短促响亮。', examples: ['cup [kʌp]', 'bus [bʌs]', 'duck [dʌk]']),
  PhoneticItem(symbol: '[u:]', category: '单元音 (后元音)', tips: '双唇收圆突出呈小孔状，舌后部抬高。', examples: ['too [tuː]', 'shoe [ʃuː]', 'food [fuːd]']),
  PhoneticItem(symbol: '[ʊ]', category: '单元音 (后元音)', tips: '双唇微圆稍突出，比 [u:] 自然放松且短促。', examples: ['book [bʊk]', 'look [lʊk]', 'foot [fʊt]']),
  PhoneticItem(symbol: '[ɔ:]', category: '单元音 (后元音)', tips: '双唇聚圆收小，舌后部向软腭抬起发长音。', examples: ['door [dɔː]', 'talk [tɔːk]', 'horse [hɔːs]']),
  PhoneticItem(symbol: '[ɒ]', category: '单元音 (后元音)', tips: '口张大呈椭圆形，短促清晰。', examples: ['hot [hɒt]', 'dog [dɒɡ]', 'box [bɒks]']),
  PhoneticItem(symbol: '[ɑ:]', category: '单元音 (后元音)', tips: '口张大，舌身平放后缩，发沉稳长音“啊”。', examples: ['car [kɑː]', 'park [pɑːk]', 'father [ˈfɑːðə]']),
];

const List<PhoneticItem> diphthongs = [
  PhoneticItem(symbol: '[eɪ]', category: '双元音', tips: '由 [e] 向 [ɪ] 滑动，口型由半开变为微合。', examples: ['cake [keɪk]', 'day [deɪ]', 'rain [reɪn]']),
  PhoneticItem(symbol: '[aɪ]', category: '双元音', tips: '由 [a] 向 [ɪ] 滑动，发音响亮平滑。', examples: ['my [maɪ]', 'like [laɪk]', 'fly [flaɪ]']),
  PhoneticItem(symbol: '[ɔɪ]', category: '双元音', tips: '由 [ɔ:] 向 [ɪ] 滑动，双唇由圆变扁。', examples: ['boy [bɔɪ]', 'toy [tɔɪ]', 'voice [vɔɪs]']),
  PhoneticItem(symbol: '[əʊ]', category: '双元音', tips: '由 [ə] 滑向 [ʊ]，口型由半开收圆。', examples: ['go [ɡəʊ]', 'home [həʊm]', 'snow [snəʊ]']),
  PhoneticItem(symbol: '[aʊ]', category: '双元音', tips: '由 [a] 滑向 [ʊ]，大张嘴后迅速收圆。', examples: ['now [naʊ]', 'house [haʊs]', 'cow [kaʊ]']),
  PhoneticItem(symbol: '[ɪə]', category: '双元音', tips: '由 [ɪ] 滑向 [ə]，双唇张开。', examples: ['ear [ɪə]', 'near [nɪə]', 'dear [dɪə]']),
  PhoneticItem(symbol: '[eə]', category: '双元音', tips: '由 [e] 滑向 [ə]，发音自然流畅。', examples: ['air [eə]', 'bear [beə]', 'hair [heə]']),
  PhoneticItem(symbol: '[ʊə]', category: '双元音', tips: '由 [ʊ] 滑向 [ə]，双唇由收圆变放松。', examples: ['poor [pʊə]', 'tour [tʊə]', 'sure [ʃʊə]']),
];

const List<PhoneticItem> consonants = [
  PhoneticItem(symbol: '[p]', category: '爆破辅音 (清)', tips: '双唇紧闭阻碍气流，然后突然张开爆破成音。', examples: ['pen [pen]', 'pig [pɪɡ]', 'cup [kʌp]']),
  PhoneticItem(symbol: '[b]', category: '爆破辅音 (浊)', tips: '发音部位同 [p]，但声带震动成音。', examples: ['big [bɪɡ]', 'book [bʊk]', 'bus [bʌs]']),
  PhoneticItem(symbol: '[t]', category: '爆破辅音 (清)', tips: '舌尖紧贴上齿龈阻气，突然冲发出声。', examples: ['tea [tiː]', 'top [tɒp]', 'cat [kæt]']),
  PhoneticItem(symbol: '[d]', category: '爆破辅音 (浊)', tips: '发音部位同 [t]，声带震动发音。', examples: ['dog [dɒɡ]', 'door [dɔː]', 'bed [bed]']),
  PhoneticItem(symbol: '[k]', category: '爆破辅音 (清)', tips: '舌后部紧贴软腭阻气，急剧离开冲出。', examples: ['cat [kæt]', 'key [kiː]', 'book [bʊk]']),
  PhoneticItem(symbol: '[g]', category: '爆破辅音 (浊)', tips: '发音部位同 [k]，声带震动发音。', examples: ['go [ɡəʊ]', 'girl [ɡɜːl]', 'bag [bæɡ]']),
  PhoneticItem(symbol: '[f]', category: '摩擦辅音 (清)', tips: '上齿轻咬下唇，气流从中摩擦而出。', examples: ['fish [fɪʃ]', 'foot [fʊt]', 'leaf [liːf]']),
  PhoneticItem(symbol: '[v]', category: '摩擦辅音 (浊)', tips: '发音部位同 [f]，声带同时发出强震动。', examples: ['van [væn]', 'very [ˈveri]', 'love [lʌv]']),
  PhoneticItem(symbol: '[θ]', category: '摩擦辅音 (清)', tips: '舌尖微微伸出上下齿之间，吹气成音（咬舌音）。', examples: ['think [θɪŋk]', 'three [θriː]', 'math [mæθ]']),
  PhoneticItem(symbol: '[ð]', category: '摩擦辅音 (浊)', tips: '发音部位同 [θ]，声带震动（咬舌音）。', examples: ['this [ðɪs]', 'that [ðæt]', 'mother [ˈmʌðə]']),
  PhoneticItem(symbol: '[s]', category: '摩擦辅音 (清)', tips: '舌尖靠近上齿龈，气流形成细狭缝隙摩擦。', examples: ['sun [sʌn]', 'sit [sɪt]', 'bus [bʌs]']),
  PhoneticItem(symbol: '[z]', category: '摩擦辅音 (浊)', tips: '发音部位同 [s]，声带强烈震动。', examples: ['zoo [zuː]', 'zero [ˈzɪərəʊ]', 'rose [rəʊz]']),
  PhoneticItem(symbol: '[ʃ]', category: '摩擦辅音 (清)', tips: '双唇稍微向前突出，舌身抬高摩擦发“嘘”音。', examples: ['she [ʃiː]', 'shoe [ʃuː]', 'fish [fɪʃ]']),
  PhoneticItem(symbol: '[ʒ]', category: '摩擦辅音 (浊)', tips: '发音部位同 [ʃ]，声带同时震动。', examples: ['pleasure [ˈpleʒə]', 'vision [ˈvɪʒn]', 'measure [ˈmeʒə]']),
  PhoneticItem(symbol: '[tʃ]', category: '破擦辅音 (清)', tips: '舌尖抵上齿龈形成阻碍后急速释放摩擦。', examples: ['chair [tʃeə]', 'cheese [tʃiːz]', 'beach [biːtʃ]']),
  PhoneticItem(symbol: '[dʒ]', category: '破擦辅音 (浊)', tips: '发音部位同 [tʃ]，声带同时震动。', examples: ['jump [dʒʌmp]', 'job [dʒɒb]', 'age [eɪdʒ]']),
  PhoneticItem(symbol: '[m]', category: '鼻辅音 (浊)', tips: '双唇紧闭，气流从鼻腔发出响亮成音。', examples: ['man [mæn]', 'mother [ˈmʌðə]', 'room [ruːm]']),
  PhoneticItem(symbol: '[n]', category: '鼻辅音 (浊)', tips: '舌尖贴上齿龈阻挡，气流从鼻腔流出。', examples: ['no [nəʊ]', 'name [neɪm]', 'sun [sʌn]']),
  PhoneticItem(symbol: '[ŋ]', category: '鼻辅音 (浊)', tips: '舌后部贴软腭，气流由鼻腔后部流出。', examples: ['sing [sɪŋ]', 'ring [rɪŋ]', 'song [sɒŋ]']),
  PhoneticItem(symbol: '[h]', category: '似拼音 (清)', tips: '口型张开，声门收窄，发轻呼气声。', examples: ['hat [hæt]', 'hot [hɒt]', 'house [haʊs]']),
  PhoneticItem(symbol: '[l]', category: '似拼音 (浊)', tips: '舌尖紧抵上齿龈，气流由舌两侧流出。', examples: ['leg [leɡ]', 'light [laɪt]', 'ball [bɔːl]']),
  PhoneticItem(symbol: '[r]', category: '似拼音 (浊)', tips: '舌尖卷起向上齿龈后方，双唇微圆。', examples: ['red [red]', 'run [rʌn]', 'rain [reɪn]']),
  PhoneticItem(symbol: '[w]', category: '半元音 (浊)', tips: '双唇突出收极圆，迅速向后面的元音滑动。', examples: ['we [wiː]', 'water [ˈwɔːtə]', 'window [ˈwɪndəʊ]']),
  PhoneticItem(symbol: '[j]', category: '半元音 (浊)', tips: '舌前部抬高靠近硬腭，发类似于短 i 的滑音。', examples: ['yes [jes]', 'you [juː]', 'year [jɪə]']),
];

// Grid View Component for IPA Chart
class PhoneticsGridView extends StatelessWidget {
  const PhoneticsGridView({super.key});

  void _showDetailBottomSheet(BuildContext context, PhoneticItem item) {
    AudioService.instance.speakPhoneticSymbol(item.symbol);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.symbol,
                      style: LuminaTheme.ipaStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '点击大声听音标纯正发音',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AudioService.instance.speakPhoneticSymbol(item.symbol);
                    },
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '👄 口型发音要领',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Text(
                  item.tips,
                  style: LuminaTheme.ipaStyle(fontSize: 14, color: Colors.amber.shade900).copyWith(height: 1.4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '📝 经典例词练习 (点击听单词原声发音)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: item.examples.map((ex) {
                  final wordOnly = ex.split(' ')[0];
                  return ActionChip(
                    avatar: const Icon(Icons.volume_up_outlined, size: 16),
                    label: Text(
                      ex,
                      style: LuminaTheme.ipaStyle(fontSize: 13),
                    ),
                    backgroundColor: Colors.grey.shade100,
                    onPressed: () {
                      AudioService.instance.speakWord(wordOnly);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, String countText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(countText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<PhoneticItem> items, Color color) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showDetailBottomSheet(context, item),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.symbol,
                  style: LuminaTheme.ipaStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.category.split(' ')[0],
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('🔊 元音音标 (Vowels)', '20 个'),
          _buildGrid(context, [...monophthongs, ...diphthongs], Colors.deepOrange),
          _buildSectionTitle('💬 辅音音标 (Consonants)', '28 个'),
          _buildGrid(context, consonants, Colors.indigo),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Phonetics Listening Quiz Component
class PhoneticsQuizView extends StatefulWidget {
  const PhoneticsQuizView({super.key});

  @override
  State<PhoneticsQuizView> createState() => _PhoneticsQuizViewState();
}

class _PhoneticsQuizViewState extends State<PhoneticsQuizView> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _answered = false;

  final List<Map<String, dynamic>> _quizItems = [
    {
      'target': '[i:]',
      'options': ['[i:]', '[ɪ]', '[e]', '[æ]'],
      'word': 'sheep',
    },
    {
      'target': '[æ]',
      'options': ['[e]', '[æ]', '[ʌ]', '[ɑ:]'],
      'word': 'apple',
    },
    {
      'target': '[eɪ]',
      'options': ['[aɪ]', '[eɪ]', '[ɔɪ]', '[əʊ]'],
      'word': 'cake',
    },
    {
      'target': '[θ]',
      'options': ['[ð]', '[s]', '[θ]', '[f]'],
      'word': 'think',
    },
    {
      'target': '[ʃ]',
      'options': ['[s]', '[z]', '[tʃ]', '[ʃ]'],
      'word': 'shoe',
    },
  ];

  @override
  void initState() {
    super.initState();
    _playTargetSound();
  }

  void _playTargetSound() {
    final target = _quizItems[_currentIndex]['target'] as String;
    AudioService.instance.speakPhoneticSymbol(target);
  }

  void _selectOption(String option) {
    if (_answered) return;
    final target = _quizItems[_currentIndex]['target'] as String;
    setState(() {
      _selectedOption = option;
      _answered = true;
      if (option == target) {
        _score += 20;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _quizItems.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
      _playTargetSound();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎉 测验完成！'),
          content: Text('你的听音辨音成绩为: $_score 分！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                  _score = 0;
                  _selectedOption = null;
                  _answered = false;
                });
                _playTargetSound();
              },
              child: const Text('再测一次'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quizItems[_currentIndex];
    final target = quiz['target'] as String;
    final options = quiz['options'] as List<String>;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _quizItems.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 24),

          // Question Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    '第 ${_currentIndex + 1} / ${_quizItems.length} 题',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    iconSize: 40,
                    onPressed: _playTargetSound,
                    icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.deepOrange),
                  ),
                  const SizedBox(height: 12),
                  const Text('点击上面喇叭听声音，选择正确的音标：'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Options Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final opt = options[index];
                Color btnColor = Colors.white;
                Color textColor = Colors.black87;

                if (_answered) {
                  if (opt == target) {
                    btnColor = Colors.green.shade100;
                    textColor = Colors.green.shade900;
                  } else if (opt == _selectedOption) {
                    btnColor = Colors.red.shade100;
                    textColor = Colors.red.shade900;
                  }
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: textColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _selectOption(opt),
                  child: Text(
                    opt,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),

          if (_answered) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _nextQuestion,
              child: Text(_currentIndex < _quizItems.length - 1 ? '下一题' : '查看结算报告'),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
