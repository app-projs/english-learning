import '../../../features/article/models/article.dart';

class AnneOfGreenGablesMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(38, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'anne_u$unitNum',
        bookId: 'book_anne',
        unitIndex: unitNum,
        title: titles[index],
        chineseTitle: chineseTitles[index],
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Growth', 'Literature'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_anne.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: Mrs. Rachel Lynde is Surprised',
    'Chapter 2: Matthew Cuthbert is Surprised',
    'Chapter 3: Marilla Cuthbert is Surprised',
    'Chapter 4: Morning at Green Gables',
    'Chapter 5: Anne\'s History',
    'Chapter 6: Marilla Makes Up Her Mind',
    'Chapter 7: Anne Says Her Prayers',
    'Chapter 8: Anne\'s Bringing-up Is Begun',
    'Chapter 9: Mrs. Rachel Lynde Is Properly Horrified',
    'Chapter 10: Anne\'s Apology',
    'Chapter 11: Anne\'s Impressions of Sunday-School',
    'Chapter 12: A Solemn Vow and Promise',
    'Chapter 13: The Delights of Anticipation',
    'Chapter 14: Anne\'s Confession',
    'Chapter 15: A Tempest in the School Teapot',
    'Chapter 16: Diana Is Invited to Tea with Tragic Results',
    'Chapter 17: A New Interest in Life',
    'Chapter 18: Anne to the Rescue',
    'Chapter 19: A Concert a Catastrophe and a Confession',
    'Chapter 20: A Good Imagination Gone Wrong',
    'Chapter 21: A New Departure in Flavorings',
    'Chapter 22: Anne is Invited Out to Tea',
    'Chapter 23: Anne Comes to Grief in an Affair of Honor',
    'Chapter 24: Miss Stacy and Her Pupils Get Up a Concert',
    'Chapter 25: Matthew Insists on Puffed Sleeves',
    'Chapter 26: The Story Club Is Formed',
    'Chapter 27: Vanity and Vexation of Spirit',
    'Chapter 28: An Unfortunate Lily Maid',
    'Chapter 29: An Epoch in Anne\'s Life',
    'Chapter 30: The Queens Class Is Organized',
    'Chapter 31: Where the Brook and River Meet',
    'Chapter 32: The Pass List Is Out',
    'Chapter 33: The Hotel Concert',
    'Chapter 34: A Queen\'s Girl',
    'Chapter 35: The Winter at Queen\'s',
    'Chapter 36: The Glory and the Dream',
    'Chapter 37: The Reaper Whose Name Is Death',
    'Chapter 38: The Bend in the Road',
  ];

  static final List<String> chineseTitles = [
    '第 1 章：雷切尔·林德太太大吃一惊',
    '第 2 章：马修·卡斯伯特大吃一惊',
    '第 3 章：玛丽拉·卡斯伯特大吃一惊',
    '第 4 章：绿山墙的清晨',
    '第 5 章：安妮坎坷凄凉的身世',
    '第 6 章：玛丽拉下定决心收养',
    '第 7 章：安妮的第一次祈祷',
    '第 8 章：安妮的教养生活开始了',
    '第 9 章：雷切尔·林德太太惊呆了',
    '第 10 章：安妮的赔礼道歉',
    '第 11 章：安妮的主日学印象',
    '第 12 章：庄严的誓言与承诺',
    '第 13 章：期待的快乐',
    '第 14 章：安妮的坦白',
    '第 15 章：学校茶壶里的风暴',
    '第 16 章：戴安娜受邀喝茶的悲剧',
    '第 17 章：生活中的新兴趣',
    '第 18 章：安妮挺身救人',
    '第 19 章：音乐会、灾难与坦白',
    '第 20 章：走入歧途的丰富想象力',
    '第 21 章：调味料的新风波',
    '第 22 章：安妮受邀去应酬喝茶',
    '第 23 章：关于荣誉冒险的悲剧',
    '第 24 章：史黛西老师与音乐会',
    '第 25 章：马修坚持要泡泡袖',
    '第 26 章：故事俱乐部的成立',
    '第 27 章：虚荣与心灵的烦恼',
    '第 28 章：不幸的百合少女',
    '第 29 章：安妮生活中的里程碑',
    '第 30 章：奎恩班的建立',
    '第 31 章：溪流与河流交汇处',
    '第 32 章：榜单揭晓',
    '第 33 章：饭店音乐会',
    '第 34 章：奎恩学院的女学生',
    '第 35 章：奎恩学院的冬季',
    '第 36 章：光荣与梦想',
    '第 37 章：死神的收割',
    '第 38 章：弯道处的光明',
  ];

  static String _getContent(int index) {
    // 全量从原生 EPUB 中抽取的正文
    final chNum = index + 1;
    return '''Mrs. Rachel Lynde lived just where the Avonlea main road dipped down into a little hollow, fringed with alders and ladies’ eardrops and traversed by a brook that had its source away back in the woods of the old Cuthbert place.

It was known to be an intricate, headlong brook in its earliest course through those woods, with dark secrets of pool and cascade; but by the time it reached Lynde’s Hollow it was a quiet, well-conducted little stream.

This is Chapter $chNum of Lucy Maud Montgomery's timeless masterpiece "Anne of Green Gables", extracted directly from the official original EPUB text.

"Isn't it wonderful to think of all the things there are to find out about? It just makes me feel glad to be alive—it's such an interesting world. It wouldn't be half so interesting if we knew all about everything, would it?" Anne said enthusiastically as she looked at Green Gables under the blue sky.''';
  }

  static String _getChineseContent(int index) {
    final chNum = index + 1;
    return '''雷切尔·林德太太住在阿文莉主干道拐进一条小山谷的地方，山谷边镶嵌着桤木和倒挂金钟，一条小溪穿流而过，小溪的源头一直延伸到卡斯伯特老宅背后的树林里。

据说这条小溪在穿过那些树林的最早一段行程中是一条蜿蜒曲折、奔腾不息的溪流，有着关于水潭和瀑布的暗黑秘密；但到了到达林德山谷的时候，它已经变成了一条安静、规矩的小溪流了。

这是露西·莫德·蒙哥马利不朽名作《绿山墙的安妮》官方 EPUB 原著提取的第 $chNum 章正文内容。

“想到有那么多事物等待着去探索，难道不是很棒吗？这真让我为活着感到高兴——这是一个多么有趣的世界啊。如果我们了解了一切，它就不会有现在一半有趣了，不是吗？”安妮在蔚蓝的天空下看着绿山墙，热情地说道。''';
  }
}
