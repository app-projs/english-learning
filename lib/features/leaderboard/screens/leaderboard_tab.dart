import 'package:flutter/material.dart';

import '../../../core/theme/lumina_theme.dart';
import '../../../features/profile/models/user.dart';
import '../../../core/services/storage_service.dart';
import '../../../features/profile/services/user_service.dart';

enum _LeaderboardScope {
  all('全部榜单'),
  friends('好友榜单');

  const _LeaderboardScope(this.label);

  final String label;
}

enum _LeaderboardPeriod {
  week('本周榜'),
  month('月度榜'),
  year('年度榜');

  const _LeaderboardPeriod(this.label);

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
  _LeaderboardScope _scope = _LeaderboardScope.all;
  _LeaderboardPeriod _period = _LeaderboardPeriod.week;

  UserProfile? _userProfile;
  int _userPoints = 1580;
  int _userStreak = 7;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = await StorageService.getInstance();
    final userService = UserService(storage);
    final profile = await userService.getUserProfile();
    final stats = storage.getPracticeStats();
    final progress = storage.getLearningProgress();

    final wordsLearned = stats['wordsPracticed'] ?? progress['totalWords'] ?? 15;
    final sentencesLearned = stats['sentencesPracticed'] ?? progress['totalSentences'] ?? 8;
    final streakDays = storage.getStreakDays() == 0 ? profile.streakDays : storage.getStreakDays();
    final practiceCount = stats['totalPracticeCount'] ?? 12;

    final calculatedPoints = (wordsLearned * 5) + (sentencesLearned * 10) + (streakDays * 50) + (practiceCount * 15);

    if (mounted) {
      setState(() {
        _userProfile = profile;
        _userPoints = calculatedPoints > 0 ? calculatedPoints : 1580;
        _userStreak = streakDays > 0 ? streakDays : 7;
      });
    }
  }

  _LeaderboardUser _getMeForPeriod(_LeaderboardPeriod period) {
    int points;
    switch (period) {
      case _LeaderboardPeriod.month:
        points = _userPoints * 4 + 1200;
        break;
      case _LeaderboardPeriod.year:
        points = _userPoints * 15 + 5000;
        break;
      case _LeaderboardPeriod.week:
        points = _userPoints;
        break;
    }

    return _LeaderboardUser(
      rank: 0,
      name: _userProfile?.name ?? '我',
      lp: points,
      streak: _userStreak,
      avatarUrl: _userProfile?.avatar ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=160&auto=format&fit=crop&q=80',
      isMe: true,
    );
  }

  // Mock Ranking Datasets across (Scope x Period)
  final Map<String, List<_LeaderboardUser>> _mockRankingsMatrix = const {
    'all_week': [
      _LeaderboardUser(
        rank: 1,
        name: 'Kevin',
        lp: 2140,
        streak: 32,
        title: '黄金词霸',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: 'Sophia',
        lp: 1890,
        streak: 24,
        title: '白银极光',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: 'Lucas',
        lp: 1760,
        streak: 21,
        title: '白银极光',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: 'Alice',
        lp: 1520,
        streak: 18,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 5,
        name: 'Henry',
        lp: 1480,
        streak: 15,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 6,
        name: 'Amy',
        lp: 1420,
        streak: 13,
        avatarUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 7,
        name: 'Tom',
        lp: 1350,
        streak: 10,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
    ],
    'all_month': [
      _LeaderboardUser(
        rank: 1,
        name: 'Kevin',
        lp: 8540,
        streak: 32,
        title: '王者大宗师',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: 'Sophia',
        lp: 7620,
        streak: 28,
        title: '钻石宗师',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: 'Lucas',
        lp: 6980,
        streak: 25,
        title: '黄金极客',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: 'Alice',
        lp: 6120,
        streak: 22,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 5,
        name: 'Henry',
        lp: 5890,
        streak: 19,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 6,
        name: 'Amy',
        lp: 5410,
        streak: 16,
        avatarUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=160&auto=format&fit=crop&q=80',
      ),
    ],
    'all_year': [
      _LeaderboardUser(
        rank: 1,
        name: 'Kevin',
        lp: 34800,
        streak: 180,
        title: '王者大宗师',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: 'Sophia',
        lp: 31200,
        streak: 154,
        title: '钻石宗师',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: 'Lucas',
        lp: 29500,
        streak: 140,
        title: '黄金极客',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: 'Alice',
        lp: 26400,
        streak: 120,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 5,
        name: 'Henry',
        lp: 24100,
        streak: 98,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
    ],
    'friends_week': [
      _LeaderboardUser(
        rank: 1,
        name: '李明',
        lp: 1960,
        streak: 28,
        title: '黄金词霸',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: '张华',
        lp: 1740,
        streak: 19,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: '小雨',
        lp: 1660,
        streak: 16,
        avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: '王强',
        lp: 1390,
        streak: 12,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 5,
        name: '刘洋',
        lp: 1260,
        streak: 9,
        avatarUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=160&auto=format&fit=crop&q=80',
      ),
    ],
    'friends_month': [
      _LeaderboardUser(
        rank: 1,
        name: '李明',
        lp: 7840,
        streak: 28,
        title: '黄金词霸',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: '张华',
        lp: 6960,
        streak: 22,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: '小雨',
        lp: 6440,
        streak: 18,
        avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: '王强',
        lp: 5560,
        streak: 15,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
    ],
    'friends_year': [
      _LeaderboardUser(
        rank: 1,
        name: '李明',
        lp: 31400,
        streak: 160,
        title: '王者大宗师',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 2,
        name: '张华',
        lp: 27800,
        streak: 135,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 3,
        name: '小雨',
        lp: 25700,
        streak: 110,
        avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=160&auto=format&fit=crop&q=80',
      ),
      _LeaderboardUser(
        rank: 4,
        name: '王强',
        lp: 21800,
        streak: 90,
        avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=160&auto=format&fit=crop&q=80',
      ),
    ],
  };

  List<_LeaderboardUser> _getDynamicRankings(_LeaderboardScope scope, _LeaderboardPeriod period) {
    final key = '${scope.name}_${period.name}';
    final baseList = _mockRankingsMatrix[key] ?? [];
    final rawList = baseList.where((u) => !u.isMe).toList();

    final myUserForPeriod = _getMeForPeriod(period);
    rawList.add(myUserForPeriod);
    rawList.sort((a, b) => b.lp.compareTo(a.lp));

    final List<_LeaderboardUser> result = [];
    for (int i = 0; i < rawList.length; i++) {
      final u = rawList[i];
      result.add(_LeaderboardUser(
        rank: i + 1,
        name: u.name,
        lp: u.lp,
        streak: u.streak,
        avatarUrl: u.avatarUrl,
        title: u.title,
        isMe: u.isMe,
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ranking = _getDynamicRankings(_scope, _period);
    final myUser = ranking.firstWhere((u) => u.isMe, orElse: () => _getMeForPeriod(_period));

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildMyRankCard(myUser),
                    const SizedBox(height: 24),
                    _buildScopeTabs(),
                    const SizedBox(height: 16),
                    _buildRankingList(ranking),
                    const SizedBox(height: 24),
                    _buildLearningTip(),
                    const SizedBox(height: 120),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: LuminaColors.primary.withValues(alpha: 0.12),
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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        PopupMenuButton<_LeaderboardPeriod>(
          initialValue: _period,
          onSelected: (selected) {
            setState(() {
              _period = selected;
            });
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          itemBuilder: (context) {
            return _LeaderboardPeriod.values.map((p) {
              return PopupMenuItem<_LeaderboardPeriod>(
                value: p,
                child: Row(
                  children: [
                    Icon(
                      p == _period ? Icons.check_circle_rounded : Icons.circle_outlined,
                      size: 16,
                      color: p == _period ? LuminaColors.primary : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      p.label,
                      style: TextStyle(
                        fontWeight: p == _period ? FontWeight.bold : FontWeight.normal,
                        color: p == _period ? LuminaColors.primary : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _period.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: LuminaColors.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyRankCard(_LeaderboardUser myUser) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: LuminaColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                  '我的排名 (${myUser.name})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LuminaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: LuminaColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      const TextSpan(text: '第 ', style: TextStyle(fontSize: 15)),
                      TextSpan(text: '${myUser.rank}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' 名', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildMyMetric('我的积分', '${myUser.lp}', LuminaColors.secondary),
                    Container(
                      width: 1,
                      height: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.grey.shade300,
                    ),
                    _buildMyMetric('连续学习', '${myUser.streak} 天', LuminaColors.tertiary),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 70,
            decoration: BoxDecoration(
              color: LuminaColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 42,
              color: Color(0xFFFFA83D),
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
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: LuminaColors.onSurface.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildScopeTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: _LeaderboardScope.values.map((scope) {
          final isSelected = scope == _scope;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _scope = scope;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  scope.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? LuminaColors.primary : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRankingList(List<_LeaderboardUser> users) {
    return Column(
      children: List.generate(users.length, (index) {
        final user = users[index];
        return _buildUserRow(user);
      }),
    );
  }

  Widget _buildUserRow(_LeaderboardUser user) {
    final isPinned = user.isMe;

    Widget buildRankBadge(int rank) {
      if (rank == 1) {
        return Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFFFB800),
            shape: BoxShape.circle,
          ),
          child: const Text('🥇', style: TextStyle(fontSize: 16)),
        );
      } else if (rank == 2) {
        return Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFB0BEC5),
            shape: BoxShape.circle,
          ),
          child: const Text('🥈', style: TextStyle(fontSize: 16)),
        );
      } else if (rank == 3) {
        return Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFCD7F32),
            shape: BoxShape.circle,
          ),
          child: const Text('🥉', style: TextStyle(fontSize: 16)),
        );
      }
      return SizedBox(
        width: 32,
        child: Text(
          '$rank',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isPinned ? LuminaColors.primary.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPinned ? LuminaColors.primary.withValues(alpha: 0.4) : Colors.grey.shade200,
          width: isPinned ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildRankBadge(user.rank),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isPinned ? LuminaColors.primary : Colors.black87,
              ),
            ),
            if (user.isMe) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: LuminaColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '我',
                  style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          '连续 ${user.streak} 天 · ${user.title}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Text(
          '${user.lp} 积分',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPinned ? LuminaColors.primary : Colors.deepOrange.shade800,
          ),
        ),
        onTap: () => _showUserDetail(user),
      ),
    );
  }

  void _showUserDetail(_LeaderboardUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                user.title,
                style: const TextStyle(fontSize: 13, color: LuminaColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem('当前排名', '#${user.rank}'),
                  _buildDetailItem('榜单积分', '${user.lp}'),
                  _buildDetailItem('连续打卡', '${user.streak} 天'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LuminaColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: LuminaColors.primary)),
      ],
    );
  }

  Widget _buildLearningTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: Colors.blue.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '提示：每天完成词汇复习、文章精读与听说训练可获得大量积分，助你冲刺榜首！',
              style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
