class AiScenarioModel {
  final String id;
  final String title;
  final String chineseTitle;
  final String aiRole;
  final String avatarIcon;
  final String difficulty;
  final String category;
  final String systemPrompt;
  final String initialGreeting;
  final String? initialGreetingTranslation;

  AiScenarioModel({
    required this.id,
    required this.title,
    required this.chineseTitle,
    required this.aiRole,
    required this.avatarIcon,
    required this.difficulty,
    required this.category,
    required this.systemPrompt,
    required this.initialGreeting,
    this.initialGreetingTranslation,
  });

  factory AiScenarioModel.fromMap(Map<String, dynamic> map) {
    return AiScenarioModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      chineseTitle: map['chinese_title']?.toString() ?? map['chineseTitle']?.toString() ?? '',
      aiRole: map['ai_role']?.toString() ?? map['aiRole']?.toString() ?? '',
      avatarIcon: map['avatar_icon']?.toString() ?? map['avatarIcon']?.toString() ?? '🤖',
      difficulty: map['difficulty']?.toString() ?? 'B1 初级',
      category: map['category']?.toString() ?? '日常沟通',
      systemPrompt: map['system_prompt']?.toString() ?? map['systemPrompt']?.toString() ?? '',
      initialGreeting: map['initial_greeting']?.toString() ?? map['initialGreeting']?.toString() ?? 'Hello!',
      initialGreetingTranslation: map['initial_greeting_translation']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'chinese_title': chineseTitle,
      'ai_role': aiRole,
      'avatar_icon': avatarIcon,
      'difficulty': difficulty,
      'category': category,
      'system_prompt': systemPrompt,
      'initial_greeting': initialGreeting,
      'initial_greeting_translation': initialGreetingTranslation,
    };
  }
}
