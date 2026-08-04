import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/widgets/modern_ui.dart';
import '../../../core/theme/theme_service.dart';
import '../../../features/article/mock/mock_articles.dart';
import '../../../features/article/models/article.dart';
import '../../../main.dart';
import '../../../features/review/screens/wrong_answers_screen.dart';
import '../../../features/favorites/screens/favorites_screen.dart';
import '../../../features/article/screens/reading_history_screen.dart';
import '../../../features/word/screens/word_practice_screen.dart';
import '../../../features/listening/screens/listening_practice_screen.dart';
import '../../../features/sentence/screens/sentence_practice_screen.dart';
import '../../../features/article/screens/article_detail_screen.dart';
import '../../../features/review/screens/completion_congratulation_screen.dart';
import '../../../core/services/audio_service.dart';
import '../../../features/word/models/word.dart';
import '../../../features/word/mock/mock_words.dart';
import '../../../core/services/storage_service.dart';
import '../../../features/profile/models/user.dart';
import '../../../features/review/screens/smart_review_screen.dart';

class DailyTab extends StatefulWidget {
  final bool isActive;
  const DailyTab({super.key, this.isActive = false});

  @override
  State<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  UserProfile? _profile;
  final int _totalSteps = 4;
  late Word _wordOfDay;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _pickWordOfDay();
  }

  @override
  void didUpdateWidget(covariant DailyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadUserProfile();
    }
  }

  void _pickWordOfDay() {
    final allWords = MockWords.getWords();
    final daySeed = DateTime.now().year * 10000 +
        DateTime.now().month * 100 +
        DateTime.now().day;
    final index = daySeed % allWords.length;
    _wordOfDay = allWords[index];
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
    return storageService.getUnifiedReviewQueue().length;
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

  void _showModuleCompletionScreen(String moduleTitle, {int earnedLp = 50}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletionCongratulationScreen(
          moduleTitle: moduleTitle,
          earnedLp: earnedLp,
          streakDays: 7,
        ),
      ),
    );
  }

  void _startPractice(int step) {
    Widget targetScreen;
    if (step == 0) {
      targetScreen = WordPracticeScreen(
        onCompleted: () {
          storageService.setDailyStepCompleted(0, true);
          _showModuleCompletionScreen('单词记忆');
        },
      );
    } else if (step == 1) {
      targetScreen = ListeningPracticeScreen(
        onCompleted: () {
          storageService.setDailyStepCompleted(1, true);
          _showModuleCompletionScreen('听力理解');
        },
      );
    } else if (step == 2) {
      targetScreen = SentencePracticeScreen(
        onCompleted: () {
          storageService.setDailyStepCompleted(2, true);
          _showModuleCompletionScreen('长难句剖析');
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
          _showModuleCompletionScreen('文章精读');
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
      _showModuleCompletionScreen('今日全套大满贯', earnedLp: 200);
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
              _buildWordOfDayCard(isDark),
              const SizedBox(height: 24),
              _buildDailyQuoteCard(isDark),
              const SizedBox(height: 24),
              _buildQuickActionsGrid(context, isDark),
              const SizedBox(height: 128),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 顶部头部区域
  Widget _buildWordOfDayCard(bool isDark) {
    return _WordFlipCard(
      word: _wordOfDay,
      isDark: isDark,
      storageService: storageService,
    );
  }

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
                color: const Color(0xFFFF9B73).withValues(alpha: 0.20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildAvatarWidget(userAvatar, displayName, radius: 28),
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
                color: const Color(0xFFF97316).withValues(alpha: 0.28),
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

  Widget _buildAvatarWidget(String? avatar, String name, {double radius = 28}) {
    if (avatar != null && avatar.startsWith('preset_')) {
      final emoji = _getPresetEmoji(avatar);
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFFFD6C8),
        child: Text(emoji, style: TextStyle(fontSize: radius * 0.9)),
      );
    }

    if (avatar != null && avatar.trim().isNotEmpty && (avatar.startsWith('http://') || avatar.startsWith('https://'))) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFFFD6C8),
        child: ClipOval(
          child: Image.network(
            avatar,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackAvatar(name, radius);
            },
          ),
        ),
      );
    }

    return _buildFallbackAvatar(name, radius);
  }

  String _getPresetEmoji(String avatarKey) {
    switch (avatarKey) {
      case 'preset_1':
        return '🎓';
      case 'preset_2':
        return '🦊';
      case 'preset_3':
        return '🚀';
      case 'preset_4':
        return '🦁';
      case 'preset_5':
        return '🤖';
      case 'preset_6':
        return '🐱';
      case 'preset_7':
        return '⚡️';
      case 'preset_8':
        return '🌸';
      default:
        return '🎓';
    }
  }

  Widget _buildFallbackAvatar(String name, double radius) {
    final firstChar = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'L';
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFF97316),
      child: Text(
        firstChar,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
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
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFFF97316).withValues(alpha: 0.18),
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
                    : Colors.white.withValues(alpha: 0.25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$_completedSteps/$_totalSteps',
                      style: const TextStyle(
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
    Color cardColor = Colors.white.withValues(alpha: 0.15);
    Color borderColor = Colors.white.withValues(alpha: 0.2);
    Color textColor = Colors.white;
    Widget statusIcon = const SizedBox();

    if (isDark) {
      cardColor = const Color(0xFF1E2124);
      borderColor = const Color(0xFF2B3035);
      textColor = Colors.white;
    }

    if (isCompleted) {
      if (!isDark) {
        cardColor = Colors.white.withValues(alpha: 0.3);
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
              ? const Color(0xFFF97316).withValues(alpha: 0.20)
              : const Color(0xFFFFEDD5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          '进行中',
          style: TextStyle(
            color: Color(0xFFEA580C),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    } else if (isLocked) {
      if (!isDark) {
        textColor = Colors.white.withValues(alpha: 0.62);
        cardColor = Colors.white.withValues(alpha: 0.08);
      }
      statusIcon = Icon(
        Icons.lock,
        color: isDark ? Colors.white30 : Colors.white.withValues(alpha: 0.58),
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

  // 3. 艾宾浩斯智能复习混入任务卡
  Widget _buildReviewAlertBanner(bool isDark) {
    final queue = storageService.getUnifiedReviewQueue();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SmartReviewScreen(
              customQueue: queue,
              onReviewCompleted: () {
                if (mounted) setState(() {});
              },
            ),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF311005), const Color(0xFF451A03)]
                : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF9A3412) : const Color(0xFFFDBA74),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF97316).withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF97316),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '🧠 SM-2 动态复习舱',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF9A3412),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${queue.length} 项到期',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '根据 SM-2 遗忘曲线算法排程，及时复习记忆保留率提升 300%',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFFED7AA) : const Color(0xFFC2410C),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SmartReviewScreen(
                      customQueue: queue,
                      onReviewCompleted: () {
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                ).then((_) {
                  if (mounted) setState(() {});
                });
              },
              child: const Text(
                '去复习',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
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
                color: const Color(0xFFF97316).withValues(alpha: 0.24),
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
                    const Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: Color(0xFFF97316),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
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
                      icon: const Icon(
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
              color: isDark ? Colors.black26 : brandColor.withValues(alpha: 0.05),
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
                color: brandColor.withValues(alpha: 0.15),
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

class _WordFlipCard extends StatefulWidget {
  final Word word;
  final bool isDark;
  final StorageService storageService;

  const _WordFlipCard({
    required this.word,
    required this.isDark,
    required this.storageService,
  });

  @override
  State<_WordFlipCard> createState() => _WordFlipCardState();
}

class _WordFlipCardState extends State<_WordFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _checkFavorite();
  }

  void _checkFavorite() {
    setState(() {
      _isFavorited = widget.storageService.getFavorites().contains(widget.word.english);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _toggleFavorite() async {
    if (_isFavorited) {
      await widget.storageService.removeFavorite(widget.word.english);
    } else {
      await widget.storageService.addFavorite(widget.word.english);
    }
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final isUnder = angle > (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isUnder
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildBackCard(),
                )
              : _buildFrontCard(),
        );
      },
    );
  }

  Widget _buildFrontCard() {
    return InkWell(
      onTap: _toggleFlip,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '🌟 每日一词 · Word of the Day',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 24),
                  onPressed: () => AudioService.instance.speakWord(widget.word.english),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.word.english,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.word.phonetic,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '💡 点击卡片翻转查看详细释义',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Icon(Icons.flip_rounded, color: Colors.white70, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return InkWell(
      onTap: _toggleFlip,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.word.english,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavorited ? Colors.redAccent : Colors.white60,
                    size: 24,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.word.chinese,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.word.exampleSentence.isNotEmpty) ...[
              Text(
                '“${widget.word.exampleSentence}”',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
            ],
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '↩️ 点击翻回正面',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Icon(Icons.flip_rounded, color: Colors.amber, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

