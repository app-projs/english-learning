import 'dart:async';
import 'dart:math';
import '../models/ai_scenario_model.dart';
import '../models/ai_chat_message_model.dart';
import 'database_service.dart';

class AiPracticeService {
  static final AiPracticeService instance = AiPracticeService._internal();
  AiPracticeService._internal();

  DatabaseService? _dbService;

  Future<void> _ensureInit() async {
    _dbService ??= await DatabaseService.getInstance();
  }

  /// 预置 AI 练习场景列表
  List<AiScenarioModel> getScenarios() {
    return [
      AiScenarioModel(
        id: 'scenario_coffee',
        title: 'Ordering Coffee at Starbucks',
        chineseTitle: '☕ 咖啡馆点餐场景',
        aiRole: 'Barista Alex',
        avatarIcon: '☕',
        difficulty: 'A2 初级基础',
        category: '日常生活',
        systemPrompt: 'You are Alex, a friendly barista at a bustling cafe. Greet the customer warmly and ask for their drink order.',
        initialGreeting: 'Hi there! Welcome to Lumina Cafe. What can I get started for you today?',
        initialGreetingTranslation: '嗨！欢迎光临 Lumina 咖啡馆。今天想喝点什么？',
      ),
      AiScenarioModel(
        id: 'scenario_interview',
        title: 'Job Interview for Software Engineer',
        chineseTitle: '💼 英文求职面试',
        aiRole: 'Interviewer Sarah',
        avatarIcon: '💼',
        difficulty: 'B2 进阶商务',
        category: '职场沟通',
        systemPrompt: 'You are Sarah, a hiring manager conducting a technical interview. Ask polite, professional questions.',
        initialGreeting: 'Good morning! Thank you for taking the time to join this interview. Could you briefly introduce yourself?',
        initialGreetingTranslation: '早上好！感谢参加本次面试。可以先简短做个自我介绍吗？',
      ),
      AiScenarioModel(
        id: 'scenario_airport',
        title: 'Airport Customs Check-in',
        chineseTitle: '✈️ 机场海关问答',
        aiRole: 'Officer David',
        avatarIcon: '✈️',
        difficulty: 'B1 实用出行',
        category: '旅游出行',
        systemPrompt: 'You are Officer David at airport customs. Ask for passports, travel purpose, and stay duration.',
        initialGreeting: 'Next please! May I see your passport and customs declaration form, please?',
        initialGreetingTranslation: '下一位！请出示您的护照和海关申报单。',
      ),
      AiScenarioModel(
        id: 'scenario_free_chat',
        title: 'Free Talk with AI Companion',
        chineseTitle: '🌟 AI 自由口语伴侣',
        aiRole: 'AI Companion Leo',
        avatarIcon: '🤖',
        difficulty: '自由全级',
        category: '日常沟通',
        systemPrompt: 'You are Leo, an encouraging English teacher and chat partner. Talk naturally about any topic.',
        initialGreeting: 'Hey friend! I am Leo, your AI English practice partner. What topic would you like to talk about today?',
        initialGreetingTranslation: '嗨朋友！我是 Leo，你的 AI 口语练琴伙伴。今天想聊些什么？',
      ),
    ];
  }

  /// 获取指定场景的历史对话
  Future<List<AiChatMessageModel>> getChatHistory(String scenarioId) async {
    await _ensureInit();
    final rows = await _dbService!.getAiChatMessages(scenarioId);

    if (rows.isEmpty) {
      // 若历史记录为空，自动插入第一条 AI 初始问候语
      final scenario = getScenarios().firstWhere(
        (s) => s.id == scenarioId,
        orElse: () => getScenarios().first,
      );

      final initialMsg = AiChatMessageModel(
        scenarioId: scenarioId,
        sender: 'ai',
        message: scenario.initialGreeting,
        translation: scenario.initialGreetingTranslation,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      final id = await _dbService!.insertAiChatMessage(initialMsg.toMap());
      return [
        AiChatMessageModel(
          id: id,
          scenarioId: scenarioId,
          sender: 'ai',
          message: scenario.initialGreeting,
          translation: scenario.initialGreetingTranslation,
          createdAt: initialMsg.createdAt,
        ),
      ];
    }

    return rows.map((r) => AiChatMessageModel.fromMap(r)).toList();
  }

  /// 发送用户消息并自动触发 AI 回应与语法诊断
  Future<AiChatMessageModel> sendUserMessage({
    required String scenarioId,
    required String userMessage,
  }) async {
    await _ensureInit();

    // 1. 评估用户的语法与地道表达
    final eval = evaluateUserMessage(userMessage);

    final userMsgModel = AiChatMessageModel(
      scenarioId: scenarioId,
      sender: 'user',
      message: userMessage,
      translation: eval['translation'],
      grammarScore: eval['score'] as int,
      corrections: eval['corrections'],
      nativeSuggestion: eval['nativeSuggestion'],
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _dbService!.insertAiChatMessage(userMsgModel.toMap());
    return userMsgModel;
  }

  /// 生成 AI 智能连贯回复
  Future<AiChatMessageModel> generateAiResponse({
    required String scenarioId,
    required String userMessage,
  }) async {
    await _ensureInit();
    final lowerUser = userMessage.toLowerCase();

    String reply = 'That sounds interesting! Could you tell me more about that?';
    String? translation = '这听起来很有趣！你能跟我多讲讲吗？';

    if (scenarioId == 'scenario_coffee') {
      if (lowerUser.contains('latte') || lowerUser.contains('coffee') || lowerUser.contains('cappuccino')) {
        reply = 'Great choice! Would you like that hot or iced, and what size would you prefer?';
        translation = '太棒的选择！请问要热的还是冰的？需要什么杯型？';
      } else if (lowerUser.contains('hot') || lowerUser.contains('iced') || lowerUser.contains('large')) {
        reply = 'Got it! That will be \$4.50. Will you be paying with card or cash today?';
        translation = '好的收到！一共 4.5 美元。请问今天是刷卡还是付现？';
      } else {
        reply = 'Sure thing! Anything else to eat with your coffee today, like a croissant?';
        translation = '没问题！今天还要加点吃的吗，比如羊角面包？';
      }
    } else if (scenarioId == 'scenario_interview') {
      if (lowerUser.contains('name') || lowerUser.contains('experience') || lowerUser.contains('developer')) {
        reply = 'Impressive background! What would you say is your greatest technical strength?';
        translation = '非常出色的背景！你认为自己最大的技术优势是什么？';
      } else {
        reply = 'Thank you for sharing that! How do you handle tight deadlines under pressure?';
        translation = '感谢分享！你在面对紧迫的截止日期和压力时通常如何处理？';
      }
    } else if (scenarioId == 'scenario_airport') {
      if (lowerUser.contains('here') || lowerUser.contains('passport') || lowerUser.contains('purpose')) {
        reply = 'Thank you. What is the main purpose of your visit to the country?';
        translation = '谢谢。请问您本次入境的主要目的是什么？';
      } else {
        reply = 'Alright! How long do you plan to stay in the city, and where will you be staying?';
        translation = '好的！您计划在此停留多久？打算住在哪里？';
      }
    }

    final aiMsg = AiChatMessageModel(
      scenarioId: scenarioId,
      sender: 'ai',
      message: reply,
      translation: translation,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    final id = await _dbService!.insertAiChatMessage(aiMsg.toMap());
    return AiChatMessageModel(
      id: id,
      scenarioId: scenarioId,
      sender: 'ai',
      message: reply,
      translation: translation,
      createdAt: aiMsg.createdAt,
    );
  }

  /// AI 实时语法评分与 Native 地道表达改写引擎
  Map<String, dynamic> evaluateUserMessage(String input) {
    final clean = input.trim();
    final words = clean.split(RegExp(r'\s+'));
    int score = 95;
    String? corrections;
    String? nativeSuggestion;

    if (words.length <= 2) {
      score = 80;
      corrections = '💡 提示：尝试使用完整的句子表达，不仅能提升流畅度，还能展现更丰富的词汇。';
      nativeSuggestion = 'Native Speaker 常说: "I would like to have a cup of latte, please."';
    } else if (!clean.endsWith('.') && !clean.endsWith('!') && !clean.endsWith('?')) {
      score = 90;
      corrections = '规范点拨：在英文书面/对话输入末尾添加适当的标点符号。';
      nativeSuggestion = '地道改写: "$clean, please."';
    } else {
      score = min(98, 88 + words.length);
      nativeSuggestion = '地道推荐: "${_generateNativeRephrase(clean)}"';
    }

    return {
      'score': score,
      'corrections': corrections,
      'nativeSuggestion': nativeSuggestion,
      'translation': '【用户原句参考】: $clean',
    };
  }

  String _generateNativeRephrase(String text) {
    if (text.toLowerCase().contains('i want')) {
      return text.replaceAll(RegExp(r'i want', caseSensitive: false), "I'd love to have");
    }
    if (text.toLowerCase().contains('give me')) {
      return text.replaceAll(RegExp(r'give me', caseSensitive: false), 'Could I please get');
    }
    return 'Sounds good! $text';
  }

  /// 获取针对当前场景的推荐启发提示 (AI Hints)
  List<String> getAiHints(String scenarioId) {
    if (scenarioId == 'scenario_coffee') {
      return [
        'I would like an iced latte, please.',
        'Could I get a large cappuccino with oat milk?',
        'Do you have any fresh pastries today?',
      ];
    } else if (scenarioId == 'scenario_interview') {
      return [
        'I have over three years of software engineering experience.',
        'My strength lies in problem-solving and modern web apps.',
        'I prioritize tasks and communicate actively with my team.',
      ];
    } else if (scenarioId == 'scenario_airport') {
      return [
        'Here is my passport and entry form.',
        'I am visiting for sightseeing and vacation.',
        'I will be staying at the Marriott Hotel for 5 days.',
      ];
    }
    return [
      'Hello Leo! I want to practice daily English conversation.',
      'Could you recommend an interesting topic for us to discuss?',
      'How is your day going so far?',
    ];
  }

  /// 清空指定场景历史
  Future<void> clearHistory(String scenarioId) async {
    await _ensureInit();
    await _dbService!.clearAiChatHistory(scenarioId);
  }
}
