import 'package:flutter/material.dart';
import 'article_list_screen.dart';
import 'practice_tab.dart';
import 'dialogue_tab.dart';
import 'achievement_screen.dart';
import 'goal_setting_screen.dart';
import 'reading_history_screen.dart';
import 'favorites_screen.dart';
import 'notification_settings_screen.dart';
import 'wrong_answers_screen.dart';
import 'practice_stats_screen.dart';
import '../services/theme_service.dart';

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

  final List<Widget> _screens = [
    const ReadingTab(),
    const PracticeTab(),
    const DialogueTab(),
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
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '阅读'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '练习'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '对话'),
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
  final Map<String, dynamic> _userStats = {
    'totalDays': 15,
    'totalWords': 256,
    'totalSentences': 89,
    'totalDialogues': 12,
    'streakDays': 5,
    'totalMinutes': 320,
  };

  final List<Map<String, dynamic>> _recentActivity = [
    {'type': 'word', 'title': '单词练习', 'count': 20, 'time': '今天'},
    {'type': 'sentence', 'title': '句子练习', 'count': 10, 'time': '今天'},
    {'type': 'article', 'title': '阅读文章', 'count': 2, 'time': '昨天'},
    {'type': 'dialogue', 'title': '对话练习', 'count': 1, 'time': '昨天'},
  ];

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatsOverview(),
            _buildLearningProgress(),
            _buildRecentActivity(),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientPrimary,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '英语学习者',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${_userStats['streakDays']} 天连续学习',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatColumn(value: '${_userStats['totalDays']}', label: '学习天数'),
              Container(
                  width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
              _StatColumn(value: '${_userStats['totalWords']}', label: '单词数'),
              Container(
                  width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
              _StatColumn(value: '${_userStats['totalMinutes']}', label: '分钟'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学习概览',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_today,
                  value: '${_userStats['totalDays']}',
                  label: '学习天数',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  value: '${_userStats['totalMinutes']}',
                  label: '学习分钟',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearningProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学习进度',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
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
                _ProgressItem(
                  icon: Icons.translate,
                  title: '单词',
                  current: _userStats['totalWords'],
                  goal: 500,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                _ProgressItem(
                  icon: Icons.format_quote,
                  title: '句子',
                  current: _userStats['totalSentences'],
                  goal: 200,
                  color: AppColors.accent,
                ),
                const SizedBox(height: 20),
                _ProgressItem(
                  icon: Icons.chat,
                  title: '对话',
                  current: _userStats['totalDialogues'],
                  goal: 50,
                  color: const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '最近活动',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
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
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentActivity.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final activity = _recentActivity[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor:
                        _getActivityColor(activity['type']).withOpacity(0.15),
                    radius: 20,
                    child: Icon(
                      _getActivityIcon(activity['type']),
                      color: _getActivityColor(activity['type']),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    activity['title'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('${activity['count']} 次练习'),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity['time'],
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
          const Text(
            '快捷操作',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AchievementScreen(),
                      ),
                    );
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PracticeStatsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.flag,
                  label: '目标',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalSettingScreen(
                          currentGoals: const {
                            'words': 500,
                            'sentences': 200,
                            'dialogues': 50,
                            'dailyMinutes': 30
                          },
                          onGoalsSaved: (goals) {
                            ScaffoldMessenger.of(context).showSnackBar(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WrongAnswersScreen(),
                      ),
                    );
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
                onChanged: widget.onThemeChanged,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('字体大小'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showFontSizeDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('通知设置'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen(
                      notificationSettings: const {
                        'dailyReminder': true,
                        'streakReminder': true,
                        'achievementNotification': true,
                        'practiceReminder': false,
                        'reminderTime': '08:00',
                      },
                      onSettingsSaved: (settings) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('通知设置已保存')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('关于我们'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择字体大小'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('小'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('小字体');
              },
            ),
            ListTile(
              title: const Text('中'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('大'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('大字体');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 开发中...')),
    );
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

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
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
