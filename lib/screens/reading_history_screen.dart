import 'package:flutter/material.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  final List<Map<String, dynamic>> _history = [
    {
      'article': _SampleArticle(
          id: '1',
          title: 'The Benefits of Reading English Books',
          difficulty: 'Intermediate',
          tags: ['Reading', 'Vocabulary'],
          readTime: 5,
          content: '',
          createdAt: DateTime.now()),
      'readAt': DateTime.now().subtract(const Duration(hours: 2)),
      'progress': 100
    },
    {
      'article': _SampleArticle(
          id: '2',
          title: 'How to Improve Your English Speaking',
          difficulty: 'Beginner',
          tags: ['Speaking', 'Practice'],
          readTime: 7,
          content: '',
          createdAt: DateTime.now()),
      'readAt': DateTime.now().subtract(const Duration(days: 1)),
      'progress': 80
    },
    {
      'article': _SampleArticle(
          id: '3',
          title: 'Advanced English Grammar Tips',
          difficulty: 'Advanced',
          tags: ['Grammar', 'Advanced'],
          readTime: 10,
          content: '',
          createdAt: DateTime.now()),
      'readAt': DateTime.now().subtract(const Duration(days: 2)),
      'progress': 50
    },
    {
      'article': _SampleArticle(
          id: '4',
          title: 'Daily English Phrases for Communication',
          difficulty: 'Beginner',
          tags: ['Speaking', 'Phrases'],
          readTime: 6,
          content: '',
          createdAt: DateTime.now()),
      'readAt': DateTime.now().subtract(const Duration(days: 3)),
      'progress': 100
    },
    {
      'article': _SampleArticle(
          id: '5',
          title: 'Understanding English Idioms',
          difficulty: 'Intermediate',
          tags: ['Vocabulary', 'Idioms'],
          readTime: 8,
          content: '',
          createdAt: DateTime.now()),
      'readAt': DateTime.now().subtract(const Duration(days: 5)),
      'progress': 100
    },
  ];

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${difference.inDays ~/ 7}周前';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读历史'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'clear', child: Text('清空历史')),
            ],
          ),
        ],
      ),
      body: _history.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final article = item['article'] as _SampleArticle;
                final readAt = item['readAt'] as DateTime;
                final progress = item['progress'] as int;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('打开: ${article.title}')),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(article.difficulty)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  article.difficulty,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        _getDifficultyColor(article.difficulty),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: article.tags.map<Widget>((tag) {
                              return Chip(
                                label: Text(tag,
                                    style: const TextStyle(fontSize: 10)),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                '${article.readTime}分钟',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                _getTimeAgo(readAt),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const Spacer(),
                              Text(
                                progress == 100 ? '已完成' : '$progress%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: progress == 100
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress == 100 ? Colors.green : Colors.orange,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            '暂无阅读历史',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '开始阅读文章来记录你的学习轨迹',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空历史'),
        content: const Text('确定要清空所有阅读历史吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('历史已清空')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _SampleArticle {
  final String id;
  final String title;
  final String difficulty;
  final List<String> tags;
  final int readTime;
  final String content;
  final DateTime createdAt;

  _SampleArticle({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.tags,
    required this.readTime,
    required this.content,
    required this.createdAt,
  });
}
