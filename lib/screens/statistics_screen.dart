import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Map<String, dynamic> _stats = {
    'totalDays': 15,
    'totalWords': 256,
    'totalSentences': 89,
    'totalDialogues': 12,
    'totalMinutes': 320,
    'currentStreak': 5,
    'longestStreak': 10,
  };

  final List<Map<String, dynamic>> _weeklyData = [
    {'day': '周一', 'words': 20, 'sentences': 10},
    {'day': '周二', 'words': 15, 'sentences': 8},
    {'day': '周三', 'words': 25, 'sentences': 12},
    {'day': '周四', 'words': 18, 'sentences': 9},
    {'day': '周五', 'words': 22, 'sentences': 11},
    {'day': '周六', 'words': 30, 'sentences': 15},
    {'day': '周日', 'words': 28, 'sentences': 14},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习统计'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildWeeklyChart(),
            const SizedBox(height: 24),
            _buildStreakSection(),
            const SizedBox(height: 24),
            _buildCategoryStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '概览',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.calendar_today,
                value: '${_stats['totalDays']}',
                label: '学习天数',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.timer,
                value: '${_stats['totalMinutes']}',
                label: '总学习分钟',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    final maxValue = _weeklyData
        .map((d) => d['words'] as int)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '本周学习数据',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _LegendItem(color: Colors.blue, label: '单词'),
                    _LegendItem(color: Colors.green, label: '句子'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _weeklyData.map((data) {
                      final wordHeight = (data['words'] / maxValue) * 120;
                      final sentenceHeight =
                          (data['sentences'] / maxValue) * 120;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${data['words']}',
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 12,
                                    height: wordHeight,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    width: 12,
                                    height: sentenceHeight,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['day'],
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '连续学习',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StreakCard(
                icon: Icons.local_fire_department,
                value: '${_stats['currentStreak']}',
                label: '当前连续',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StreakCard(
                icon: Icons.emoji_events,
                value: '${_stats['longestStreak']}',
                label: '最长连续',
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryStats() {
    final categories = [
      {
        'name': '单词',
        'value': _stats['totalWords'],
        'goal': 500,
        'color': Colors.blue
      },
      {
        'name': '句子',
        'value': _stats['totalSentences'],
        'goal': 200,
        'color': Colors.green
      },
      {
        'name': '对话',
        'value': _stats['totalDialogues'],
        'goal': 50,
        'color': Colors.purple
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '分类统计',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...categories.map((cat) {
          final progress = (cat['value'] as int) / (cat['goal'] as int);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CategoryProgress(
              name: cat['name'] as String,
              value: cat['value'] as int,
              goal: cat['goal'] as int,
              color: cat['color'] as Color,
              progress: progress.clamp(0.0, 1.0),
            ),
          );
        }),
      ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StreakCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value 天',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
                Text(label, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  final String name;
  final int value;
  final int goal;
  final Color color;
  final double progress;

  const _CategoryProgress({
    required this.name,
    required this.value,
    required this.goal,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$value / $goal',
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% 达成',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
