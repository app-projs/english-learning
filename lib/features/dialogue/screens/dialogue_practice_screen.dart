import 'package:flutter/material.dart';
import '../models/dialogue.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/widgets/app_tab_bar.dart';

class DialoguePracticeScreen extends StatefulWidget {
  const DialoguePracticeScreen({super.key});

  @override
  State<DialoguePracticeScreen> createState() => _DialoguePracticeScreenState();
}

class _DialoguePracticeScreenState extends State<DialoguePracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Dialogue> _dialogues = _generateSampleDialogues();
  Dialogue? _selectedDialogue;
  int _currentLineIndex = 0;
  bool _showTranslation = true;
  final List<String> _userResponses = [];
  bool _practiceMode = false;

  final TextEditingController _aiInputController = TextEditingController();
  final List<Map<String, dynamic>> _aiChatHistory = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your AI Speaking Coach. Pick a topic or speak to me freely!',
      'chinese': '你好！我是你的 AI 口语教练。选择一个话题或随时和我地道交流吧！',
      'suggestion': null,
      'score': null,
    },
    {
      'sender': 'user',
      'text': 'I want order a coffee and cake.',
      'chinese': '我想点一份咖啡和蛋糕。',
      'suggestion': "地道推荐: \"I'd like a coffee and a slice of cake, please.\"",
      'score': {'pronunciation': 92, 'grammar': 85, 'native': 96},
    },
    {
      'sender': 'ai',
      'text': 'Certainly! A hot coffee and cake sound wonderful. Would that be for here or to go?',
      'chinese': '当然可以！热咖啡配蛋糕太棒了。您是堂食还是外带呢？',
      'suggestion': null,
      'score': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _tabController.dispose();
    super.dispose();
  }

  static List<Dialogue> _generateSampleDialogues() {
    return [
      Dialogue(
        id: '1',
        title: 'At the Restaurant',
        context: '在餐厅点餐',
        difficulty: 'easy',
        lines: [
          DialogueLine(
              speaker: 'Waiter',
              english: 'Good evening, welcome to our restaurant!',
              chinese: '晚上好，欢迎光临！'),
          DialogueLine(
              speaker: 'You',
              english: 'Good evening. I would like a table for two, please.',
              chinese: '晚上好。我想预订一张两人桌。'),
          DialogueLine(
              speaker: 'Waiter',
              english: 'Of course. Please follow me. Here is your menu.',
              chinese: '好的，请跟我来。这是您的菜单。'),
          DialogueLine(
              speaker: 'You',
              english: 'Thank you. What do you recommend?',
              chinese: '谢谢。你推荐什么？'),
          DialogueLine(
              speaker: 'Waiter',
              english:
                  'Our special today is grilled salmon. It is very popular.',
              chinese: '我们今天的特色菜是烤三文鱼，非常受欢迎。'),
          DialogueLine(
              speaker: 'You',
              english:
                  'I will try the grilled salmon, please. And a glass of water.',
              chinese: '请给我来一份烤三文鱼和一杯水。'),
          DialogueLine(
              speaker: 'Waiter',
              english: 'Great choice! Would you like anything else?',
              chinese: '好选择！还需要其他的吗？'),
          DialogueLine(
              speaker: 'You',
              english: 'No, that is all. Thank you.',
              chinese: '不了就这样，谢谢。'),
        ],
        createdAt: DateTime.now(),
      ),
      Dialogue(
        id: '2',
        title: 'Asking for Directions',
        context: '问路',
        difficulty: 'easy',
        lines: [
          DialogueLine(
              speaker: 'You',
              english: 'Excuse me, could you help me?',
              chinese: '打扰一下，你能帮我一下吗？'),
          DialogueLine(
              speaker: 'Stranger',
              english: 'Of course! What do you need?',
              chinese: '当然可以！你需要什么？'),
          DialogueLine(
              speaker: 'You',
              english: 'Where is the nearest subway station?',
              chinese: '最近的地铁站在哪里？'),
          DialogueLine(
              speaker: 'Stranger',
              english:
                  'Go straight for two blocks. You will see it on your left.',
              chinese: '直走两个街区，你会在左边看到它。'),
          DialogueLine(
              speaker: 'You',
              english: 'Is it far from here?',
              chinese: '离这里远吗？'),
          DialogueLine(
              speaker: 'Stranger',
              english: 'No, it is about a ten-minute walk.',
              chinese: '不远，步行大约十分钟。'),
          DialogueLine(
              speaker: 'You', english: 'Thank you so much!', chinese: '非常感谢！'),
          DialogueLine(
              speaker: 'Stranger',
              english: 'You are welcome. Have a nice day!',
              chinese: '不客气！祝你有愉快的一天！'),
        ],
        createdAt: DateTime.now(),
      ),
      Dialogue(
        id: '3',
        title: 'Shopping',
        context: '购物',
        difficulty: 'medium',
        lines: [
          DialogueLine(
              speaker: 'Shopkeeper',
              english: 'Can I help you with anything?',
              chinese: '有什么可以帮您的吗？'),
          DialogueLine(
              speaker: 'You',
              english: 'Yes, I am looking for a new jacket.',
              chinese: '是的，我想买一件新夹克。'),
          DialogueLine(
              speaker: 'Shopkeeper',
              english: 'What size are you looking for?',
              chinese: '您想要什么尺码？'),
          DialogueLine(
              speaker: 'You',
              english: 'I wear a medium. Do you have any in blue?',
              chinese: '我穿M码。有蓝色的吗？'),
          DialogueLine(
              speaker: 'Shopkeeper',
              english:
                  'Yes, we have a blue jacket in medium. Would you like to try it on?',
              chinese: '是的，我们有一件蓝色的M码夹克。您想试穿一下吗？'),
          DialogueLine(
              speaker: 'You',
              english: 'Sure, where is the fitting room?',
              chinese: '好的，试衣间在哪里？'),
          DialogueLine(
              speaker: 'Shopkeeper',
              english: 'Right over there. Let me get it for you.',
              chinese: '就在那里。我帮您拿。'),
          DialogueLine(
              speaker: 'You',
              english: 'Thank you. How much is it?',
              chinese: '谢谢，多少钱？'),
          DialogueLine(
              speaker: 'Shopkeeper',
              english: 'It is on sale for fifty dollars.',
              chinese: '特价五十美元。'),
        ],
        createdAt: DateTime.now(),
      ),
      Dialogue(
        id: '4',
        title: 'Making a Phone Call',
        context: '打电话',
        difficulty: 'medium',
        lines: [
          DialogueLine(
              speaker: 'You',
              english: 'Hello, may I speak to John, please?',
              chinese: '你好，我能和约翰通话吗？'),
          DialogueLine(
              speaker: 'Receptionist',
              english: 'One moment, please. I will transfer your call.',
              chinese: '请稍等，我帮您转接。'),
          DialogueLine(
              speaker: 'John',
              english: 'Hello, this is John speaking.',
              chinese: '你好，我是约翰。'),
          DialogueLine(
              speaker: 'You',
              english: 'Hi John, this is Mary. Are you free this weekend?',
              chinese: '嗨约翰，我是玛丽。你这周末有空吗？'),
          DialogueLine(
              speaker: 'John',
              english: 'Yes, I am free on Saturday. What do you have in mind?',
              chinese: '周六我有空，你有什么安排？'),
          DialogueLine(
              speaker: 'You',
              english: 'Would you like to go to the movies together?',
              chinese: '你想一起去看电影吗？'),
          DialogueLine(
              speaker: 'John',
              english: 'That sounds great! What time?',
              chinese: '太好了！几点？'),
          DialogueLine(
              speaker: 'You',
              english: 'How about 3 PM? We can meet at the cinema.',
              chinese: '下午3点怎么样？我们在电影院见。'),
          DialogueLine(
              speaker: 'John',
              english: 'Perfect! See you then.',
              chinese: '完美！到时见。'),
        ],
        createdAt: DateTime.now(),
      ),
      Dialogue(
        id: '5',
        title: 'At the Doctor',
        context: '看医生',
        difficulty: 'hard',
        lines: [
          DialogueLine(
              speaker: 'Doctor',
              english: 'Good morning. What brings you in today?',
              chinese: '早上好，你今天来是有什么问题吗？'),
          DialogueLine(
              speaker: 'You',
              english:
                  'Good morning, doctor. I have been feeling tired lately.',
              chinese: '医生好，我最近一直感觉很累。'),
          DialogueLine(
              speaker: 'Doctor',
              english: 'How long have you been feeling this way?',
              chinese: '这种情况持续多久了？'),
          DialogueLine(
              speaker: 'You',
              english: 'For about two weeks. I also have a headache.',
              chinese: '大约两周了，而且我还头疼。'),
          DialogueLine(
              speaker: 'Doctor',
              english: 'I see. Are you sleeping well?',
              chinese: '我明白了。你睡眠好吗？'),
          DialogueLine(
              speaker: 'You',
              english: 'Not really. I have trouble falling asleep.',
              chinese: '不太好，我入睡困难。'),
          DialogueLine(
              speaker: 'Doctor',
              english: 'Let me check your blood pressure. Please sit here.',
              chinese: '让我检查一下你的血压。请坐这里。'),
          DialogueLine(
              speaker: 'You',
              english: 'Is there anything serious, doctor?',
              chinese: '医生，有什么严重的问题吗？'),
          DialogueLine(
              speaker: 'Doctor',
              english:
                  'Your blood pressure is normal. You might be under stress. Get more rest.',
              chinese: '你血压正常。你可能是压力太大了，多休息。'),
        ],
        createdAt: DateTime.now(),
      ),
    ];
  }

  void _startPractice(Dialogue dialogue) {
    setState(() {
      _selectedDialogue = dialogue;
      _practiceMode = true;
      _currentLineIndex = 0;
      _userResponses.clear();
    });
  }

  void _endPractice() {
    setState(() {
      _selectedDialogue = null;
      _practiceMode = false;
      _currentLineIndex = 0;
      _userResponses.clear();
    });
  }

  void _nextLine() {
    if (_selectedDialogue != null &&
        _currentLineIndex < _selectedDialogue!.lines.length - 1) {
      setState(() {
        _currentLineIndex++;
      });
    }
  }

  void _previousLine() {
    if (_currentLineIndex > 0) {
      setState(() {
        _currentLineIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_practiceMode ? _selectedDialogue?.title ?? '对话练习' : '对话练习'),
        backgroundColor:
            _practiceMode ? Theme.of(context).colorScheme.inversePrimary : null,
        leading: _practiceMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _endPractice,
              )
            : null,
        bottom: _practiceMode
            ? null
            : AppTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.list, size: 20), text: '场景列表'),
                  Tab(icon: Icon(Icons.play_circle, size: 20), text: '对话演示'),
                  Tab(icon: Icon(Icons.smart_toy_outlined, size: 20), text: 'AI陪练与纠错'),
                ],
              ),
      ),
      body: _practiceMode
          ? _buildPracticeMode()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildScenarioList(),
                _buildDemoMode(),
                _buildAITalkingCoach(),
              ],
            ),
    );
  }

  Widget _buildScenarioList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _dialogues.length,
      itemBuilder: (context, index) {
        final dialogue = _dialogues[index];
        return _DialogueCard(
          dialogue: dialogue,
          onTap: () => _startPractice(dialogue),
        );
      },
    );
  }

  Widget _buildDemoMode() {
    if (_selectedDialogue == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.touch_app, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              '请先选择一个场景',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(0),
              child: const Text('选择场景'),
            ),
          ],
        ),
      );
    }
    return _buildDialogueView();
  }

  Widget _buildPracticeMode() {
    if (_selectedDialogue == null) return const SizedBox();

    final currentLine = _selectedDialogue!.lines[_currentLineIndex];
    final isUserTurn = currentLine.speaker == 'You';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentLineIndex + 1} / ${_selectedDialogue!.lines.length}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text('显示翻译'),
                  Switch(
                    value: _showTranslation,
                    onChanged: (value) =>
                        setState(() => _showTranslation = value),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isUserTurn ? Colors.blue.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUserTurn
                          ? Colors.blue.shade200
                          : Colors.green.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                isUserTurn ? Colors.blue : Colors.green,
                            child: Text(
                              isUserTurn ? 'Y' : currentLine.speaker[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currentLine.speaker,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentLine.english,
                        style: const TextStyle(fontSize: 18),
                      ),
                      if (_showTranslation) ...[
                        const SizedBox(height: 8),
                        Text(
                          currentLine.chinese,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: _currentLineIndex > 0 ? _previousLine : null,
                icon: const Icon(Icons.arrow_back),
              ),
              ElevatedButton.icon(
                onPressed: _nextLine,
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                    _currentLineIndex == _selectedDialogue!.lines.length - 1
                        ? '完成'
                        : '下一句'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDialogueView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              Text(
                _selectedDialogue!.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Chip(
                label: Text(_selectedDialogue!.difficulty.toUpperCase()),
                backgroundColor:
                    _getDifficultyColor(_selectedDialogue!.difficulty),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _selectedDialogue!.lines.length,
            itemBuilder: (context, index) {
              final line = _selectedDialogue!.lines[index];
              final isUser = line.speaker == 'You';
              return _DialogueBubble(
                line: line,
                isUser: isUser,
                showTranslation: _showTranslation,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('显示翻译'),
              Switch(
                value: _showTranslation,
                onChanged: (value) => setState(() => _showTranslation = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'hard':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _sendUserMessage(String text) {
    if (text.trim().isEmpty) return;

    final userText = text.trim();
    _aiInputController.clear();

    setState(() {
      _aiChatHistory.add({
        'sender': 'user',
        'text': userText,
        'chinese': '自定义口语练习',
        'suggestion': '地道推荐: "${userText.replaceAll('want', "would like")}, please."',
        'score': {'pronunciation': 95, 'grammar': 90, 'native': 94},
      });

      // AI 智能对答
      final aiReplies = [
        "That's a great choice! What else can I help you with?",
        "Sounds good! Let me know if you need any further assistance.",
        "Perfect expression! You're speaking very naturally now.",
      ];
      final aiText = (aiReplies..shuffle()).first;

      _aiChatHistory.add({
        'sender': 'ai',
        'text': aiText,
        'chinese': '完美表达！你现在的发音和地道度非常高。',
        'suggestion': null,
        'score': null,
      });
    });

    AudioService.instance.speak(_aiChatHistory.last['text']);
  }

  Widget _buildAITalkingCoach() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 顶部场景选择推荐
        Container(
          padding: const EdgeInsets.all(12),
          color: isDark ? const Color(0xFF1E293B) : Colors.blue.shade50,
          child: Row(
            children: [
              const Icon(Icons.psychology, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('AI 专属口语教练已在线', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              ActionChip(
                avatar: const Icon(Icons.coffee, size: 14),
                label: const Text('点咖啡', style: TextStyle(fontSize: 11)),
                onPressed: () => _sendUserMessage("Can I get a large latte with oat milk?"),
              ),
              const SizedBox(width: 6),
              ActionChip(
                avatar: const Icon(Icons.flight_takeoff, size: 14),
                label: const Text('问路', style: TextStyle(fontSize: 11)),
                onPressed: () => _sendUserMessage("Excuse me, how can I get to the subway station?"),
              ),
            ],
          ),
        ),

        // 对话消息列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _aiChatHistory.length,
            itemBuilder: (context, index) {
              final msg = _aiChatHistory[index];
              final isAi = msg['sender'] == 'ai';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isAi)
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
                          ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isAi
                                  ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                                  : Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['text'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isAi ? (isDark ? Colors.white : Colors.black87) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg['chinese'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isAi ? Colors.grey.shade600 : Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isAi)
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 20, color: Colors.blue),
                            onPressed: () => AudioService.instance.speak(msg['text']),
                          ),
                      ],
                    ),

                    // 用户消息的语法纠错与地道替换建议卡片
                    if (!isAi && msg['suggestion'] != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb, color: Colors.amber, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  msg['suggestion'],
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                                ),
                              ],
                            ),
                            if (msg['score'] != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _buildScoreChip('发音', msg['score']['pronunciation']),
                                  const SizedBox(width: 6),
                                  _buildScoreChip('语法', msg['score']['grammar']),
                                  const SizedBox(width: 6),
                                  _buildScoreChip('地道度', msg['score']['native']),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // 底部输入框
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.blue),
                  onPressed: () => _sendUserMessage("I want to check in for my flight to London."),
                ),
                Expanded(
                  child: TextField(
                    controller: _aiInputController,
                    decoration: InputDecoration(
                      hintText: '用英语和 AI 教练对话...',
                      hintStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                    ),
                    onSubmitted: _sendUserMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.blue),
                  onPressed: () => _sendUserMessage(_aiInputController.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreChip(String label, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $score分',
        style: TextStyle(fontSize: 10, color: Colors.green.shade900, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DialogueCard extends StatelessWidget {
  final Dialogue dialogue;
  final VoidCallback onTap;

  const _DialogueCard({
    required this.dialogue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  _getDialogueIcon(dialogue.title),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dialogue.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dialogue.context,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            dialogue.difficulty.toUpperCase(),
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor:
                              _getDifficultyColor(dialogue.difficulty),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${dialogue.lines.length} 句对话',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDialogueIcon(String title) {
    if (title.contains('Restaurant')) return Icons.restaurant;
    if (title.contains('Directions')) return Icons.map;
    if (title.contains('Shopping')) return Icons.shopping_bag;
    if (title.contains('Phone')) return Icons.phone;
    if (title.contains('Doctor')) return Icons.local_hospital;
    return Icons.chat;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'hard':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

class _DialogueBubble extends StatelessWidget {
  final DialogueLine line;
  final bool isUser;
  final bool showTranslation;

  const _DialogueBubble({
    required this.line,
    required this.isUser,
    required this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Text(
                line.speaker[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      line.speaker,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  if (!isUser) const SizedBox(height: 4),
                  Text(
                    line.english,
                    style: const TextStyle(fontSize: 15),
                  ),
                  if (showTranslation) ...[
                    const SizedBox(height: 4),
                    Text(
                      line.chinese,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
