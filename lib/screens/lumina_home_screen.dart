import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';
import '../widgets/lumina_card.dart';
import 'daily_tab.dart';
import 'leaderboard_tab.dart';
import 'home_screen.dart';
import 'word_practice_screen.dart';
import 'sentence_practice_screen.dart';
import 'article_list_screen.dart';
import 'listening_practice_screen.dart';
import '../services/audio_service.dart';

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

          // Floating Bottom Navigation
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
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
                child: const Icon(Icons.volume_up,
                    color: Color(0xFFF97316), size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ $feature正在开发中，敬请期待！'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildBentoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildBentoCard(
          title: '音标',
          subtitle: '48个标准发音',
          tagText: '12/48',
          mainColor: const Color(0xFF603CE2),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCfjrcfKh-a41yJm3dKcZoMxPF9rVbFbsKdDlqfY3CPDWuVRJ6M71iTI_n4j1Sw9EonrXSr23CVVtQcDTRI7EvJ6Q88DpBt4ouTQwVDnRq2526B0bXbXro2KzEUp-20ijckCoMGjiMqOmZuEZ3CyIM6c11KaK6ZdYBNOz_1WgabcigzB1Zdo_73w9zmia7ISOA7oJih6g5icoA_dvt2iYuR6JbRfUeTGazDBtBm9xrwdxKes0ofPpW-G0UIuR6-7oOuQj51jHUsukwp',
          onTap: () => _showComingSoon('音标发音练习'),
        ),
        _buildBentoCard(
          title: '字词根',
          subtitle: '词根词缀记忆',
          tagText: '86词根',
          mainColor: const Color(0xFFB8860B),
          tagColor: const Color(0xFFFF9C41),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA7TGnFrc0GF5SUsZCZ_Yhnp7nKI5_HQ1hdgULeNiQgngeuPqKtTCJh5jwG2GDgQI01pnIv36m5O4sgGIG9-iiPD0x377NHPvU8vqjLgwpzkvODWCLEbl0Tef-R5t-g1ADyl7LHJK2nZyKnOfUmmthgyXGDY2hzzfloo0XHnu_EoNQ2FlQn-GRnrpjwj7PIYy0ay8bOKR2j_DBwNddVZMLKU7ltYxKMzEhEfiVDUZbDFn6J-fvo92fdVdDn47bFcba-cRAG_3_1j79p',
          onTap: () => _showComingSoon('字词根记忆专项'),
        ),
        _buildBentoCard(
          title: '词汇',
          subtitle: '科学背单词',
          tagText: '今日30词',
          mainColor: const Color(0xFFD2691E),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCjI7a5AHrjh9NK6WLyz2JB9tnHnBY3RgtzNt6ADiHVnJvDL5LkiZadHrr0J1T60BwLZd22vi1wd1HucBJj1wpQrrj_HgKktHKO9_HWWd7oB41ELDm30WgFR6mw8YAa-aIf1fm4PIaxTRJryqQBT3RJlsg4S-5aBztsD_UaI4thFg-4_CcdjC986slbmC1S7mUB6j7NjWGov2MHOuZCVK3LIOvKPYZM7QVJqsxloMy_NhBb1YiEv8UHdW6TrcbBscyNxp_MhJagjgqp',
          onTap: () => _navigateTo(const WordPracticeScreen()),
        ),
        _buildBentoCard(
          title: '语法',
          subtitle: '语法体系梳理',
          tagText: '初中·中',
          mainColor: const Color(0xFF00647C),
          tagColor: const Color(0xFF007F9D),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC8mfzTZpLO3GF9JxchwjuzunQMcibD3Nsbo_4TYRRRRNvLMWHyjPqjvnhFkfE2h-a86d7PK-wEBCAhUZjHVzRFHQ8pPAEPFEvNpTqu-0iOHwBEtalKzwIg3gnmr6iNoz47LvAIFFM6qoAOpQXKWf_URujmlsaynFEYT3MbEEVpo3zifovhwwZ1ehuAMIDxFTaTNsKabUuVlYWcAwMdpx6fViQVySxMM_CJfHKu67WZ17nGJf5bPLmAAAOPRJTD7NM12O_artWlSIX5',
          onTap: () => _navigateTo(const SentencePracticeScreen()),
        ),
        _buildBentoCard(
          title: '阅读',
          subtitle: '精选文章练习',
          tagText: '12篇精读',
          mainColor: const Color(0xFFB22222),
          tagColor: const Color(0xFFBA1A1A),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuB-jXFPJ8-ZI6PL5w-aOu4H95W7wYoYZrDHOSG1KZSKOD3mS6WL4b2r3ajdTFImb7D55N4Zg_EoAQvfzcFo8hWeYvNwkLBdhisrVPsxR8_Sr89maAN5PAN5YVSaSTd_AWhYKtFRtXdVTLsPBPHnOyTgEf4t7pDan4mmLO7I8vjJbsrSqZ3gnbUHtTqJOTL9dERh4XEapgc2xqVwx1DasoGeTeTk6YB9Shlzf-3mV9P7Xp1p0vPS5qOpa9Z9U5i0Fc8isuM9yYVnJmC_',
          onTap: () => _navigateTo(const ReadingTab()),
        ),
        _buildBentoCard(
          title: '听力',
          subtitle: '磨耳朵训练',
          tagText: '15分钟',
          mainColor: const Color(0xFF483D8B),
          tagColor: const Color(0xFFF97316),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuACwajHtOu41YRYpavq0w-qJdBlg8aN-IABlshArWcHciNC12h7AIMAd3HueHpMc065cl3YVyEbQPT_fauFlf2cyW9MqV6paiViGxr1NaznXOv_BDsPx1KX_SorO-USvfczNVF01hN9MI3sfd7KQm0RfKChWf-7Gvu78AkaQef_Jxa2wUbGgusxAZRZbcy9kBthThgHhvj1PEN9lciPGxFCjkyf6ALDPL3oRaaMZv-9AmVHB72KdonbBSbBipvWdO8nowglAOUlXGFR',
          onTap: () => _navigateTo(const ListeningPracticeScreen()),
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String subtitle,
    required String tagText,
    required Color mainColor,
    Color? tagColor,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    final softColor = Color.lerp(mainColor, Colors.white, 0.78)!;
    final paleColor = Color.lerp(mainColor, Colors.white, 0.9)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            softColor,
            paleColor,
            Colors.white.withValues(alpha: 0.96),
            Colors.white,
          ],
          stops: const [0.0, 0.42, 0.78, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: mainColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: mainColor.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: mainColor,
                                fontSize: 20,
                              ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: mainColor.withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagColor ?? mainColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tagText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -8,
                right: -8,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard() {
    return LuminaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineMedium,
                        children: const [
                          TextSpan(text: '连续学习 '),
                          TextSpan(
                              text: '7',
                              style: TextStyle(
                                  color: LuminaColors.secondary,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(text: ' 天'),
                        ],
                      ),
                    ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, '首页', isActive: _currentIndex == 0),
          _buildNavItem(1, Icons.menu_book, '学习', isActive: _currentIndex == 1),
          _buildNavItem(2, Icons.leaderboard, '榜单',
              isActive: _currentIndex == 2),
          _buildNavItem(3, Icons.person, '我的', isActive: _currentIndex == 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label,
      {bool isActive = false}) {
    const activeColor = Color(0xFF111111);

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : LuminaColors.outline,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? activeColor : LuminaColors.outline,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isActive ? 14 : 0,
              height: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
