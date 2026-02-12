import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _showTranslation = false;
  double _fontSize = 16.0;
  int _currentSentenceIndex = 0;

  List<String> _sentences = [];

  @override
  void initState() {
    super.initState();
    _splitSentences();
  }

  void _splitSentences() {
    _sentences = widget.article.content.split(RegExp(r'(?<=[.!?])\s+'));
  }

  void _toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void _adjustFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(12.0, 24.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: [
          IconButton(
            icon: Icon(
                _showTranslation ? Icons.translate : Icons.translate_outlined),
            onPressed: _toggleTranslation,
            tooltip: '显示/隐藏翻译',
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () => _adjustFontSize(1.0),
            tooltip: '增大字体',
          ),
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () => _adjustFontSize(-1.0),
            tooltip: '减小字体',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildArticleInfo(),
          _buildProgressBar(),
          Expanded(
            child: _buildArticleContent(),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildArticleInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Chip(
            label: Text(widget.article.difficulty),
            backgroundColor: _getDifficultyColor(widget.article.difficulty),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.schedule, size: 16),
          const SizedBox(width: 4),
          Text('${widget.article.readTime} 分钟阅读'),
          const Spacer(),
          Text(
            '字体大小: ${_fontSize.toInt()}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentSentenceIndex + 1) / _sentences.length,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildArticleContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.article.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._sentences.asMap().entries.map((entry) {
            int index = entry.key;
            String sentence = entry.value;
            return _SentenceBlock(
              sentence: sentence,
              index: index,
              currentIndex: _currentSentenceIndex,
              fontSize: _fontSize,
              showTranslation: _showTranslation,
              onTap: () {
                setState(() {
                  _currentSentenceIndex = index;
                });
              },
              translation: _getSentenceTranslation(sentence),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentSentenceIndex > 0
                  ? () {
                      setState(() {
                        _currentSentenceIndex--;
                      });
                    }
                  : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('上一句'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentSentenceIndex < _sentences.length - 1
                  ? () {
                      setState(() {
                        _currentSentenceIndex++;
                      });
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('下一句'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getSentenceTranslation(String sentence) {
    Map<String, String> translations = {
      'Reading books in English can significantly improve your language skills...':
          '阅读英文书籍可以显著提高你的语言技能...',
      'Speaking English fluently requires practice and dedication...':
          '流利地说英语需要练习和专注...',
      'Mastering English grammar takes time and effort...': '掌握英语语法需要时间和努力...',
    };
    return translations[sentence] ?? '翻译功能开发中...';
  }
}

class _SentenceBlock extends StatelessWidget {
  final String sentence;
  final int index;
  final int currentIndex;
  final double fontSize;
  final bool showTranslation;
  final VoidCallback onTap;
  final String translation;

  const _SentenceBlock({
    required this.sentence,
    required this.index,
    required this.currentIndex,
    required this.fontSize,
    required this.showTranslation,
    required this.onTap,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    final isHighlighted = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.yellow[100] : Colors.transparent,
          border: isHighlighted ? Border.all(color: Colors.yellow[600]!) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sentence,
              style: TextStyle(
                fontSize: fontSize,
                height: 1.5,
                color: isHighlighted ? Colors.black87 : Colors.black,
                fontWeight: isHighlighted ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (showTranslation) ...[
              const SizedBox(height: 8),
              Text(
                translation,
                style: TextStyle(
                  fontSize: fontSize - 2,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
