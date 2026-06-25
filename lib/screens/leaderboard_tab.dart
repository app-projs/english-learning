import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  bool _isGlobal = true;

  final List<Map<String, dynamic>> _globalUsers = [
    {'rank': 1, 'name': 'Sarah', 'lp': 4820, 'streak': 45, 'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=80'},
    {'rank': 2, 'name': 'Ryan', 'lp': 4210, 'streak': 30, 'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80'},
    {'rank': 3, 'name': 'Emma', 'lp': 3980, 'streak': 21, 'avatarUrl': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&auto=format&fit=crop&q=80'},
    {'rank': 4, 'name': '李明', 'lp': 3540, 'streak': 15, 'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80'},
    {'rank': 5, 'name': '张华', 'lp': 3100, 'streak': 12, 'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=80'},
    {'rank': 6, 'name': '王强', 'lp': 2890, 'streak': 8, 'avatarUrl': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=80'},
    {'rank': 7, 'name': '刘洋', 'lp': 2750, 'streak': 5, 'avatarUrl': 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=100&auto=format&fit=crop&q=80'},
  ];

  final List<Map<String, dynamic>> _friendUsers = [
    {'rank': 1, 'name': '李明', 'lp': 3540, 'streak': 15, 'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80'},
    {'rank': 2, 'name': '张华', 'lp': 3100, 'streak': 12, 'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=80'},
    {'rank': 3, 'name': 'Alex (我)', 'lp': 2450, 'streak': 7, 'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80', 'isMe': true},
    {'rank': 4, 'name': '王强', 'lp': 2390, 'streak': 8, 'avatarUrl': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=80'},
  ];

  void _giveClap(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('👏 已为 $name 学习加油鼓掌！'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final users = _isGlobal ? _globalUsers : _friendUsers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习榜单'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildMyRankCard(isDark),
          _buildRankingToggle(isDark),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserRankRow(user, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 顶部：我当前的排名卡片
  Widget _buildMyRankCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D20) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2B3035) : const Color(0xFFE9ECEF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 排名
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的排名',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '#12',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                  const Text(
                    '名',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 24),
          // 头像昵称
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex (我)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  '段位：白银极光',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          // 能量积分
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '2,450',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              const Text(
                '能量值 LP',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 榜单切换
  Widget _buildRankingToggle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2B3035) : const Color(0xFFECEFEF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildToggleButton('全球排行榜', _isGlobal, () {
                setState(() => _isGlobal = true);
              }, isDark),
            ),
            Expanded(
              child: _buildToggleButton('好友排行榜', !_isGlobal, () {
                setState(() => _isGlobal = false);
              }, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1A1D20) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? (isDark ? Colors.white : AppColors.primary)
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  // 单个排名行项目
  Widget _buildUserRankRow(Map<String, dynamic> user, bool isDark) {
    final rank = user['rank'] as int;
    final name = user['name'] as String;
    final lp = user['lp'] as int;
    final streak = user['streak'] as int;
    final avatarUrl = user['avatarUrl'] as String;
    final isMe = user['isMe'] ?? false;

    // 前三名特殊底色
    Color? rowBgColor;
    Color borderThemeColor = isDark ? const Color(0xFF2B3035) : const Color(0xFFE9ECEF);
    if (!_isGlobal && isMe) {
      rowBgColor = AppColors.primary.withOpacity(0.05);
      borderThemeColor = AppColors.primary.withOpacity(0.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: rowBgColor ?? (isDark ? const Color(0xFF1A1D20) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderThemeColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 排名奖章
          _buildRankBadge(rank),
          const SizedBox(width: 16),
          // 用户头像
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          // 用户名与打卡数
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Color(0xFFF76707), size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '已坚持 $streak天',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 积分 LP 与 鼓掌按钮
          Text(
            '$lp LP',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          if (!isMe)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.thumb_up_outlined, color: Colors.grey, size: 20),
              onPressed: () => _giveClap(name),
            )
          else
            const SizedBox(width: 28), // 占位
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFFFD700),
          shape: BoxShape.circle,
        ),
        child: const Text('🥇', style: TextStyle(fontSize: 16)),
      );
    } else if (rank == 2) {
      return Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFC0C0C0),
          shape: BoxShape.circle,
        ),
        child: const Text('🥈', style: TextStyle(fontSize: 16)),
      );
    } else if (rank == 3) {
      return Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFCD7F32),
          shape: BoxShape.circle,
        ),
        child: const Text('🥉', style: TextStyle(fontSize: 16)),
      );
    } else {
      return SizedBox(
        width: 28,
        child: Text(
          '#$rank',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
