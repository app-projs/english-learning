import 'dart:convert';
import '../../../core/services/database_service.dart';

class PhoneticItemModel {
  final String id;
  final String symbol;
  final String type; // 'vowel' | 'consonant'
  final String category;
  final String tips;
  final List<String> examples;

  PhoneticItemModel({
    required this.id,
    required this.symbol,
    required this.type,
    required this.category,
    required this.tips,
    required this.examples,
  });

  factory PhoneticItemModel.fromJson(Map<String, dynamic> json) {
    List<String> exList = [];
    if (json['examples'] is List) {
      exList = List<String>.from(json['examples']);
    } else if (json['examples'] is String) {
      try {
        final decoded = jsonDecode(json['examples']);
        if (decoded is List) exList = List<String>.from(decoded);
      } catch (_) {
        exList = (json['examples'] as String).split(',');
      }
    }

    return PhoneticItemModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      type: json['type'] as String? ?? 'vowel',
      category: json['category'] as String? ?? '',
      tips: json['tips'] as String? ?? '',
      examples: exList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'type': type,
        'category': category,
        'tips': tips,
        'examples': jsonEncode(examples),
      };
}

class PhoneticsService {
  final DatabaseService _database;

  PhoneticsService(this._database);

  Future<void> _seedDatabaseIfNeeded() async {
    final existing = await _database.getAllPhonetics();
    if (existing.isNotEmpty) return;

    final initialPhonetics = [
      // 单元音 (前元音 / 中元音 / 后元音)
      PhoneticItemModel(id: 'p_i_long', symbol: '[i:]', type: 'vowel', category: '前元音 (长元音)', tips: '嘴唇向两侧拉平像微笑，舌尖抵下齿，发音长而高响。', examples: ['see /si:/', 'we /wi:/', 'eat /i:t/']),
      PhoneticItemModel(id: 'p_i_short', symbol: '[ɪ]', type: 'vowel', category: '前元音 (短元音)', tips: '嘴唇微微张开自然放松，发音短促有力。', examples: ['sit /sɪt/', 'big /bɪɡ/', 'it /ɪt/']),
      PhoneticItemModel(id: 'p_e', symbol: '[e]', type: 'vowel', category: '前元音 (短元音)', tips: '嘴唇张开约一指宽度，舌尖抵下齿。', examples: ['bed /bed/', 'red /red/', 'pen /pen/']),
      PhoneticItemModel(id: 'p_ae', symbol: '[æ]', type: 'vowel', category: '前元音 (短元音)', tips: '嘴巴张大至能容纳两指，嘴角向两侧拉。', examples: ['cat /kæt/', 'bag /bæɡ/', 'apple /ˈæpl/']),
      PhoneticItemModel(id: 'p_a_long', symbol: '[ɑ:]', type: 'vowel', category: '后元音 (长元音)', tips: '张大嘴巴发"啊"音，舌身平放后缩。', examples: ['car /kɑ:/', 'park /pɑːk/', 'far /fɑː/']),
      PhoneticItemModel(id: 'p_o_short', symbol: '[ɒ]', type: 'vowel', category: '后元音 (短元音)', tips: '双唇收圆成椭圆形，发音短促。', examples: ['hot /hɒt/', 'dog /dɒɡ/', 'box /bɒks/']),
      PhoneticItemModel(id: 'p_o_long', symbol: '[ɔ:]', type: 'vowel', category: '后元音 (长元音)', tips: '双唇收圆突出呈小"O"形，舌身向后缩。', examples: ['door /dɔ:/', 'more /mɔ:/', 'call /kɔ:l/']),
      PhoneticItemModel(id: 'p_u_short', symbol: '[ʊ]', type: 'vowel', category: '后元音 (短元音)', tips: '双唇微微收圆向前突出，发音短促。', examples: ['book /bʊk/', 'look /lʊk/', 'good /ɡʊd/']),
      PhoneticItemModel(id: 'p_u_long', symbol: '[u:]', type: 'vowel', category: '后元音 (长元音)', tips: '双唇收得极小极圆向前突出，发音饱满。', examples: ['too /tu:/', 'food /fu:d/', 'cool /ku:l/']),
      PhoneticItemModel(id: 'p_u_hat', symbol: '[ʌ]', type: 'vowel', category: '中元音 (短元音)', tips: '嘴巴半张，舌身平放中位。', examples: ['cup /kʌp/', 'sun /sʌn/', 'bus /bʌs/']),
      PhoneticItemModel(id: 'p_er_long', symbol: '[ɜ:]', type: 'vowel', category: '中元音 (长元音)', tips: '嘴巴半张自然，舌身居中，声带震动。', examples: ['bird /bɜːd/', 'girl /ɡɜːl/', 'work /wɜːk/']),
      PhoneticItemModel(id: 'p_er_short', symbol: '[ə]', type: 'vowel', category: '中元音 (短元音)', tips: '全放松轻读"额"音，英语中最常见的非重读元音。', examples: ['ago /əˈɡəʊ/', 'teacher /ˈtiːtʃə/', 'about /əˈbaʊt/']),
      
      // 爆破音与摩擦音
      PhoneticItemModel(id: 'p_p', symbol: '[p]', type: 'consonant', category: '爆破音 (清辅音)', tips: '双唇紧闭阻挡气流，而后突然张开爆发出声，声带不震动。', examples: ['pen /pen/', 'apple /ˈæpl/', 'cup /kʌp/']),
      PhoneticItemModel(id: 'p_b', symbol: '[b]', type: 'consonant', category: '爆破音 (浊辅音)', tips: '双唇紧闭，声带震动，爆发吐气。', examples: ['book /bʊk/', 'big /bɪɡ/', 'bag /bæɡ/']),
      PhoneticItemModel(id: 'p_t', symbol: '[t]', type: 'consonant', category: '爆破音 (清辅音)', tips: '舌尖紧贴上齿龈，气流冲开舌尖爆破而出。', examples: ['tea /ti:/', 'top /tɒp/', 'cat /kæt/']),
      PhoneticItemModel(id: 'p_d', symbol: '[d]', type: 'consonant', category: '爆破音 (浊辅音)', tips: '舌尖抵上齿龈阻气，声带震动突然释放。', examples: ['dog /dɒɡ/', 'door /dɔ:/', 'red /red/']),
      PhoneticItemModel(id: 'p_k', symbol: '[k]', type: 'consonant', category: '爆破音 (清辅音)', tips: '舌后部隆起紧贴软腭，突然冲开发出送气音。', examples: ['key /ki:/', 'cat /kæt/', 'book /bʊk/']),
      PhoneticItemModel(id: 'p_g', symbol: '[ɡ]', type: 'consonant', category: '爆破音 (浊辅音)', tips: '舌后部贴软腭，声带震动释放。', examples: ['go /ɡəʊ/', 'get /ɡet/', 'bag /bæɡ/']),
      PhoneticItemModel(id: 'p_f', symbol: '[f]', type: 'consonant', category: '摩擦音 (清辅音)', tips: '上齿轻咬下唇，气流由缝隙摩擦而出。', examples: ['fly /flaɪ/', 'fish /fɪʃ/', 'off /ɒf/']),
      PhoneticItemModel(id: 'p_v', symbol: '[v]', type: 'consonant', category: '摩擦音 (浊辅音)', tips: '上齿咬下唇，声带震动伴随气流摩擦。', examples: ['van /væn/', 'very /ˈveri/', 'love /lʌv/']),
      PhoneticItemModel(id: 'p_s', symbol: '[s]', type: 'consonant', category: '摩擦音 (清辅音)', tips: '舌尖靠近上齿龈，气流由狭缝吹出发出嘶嘶声。', examples: ['sun /sʌn/', 'see /si:/', 'bus /bʌs/']),
      PhoneticItemModel(id: 'p_z', symbol: '[z]', type: 'consonant', category: '摩擦音 (浊辅音)', tips: '舌尖靠近上齿龈，声带震动发出嗡嗡声。', examples: ['zoo /zu:/', 'zero /ˈzɪərəʊ/', 'rose /rəʊz/']),
    ];

    for (final item in initialPhonetics) {
      await _database.insertPhonetic(item.toJson());
    }
  }

  Future<List<PhoneticItemModel>> getPhoneticsByType(String type) async {
    await _seedDatabaseIfNeeded();
    final rows = await _database.getPhoneticsByType(type);
    return rows.map((r) => PhoneticItemModel.fromJson(r)).toList();
  }

  Future<List<PhoneticItemModel>> getAllPhonetics() async {
    await _seedDatabaseIfNeeded();
    final rows = await _database.getAllPhonetics();
    return rows.map((r) => PhoneticItemModel.fromJson(r)).toList();
  }
}
