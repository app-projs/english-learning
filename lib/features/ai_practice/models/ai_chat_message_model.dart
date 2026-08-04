class AiChatMessageModel {
  final int? id;
  final String scenarioId;
  final String sender; // 'ai' or 'user'
  final String message;
  final String? translation;
  final int? grammarScore;
  final String? corrections;
  final String? nativeSuggestion;
  final int createdAt;

  AiChatMessageModel({
    this.id,
    required this.scenarioId,
    required this.sender,
    required this.message,
    this.translation,
    this.grammarScore,
    this.corrections,
    this.nativeSuggestion,
    required this.createdAt,
  });

  factory AiChatMessageModel.fromMap(Map<String, dynamic> map) {
    return AiChatMessageModel(
      id: map['id'] is int ? map['id'] as int : null,
      scenarioId: map['scenario_id']?.toString() ?? map['scenarioId']?.toString() ?? '',
      sender: map['sender']?.toString() ?? 'ai',
      message: map['message']?.toString() ?? '',
      translation: map['translation']?.toString(),
      grammarScore: map['grammar_score'] is int ? map['grammar_score'] as int : (map['grammarScore'] is int ? map['grammarScore'] as int : null),
      corrections: map['corrections']?.toString(),
      nativeSuggestion: map['native_suggestion']?.toString() ?? map['nativeSuggestion']?.toString(),
      createdAt: map['created_at'] is int ? map['created_at'] as int : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'scenario_id': scenarioId,
      'sender': sender,
      'message': message,
      'translation': translation,
      'grammar_score': grammarScore,
      'corrections': corrections,
      'native_suggestion': nativeSuggestion,
      'created_at': createdAt,
    };
  }
}
