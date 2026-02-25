import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/theme_service.dart';
import 'word_practice_screen.dart';
import 'sentence_practice_screen.dart';
import 'dialogue_practice_screen.dart';
import 'listening_practice_screen.dart';

class PracticeTab extends StatelessWidget {
  const PracticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.gradientPrimary,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          '练习中心',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '每天进步一点点',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildListDelegate([
                _PracticeCard(
                  title: '单词练习',
                  subtitle: '提升词汇量',
                  icon: Icons.translate,
                  gradientColors: AppColors.gradientPrimary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WordPracticeScreen(),
                      ),
                    );
                  },
                ),
                _PracticeCard(
                  title: '句子练习',
                  subtitle: '理解句子结构',
                  icon: Icons.format_quote,
                  gradientColors: AppColors.gradientSuccess,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SentencePracticeScreen(),
                      ),
                    );
                  },
                ),
                _PracticeCard(
                  title: '对话练习',
                  subtitle: '场景对话',
                  icon: Icons.chat,
                  gradientColors: AppColors.gradientWarning,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DialoguePracticeScreen(),
                      ),
                    );
                  },
                ),
                _PracticeCard(
                  title: '听力练习',
                  subtitle: '提升听力理解',
                  icon: Icons.headphones,
                  gradientColors: const [Color(0xFFEC4899), Color(0xFFF472B6)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListeningPracticeScreen(),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '练习技巧',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TipCard(
                    icon: Icons.lightbulb_outline,
                    title: '分散学习',
                    description: '每天多次短时间学习比一次性长时间学习更有效',
                  ),
                  const SizedBox(height: 12),
                  _TipCard(
                    icon: Icons.repeat,
                    title: '间隔重复',
                    description: '复习已学过的内容，加强记忆痕迹',
                  ),
                  const SizedBox(height: 12),
                  _TipCard(
                    icon: Icons.psychology,
                    title: '主动回忆',
                    description: '不看答案回忆内容，比被动阅读更能加深理解',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
