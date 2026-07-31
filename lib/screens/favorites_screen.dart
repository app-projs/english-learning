import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../mock/mock_words.dart';
import '../mock/mock_articles.dart';
import '../theme/lumina_theme.dart';
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
    final favoriteContexts = _storageService!.getAllFavoriteContexts();

    final List<Map<String, dynamic>> wordList = [];
    for (final id in wordIds) {
      final word = MockWords.getWordById(id);
      final ctx = favoriteContexts[id.toLowerCase()];
      if (word != null) {
        wordList.add({
          'id': word.id,
          'english': word.english,
          'chinese': word.chinese,
          'phonetic': word.phonetic,
          'articleTitle': ctx?['articleTitle'],
          'sentence': ctx?['sentence'],
          'articleId': ctx?['articleId'],
        });
      } else {
        wordList.add({
          'id': id,
          'english': id,
          'chinese': '生词本精选词',
          'phonetic': '/$id/',
          'articleTitle': ctx?['articleTitle'],
          'sentence': ctx?['sentence'],
          'articleId': ctx?['articleId'],
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
    AudioService.instance.stop();
    _tabController.dispose();
    super.dispose();
  }

  void _exportFavorites() {
    if (_wordFavorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无已收藏单词')),
      );
      return;
    }

    final dateStr = DateTime.now().toString().split(' ')[0];
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('==========================================');
    buffer.writeln('  Lumina English · 英语生词备考打印清单');
    buffer.writeln('  生成日期: $dateStr  |  总词汇量: ${_wordFavorites.length} 个');
    buffer.writeln('==========================================\n');

    for (int i = 0; i < _wordFavorites.length; i++) {
      final w = _wordFavorites[i];
      buffer.writeln('${(i + 1).toString().padLeft(2, '0')}. ${w['english']}   ${w['phonetic']}');
      buffer.writeln('    释义: ${w['chinese']}');
      if (w['articleTitle'] != null && (w['articleTitle'] as String).isNotEmpty) {
        buffer.writeln('    出处: 《${w['articleTitle']}》');
      }
      buffer.writeln('------------------------------------------');
    }

    final text = buffer.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('生词本备考清单导出'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.print_rounded, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '标准 A4 打印单已生成 ($dateStr)，支持 TXT 导出与剪贴板复制。',
                          style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  text,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已成功复制 A4 备考清单到剪贴板！')),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('一键复制'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: [
          IconButton(
            onPressed: _exportFavorites,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: '导出 A4 生词清单',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: Colors.blue),
              insets: EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            tabs: const [
              Tab(text: '单词'),
              Tab(text: '文章'),
            ],
          ),
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
        final hasContext = word['articleTitle'] != null && (word['articleTitle'] as String).isNotEmpty;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                word['english'] ?? '',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                word['phonetic'] ?? '',
                                style: LuminaTheme.ipaStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            word['chinese'] ?? '',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.blue),
                      onPressed: () => AudioService.instance.speak(word['english'] ?? ''),
                    ),
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
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已取消收藏')),
                        );
                      },
                    ),
                  ],
                ),
                if (hasContext) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            final artIdStr = word['articleId'] ?? '';
                            final fullArticle = MockArticles.getArticles().where((a) => a.id.toString() == artIdStr || a.title == word['articleTitle'] || a.chineseTitle == word['articleTitle']).firstOrNull;
                            if (fullArticle != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: fullArticle)),
                              ).then((_) => _loadFavorites());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('出处: 《${word['articleTitle']}》')),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.menu_book_rounded, size: 15, color: Colors.amber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '出处文章: 《${word['articleTitle']}》',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 18, color: Colors.amber.shade800),
                            ],
                          ),
                        ),
                        if (word['sentence'] != null && (word['sentence'] as String).isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '“${word['sentence']}”',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Colors.brown.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
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
                          if (!mounted) return;
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
