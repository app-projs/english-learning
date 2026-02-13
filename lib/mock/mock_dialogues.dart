import '../models/sentence.dart';

class MockDialogues {
  static List<Dialogue> getDialogues() {
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

  static Dialogue? getDialogueById(String id) {
    return getDialogues().where((d) => d.id == id).firstOrNull;
  }

  static List<Dialogue> getDialoguesByDifficulty(String difficulty) {
    return getDialogues().where((d) => d.difficulty == difficulty).toList();
  }
}
