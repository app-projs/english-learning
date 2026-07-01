import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../mock/mock_words.dart';
import '../mock/mock_articles.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StorageService? _storageService;
  List<Map<String, dynamic>> _wordFavorites = [];
  List<Map<String, dynamic>> _articleFavorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _storageService = await StorageService.getInstance();
    final wordIds = _storageService!.getFavorites();
    final articleIds = _storageService!.getArticleFavorites();

    final List<Map<String, dynamic>> wordList = [];
    for (final id in wordIds) {
      final word = MockWords.getWordById(id);
      if (word != null) {
        wordList.add({
          'id': word.id,
          'english': word.english,
          'chinese': word.chinese,
          'phonetic': word.phonetic,
        });
      }
    }

    final List<Map<String, dynamic>> articleList = [];
    for (final id in articleIds) {
      final article = MockArticles.getArticles().where((a) => a.id == id).firstOrNull;
      if (article != null) {
        articleList.add({
          'id': article.id,
          'title': article.title,
          'difficulty': article.difficulty,
          'tags': article.tags,
        });
      }
    }

    if (mounted) {
      setState(() {
        _wordFavorites = wordList;
        _articleFavorites = articleList;
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
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
            title: Text(word['english'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(word['chinese'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(word['phonetic'] ?? '',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () async {
                    final id = word['id'];
                    setState(() {
                      _wordFavorites.removeAt(index);
                    });
                    if (id != null) {
                      await _storageService?.removeFavorite(id);
                    }
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
              final id = article['id'];
              final fullArticle = MockArticles.getArticles().where((a) => a.id == id).firstOrNull;
              if (fullArticle != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: fullArticle),
                  ),
                ).then((_) {
                  _loadFavorites();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('无法打开文章: ${article['title']}')),
                );
              }
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
                          article['title'] ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          final id = article['id'];
                          setState(() {
                            _articleFavorites.removeAt(index);
                          });
                          if (id != null) {
                            await _storageService?.removeArticleFavorite(id);
                          }
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
                    children: ((article['tags'] ?? []) as List).map<Widget>((tag) {
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
