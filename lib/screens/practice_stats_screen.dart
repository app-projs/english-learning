import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class PracticeStatsScreen extends StatefulWidget {
  const PracticeStatsScreen({super.key});

  @override
  State<PracticeStatsScreen> createState() => _PracticeStatsScreenState();
}

class _PracticeStatsScreenState extends State<PracticeStatsScreen> {
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _weeklyData = [];
  StorageService? _storageService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    _storageService = await StorageService.getInstance();
    final stats = _storageService!.getPracticeStats();
    final weeklyData = _storageService!.getWeeklyPracticeData();
    setState(() {
      _stats = stats;
      _weeklyData = weeklyData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('练习统计'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCard(),
                  const SizedBox(height: 24),
                  _buildWeeklyChart(),
                  const SizedBox(height: 24),
                  _buildCategoryStats(),
                  const SizedBox(height: 24),
                  _buildAccuracyCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCard() {
    final total = (_stats['correctCount'] ?? 0) + (_stats['wrongCount'] ?? 0);
    final correct = _stats['correctCount'] ?? 0;
    final accuracy =
        total > 0 ? (correct / total * 100).toStringAsFixed(1) : '0';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '练习概览',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: '总练习次数',
                  value: '${_stats['totalPracticeCount'] ?? 0}',
                  icon: Icons.replay,
                  color: Colors.blue,
                ),
                _StatItem(
                  label: '正确题数',
                  value: '$correct',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                _StatItem(
                  label: '错误题数',
                  value: '${_stats['wrongCount'] ?? 0}',
                  icon: Icons.cancel,
                  color: Colors.red,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: '总练习时长',
                  value: '${_stats['totalTimeMinutes'] ?? 0}分钟',
                  icon: Icons.timer,
                  color: Colors.orange,
                ),
                _StatItem(
                  label: '正确率',
                  value: '$accuracy%',
                  icon: Icons.percent,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final maxTotal = _weeklyData.fold<int>(
      1,
      (max, item) => (item['total'] as int) > max ? item['total'] as int : max,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '本周练习趋势',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _weeklyData.map((data) {
                  final date = DateTime.parse(data['date']);
                  final dayNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                  final dayIndex = (date.weekday - 1) % 7;
                  final isToday = _isToday(date);
                  final height = (data['total'] as int) / maxTotal * 120;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${data['total']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.blue : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: height.clamp(4.0, 120.0),
                        decoration: BoxDecoration(
                          color: isToday ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dayNames[dayIndex],
                        style: TextStyle(
                          fontSize: 12,
                          color: isToday ? Colors.blue : Colors.grey,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildCategoryStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '分类统计',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _CategoryProgress(
              icon: Icons.translate,
              label: '单词练习',
              count: _stats['wordsPracticed'] ?? 0,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _CategoryProgress(
              icon: Icons.format_quote,
              label: '句子练习',
              count: _stats['sentencesPracticed'] ?? 0,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _CategoryProgress(
              icon: Icons.chat,
              label: '对话练习',
              count: _stats['dialoguesPracticed'] ?? 0,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _CategoryProgress(
              icon: Icons.headphones,
              label: '听力练习',
              count: _stats['listeningPracticed'] ?? 0,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyCard() {
    final total = (_stats['correctCount'] ?? 0) + (_stats['wrongCount'] ?? 0);
    final correct = _stats['correctCount'] ?? 0;
    final wrong = _stats['wrongCount'] ?? 0;
    final accuracy = total > 0 ? correct / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '正确率分析',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: accuracy,
                              strokeWidth: 10,
                              backgroundColor: Colors.red.shade100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getAccuracyColor(accuracy),
                              ),
                            ),
                            Text(
                              '${(accuracy * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '总体正确率',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AccuracyItem(
                        label: '正确',
                        count: correct,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _AccuracyItem(
                        label: '错误',
                        count: wrong,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      _AccuracyItem(
                        label: '总计',
                        count: total,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.orange;
    return Colors.red;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _CategoryProgress({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: count / 100,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AccuracyItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _AccuracyItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
