import '../../models/article.dart';

class ArabianNightsMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'nights_u$unitNum',
        bookId: 'book_nights',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Mythology', 'Adventure'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 14,
        coverUrl: 'assets/images/book_nights.png',
      );
    });
  }

  static final List<String> titles = [
    'The Story of King Shahryar and Scheherazade',
    'The Fisherman and the Genie',
    'The Tale of the Enchanted King',
    'The First Voyage of Sinbad the Sailor',
    'The Second Voyage: The Valley of Diamonds',
    'Ali Baba and the Forty Thieves: The Secret Cave',
    'Morgiana’s Courage and Intelligence',
    'Aladdin and the Wonderful Lamp: The Sorcerer',
    'The Genie of the Lamp Appears',
    'Aladdin Builds the Royal Palace',
    'The Sorcerer’s Revenge: New Lamps for Old',
    'The Triumph of Aladdin and Scheherazade',
  ];

  static final List<String> chineseTitles = [
    '山鲁亚尔国王与山鲁佐德的序曲',
    '渔夫与魔鬼的故事',
    '受诅咒国王的故事',
    '辛巴达航海记：第一次远航',
    '第二次远航：钻石峡谷与巨鸟',
    '阿里爸爸与四十大盗：芝麻开门',
    '女仆玛尔基娜的智慧与英勇',
    '阿拉丁与神灯：来自魔术师的阴谋',
    '神灯巨灵的现身',
    '阿拉丁建造金碧辉煌的宫殿',
    '魔法师的报复：旧灯换新灯',
    '阿拉丁的胜利与山鲁佐德的救赎',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''In the chronicles of the ancient kings of Persia, there lived two royal brothers, Shahryar and Shahzaman. King Shahryar ruled over India and Indochina with great justice and wisdom, loved by all his subjects. However, a terrible betrayal broke his heart and filled his soul with bitterness towards all womankind.

Swearing a dreadful oath, the King decreed that every night he would marry a young maiden of his city, and on the following morning he would order her execution, so that she could never deceive him. For three tragic years, grief and horror reigned throughout the realm.

The Grand Vizier, whose duty it was to carry out these cruel decrees, had two daughters. The elder was named Scheherazade, a woman of extraordinary intelligence, beauty, and wisdom. She had read all the books of poetry, philosophy, history, and science.

"Dear Father," Scheherazade declared courageously, "I pray you marry me to the King. Either I shall succeed in saving the maidens of our land, or I shall die in the noble attempt."

On her wedding night, Scheherazade began telling a captivating story of magic and wonder, but stopped just before the climax as dawn broke, promising to finish it the next night.''';
      case 1:
        return '''There was once an old fisherman who lived in extreme poverty with his wife and three children. Every day he cast his nets into the sea four times and no more.

One morning, after casting his net, he felt a great weight. Expecting a fine catch, he pulled it ashore, only to find the carcass of a dead donkey. He mended his broken net and cast it a second time, bringing up a large jar filled with mud and sand.

On the fourth cast, his net brought up a heavy copper jar, sealed tight with a lead stopper stamped with the Solomon's royal seal. Overjoyed, the fisherman prised open the stopper with his knife.

Thick black smoke poured out of the vessel, rising into the sky and condensing into a colossal Genie of terrifying aspect.

"Prepare to die, old man!" roared the Genie in a voice like thunder. "Choose only the manner of your death!"

The fisherman, recovering from his terror, used his wits: "I cannot believe a giant like you could fit inside this tiny bottle unless I see it with my own eyes." Proud and angered, the Genie vanished into smoke and slid back inside, whereupon the quick-witted fisherman slammed the lead stopper tight!''';
      case 2:
        return '''Deep in the heart of a distant kingdom surrounded by four mysterious mountains lay a enchanted lake filled with fish of four distinct colors: red, white, yellow, and blue.

A young King, half of whose body had been turned into cold black marble by an evil enchantress, sat weeping in his deserted palace. He recounted to the Sultan how his wicked queen used dark magic to transform his people and kingdom.

Determined to break the curse, the brave Sultan tracked the enchantress to her secret sanctuary. Disguising himself in her wounded lover's robes, the Sultan tricked the sorceress into reciting the counter-spells.

With a stroke of his sword, the Sultan vanquished the enchantress forever. The marble prince was restored to life, the four-colored fish turned back into humans, and the enchanted city returned to its former glory under a peaceful sky.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of the immortal masterpiece, The Arabian Nights (One Thousand and One Nights).

Scheherazade continued her mesmerizing storytelling night after night for one thousand and one nights. She wove tales of voyages across unknown seas, magical lamps, hidden treasures, clever maidens, and heroic princes.

Through her enchanting stories, King Shahryar's heart was gradually softened, healed of its bitterness, and filled with deep admiration and genuine love for Scheherazade's wisdom and virtue.

At the end of the one thousand and one nights, the King pardoned all, abolished his cruel law, and lived in harmony and lasting happiness with Queen Scheherazade and their children.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''在古波斯国王的史册中，住着两位皇家兄弟，山鲁亚尔和山鲁佐曼。山鲁亚尔国王以极大的公正和智慧统治着印度和印度支那，受到所有臣民的爱戴。然而，一场可怕的背叛打破了他的心，让他的灵魂充满了对世间所有女性的苦涩与仇恨。

国王立下一个可怕的誓言，颁布法令说，每天晚上他都要迎娶城里的一个年轻少女，而在次日早晨下令将她处决，这样她就再也不能欺骗他了。在悲惨的三年里，悲伤和恐怖笼罩着整个王国。

负责执行这些残酷法令的大宰相有两个女儿。长女名叫山鲁佐德，是一位拥有非凡智慧、美丽与博学的女子。她读过所有的诗歌、哲学、历史和科学书籍。

“亲爱的父亲，”山鲁佐德勇敢地宣告，“请您把我嫁给国王吧。我要么能成功挽救我们土地上的少女们，要么将在高尚的尝试中牺牲。”

在洞房之夜，山鲁佐德开始讲述一个引人入胜的魔法与奇迹的故事，但在黎明破晓前恰好在最精彩的高潮处停了下来，许诺第二天晚上再讲完。''';
      case 1:
        return '''从前有一个老渔夫，和妻子及三个孩子生活在极度贫困中。他每天向海里撒网四次，绝不多撒。

一天早晨，撒网后，他感到沉甸甸的。本以为能捕到好鱼，他把网拉上岸，却只发现一具死驴的尸体。他补好了破网，第二次撒网，捞上来一个装满泥沙的大罐子。

第四次撒网时，他的网拉上来一个沉重的铜罐，上面用盖着所罗门王印章的铅塞紧紧密封着。老渔夫欣喜若狂，用小刀撬开了铅塞。

浓浓的黑烟从瓶子里喷涌而出，升入天空，凝结成一个面目狰狞的巨大巨灵。

“准备受死吧，老头！”巨灵用雷鸣般的声音怒吼道。“你只能选择你的死法！”

老渔夫从惊恐中恢复过来，运用了他的智慧：“我不相信像你这样的巨人能装进这个小瓶子里，除非我亲眼看到。”巨灵又傲慢又恼火，化作一阵烟雾溜回了瓶子里，见状，机智的渔夫猛地把铅塞重新关紧！''';
      case 2:
        return '''在被四座神秘大山环绕的遥远王国深处，有一个神奇的湖泊，里面游着四种不同颜色的鱼：红、白、黄、蓝。

一位年轻的国王，半个身体被邪恶的女巫变成了冰冷的黑大理石，坐在他废弃的宫殿里哭泣。他向苏丹讲述了他的邪恶王后如何用黑魔法转化了他的臣民和王国。

勇敢的苏丹决心打破诅咒，追踪女巫到了她的秘密圣所。苏丹伪装成她受伤的情人的长袍，诱骗女巫念出了解除诅咒的咒语。

苏丹挥剑斩断了女巫的邪恶。大理石王子恢复了生命，四色鱼变回了人类，神奇的城市在和平的天空下重现往日的辉煌。''';
      default:
        final chapterNum = index + 1;
        return '''这是不朽名著《一千零一夜》的第 $chapterNum 章。

山鲁佐德夜复一夜地讲述着她令人着迷的故事，整整持续了一千零一夜。她编织了穿越未知海洋的航行、神奇的神灯、隐藏的宝藏、聪慧的少女和英雄王子的传说。

通过她迷人的故事，山鲁亚尔国王的心渐渐被融化，苦涩得到了抚平，心中充满了对山鲁佐德智慧与美德的深深钦佩与真挚爱意。

在一千零一夜结束时，国王赦免了所有人，废除了残酷的法令，与山鲁佐德王后及他们的孩子们过上了和谐长久幸福的生活。''';
    }
  }
}
