import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/audio_service.dart';
import '../../word/mock/mock_words.dart';
import '../../../features/article/mock/mock_articles.dart';
import '../../../core/theme/lumina_theme.dart';
import '../../../features/article/screens/article_detail_screen.dart';

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

  // 智能音频连播与听写模式状态
  bool _isAutoLooping = false;
  int _autoLoopIndex = 0;
  bool _isDictationMode = false;
  int _dictationIndex = 0;
  final TextEditingController _dictationInputController = TextEditingController();
  bool? _dictationIsCorrect;
  final ScrollController _scrollController = ScrollController();

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
    _isAutoLooping = false;
    AudioService.instance.stop();
    _tabController.dispose();
    _dictationInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleAutoLoop() {
    if (_wordFavorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无已收藏单词可连播')),
      );
      return;
    }
    setState(() {
      _isAutoLooping = !_isAutoLooping;
      if (_isAutoLooping) {
        _autoLoopIndex = 0;
        _startAutoLoopNext();
      } else {
        AudioService.instance.stop();
      }
    });
  }

  Future<void> _startAutoLoopNext() async {
    if (!_isAutoLooping || !mounted || _wordFavorites.isEmpty) return;

    if (_autoLoopIndex >= _wordFavorites.length) {
      _autoLoopIndex = 0;
    }

    final word = _wordFavorites[_autoLoopIndex];
    final english = (word['english'] ?? '').toString();

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        (_autoLoopIndex * 90.0).clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    setState(() {});

    if (english.isNotEmpty) {
      AudioService.instance.speak(english);
    }

    await Future.delayed(const Duration(seconds: 3));
    if (!_isAutoLooping || !mounted) return;

    _autoLoopIndex++;
    _startAutoLoopNext();
  }

  void _toggleDictationMode() {
    if (_wordFavorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无已收藏单词进行听写')),
      );
      return;
    }
    setState(() {
      _isDictationMode = !_isDictationMode;
      _dictationIndex = 0;
      _dictationIsCorrect = null;
      _dictationInputController.clear();
      if (_isDictationMode) {
        _playDictationAudio();
      }
    });
  }

  void _playDictationAudio() {
    if (_wordFavorites.isEmpty || _dictationIndex >= _wordFavorites.length) return;
    final english = (_wordFavorites[_dictationIndex]['english'] ?? '').toString();
    AudioService.instance.speak(english);
  }

  void _checkDictationAnswer() {
    if (_wordFavorites.isEmpty || _dictationIndex >= _wordFavorites.length) return;
    final target = (_wordFavorites[_dictationIndex]['english'] ?? '').toString().trim().toLowerCase();
    final input = _dictationInputController.text.trim().toLowerCase();

    setState(() {
      _dictationIsCorrect = (input == target);
    });
  }

  void _nextDictationWord() {
    if (_dictationIndex < _wordFavorites.length - 1) {
      setState(() {
        _dictationIndex++;
        _dictationIsCorrect = null;
        _dictationInputController.clear();
      });
      _playDictationAudio();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 恭喜！生词本听写测试全部完成！')),
      );
      setState(() {
        _isDictationMode = false;
      });
    }
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
            onPressed: _toggleAutoLoop,
            icon: Icon(
              _isAutoLooping ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: _isAutoLooping ? Colors.amberAccent : null,
            ),
            tooltip: _isAutoLooping ? '暂停连播' : '智能音频连播',
          ),
          IconButton(
            onPressed: _toggleDictationMode,
            icon: Icon(
              _isDictationMode ? Icons.list_alt_rounded : Icons.edit_note_rounded,
              color: _isDictationMode ? Colors.greenAccent : null,
            ),
            tooltip: _isDictationMode ? '返回列表' : '听写强化模式',
          ),
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
                _isDictationMode ? _buildDictationView() : _buildWordFavorites(),
                _buildArticleFavorites(),
              ],
            ),
    );
  }

  Widget _buildWordFavorites() {
    if (_wordFavorites.isEmpty) {
      return _buildEmptyState('暂无收藏单词', '在单词练习中点击心形图标收藏');
    }

    return Column(
      children: [
        if (_isAutoLooping) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.amber.shade100,
            child: Row(
              children: [
                const Icon(Icons.volume_up_rounded, color: Colors.brown, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '🎧 智能发音连播中 (${_autoLoopIndex + 1}/${_wordFavorites.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown),
                  ),
                ),
                TextButton.icon(
                  onPressed: _toggleAutoLoop,
                  icon: const Icon(Icons.pause, size: 16, color: Colors.brown),
                  label: const Text('暂停', style: TextStyle(color: Colors.brown)),
                ),
              ],
            ),
          ),
        ],
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _wordFavorites.length,
            itemBuilder: (context, index) {
              final word = _wordFavorites[index];
              final isCurrentPlaying = _isAutoLooping && _autoLoopIndex == index;
              final hasContext = word['articleTitle'] != null && (word['articleTitle'] as String).isNotEmpty;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: isCurrentPlaying
                      ? const BorderSide(color: Colors.amber, width: 2.5)
                      : BorderSide.none,
                ),
                elevation: isCurrentPlaying ? 6 : 2,
                color: isCurrentPlaying ? Colors.amber.shade50 : null,
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
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrentPlaying ? Colors.amber.shade900 : null,
                                      ),
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
          ),
        ),
      ],
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

  Widget _buildDictationView() {
    if (_wordFavorites.isEmpty || _dictationIndex >= _wordFavorites.length) {
      return const Center(child: Text('暂无听写数据'));
    }

    final word = _wordFavorites[_dictationIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '✍️ 生词听写测试 (${_dictationIndex + 1} / ${_wordFavorites.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.blue, size: 28),
                onPressed: _playDictationAudio,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '音标: ${word['phonetic'] ?? ''}',
                    style: LuminaTheme.ipaStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '释义: ${word['chinese'] ?? ''}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 24,
                    indent: 8,
                    endIndent: 8,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                  TextField(
                    controller: _dictationInputController,
                    decoration: InputDecoration(
                      hintText: '请输入听到的英文单词...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.blue),
                        onPressed: _checkDictationAnswer,
                      ),
                    ),
                    onSubmitted: (_) => _checkDictationAnswer(),
                  ),
                  if (_dictationIsCorrect != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _dictationIsCorrect! ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _dictationIsCorrect! ? Colors.green.shade300 : Colors.red.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _dictationIsCorrect! ? Icons.check_circle : Icons.cancel,
                            color: _dictationIsCorrect! ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _dictationIsCorrect!
                                  ? '🎉 拼写正确！完全掌握！'
                                  : '❌ 拼写有误，正确拼写为：${word['english']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _dictationIsCorrect! ? Colors.green.shade900 : Colors.red.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _playDictationAudio,
                icon: const Icon(Icons.replay),
                label: const Text('重听'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _nextDictationWord,
                icon: const Icon(Icons.arrow_forward),
                label: Text(_dictationIndex < _wordFavorites.length - 1 ? '下一题' : '完成听写'),
              ),
            ],
          ),
        ],
      ),
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
