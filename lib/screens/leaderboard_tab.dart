import 'package:flutter/material.dart';

import '../theme/lumina_theme.dart';

enum _LeaderboardScope {
  school('全校榜'),
  friends('好友榜'),
  classRoom('班级榜');

  const _LeaderboardScope(this.label);

  final String label;
}

class _LeaderboardUser {
  const _LeaderboardUser({
    required this.rank,
    required this.name,
    required this.lp,
    required this.streak,
    required this.avatarUrl,
    this.title = '白银极光',
    this.isMe = false,
  });

  final int rank;
  final String name;
  final int lp;
  final int streak;
  final String avatarUrl;
  final String title;
  final bool isMe;
}

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  _LeaderboardScope _scope = _LeaderboardScope.school;

  static const _me = _LeaderboardUser(
    rank: 12,
    name: 'Emma',
    lp: 1580,
    streak: 7,
    avatarUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=160&auto=format&fit=crop&q=80',
    isMe: true,
  );

  final Map<_LeaderboardScope, List<_LeaderboardUser>> _rankings = const {
    _LeaderboardScope.school: [
      _LeaderboardUser(
        rank: 1,
        name: 'Kevin',
        lp: 2140,
        streak: 32,
        title: '黄金词霸',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: 'Sophia',
        lp: 1890,
        streak: 24,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: 'Lucas',
        lp: 1760,
        streak: 21,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: 'Alice',
        lp: 1520,
        streak: 18,
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 5,
        name: 'Henry',
        lp: 1480,
        streak: 15,
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 6,
        name: 'Amy',
        lp: 1420,
        streak: 13,
        avatarUrl:
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=160&auto=format&fit=crop&q=80',
      ),
      _me,
    ],
    _LeaderboardScope.friends: [
      _LeaderboardUser(
        rank: 1,
        name: '李明',
        lp: 1960,
        streak: 28,
        title: '黄金词霸',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: '张华',
        lp: 1740,
        streak: 19,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: '小雨',
        lp: 1660,
        streak: 16,
        avatarUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=160&auto=format&fit=crop&q=80',
      ),
      _me,
      _LeaderboardUser(
        rank: 4,
        name: '王强',
        lp: 1390,
        streak: 12,
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 5,
        name: '刘洋',
        lp: 1260,
        streak: 9,
        avatarUrl:
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=160&auto=format&fit=crop&q=80',
      ),
    ],
    _LeaderboardScope.classRoom: [
      _LeaderboardUser(
        rank: 1,
        name: 'Mia',
        lp: 1840,
        streak: 22,
        title: '黄金词霸',
        avatarUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: 'Noah',
        lp: 1690,
        streak: 19,
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
      _me,
      _LeaderboardUser(
        rank: 3,
        name: 'Ryan',
        lp: 1510,
        streak: 16,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: 'Nina',
        lp: 1395,
        streak: 11,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final ranking = _rankings[_scope]!;
    final podiumUsers = ranking.where((user) => user.rank <= 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    final listUsers = ranking.where((user) => user.rank > 3).toList();

    return Container(
      color: LuminaColors.background,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildMyRankCard(),
                    const SizedBox(height: 30),
                    _buildScopeTabs(),
                    const SizedBox(height: 44),
                    _buildPodium(podiumUsers),
                    const SizedBox(height: 30),
                    _buildRankingList(listUsers),
                    const SizedBox(height: 26),
                    _buildLearningTip(),
                    const SizedBox(height: 128),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: LuminaColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.leaderboard_rounded,
            color: LuminaColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '学习榜单',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '本周榜',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: LuminaColors.onSurface,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyRankCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.75)),
        boxShadow: [
          BoxShadow(
            color: LuminaColors.primary.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '我的排名',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: LuminaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: LuminaColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: '第 ', style: TextStyle(fontSize: 16)),
                      TextSpan(text: '12', style: TextStyle(fontSize: 24)),
                      TextSpan(text: ' 名', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _buildMyMetric('我的LP', '1580', LuminaColors.secondary),
                    Container(
                      width: 1,
                      height: 34,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: LuminaColors.outline.withOpacity(0.22),
                    ),
                    _buildMyMetric('连续学习', '7 天', LuminaColors.tertiary),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 98,
            height: 76,
            decoration: BoxDecoration(
              color: LuminaColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.leaderboard_rounded,
                  size: 46,
                  color: LuminaColors.primary.withOpacity(0.16),
                ),
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 42,
                  color: Color(0xFFFFA83D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: LuminaColors.onSurface.withOpacity(0.72),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildScopeTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: LuminaColors.outline.withOpacity(0.16),
          ),
        ),
      ),
      child: Row(
        children: _LeaderboardScope.values.map((scope) {
          final isSelected = _scope == scope;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => setState(() => _scope = scope),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      scope.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? LuminaColors.primary
                            : LuminaColors.onSurface.withOpacity(0.74),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: isSelected ? 38 : 0,
                      height: 4,
                      decoration: BoxDecoration(
                        color: LuminaColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPodium(List<_LeaderboardUser> users) {
    final first = users.firstWhere((user) => user.rank == 1);
    final second = users.firstWhere(
      (user) => user.rank == 2,
      orElse: () => users.first,
    );
    final third = users.firstWhere(
      (user) => user.rank == 3,
      orElse: () => users.last,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildPodiumPlace(second, height: 100)),
        const SizedBox(width: 8),
        Expanded(child: _buildPodiumPlace(first, height: 124, isWinner: true)),
        const SizedBox(width: 8),
        Expanded(child: _buildPodiumPlace(third, height: 100)),
      ],
    );
  }

  Widget _buildPodiumPlace(
    _LeaderboardUser user, {
    required double height,
    bool isWinner = false,
  }) {
    final rankColor = switch (user.rank) {
      1 => const Color(0xFFFF8B2B),
      2 => const Color(0xFFC9D3DE),
      _ => const Color(0xFFFF9B3D),
    };
    final cardColor = user.rank == 1
        ? const Color(0xFFFFDDC5)
        : Colors.white.withOpacity(0.72);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => _openUserDetail(user),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              Positioned(
                top: isWinner ? -44 : -28,
                left: 0,
                right: 0,
                child: Center(child: _buildRankTopper(user.rank)),
              ),
              Container(
                width: isWinner ? 78 : 62,
                height: isWinner ? 78 : 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: rankColor.withOpacity(0.55), width: 4),
                  image: DecorationImage(
                    image: NetworkImage(user.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withOpacity(0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -3,
                bottom: -3,
                child: Container(
                  width: isWinner ? 32 : 26,
                  height: isWinner ? 32 : 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: rankColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '${user.rank}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(color: Colors.white.withOpacity(0.7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isWinner ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: LuminaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${user.lp} LP',
                  style: TextStyle(
                    fontSize: isWinner ? 17 : 15,
                    fontWeight: FontWeight.w700,
                    color: user.rank == 1
                        ? const Color(0xFFFF7A1A)
                        : LuminaColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankTopper(int rank) {
    final color = switch (rank) {
      1 => const Color(0xFFFFB84D),
      2 => const Color(0xFFB9C5D3),
      _ => const Color(0xFFFF9B3D),
    };

    if (rank == 1) {
      return const Text(
        '👑',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 42,
          height: 1,
          shadows: [
            Shadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
            Shadow(
              color: Color(0x55FFB84D),
              blurRadius: 14,
              offset: Offset(0, 2),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Icon(
        rank == 2 ? Icons.diamond_rounded : Icons.auto_awesome_rounded,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildRankingList(List<_LeaderboardUser> users) {
    final visibleUsers = users.where((user) => !user.isMe).toList();

    return Column(
      children: [
        ...visibleUsers.map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildRankingRow(user),
          ),
        ),
        if (visibleUsers.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildMoreDivider(),
          const SizedBox(height: 20),
        ],
        _buildRankingRow(_me, isPinned: true),
      ],
    );
  }

  Widget _buildRankingRow(_LeaderboardUser user, {bool isPinned = false}) {
    final backgroundColor = isPinned
        ? LuminaColors.primary.withOpacity(0.13)
        : Colors.white.withOpacity(0.72);
    final borderColor = isPinned
        ? LuminaColors.primary.withOpacity(0.22)
        : Colors.white.withOpacity(0.65);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () => _openUserDetail(user),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: LuminaColors.primary
                    .withValues(alpha: isPinned ? 0.08 : 0.04),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '${user.rank}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isPinned
                        ? LuminaColors.primary
                        : LuminaColors.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              CircleAvatar(
                radius: 21,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  isPinned ? FontWeight.w800 : FontWeight.w700,
                              color: LuminaColors.onSurface,
                            ),
                          ),
                        ),
                        if (user.isMe) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: LuminaColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '我',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 14,
                          color:
                              const Color(0xFFFF7A1A).withOpacity(0.88),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '连续 ${user.streak} 天 · ${user.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: LuminaColors.onSurface
                                  .withOpacity(0.52),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${user.lp} LP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color:
                      isPinned ? LuminaColors.primary : LuminaColors.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: LuminaColors.outline.withOpacity(0.78),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openUserDetail(_LeaderboardUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _LeaderboardUserDetailScreen(user: user),
      ),
    );
  }

  Widget _buildMoreDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: LuminaColors.outline.withOpacity(0.28),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildLearningTip() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFDDF1FF).withOpacity(0.96),
            const Color(0xFFEFF4FF).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: LuminaColors.tertiary.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: LuminaColors.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '学习小贴士',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: LuminaColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '每天进步一点点，终会发光发亮！快去完成今天的口语练习吧。',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.65,
                    fontWeight: FontWeight.w600,
                    color: LuminaColors.tertiary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.76),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFFFB84D),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardUserDetailScreen extends StatelessWidget {
  const _LeaderboardUserDetailScreen({required this.user});

  final _LeaderboardUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuminaColors.background,
      appBar: AppBar(
        backgroundColor: LuminaColors.background,
        elevation: 0,
        title: const Text('学习档案'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          children: [
            _buildProfileCard(),
            const SizedBox(height: 18),
            _buildStatsGrid(),
            const SizedBox(height: 18),
            _buildRecentCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: LuminaColors.primary.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: LuminaColors.onSurface,
                ),
              ),
              if (user.isMe) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: LuminaColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '我',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: LuminaColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              user.title,
              style: const TextStyle(
                color: LuminaColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: List.generate(
        4,
        (index) {
          final items = [
            ('当前排名', '#${user.rank}', LuminaColors.primary),
            ('本周 LP', '${user.lp}', LuminaColors.secondary),
            ('连续学习', '${user.streak} 天', LuminaColors.tertiary),
            ('完成率', '${72 + user.rank % 18}%', const Color(0xFFFF7A1A)),
          ];
          final item = items[index];
          return _buildStatCard(item.$1, item.$2, item.$3);
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: LuminaColors.onSurface.withOpacity(0.56),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCard() {
    final activities = [
      ('完成词汇复习', '+80 LP'),
      ('阅读精练 1 篇', '+120 LP'),
      ('连续打卡奖励', '+50 LP'),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.62)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '最近学习动态',
            style: TextStyle(
              color: LuminaColors.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: LuminaColors.success.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: LuminaColors.success,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity.$1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    activity.$2,
                    style: const TextStyle(
                      color: LuminaColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
