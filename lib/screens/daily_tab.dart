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
import '../services/audio_service.dart';
import '../models/user.dart';

class DailyTab extends StatefulWidget {
  final bool isActive;
  const DailyTab({super.key, this.isActive = false});

  @override
  State<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  UserProfile? _profile;
  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void didUpdateWidget(covariant DailyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await userService.getUserProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
    }
  }

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
    return storageService
        .getWrongAnswers()
        .where((item) => item['reviewed'] != true)
        .length;
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
      _loadUserProfile();
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

  void _speakQuote(String quoteText) {
    AudioService.instance.speak(quoteText);
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
              const SizedBox(height: 128), // Space for floating bottom nav
            ],
          ),
        ),
      ),
    );
  }

  // 1. 顶部头部区域
  Widget _buildHeader(bool isDark) {
    final displayName = _profile?.name ?? 'Alex';
    final userAvatar = _profile?.avatar;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2.5),
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
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            backgroundImage: userAvatar != null && userAvatar.isNotEmpty
                ? NetworkImage(userAvatar)
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80'),
          ),
        ),
        const SizedBox(width: 16),
        // 欢迎词与学习目标
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $displayName! 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '学习目标：大学英语四级',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        // 立体打卡火苗
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB020), Color(0xFFF97316)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              // 3D 实体偏置底座
              const BoxShadow(
                color: Color(0xFFC2410C),
                offset: Offset(0, 3.5),
                blurRadius: 0,
              ),
              // 软阴影
              BoxShadow(
                color: const Color(0xFFF97316).withOpacity(0.28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_streakDays 天',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. 每日学习任务舱
  Widget _buildDailyCabinCard(bool isDark) {
    final progress = _completedSteps / _totalSteps;

    // 渐变色：浅色模式下使用干净暖橘，深色模式为卡片深灰
    final gradientColors =
        isDark ? null : const [Color(0xFFFFC857), Color(0xFFF97316)];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              )
            : null,
        color: gradientColors == null ? AppColors.darkCard : null,
        borderRadius: BorderRadius.circular(28), // 特大圆角
        border: Border.all(
          color: isDark ? const Color(0xFF2B3035) : const Color(0xFFFFE4B5),
          width: 1.5,
        ),
        boxShadow: [
          // 3D 实体偏置底座
          BoxShadow(
            color: isDark ? const Color(0xFF1E2124) : const Color(0xFFC2410C),
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
          // 软阴影
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : const Color(0xFFF97316).withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 进度圆环
              ProgressRing(
                progress: progress,
                size: 84,
                strokeWidth: 8,
                progressColor: isDark ? const Color(0xFFF97316) : Colors.white,
                backgroundColor: isDark
                    ? Colors.grey.shade800
                    : Colors.white.withOpacity(0.25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$_completedSteps/$_totalSteps',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
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
                                    content: Text(
                                        '请按顺序完成今日任务。当前应进行：${titles[activeIdx]}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                _startPractice(index);
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: _buildStepRowCard(
                              titles[index],
                              completed,
                              isDark,
                              isActive: active,
                              isLocked: locked,
                            ),
                          ),
                        ),
                        if (index < 3) const SizedBox(height: 6),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 3D 胶囊大按钮
          ModernButton(
            text: _completedSteps == _totalSteps ? '今日已完成，点此复习' : '继续今日学习',
            width: double.infinity,
            gradientColors:
                isDark ? null : const [Color(0xFFFFB020), Color(0xFFF97316)],
            backgroundColor: isDark ? null : const Color(0xFFF97316),
            onPressed: _completedSteps == _totalSteps
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WrongAnswersScreen()),
                    ).then((_) {
                      setState(() {});
                    });
                  }
                : _resumeLearning,
          ),
        ],
      ),
    );
  }

  // 任务舱步骤项
  Widget _buildStepRowCard(String title, bool isCompleted, bool isDark,
      {bool isActive = false, bool isLocked = false}) {
    Color cardColor = Colors.white.withOpacity(0.15);
    Color borderColor = Colors.white.withOpacity(0.2);
    Color textColor = Colors.white;
    Widget statusIcon = const SizedBox();

    if (isDark) {
      cardColor = const Color(0xFF1E2124);
      borderColor = const Color(0xFF2B3035);
      textColor = Colors.white;
    }

    if (isCompleted) {
      if (!isDark) {
        cardColor = Colors.white.withOpacity(0.3);
        textColor = Colors.white;
      }
      statusIcon = const Icon(Icons.check_circle,
          color: Color(0xFF58CC02), size: 18); // 经典的 Duolingo 绿色对勾
    } else if (isActive) {
      if (!isDark) {
        cardColor = Colors.white;
        borderColor = Colors.white;
        textColor = const Color(0xFFEA580C);
      }
      statusIcon = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFFF97316).withOpacity(0.20)
              : const Color(0xFFFFEDD5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '进行中',
          style: TextStyle(
            color: const Color(0xFFEA580C),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    } else if (isLocked) {
      if (!isDark) {
        textColor = Colors.white.withOpacity(0.62);
        cardColor = Colors.white.withOpacity(0.08);
      }
      statusIcon = Icon(
        Icons.lock,
        color: isDark ? Colors.white30 : Colors.white.withOpacity(0.58),
        size: 14,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  (isActive || isCompleted) ? FontWeight.w800 : FontWeight.bold,
              color: textColor,
            ),
          ),
          statusIcon,
        ],
      ),
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
          color: isDark ? const Color(0xFF2A1A12) : const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.flash_on,
              color: Color(0xFFF97316),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '温故知新：还有 $_pendingReviewCount 个单词需要复习，点击立即消灭！',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFFED7AA)
                      : const Color(0xFFEA580C),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? const Color(0xFFFED7AA) : const Color(0xFFEA580C),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // 4. 每日金句
  Widget _buildDailyQuoteCard(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI 吉祥物头像 (3D 风格)
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB020), Color(0xFFF97316)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF97316).withOpacity(0.24),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.smart_toy, // 可爱的机器人小助手
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 金句对话气泡
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF2B3035) : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              boxShadow: [
                // 3D 实体偏置底座
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF1E2124)
                      : const Color(0xFFD1D5DB),
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: Color(0xFFF97316),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '每日金句',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.volume_up,
                        color: Color(0xFFF97316),
                        size: 20,
                      ),
                      onPressed: () => _speakQuote(
                          'The limits of my language mean the limits of my world.'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'The limits of my language mean the limits of my world.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '语言的边界，就是世界的边界。',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 5. 快捷工具网格
  Widget _buildQuickActionsGrid(BuildContext context, bool isDark) {
    final favoriteCount = storageService.getFavorites().length;
    final wrongAnswersCount = storageService.getWrongAnswers().length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '学习工具箱',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                Icons.book,
                '生词本',
                '$favoriteCount个单词',
                const Color(0xFF20C997), // 翠绿
                isDark ? const Color(0xFF163229) : const Color(0xFFE8F9F5),
                isDark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesScreen()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                Icons.rule,
                '错题集',
                '$wrongAnswersCount道错题',
                const Color(0xFFFF4E73), // 亮粉
                isDark ? const Color(0xFF3B1820) : const Color(0xFFFFF0F3),
                isDark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WrongAnswersScreen()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                Icons.calendar_month,
                '打卡日历',
                '学习记录',
                const Color(0xFFFF9E1B), // 活力橙黄
                isDark ? const Color(0xFF332310) : const Color(0xFFFFF9DB),
                isDark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReadingHistoryScreen()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String label,
    String value,
    Color brandColor,
    Color bgBackgroundColor,
    bool isDark,
    VoidCallback onTap,
  ) {
    // 3D 边框色
    final borderColor = isDark
        ? const Color(0xFF2B3035)
        : HSLColor.fromColor(bgBackgroundColor)
            .withLightness(
                (HSLColor.fromColor(bgBackgroundColor).lightness - 0.08)
                    .clamp(0.0, 1.0))
            .toColor();

    final bottomColor = isDark
        ? const Color(0xFF1E2124)
        : HSLColor.fromColor(bgBackgroundColor)
            .withLightness(
                (HSLColor.fromColor(bgBackgroundColor).lightness - 0.16)
                    .clamp(0.0, 1.0))
            .toColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          boxShadow: [
            // 3D 实体偏置底座
            BoxShadow(
              color: bottomColor,
              offset: const Offset(0, 3.5),
              blurRadius: 0,
            ),
            // 软阴影
            BoxShadow(
              color: isDark ? Colors.black26 : brandColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: brandColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? Colors.white
                    : HSLColor.fromColor(brandColor)
                        .withLightness(0.3)
                        .toColor(),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : HSLColor.fromColor(brandColor)
                        .withLightness(0.4)
                        .toColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
