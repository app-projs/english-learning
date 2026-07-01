import 'dart:math';
import 'package:flutter/material.dart';
import 'practice_tab.dart';
import 'achievement_screen.dart';
import 'goal_setting_screen.dart';
import 'reading_history_screen.dart';
import 'favorites_screen.dart';
import 'notification_settings_screen.dart';
import 'wrong_answers_screen.dart';
import 'practice_stats_screen.dart';
import 'daily_tab.dart';
import 'leaderboard_tab.dart';
import '../theme/lumina_theme.dart';
import '../models/user.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
        DailyTab(isActive: _currentIndex == 0),
        const PracticeTab(),
        const LeaderboardTab(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ..._screens,
          ProfileTab(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: '学习'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '专项'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: '榜单'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ProfileTab({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      isDarkMode: isDarkMode,
      onThemeChanged: onThemeChanged,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  List<ActivityRecord> _activities = [];
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final shouldShowLoading = _profile == null;
    if (shouldShowLoading && mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final profile = await userService.getUserProfile();
      final activities = await userService.getRecentActivity();
      final achievements = await userService.getAchievements();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _activities = activities;
        _achievements = achievements;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'translate':
        return Icons.translate;
      case 'format_quote':
        return Icons.format_quote;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.emoji_events;
    }
  }

  List<double> _calculateRadarValues(UserProfile profile) {
    final vocabProgress = profile.wordsGoal > 0
        ? (profile.totalWords / profile.wordsGoal * 100)
        : 50.0;
    final grammarProgress = profile.sentencesGoal > 0
        ? (profile.totalSentences / profile.sentencesGoal * 100)
        : 50.0;
    final dialogueProgress = profile.dialoguesGoal > 0
        ? (profile.totalDialogues / profile.dialoguesGoal * 100)
        : 50.0;

    final readingProgress = 40.0 + (profile.totalDays * 3.0);
    final listeningProgress = 50.0 + (profile.totalMinutes * 0.1);

    return [
      vocabProgress.clamp(30.0, 100.0),
      grammarProgress.clamp(30.0, 100.0),
      dialogueProgress.clamp(30.0, 100.0),
      listeningProgress.clamp(30.0, 100.0),
      readingProgress.clamp(30.0, 100.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 16),
                  _buildRadarChartCard(),
                  const SizedBox(height: 16),
                  _buildAchievementsShelf(),
                  const SizedBox(height: 16),
                  _buildStatsOverview(),
                  const SizedBox(height: 16),
                  _buildLearningProgress(),
                  const SizedBox(height: 16),
                  _buildRecentActivity(),
                  const SizedBox(height: 16),
                  _buildQuickActions(),
                  const SizedBox(height: 128), // Space for floating bottom nav
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    if (_profile == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatar = _profile!.avatar;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF2A1A12), Color(0xFF17120E)]
                : const [Color(0xFFFFF7ED), Color(0xFFFFFBF3)],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark
                ? const Color(0xFFF97316).withOpacity(0.22)
                : Colors.white.withOpacity(0.72),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF97316).withOpacity(isDark ? 0.12 : 0.14),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFD6C8),
                    border: Border.all(
                      color: const Color(0xFFFFA98F),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9B73).withOpacity(0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    backgroundImage: avatar != null && avatar.isNotEmpty
                        ? NetworkImage(avatar)
                        : const NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80',
                          ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _profile!.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? Colors.white
                                    : LuminaColors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: _showEditNameDialog,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(isDark ? 0.12 : 0.62),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: isDark
                                    ? const Color(0xFFFED7AA)
                                    : const Color(0xFFEA580C),
                                size: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '学习目标：大学英语四级',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white.withOpacity(0.72)
                              : const Color(0xFF7C2D12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildProfileBadge(
                            Icons.workspace_premium_rounded,
                            '白银极光',
                            isDark,
                          ),
                          _buildProfileBadge(
                            Icons.local_fire_department_rounded,
                            '${_profile!.streakDays} 天连续',
                            isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                    child: _buildHeaderStat(
                        '学习天数', '${_profile!.totalDays}', isDark)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildHeaderStat(
                        '已掌握词', '${_profile!.totalWords}', isDark)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildHeaderStat(
                        '累计分钟', '${_profile!.totalMinutes}', isDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.white.withOpacity(0.66),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: isDark ? const Color(0xFFFED7AA) : const Color(0xFFEA580C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? Colors.white.withOpacity(0.62)
                  : const Color(0xFF7C2D12).withOpacity(0.72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBadge(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFFF97316).withOpacity(0.16)
            : const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: const Color(0xFFF97316).withOpacity(isDark ? 0.24 : 0.28),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark ? const Color(0xFFFED7AA) : const Color(0xFFEA580C),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFFED7AA) : const Color(0xFFEA580C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChartCard() {
    if (_profile == null) return const SizedBox.shrink();

    final radarValues = _calculateRadarValues(_profile!);
    final radarLabels = ['词汇力', '语法力', '发音力', '听力力', '阅读力'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '五维英语能力',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '基于您的学习天数 and 各专项训练进度评估',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: CustomPaint(
                    painter: RadarChartPainter(
                      values: radarValues,
                      labels: radarLabels,
                      strokeColor: const Color(0xFFF97316),
                      fillColor: const Color(0xFFF97316).withOpacity(0.18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsShelf() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '成就徽章柜',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '已解锁 ${_achievements.where((a) => a.unlocked).length}/${_achievements.length}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              final isUnlocked = achievement.unlocked;
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  color: isUnlocked
                      ? Colors.amber.shade50.withOpacity(0.6)
                      : Colors.grey.shade100,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _showAchievementDetail(achievement),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIcon(achievement.icon),
                            size: 32,
                            color: isUnlocked
                                ? Colors.amber.shade700
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            achievement.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? Colors.amber.shade900
                                  : Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAchievementDetail(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(
              _getIcon(achievement.icon),
              color: achievement.unlocked ? Colors.amber.shade700 : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(achievement.name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: achievement.unlocked
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                achievement.unlocked ? '已解锁' : '未解锁 (继续学习以解锁)',
                style: TextStyle(
                  color: achievement.unlocked
                      ? Colors.green.shade700
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: _profile?.name ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改昵称'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入新的昵称',
            border: OutlineInputBorder(),
          ),
          maxLength: 15,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                final navigator = Navigator.of(context);
                await userService.updateUserName(newName);
                navigator.pop();
                _loadUserData();
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    if (_profile == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '学习概览',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_today,
                  value: '${_profile!.totalDays}',
                  label: '学习天数',
                  color: const Color(0xFFF97316),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  value: '${_profile!.totalMinutes}',
                  label: '学习分钟',
                  color: LuminaColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearningProgress() {
    if (_profile == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '学习进度',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ProgressItem(
                    icon: Icons.translate,
                    title: '单词',
                    current: _profile!.totalWords,
                    goal: _profile!.wordsGoal,
                    color: const Color(0xFFF97316),
                  ),
                  const SizedBox(height: 20),
                  _ProgressItem(
                    icon: Icons.format_quote,
                    title: '句子',
                    current: _profile!.totalSentences,
                    goal: _profile!.sentencesGoal,
                    color: LuminaColors.success,
                  ),
                  const SizedBox(height: 20),
                  _ProgressItem(
                    icon: Icons.chat,
                    title: '对话',
                    current: _profile!.totalDialogues,
                    goal: _profile!.dialoguesGoal,
                    color: Colors.amber.shade700,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    if (_activities.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '最近活动',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _activities.length > 4 ? 4 : _activities.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, indent: 72, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor:
                        _getActivityColor(activity.type).withOpacity(0.15),
                    radius: 20,
                    child: Icon(
                      _getActivityIcon(activity.type),
                      color: _getActivityColor(activity.type),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    activity.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('${activity.count} 次练习'),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity.time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '快捷操作',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.favorite,
                  label: '收藏',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.history,
                  label: '历史',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReadingHistoryScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.emoji_events,
                  label: '成就',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AchievementScreen(),
                      ),
                    );
                    _loadUserData();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.bar_chart,
                  label: '统计',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PracticeStatsScreen(),
                      ),
                    );
                    _loadUserData();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.flag,
                  label: '目标',
                  onTap: () {
                    if (_profile == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalSettingScreen(
                          currentGoals: {
                            'words': _profile!.wordsGoal,
                            'sentences': _profile!.sentencesGoal,
                            'dialogues': _profile!.dialoguesGoal,
                            'dailyMinutes': 30,
                          },
                          onGoalsSaved: (goals) async {
                            final messenger = ScaffoldMessenger.of(context);
                            await userService.updateUserGoals(
                              wordsGoal: goals['words'] ?? 500,
                              sentencesGoal: goals['sentences'] ?? 200,
                              dialoguesGoal: goals['dialogues'] ?? 50,
                            );
                            _loadUserData();
                            messenger.showSnackBar(
                              const SnackBar(content: Text('目标已保存')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.error_outline,
                  label: '错题',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WrongAnswersScreen(),
                      ),
                    );
                    _loadUserData();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'word':
        return Icons.translate;
      case 'sentence':
        return Icons.format_quote;
      case 'article':
        return Icons.menu_book;
      case 'dialogue':
        return Icons.chat;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'word':
        return Colors.blue;
      case 'sentence':
        return Colors.green;
      case 'article':
        return Colors.purple;
      case 'dialogue':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '设置',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('深色模式'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (val) {
                  Navigator.pop(ctx);
                  widget.onThemeChanged(val);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('字体大小'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(ctx);
                _showFontSizeDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('通知设置'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                Navigator.pop(ctx);
                final navigator = Navigator.of(context);
                final settings = await userService.getSettings();
                final notifySettings = {
                  'dailyReminder': settings['dailyReminder'] ?? true,
                  'streakReminder': settings['streakReminder'] ?? true,
                  'achievementNotification':
                      settings['achievementNotification'] ?? true,
                  'practiceReminder': settings['practiceReminder'] ?? false,
                  'reminderTime': settings['reminderTime'] ?? '08:00',
                };
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen(
                      notificationSettings: notifySettings,
                      onSettingsSaved: (newSettings) async {
                        final messengerOuter = ScaffoldMessenger.of(context);
                        final settings = await userService.getSettings();
                        settings.addAll(newSettings);
                        await userService.updateSettings(settings);
                        messengerOuter.showSnackBar(
                          const SnackBar(content: Text('通知设置已保存')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.red),
              title: const Text('清理本地缓存', style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () {
                Navigator.pop(ctx);
                _clearCache();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) async {
    final settings = await userService.getSettings();
    final currentSize = settings['fontSize'] ?? 'medium';

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择字体大小'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption(context, 'small', '小', currentSize),
            _buildFontSizeOption(context, 'medium', '中 (默认)', currentSize),
            _buildFontSizeOption(context, 'large', '大', currentSize),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(
      BuildContext context, String key, String label, String currentSize) {
    final isSelected = key == currentSize;
    return ListTile(
      title: Text(label,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing:
          isSelected ? const Icon(Icons.check, color: Color(0xFFF97316)) : null,
      onTap: () async {
        final navigator = Navigator.of(context);
        final messenger = ScaffoldMessenger.of(context);
        await userService.updateSetting('fontSize', key);
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(content: Text('已设置字体为: $label')),
        );
      },
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清理缓存'),
        content: const Text('确定要清理所有本地学习缓存并重置数据吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              await storageService.clearAll();
              navigator.pop();
              _loadUserData();
              messenger.showSnackBar(
                const SnackBar(content: Text('已成功清理所有本地数据')),
              );
            },
            child: const Text('确定重置', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color strokeColor;
  final Color fillColor;

  RadarChartPainter({
    required this.values,
    required this.labels,
    required this.strokeColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 * 0.7;

    final Paint webPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final int websCount = 4;
    final int sidesCount = 5;

    // Draw background concentric polygons
    for (int w = 1; w <= websCount; w++) {
      final currentRadius = radius * (w / websCount);
      final Path path = Path();
      for (int i = 0; i < sidesCount; i++) {
        final angle = (i * 2 * pi / sidesCount) - pi / 2;
        final x = centerX + currentRadius * cos(angle);
        final y = centerY + currentRadius * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, webPaint);
    }

    // Draw axis lines and labels
    for (int i = 0; i < sidesCount; i++) {
      final angle = (i * 2 * pi / sidesCount) - pi / 2;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      canvas.drawLine(Offset(centerX, centerY), Offset(x, y), webPaint);

      // Label text painter
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${labels[i]}\n${values[i].toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final labelRadius = radius + 15;
      final labelX = centerX + labelRadius * cos(angle) - textPainter.width / 2;
      final labelY =
          centerY + labelRadius * sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(labelX, labelY));
    }

    // Draw data polygon
    final Path dataPath = Path();
    final Paint dataFillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final Paint dataStrokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < sidesCount; i++) {
      final currentVal = values[i].clamp(0.0, 100.0);
      final currentRadius = radius * (currentVal / 100.0);
      final angle = (i * 2 * pi / sidesCount) - pi / 2;
      final x = centerX + currentRadius * cos(angle);
      final y = centerY + currentRadius * sin(angle);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataFillPaint);
    canvas.drawPath(dataPath, dataStrokePaint);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int current;
  final int goal;
  final Color color;

  const _ProgressItem({
    required this.icon,
    required this.title,
    required this.current,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / goal;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '$current / $goal',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon,
                  size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
