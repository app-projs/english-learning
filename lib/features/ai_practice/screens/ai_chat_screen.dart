import 'package:flutter/material.dart';
import '../models/ai_scenario_model.dart';
import '../models/ai_chat_message_model.dart';
import '../services/ai_practice_service.dart';
import '../../../core/services/audio_service.dart';

class AiChatScreen extends StatefulWidget {
  final AiScenarioModel scenario;

  const AiChatScreen({super.key, required this.scenario});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<AiChatMessageModel> _messages = [];
  List<String> _hints = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _showTranslationAll = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final msgs = await AiPracticeService.instance.getChatHistory(widget.scenario.id);
    final hints = AiPracticeService.instance.getAiHints(widget.scenario.id);

    if (mounted) {
      setState(() {
        _messages = msgs;
        _hints = hints;
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage([String? textOverride]) async {
    final text = textOverride ?? _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    if (textOverride == null) {
      _inputController.clear();
    }

    setState(() {
      _isSending = true;
    });

    // 1. 发送用户消息并评估
    final userMsg = await AiPracticeService.instance.sendUserMessage(
      scenarioId: widget.scenario.id,
      userMessage: text,
    );

    setState(() {
      _messages.add(userMsg);
    });
    _scrollToBottom();

    // 2. 模拟 AI 思考延迟 (1000ms)
    await Future.delayed(const Duration(milliseconds: 800));

    // 3. 生成 AI 回应
    final aiMsg = await AiPracticeService.instance.generateAiResponse(
      scenarioId: widget.scenario.id,
      userMessage: text,
    );

    if (mounted) {
      setState(() {
        _messages.add(aiMsg);
        _isSending = false;
      });
      _scrollToBottom();
      // 自动播放 AI 语音
      AudioService.instance.speak(aiMsg.message);
    }
  }

  Future<void> _handleClearHistory() async {
    await AiPracticeService.instance.clearHistory(widget.scenario.id);
    await _loadMessages();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已清空当前场景的对话记录。'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          children: [
            Text(widget.scenario.avatarIcon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.scenario.chineseTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'AI 角色: ${widget.scenario.aiRole}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showTranslationAll ? Icons.visibility_off_outlined : Icons.translate_rounded,
              color: isDark ? Colors.white70 : const Color(0xFF2563EB),
            ),
            tooltip: _showTranslationAll ? '隐藏全局译文' : '展开全局译文',
            onPressed: () {
              setState(() {
                _showTranslationAll = !_showTranslationAll;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              if (val == 'clear') _handleClearHistory();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('清空对话历史', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 场景目标指示线
          _buildScenarioHeaderBanner(isDark),

          // 消息列
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageItem(_messages[index], isDark);
                    },
                  ),
          ),

          if (_isSending)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.scenario.aiRole} 正在输入...',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

          // AI Hints 提示区
          if (_hints.isNotEmpty) _buildAiHintsRow(isDark),

          // 底部输入栏
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildScenarioHeaderBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, size: 15, color: Color(0xFF2563EB)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '提示: 发送任意表达，AI 将自动分析语法并提供地道 Native 改写建议。',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(AiChatMessageModel msg, bool isDark) {
    final isAi = msg.sender == 'ai';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAi) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.12),
              child: Text(widget.scenario.avatarIcon, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isAi
                        ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                        : const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(18).copyWith(
                      topLeft: isAi ? Radius.zero : null,
                      topRight: !isAi ? Radius.zero : null,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.message,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: isAi
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      if (isAi) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => AudioService.instance.speak(msg.message),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.volume_up_rounded,
                                    size: 15,
                                    color: Color(0xFF2563EB),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '朗读发音',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],

                      // 全局译文展露
                      if ((_showTranslationAll || !isAi) && msg.translation != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          msg.translation!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isAi
                                ? (isDark ? Colors.white54 : Colors.grey.shade600)
                                : Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 用户消息分析指示面板 (AI Grammar Score & Native Rephrasing)
                if (!isAi && msg.grammarScore != null) ...[
                  const SizedBox(height: 6),
                  _buildUserGrammarBadge(msg, isDark),
                ],
              ],
            ),
          ),

          if (!isAi) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange.shade100,
              child: const Icon(Icons.person, size: 20, color: Colors.orange),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserGrammarBadge(AiChatMessageModel msg, bool isDark) {
    final score = msg.grammarScore!;
    final isHigh = score >= 90;

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isHigh
            ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5))
            : (isDark ? const Color(0xFF78350F) : const Color(0xFFFFFBEB)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHigh ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isHigh ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                size: 14,
                color: isHigh ? Colors.green.shade700 : Colors.amber.shade900,
              ),
              const SizedBox(width: 6),
              Text(
                'AI 评估: $score 分 (${isHigh ? "地道规范" : "语法提示"})',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isHigh ? Colors.green.shade900 : Colors.amber.shade900,
                ),
              ),
            ],
          ),
          if (msg.corrections != null) ...[
            const SizedBox(height: 4),
            Text(
              msg.corrections!,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.brown.shade800,
              ),
            ),
          ],
          if (msg.nativeSuggestion != null) ...[
            const SizedBox(height: 4),
            Text(
              msg.nativeSuggestion!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF6EE7B7) : Colors.green.shade800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAiHintsRow(bool isDark) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _hints.length,
        itemBuilder: (context, index) {
          final hint = _hints[index];
          return GestureDetector(
            onTap: () => _handleSendMessage(hint),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, size: 13, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    hint,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSendMessage(),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '用英文发送回复，AI 将实时诊断...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.send_rounded, size: 20),
              onPressed: () => _handleSendMessage(),
            ),
          ],
        ),
      ),
    );
  }
}
