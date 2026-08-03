import '../../models/article.dart';

class TreasureIslandMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(34, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'treasure_u$unitNum',
        bookId: 'book_treasure',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Pirates', 'Adventure'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 11,
        coverUrl: 'assets/images/book_treasure.png',
      );
    });
  }

  static final List<String> titles = [
    'The Old Sea-dog at the Admiral Benbow',
    'Black Dog Appears and Disappears',
    'The Black Spot',
    'The Sea-chest',
    'The Last of the Blind Man',
    'The Captain’s Papers',
    'I Go to Bristol',
    'At the Sign of the Spy-glass',
    'Powder and Arms',
    'The Voyage',
    'What I Heard in the Apple Barrel',
    'Council of War',
    'How My Shore Adventure Began',
    'The First Blow',
    'The Man of the Island',
    'How the Ship Was Abandoned',
    'The Jolly Roger’s Last Trip',
    'End of the First Day’s Fighting',
    'The Garrison at the Stockade',
    'Silver’s Embassy',
    'The Attack',
    'How My Sea Adventure Began',
    'The Ebb-tide Runs',
    'The Cruise of the Coracle',
    'I Strike the Jolly Roger',
    'Israel Hands',
    'Pieces of Eight',
    'In the Enemy’s Camp',
    'The Black Spot Again',
    'On Parole',
    'The Treasure Hunt—Flint’s Pointer',
    'The Voice Among the Trees',
    'The Fall of a Chieftain',
    'At Last',
  ];

  static final List<String> chineseTitles = [
    '本博将军客栈的老航海家',
    '黑狗的现身与消失',
    '黑券标记的威胁',
    '航海水手箱的秘密',
    '瞎子皮尤的末日',
    '船长的机密文件',
    '前往布里斯托尔港',
    '望远镜客栈招牌下',
    '火药与武器装备',
    '开航出海',
    '苹果桶里听到的秘密阴谋',
    '军事会议与对策',
    '上岸冒险的开始',
    '第一击杀致命一击',
    '岛上的神秘人本·甘恩',
    '弃船撤离的经过',
    '海盗旗的最后航行',
    '第一天战斗的结束',
    '木栅要塞的守军',
    '西尔弗谈判特使',
    '木栅堡垒攻防战',
    '海上冒险的序幕',
    '退潮的水流',
    '小皮艇漂流巡航',
    '降下海盗旗',
    '与以色列·汉兹的决斗',
    '八比索银币（鹦鹉啼鸣）',
    '沦为敌营俘虏',
    '再次出现的黑券',
    '获得假释与谈判',
    '寻宝：弗林特船长的地标',
    '树丛中的诡异声音',
    '海盗头目的覆灭',
    '财富归来与结局',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Squire Trelawney, Dr. Livesey, and the rest of these gentlemen having asked me to write down the whole particulars about Treasure Island, from the beginning to the end, keeping nothing back but the bearings of the island, and that only because there is still treasure not yet lifted, I take up my pen in the year of grace 17__ and go back to the time when my father kept the Admiral Benbow inn and the brown old seaman with the sabre cut first took up his lodging under our roof.

I remember him as if it were yesterday, as he came plodding to the inn door, his sea-chest following behind him in a hand-barrow—a tall, strong, heavy, nut-brown man, his pigtail falling over the shoulder of his soiled blue coat, his hands ragged and scarred, with black, broken nails, and the sabre cut across one cheek, a dirty, livid white.

I remember him looking round the cover and whistling to himself as he did so, and then breaking out in that old sea-song that he sang so often afterwards:

"Fifteen men on the dead man's chest—
Yo-ho-ho, and a bottle of rum!"

in the high, old tottering voice that seemed to have been tuned and broken at the capstan bars.''';
      case 1:
        return '''It was not very long after this that there occurred the first of the mysterious events that rid us at last of the captain, though not, as you will see, of his affairs. It was a bitter cold winter, with long, hard frosts and heavy gales, and it was plain from the first that my poor father was little likely to see the spring.

One January morning, very early, a pinching, frosty morning, the cove all grey with hoar-frost, the ripple lapping softly on the stones, the sun still low and only touching the hilltops and shining far to seaward, the captain rose earlier than usual and set off down the beach, his cutlass swinging under the broad skirts of his old blue coat, his brass telescope under his arm, his hat cocked back upon his head.

I remember his breath smoking in the freezing air as he strode off, and the last sound I heard of him, as he turned the big rock, was a loud snort of indignation, as though his mind was still running upon Dr. Livesey.

Well, mother was upstairs with father; and I was laying the breakfast-table against the captain's return when the parlour door opened and a man stepped in whom I had never seen before.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Robert Louis Stevenson's legendary pirate masterpiece, Treasure Island.

Young Jim Hawkins found himself swept into a high-seas adventure of mutiny, buried gold, and cunning pirates led by the memorable, one-legged Long John Silver.

"Fifteen men on the dead man's chest—Yo-ho-ho, and a bottle of rum!" rang the famous pirate chant across the tropical island.

Jim's bravery and quick wits helped Squire Trelawney and Dr. Livesey outsmart the mutineers, secure Captain Flint's legendary treasure, and sail home victorious.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''崔劳尼乡绅、李维西医生以及其他几位绅士要我把关于金银岛的全部始末原原本本写下来，从头到尾，除了岛的经纬度位置外毫无保留——之所以保留经纬度，只是因为那里还有尚未挖出的宝藏——于是在主历 17__ 年，我拿起笔，回到我父亲开‘本博将军’客栈、那位脸上有刀疤的棕色老航海家第一次在我们屋檐下租房住下的那个时代。

我至今还清晰地记得他，就像昨天发生的一样。他步履沉重地走到客栈门口，他的航海木箱装在手推车里跟在后面——一个高大、强壮、沉重、栗褐色皮肤的男人，他的辫子垂在他那件沾满污垢的蓝大衣肩膀上，双手破破烂烂全是伤痕，留着发黑破裂的指甲，一条刀疤横贯一侧脸颊，呈现出肮脏发青的白色。

我记得他环顾着四周海湾，边看边自顾自地吹着口哨，然后突然唱起那首他后来经常唱的老海盗歌：

“十五个人争夺死人箱——
哟-呵-呵，来瓶朗姆酒！”

那高亢、老迈颤抖的声音，仿佛是在拔锚绞盘棒上调过音又破了嗓子一样。''';
      case 1:
        return '''就在这之后不久，发生了第一件神秘事件，最终让我们摆脱了那位船长，尽管正如你将看到的，并没有摆脱他的麻烦事。那是个严寒的冬天，有漫长严酷的霜冻和猛烈的暴风，从一开始就很明显，我可怜的父亲很难撑到春天了。

一月的一个早晨，非常早，一个刺骨霜冻的早晨，小海湾因为白霜而一片灰色，波浪在石头上轻轻拍打，太阳依然很低，只照亮了山顶并向远方的大海放射光芒，船长比往常更早起床，沿着海滩出发了，他的弯刀在他老旧蓝大衣的宽大裙摆下摆动，黄铜望远镜夹在胳膊下，帽子斜戴在头上。

我记得他在冰冷的空气中呼出白烟迈步走远，当他拐过巨石时我听到的他发出的最后声音，是一声响亮的愤慨哼声，仿佛他的心思还在李维西医生身上。

当时，母亲在楼上陪着父亲；我正在摆早餐桌等待船长回来，这时客厅的门开了，一个我以前从未见过的男人走了进来。''';
      default:
        final chapterNum = index + 1;
        return '''这是罗伯特·路易斯·史蒂文森传奇海盗名著《金银岛》的第 $chapterNum 章。

年轻的吉姆·霍金斯发现自己卷入了由令人难忘的单腿海盗高个子约翰·西尔弗领导的叛变、埋藏黄金和狡黠海盗的公海冒险中。

“十五个人争夺死人箱——哟-呵-呵，来瓶朗姆酒！”著名的海盗吟唱在热带岛屿上回荡。

吉姆的勇敢和机智帮助崔劳尼乡绅和李维西医生智胜了叛变者，安全获得了弗林特船长传奇的宝藏，并胜利航行回家。''';
    }
  }
}
