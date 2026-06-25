import 'package:flutter/material.dart';
import '../widgets/modern_ui.dart';
import '../services/theme_service.dart';
import '../mock/mock_articles.dart';
import '../models/article.dart';
import '../main.dart';
import 'wrong_answers_screen.dart';
import 'favorites_screen.dart';
import 'reading_history_screen.dart';
import 'word_practice_screen.dart';
import 'listening_practice_screen.dart';
import 'sentence_practice_screen.dart';
import 'article_detail_screen.dart';

class DailyTab extends StatefulWidget {
  const DailyTab({super.key});

  @override
  State<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  final int _totalSteps = 4;

  int get _completedSteps {
    int count = 0;
    if (storageService.isDailyStepCompleted(0)) count++;
    if (storageService.isDailyStepCompleted(1)) count++;
    if (storageService.isDailyStepCompleted(2)) count++;
    if (storageService.isDailyStepCompleted(3)) count++;
    return count;
  }

  int get _streakDays {
    final days = storageService.getStreakDays();
    return days == 0 ? 7 : days;
  }

  int get _pendingReviewCount {
    return storageService.getWrongAnswers().where((item) => item['reviewed'] != true).length;
  }

  bool isCompleted(int i) => storageService.isDailyStepCompleted(i);

  bool isActive(int i) {
    if (isCompleted(i)) return false;
    if (i == 0) return true;
    for (int j = 0; j < i; j++) {
      if (!isCompleted(j)) return false;
    }
    return true;
  }

  bool isLocked(int i) {
    if (isCompleted(i)) return false;
    if (isActive(i)) return false;
    return true;
  }

  void _startPractice(int step) {
    Widget targetScreen;
    if (step == 0) {
      targetScreen = WordPracticeScreen(
        onCompleted: () {
          storageService.setDailyStepCompleted(0, true);
        },
      );
    } else if (step == 1) {
      targetScreen = ListeningPracticeScreen(
        onCompleted: () {
          storageService.setDailyStepCompleted(1, true);
        },
      );
    } else if (step == 2) {
      targetScreen = SentencePracticeScreen(
        onCompleted: () {
          storageService.setDailyStepCompleted(2, true);
        },
      );
    } else {
      final articles = MockArticles.getArticles();
      final sampleArticle = articles.isNotEmpty
          ? articles.first
          : Article(
              id: '1',
              title: 'The Benefits of Reading English Books',
              content: 'Reading books in English...',
              difficulty: 'Intermediate',
              tags: ['Reading'],
              createdAt: DateTime.now(),
              readTime: 5,
            );
      targetScreen = ArticleDetailScreen(
        article: sampleArticle,
        onCompleted: () {
          storageService.setDailyStepCompleted(3, true);
        },
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    ).then((_) {
      setState(() {});
    });
  }

  void _resumeLearning() {
    int activeStep = -1;
    for (int i = 0; i < 4; i++) {
      if (!storageService.isDailyStepCompleted(i)) {
        activeStep = i;
        break;
      }
    }

    if (activeStep == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恭喜你！今日学习任务已全部完成！ 🎉'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _startPractice(activeStep);
  }

  void _speakQuote() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔊 正在播放每日金句原声朗读...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 24),
              _buildDailyCabinCard(isDark),
              if (_pendingReviewCount > 0) ...[
                const SizedBox(height: 16),
                _buildReviewAlertBanner(isDark),
              ],
              const SizedBox(height: 24),
              _buildDailyQuoteCard(isDark),
              const SizedBox(height: 24),
              _buildQuickActionsGrid(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 顶部头部区域
  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        // 用户头像
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF2B3035) : const Color(0xFFE9ECEF),
              width: 1.5,
            ),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80'),
          ),
        ),
        const SizedBox(width: 14),
        // 欢迎词与学习目标
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '你好，Alex！',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '学习目标：大学英语四级',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        // 打卡火苗
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF76707).withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Color(0xFFF76707),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '连续打卡 $_streakDays天',
                style: const TextStyle(
                  color: Color(0xFFF76707),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. 每日学习任务舱
  Widget _buildDailyCabinCard(bool isDark) {
    final progress = _completedSteps / _totalSteps;

    return ModernCard(
      padding: const EdgeInsets.all(24),
      gradientColors: isDark ? null : AppColors.gradientPrimary,
      borderRadius: 16,
      child: Column(
        children: [
          Row(
            children: [
              // 进度圆环
              ProgressRing(
                progress: progress,
                size: 80,
                strokeWidth: 6,
                progressColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '已完成 $_completedSteps/$_totalSteps',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // 四大步骤任务列表
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    final titles = ['1. 每日单词', '2. 每日听力', '3. 每日句子', '4. 每日文章'];
                    final completed = isCompleted(index);
                    final active = isActive(index);
                    final locked = isLocked(index);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (locked) {
                                int activeIdx = 0;
                                for (int i = 0; i < 4; i++) {
                                  if (isActive(i)) {
                                    activeIdx = i;
                                    break;
                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('请按顺序完成今日任务。当前应进行：${titles[activeIdx]}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                _startPractice(index);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              child: _buildStepRow(
                                titles[index],
                                completed,
                                isDark,
                                isActive: active,
                                isLocked: locked,
                              ),
                            ),
                          ),
                        ),
                        if (index < 3) const SizedBox(height: 4),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 胶囊大按钮
          ModernButton(
            text: _completedSteps == _totalSteps ? '今日已完成，点此复习' : '继续今日学习',
            width: double.infinity,
            onPressed: _completedSteps == _totalSteps
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WrongAnswersScreen()),
                    ).then((_) {
                      setState(() {});
                    });
                  }
                : _resumeLearning,
            gradientColors: isDark ? AppColors.gradientPrimary : null,
          ),
        ],
      ),
    );
  }

  // 任务舱步骤项
  Widget _buildStepRow(String title, bool isCompleted, bool isDark, {bool isActive = false, bool isLocked = false}) {
    Color textColor = Colors.white;
    Widget statusIcon = const SizedBox();

    if (isCompleted) {
      textColor = Colors.white.withOpacity(0.9);
      statusIcon = const Icon(Icons.check_circle, color: Colors.white, size: 16);
    } else if (isActive) {
      textColor = Colors.white;
      statusIcon = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          '进行中',
          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
    } else if (isLocked) {
      textColor = Colors.white.withOpacity(0.5);
      statusIcon = Icon(Icons.lock, color: Colors.white.withOpacity(0.5), size: 14);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: (isActive || isCompleted) ? FontWeight.w600 : FontWeight.normal,
            color: textColor,
          ),
        ),
        statusIcon,
      ],
    );
  }

  // 3. 复习警示条
  Widget _buildReviewAlertBanner(bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WrongAnswersScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2514) : const Color(0xFFFFF9DB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF664D03) : const Color(0xFFFFEC99),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.flash_on,
              color: Color(0xFFF76707),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '温故知新：还有 $_pendingReviewCount 个单词需要复习，点击立即消灭！',
                style: TextStyle(
                  color: isDark ? const Color(0xFFFFD43B) : const Color(0xFFE67E22),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? const Color(0xFFFFD43B) : const Color(0xFFE67E22),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // 4. 每日金句
  Widget _buildDailyQuoteCard(bool isDark) {
    return ModernCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.format_quote, color: AppColors.primary, size: 20),
                  SizedBox(width: 6),
                  Text(
                    '每日金句',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.volume_up, color: AppColors.primary, size: 22),
                onPressed: _speakQuote,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'The limits of my language mean the limits of my world.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '语言的边界，就是世界的边界。',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 5. 快捷工具网格
  Widget _buildQuickActionsGrid(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '学习工具箱',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                Icons.book,
                '生词本',
                '34个生词',
                const Color(0xFF0C8599),
                isDark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                Icons.rule,
                '错题集',
                '5道错题',
                const Color(0xFFF76707),
                isDark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WrongAnswersScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                Icons.calendar_month,
                '打卡日历',
                '学习记录',
                const Color(0xFF2B8A3E),
                isDark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReadingHistoryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String label, String value, Color color, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1D20) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2B3035) : const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
