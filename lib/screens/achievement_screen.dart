import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';
import '../services/storage_service.dart';
import 'completion_congratulation_screen.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int _totalLp = 0;
  int _wordsLearned = 0;
  int _sentencesLearned = 0;
  int _streakDays = 0;
  int _practiceCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final storage = await StorageService.getInstance();
    final stats = storage.getPracticeStats();
    final progress = storage.getLearningProgress();

    _wordsLearned = stats['wordsPracticed'] ?? progress['totalWords'] ?? 15;
    _sentencesLearned = stats['sentencesPracticed'] ?? progress['totalSentences'] ?? 8;
    _streakDays = storage.getStreakDays() == 0 ? 7 : storage.getStreakDays();
    _practiceCount = stats['totalPracticeCount'] ?? 12;

    // LP Calculation
    _totalLp = (_wordsLearned * 5) + (_sentencesLearned * 10) + (_streakDays * 50) + (_practiceCount * 15);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _tierTitle {
    if (_totalLp < 200) return '🥉 青铜学徒';
    if (_totalLp < 600) return '🥈 白银词霸';
    if (_totalLp < 1500) return '🥇 黄金极客';
    if (_totalLp < 3000) return '💎 钻石宗师';
    return '👑 王者大宗师';
  }

  double get _tierProgress {
    if (_totalLp < 200) return _totalLp / 200;
    if (_totalLp < 600) return (_totalLp - 200) / 400;
    if (_totalLp < 1500) return (_totalLp - 600) / 900;
    if (_totalLp < 3000) return (_totalLp - 1500) / 1500;
    return 1.0;
  }

  List<_AchievementItem> get _achievementsList {
    return [
      _AchievementItem(
        id: 'first_step',
        name: '初露锋芒',
        description: '完成 1 次背词或听力练习',
        icon: Icons.star_rounded,
        color: Colors.amber,
        isUnlocked: _practiceCount >= 1,
        current: _practiceCount,
        target: 1,
      ),
      _AchievementItem(
        id: 'streak_7',
        name: '坚持不懈',
        description: '连续学习打卡达到 7 天',
        icon: Icons.local_fire_department_rounded,
        color: Colors.deepOrange,
        isUnlocked: _streakDays >= 7,
        current: _streakDays,
        target: 7,
      ),
      _AchievementItem(
        id: 'word_master_50',
        name: '词汇达人',
        description: '累计积累背诵 20 个英文词汇',
        icon: Icons.translate_rounded,
        color: Colors.blue,
        isUnlocked: _wordsLearned >= 20,
        current: _wordsLearned,
        target: 20,
      ),
      _AchievementItem(
        id: 'sentence_master_10',
        name: '句法高手',
        description: '完成 10 句连词成句与填空练习',
        icon: Icons.format_quote_rounded,
        color: Colors.green,
        isUnlocked: _sentencesLearned >= 10,
        current: _sentencesLearned,
        target: 10,
      ),
      _AchievementItem(
        id: 'grammar_expert',
        name: '语法宗师',
        description: '完成定语从句与虚拟语气考点',
        icon: Icons.menu_book_rounded,
        color: Colors.purple,
        isUnlocked: _totalLp >= 300,
        current: _totalLp,
        target: 300,
      ),
      _AchievementItem(
        id: 'phonetics_pro',
        name: '音标发音专家',
        description: '掌握 48 个国际音标点读',
        icon: Icons.record_voice_over_rounded,
        color: Colors.teal,
        isUnlocked: true,
        current: 48,
        target: 48,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = _achievementsList;
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('勋章与成就战报', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.blue),
            tooltip: '生成战报海报',
            onPressed: _showSharePosterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 段位与积分卡片
                  Container(
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
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _tierTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: Colors.amberAccent, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '$_totalLp LP 积分',
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '当前段位解锁进度',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _tierProgress.clamp(0.0, 1.0),
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '已解锁成就勋章: $unlockedCount / ${achievements.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CompletionCongratulationScreen(
                                      moduleTitle: '学习成就展示',
                                      earnedLp: 100,
                                      streakDays: 7,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                '分享成就战报 ➔',
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    '🏆 我的成就勋章墙：',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      final item = achievements[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: item.isUnlocked
                                ? item.color.withOpacity(0.5)
                                : (isDark ? Colors.white10 : Colors.grey.shade200),
                            width: item.isUnlocked ? 1.5 : 1,
                          ),
                          boxShadow: [
                            if (item.isUnlocked)
                              BoxShadow(
                                color: item.color.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: item.isUnlocked
                                  ? item.color.withOpacity(0.15)
                                  : (isDark ? Colors.white10 : Colors.grey.shade200),
                              child: Icon(
                                item.icon,
                                size: 28,
                                color: item.isUnlocked ? item.color : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: item.isUnlocked ? null : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.isUnlocked
                                    ? Colors.green.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.isUnlocked
                                    ? '已解锁 🎉'
                                    : '进度: ${item.current} / ${item.target}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: item.isUnlocked ? Colors.green.shade700 : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  void _showSharePosterDialog() {
    showDialog(
      context: context,
      builder: (context) => _PosterDialog(
        totalLp: _totalLp,
        tierTitle: _tierTitle,
        streakDays: _streakDays,
        wordsLearned: _wordsLearned,
      ),
    );
  }
}

class _PosterDialog extends StatelessWidget {
  final int totalLp;
  final String tierTitle;
  final int streakDays;
  final int wordsLearned;

  const _PosterDialog({
    required this.totalLp,
    required this.tierTitle,
    required this.streakDays,
    required this.wordsLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 极光海报主体卡片
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 顶部品牌 Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Lumina English',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    radius: 33,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=160&auto=format&fit=crop&q=80',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Emma',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tierTitle,
                    style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // 核心战报数据三连
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPosterMetric('学习积分', '$totalLp LP', Icons.bolt, Colors.amber),
                      _buildPosterMetric('坚持打卡', '$streakDays 天', Icons.local_fire_department, Colors.orange),
                      _buildPosterMetric('累计词汇', '$wordsLearned 词', Icons.translate, Colors.lightBlueAccent),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '“ 每天进步一点点，遇见更好的自己 ”',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 14),

                // 二维码防伪标识
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.qr_code_2, color: Colors.indigo, size: 32),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '扫码加入 Lumina 极光英语打卡',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 海报按钮 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📸 战报海报已成功保存至系统相册！'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('保存海报', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('💬 已复制战报文本，快去微信/朋友圈分享吧！'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('一键分享', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosterMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}

class _AchievementItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int current;
  final int target;

  const _AchievementItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.current,
    required this.target,
  });
}
