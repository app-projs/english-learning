import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';
import '../widgets/lumina_card.dart';

class LuminaHomeScreen extends StatefulWidget {
  const LuminaHomeScreen({super.key});

  @override
  State<LuminaHomeScreen> createState() => _LuminaHomeScreenState();
}

class _LuminaHomeScreenState extends State<LuminaHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuminaColors.background,
      body: Stack(
        children: [
          // Background graphic/liquid effect can go here in the future
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
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
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: LuminaColors.background.withOpacity(0.9),
      pinned: true,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LuminaColors.primary.withOpacity(0.2), width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuA1DbSnQ9dv99Knejut0CaF3gfa7u8RffV19KKgPLWRTGdfCYGZz-XaQqvH0UAh2EPd0fwk7oAkMhl6HisnmqwrTKkyVr8TtmYZqNMHlSde6v1ESejlabbwzW-2U1v44UYQlaS1XU_OFEbjCfbb73xZn0JX6qUR9x9Sb0kfvDRHh9iUxSmBEvJMw7tribJg8wnJR3sh1ybP-rcVmdz4ICoghvIlJ9eBc1bmzfqvH51DGlbSPeL2NK1WWwzAtXSwi_y-Uw2R3T1yk53S'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '早上好, Emma! 👋',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '今天也要元气满满地学习呀！',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LuminaColors.outline,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: LuminaColors.onSurface),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }

  Widget _buildQuoteBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: LuminaColors.primaryContainer.withOpacity(0.08),
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
                        color: LuminaColors.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"Learning is a treasure that will follow its owner everywhere."',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: LuminaColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: LuminaColors.primary, size: 28),
          ),
        ],
      ),
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
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCfjrcfKh-a41yJm3dKcZoMxPF9rVbFbsKdDlqfY3CPDWuVRJ6M71iTI_n4j1Sw9EonrXSr23CVVtQcDTRI7EvJ6Q88DpBt4ouTQwVDnRq2526B0bXbXro2KzEUp-20ijckCoMGjiMqOmZuEZ3CyIM6c11KaK6ZdYBNOz_1WgabcigzB1Zdo_73w9zmia7ISOA7oJih6g5icoA_dvt2iYuR6JbRfUeTGazDBtBm9xrwdxKes0ofPpW-G0UIuR6-7oOuQj51jHUsukwp',
        ),
        _buildBentoCard(
          title: '字词根',
          subtitle: '词根词缀记忆',
          tagText: '86词根',
          mainColor: const Color(0xFFB8860B),
          tagColor: const Color(0xFFFF9C41),
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA7TGnFrc0GF5SUsZCZ_Yhnp7nKI5_HQ1hdgULeNiQgngeuPqKtTCJh5jwG2GDgQI01pnIv36m5O4sgGIG9-iiPD0x377NHPvU8vqjLgwpzkvODWCLEbl0Tef-R5t-g1ADyl7LHJK2nZyKnOfUmmthgyXGDY2hzzfloo0XHnu_EoNQ2FlQn-GRnrpjwj7PIYy0ay8bOKR2j_DBwNddVZMLKU7ltYxKMzEhEfiVDUZbDFn6J-fvo92fdVdDn47bFcba-cRAG_3_1j79p',
        ),
        _buildBentoCard(
          title: '词汇',
          subtitle: '科学背单词',
          tagText: '今日30词',
          mainColor: const Color(0xFFD2691E),
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCjI7a5AHrjh9NK6WLyz2JB9tnHnBY3RgtzNt6ADiHVnJvDL5LkiZadHrr0J1T60BwLZd22vi1wd1HucBJj1wpQrrj_HgKktHKO9_HWWd7oB41ELDm30WgFR6mw8YAa-aIf1fm4PIaxTRJryqQBT3RJlsg4S-5aBztsD_UaI4thFg-4_CcdjC986slbmC1S7mUB6j7NjWGov2MHOuZCVK3LIOvKPYZM7QVJqsxloMy_NhBb1YiEv8UHdW6TrcbBscyNxp_MhJagjgqp',
        ),
        _buildBentoCard(
          title: '语法',
          subtitle: '语法体系梳理',
          tagText: '初中·中',
          mainColor: const Color(0xFF00647C),
          tagColor: const Color(0xFF007F9D),
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC8mfzTZpLO3GF9JxchwjuzunQMcibD3Nsbo_4TYRRRRNvLMWHyjPqjvnhFkfE2h-a86d7PK-wEBCAhUZjHVzRFHQ8pPAEPFEvNpTqu-0iOHwBEtalKzwIg3gnmr6iNoz47LvAIFFM6qoAOpQXKWf_URujmlsaynFEYT3MbEEVpo3zifovhwwZ1ehuAMIDxFTaTNsKabUuVlYWcAwMdpx6fViQVySxMM_CJfHKu67WZ17nGJf5bPLmAAAOPRJTD7NM12O_artWlSIX5',
        ),
        _buildBentoCard(
          title: '阅读',
          subtitle: '精选文章练习',
          tagText: '12篇精读',
          mainColor: const Color(0xFFB22222),
          tagColor: const Color(0xFFBA1A1A),
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB-jXFPJ8-ZI6PL5w-aOu4H95W7wYoYZrDHOSG1KZSKOD3mS6WL4b2r3ajdTFImb7D55N4Zg_EoAQvfzcFo8hWeYvNwkLBdhisrVPsxR8_Sr89maAN5PAN5YVSaSTd_AWhYKtFRtXdVTLsPBPHnOyTgEf4t7pDan4mmLO7I8vjJbsrSqZ3gnbUHtTqJOTL9dERh4XEapgc2xqVwx1DasoGeTeTk6YB9Shlzf-3mV9P7Xp1p0vPS5qOpa9Z9U5i0Fc8isuM9yYVnJmC_',
        ),
        _buildBentoCard(
          title: '听力',
          subtitle: '磨耳朵训练',
          tagText: '15分钟',
          mainColor: const Color(0xFF483D8B),
          tagColor: LuminaColors.primary,
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuACwajHtOu41YRYpavq0w-qJdBlg8aN-IABlshArWcHciNC12h7AIMAd3HueHpMc065cl3YVyEbQPT_fauFlf2cyW9MqV6paiViGxr1NaznXOv_BDsPx1KX_SorO-USvfczNVF01hN9MI3sfd7KQm0RfKChWf-7Gvu78AkaQef_Jxa2wUbGgusxAZRZbcy9kBthThgHhvj1PEN9lciPGxFCjkyf6ALDPL3oRaaMZv-9AmVHB72KdonbBSbBipvWdO8nowglAOUlXGFR',
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: mainColor,
                        fontSize: 20,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: mainColor.withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                          TextSpan(text: '7', style: TextStyle(color: LuminaColors.secondary, fontWeight: FontWeight.bold)),
                          TextSpan(text: ' 天'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LuminaColors.outline),
                        children: const [
                          TextSpan(text: '再坚持 '),
                          TextSpan(text: '3', style: TextStyle(color: LuminaColors.primary, fontWeight: FontWeight.bold)),
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
                  color: LuminaColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium, color: LuminaColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('当前进度', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: LuminaColors.outline)),
              Text('70%', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: LuminaColors.outline)),
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
                    color: index < 7 ? LuminaColors.secondary : Colors.black.withOpacity(0.05),
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
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, '首页', isActive: true),
          _buildNavItem(1, Icons.menu_book, '学习'),
          _buildNavItem(2, Icons.leaderboard, '榜单'),
          _buildNavItem(3, Icons.person, '我的'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isActive = false}) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? LuminaColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? LuminaColors.primary : LuminaColors.outline,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? LuminaColors.primary : LuminaColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
