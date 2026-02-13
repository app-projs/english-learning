import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _wordFavorites = [
    {
      'id': '1',
      'english': 'abandon',
      'chinese': '放弃；遗弃',
      'phonetic': '/əˈbændən/'
    },
    {
      'id': '2',
      'english': 'benefit',
      'chinese': '利益；好处',
      'phonetic': '/ˈbenɪfɪt/'
    },
    {
      'id': '3',
      'english': 'challenge',
      'chinese': '挑战',
      'phonetic': '/ˈtʃælɪndʒ/'
    },
  ];

  final List<Map<String, dynamic>> _articleFavorites = [
    {
      'id': '1',
      'title': 'The Benefits of Reading English Books',
      'difficulty': 'Intermediate',
      'tags': ['Reading', 'Vocabulary']
    },
    {
      'id': '3',
      'title': 'Advanced English Grammar Tips',
      'difficulty': 'Advanced',
      'tags': ['Grammar', 'Advanced']
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '单词'),
            Tab(text: '文章'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWordFavorites(),
          _buildArticleFavorites(),
        ],
      ),
    );
  }

  Widget _buildWordFavorites() {
    if (_wordFavorites.isEmpty) {
      return _buildEmptyState('暂无收藏单词', '在单词练习中点击心形图标收藏');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _wordFavorites.length,
      itemBuilder: (context, index) {
        final word = _wordFavorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(word['english'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(word['chinese']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(word['phonetic'],
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _wordFavorites.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已取消收藏')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticleFavorites() {
    if (_articleFavorites.isEmpty) {
      return _buildEmptyState('暂无收藏文章', '在文章详情中点击收藏按钮');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _articleFavorites.length,
      itemBuilder: (context, index) {
        final article = _articleFavorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('打开: ${article['title']}')),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _articleFavorites.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已取消收藏')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (article['tags'] as List).map<Widget>((tag) {
                      return Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 10)),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(title,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
