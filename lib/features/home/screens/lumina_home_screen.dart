import 'package:flutter/material.dart';
import '../../../core/theme/lumina_theme.dart';
import '../../../core/widgets/lumina_card.dart';
import 'daily_tab.dart';
import '../../../features/leaderboard/screens/leaderboard_tab.dart';
import '../../../features/profile/screens/home_screen.dart';
import '../../../features/word/screens/word_practice_screen.dart';
import '../../../features/sentence/screens/sentence_practice_screen.dart';
import '../../../features/article/screens/article_list_screen.dart';
import '../../../features/listening/screens/listening_practice_screen.dart';
import '../../../features/word_root/screens/word_roots_screen.dart';
import '../../../core/services/audio_service.dart';
import '../../../features/phonetics/screens/phonetics_practice_screen.dart';
import '../../../features/ai_practice/screens/ai_practice_tab.dart';

class LuminaHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const LuminaHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LuminaHomeScreen> createState() => _LuminaHomeScreenState();
}

class _LuminaHomeScreenState extends State<LuminaHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      DailyTab(isActive: _currentIndex == 0),
      _buildSpecializedTab(),
      const AiPracticeTab(), // 最中间 (Index = 2) AI 练习模块
      const LeaderboardTab(),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: LuminaColors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: tabs,
          ),

          // Full-width Bottom Navigation Dock (顶部无圆角平直设计)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializedTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _buildQuoteBanner(),
                  const SizedBox(height: 24),
                  _buildBentoGrid(),
                  const SizedBox(height: 24),
                  _buildAchievementCard(),
                  const SizedBox(height: 128), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteBanner() {
    const quoteText =
        'Learning is a treasure that will follow its owner everywhere.';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今日名言',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFEA580C),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"$quoteText"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => AudioService.instance.speak(quoteText),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_up,
                  color: Color(0xFFEA580C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                title: '单词练习',
                subtitle: '背词 / 记忆卡',
                accentColor: const Color(0xFF3B82F6),
                badgeText: '核心词汇',
                icon: Icons.font_download_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WordPracticeScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureCard(
                title: '名著精读',
                subtitle: '沉浸原著长文',
                accentColor: const Color(0xFF10B981),
                badgeText: '名著分句',
                icon: Icons.book_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReadingTab(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                title: '长句翻译',
                subtitle: '语境句型打磨',
                accentColor: const Color(0xFFF59E0B),
                badgeText: '精选长句',
                icon: Icons.translate_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SentencePracticeScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureCard(
                title: '听力训练',
                subtitle: '音频播报跟读',
                accentColor: const Color(0xFF8B5CF6),
                badgeText: '发音强化',
                icon: Icons.headphones_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeningPracticeScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                title: '自然拼读',
                subtitle: '国际音标表发音',
                accentColor: const Color(0xFFEC4899),
                badgeText: '48音标',
                icon: Icons.record_voice_over_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhoneticsPracticeScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureCard(
                title: '字词根词缀',
                subtitle: '高效构词法拓展',
                accentColor: const Color(0xFF06B6D4),
                badgeText: '思维导图',
                icon: Icons.account_tree_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WordRootsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required Color accentColor,
    required String badgeText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LuminaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('连续学习挑战',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: LuminaColors.outline),
                        children: const [
                          TextSpan(text: '再坚持 '),
                          TextSpan(
                              text: '3',
                              style: TextStyle(
                                  color: Color(0xFFEA580C),
                                  fontWeight: FontWeight.bold)),
                          TextSpan(text: ' 天即可获得惊喜奖励'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium,
                    color: Color(0xFFF97316)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('当前进度',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: LuminaColors.outline)),
              Text('70%',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: LuminaColors.outline)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Row(
              children: List.generate(10, (index) {
                return Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(right: index < 9 ? 2 : 0),
                    color: index < 7
                        ? LuminaColors.secondary
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.zero, // 上半部分不要留圆角，平直直角设计
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, '首页', isActive: _currentIndex == 0),
              _buildNavItem(1, Icons.menu_book_rounded, '学习', isActive: _currentIndex == 1),
              _buildCenterAiNavItem(2, 'AI 练习', isActive: _currentIndex == 2), // 最中间 Index 2
              _buildNavItem(3, Icons.leaderboard_rounded, '榜单', isActive: _currentIndex == 3),
              _buildNavItem(4, Icons.person_rounded, '我的', isActive: _currentIndex == 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isActive = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E293B);
    final inactiveColor = activeColor.withValues(alpha: 0.55);

    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 4),
            // 固定纵向占用高度 3px，用 width 和 opacity 实现平滑淡入扩展，彻底解决纵向挤压引起的闪烁抖动
            SizedBox(
              height: 3,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: isActive ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: isActive ? 12 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 最中间 AI 练习专属高亮按钮
  Widget _buildCenterAiNavItem(int index, String label, {bool isActive = false}) {
    const activeColor = Color(0xFF2563EB);
    final inactiveColor = activeColor.withValues(alpha: 0.55);

    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive
                      ? [const Color(0xFF2563EB), const Color(0xFF4F46E5)]
                      : [const Color(0xFF3B82F6).withValues(alpha: 0.15), const Color(0xFF6366F1).withValues(alpha: 0.15)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                color: isActive ? Colors.amber : const Color(0xFF2563EB).withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
