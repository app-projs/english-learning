import 'package:flutter/material.dart';
import '../models/dictionary_word_model.dart';
import '../services/audio_service.dart';
import '../services/dictionary_service.dart';
import '../services/storage_service.dart';

/// 全局复用单词详情与气泡弹窗组件
class WordDetailDialog extends StatefulWidget {
  final String rawWord;
  final String? articleTitle;
  final String? sentenceContext;
  final String? articleId;

  const WordDetailDialog({
    super.key,
    required this.rawWord,
    this.articleTitle,
    this.sentenceContext,
    this.articleId,
  });

  /// 全局快捷唤起单词气泡/弹窗入口
  static Future<void> show(
    BuildContext context,
    String rawWord, {
    String? articleTitle,
    String? sentenceContext,
    String? articleId,
  }) async {
    final clean = rawWord.replaceAll(RegExp(r'[^\w\-]'), '').trim();
    if (clean.isEmpty) return;

    // 播放音效发音
    AudioService.instance.speak(clean);

    await showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (ctx) => WordDetailDialog(
        rawWord: clean,
        articleTitle: articleTitle,
        sentenceContext: sentenceContext,
        articleId: articleId,
      ),
    );
  }

  @override
  State<WordDetailDialog> createState() => _WordDetailDialogState();
}

class _WordDetailDialogState extends State<WordDetailDialog> {
  bool _isLoading = true;
  bool _isFavorited = false;
  DictionaryWordModel? _wordDetail;
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _loadWordDetails();
  }

  Future<void> _loadWordDetails() async {
    _storageService = await StorageService.getInstance();
    final lowerWord = widget.rawWord.toLowerCase();
    _isFavorited = _storageService?.getFavorites().contains(lowerWord) ?? false;

    // 从 DictionaryService 中发起三阶逻辑查询 (SQLite -> 词干推导 -> 在线学习落库)
    final detail = await DictionaryService.instance.lookupWordDetail(
      widget.rawWord,
      articleTitle: widget.articleTitle,
    );

    if (mounted) {
      setState(() {
        _wordDetail = detail;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_storageService == null || _wordDetail == null) return;
    final lower = widget.rawWord.toLowerCase();

    if (_isFavorited) {
      await _storageService!.removeFavorite(lower);
    } else {
      await _storageService!.addFavorite(lower);
      await _storageService!.saveFavoriteContext(
        widget.rawWord,
        articleTitle: widget.articleTitle ?? '阅读词汇',
        sentence: widget.sentenceContext ?? '来源于文章精读',
        articleId: widget.articleId,
      );
    }

    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        width: 330,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _isLoading ? _buildLoadingView() : _buildContentBody(isDark),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 2.5),
          SizedBox(height: 16),
          Text(
            '检索字典与词库中...',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBody(bool isDark) {
    final detail = _wordDetail!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 头部：单词 + 朗读 + 收藏
        Row(
          children: [
            Expanded(
              child: Text(
                detail.word,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            IconButton(
              onPressed: () => AudioService.instance.speak(detail.word),
              icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF2563EB), size: 24),
              tooltip: '朗读发音',
            ),
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                _isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isFavorited ? Colors.red.shade500 : Colors.grey,
                size: 24,
              ),
              tooltip: '加入生词本',
            ),
          ],
        ),

        if (detail.phonetic.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            detail.phonetic,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],

        const SizedBox(height: 14),
        Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
        const SizedBox(height: 14),

        // 释义区
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (detail.pos != null && detail.pos!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(right: 8, top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  detail.pos!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            Expanded(
              child: Text(
                detail.chinese,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // 例句（如果有）
        if (detail.example != null && detail.example!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.example!,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
                if (detail.exampleTranslation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    detail.exampleTranslation!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],

        const SizedBox(height: 14),

        // 来源 Chip 标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 14, color: Colors.amber.shade800),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '来源: ${detail.source ?? "词典库"}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 底部“知道了”按钮
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ),
      ],
    );
  }
}
