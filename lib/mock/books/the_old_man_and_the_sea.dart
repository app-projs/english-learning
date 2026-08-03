import '../../models/article.dart';

class OldManAndSeaMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'sea_u$unitNum',
        bookId: 'book_sea',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Courage', 'Literature'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 10,
        coverUrl: 'assets/images/book_sea.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Old Man and the Boy',
    'Chapter 2: Eighty-four Days Without a Fish',
    'Chapter 3: Setting Out Into the Gulf Stream',
    'Chapter 4: The Strike of the Great Marlin',
    'Chapter 5: The Endurance Test',
    'Chapter 6: A Man Can Be Destroyed But Not Defeated',
    'Chapter 7: The Capture of the Giant Fish',
    'Chapter 8: The Attack of the Mako Sharks',
    'Chapter 9: The Battle in the Dark',
    'Chapter 10: The Skeleton and the Dream of Lions',
  ];

  static final List<String> chineseTitles = [
    '老人与男孩的深情记忆',
    '连续八十四天没有捕到鱼',
    '独自驶向墨西哥湾流深处',
    '巨型大马林鱼的咬钩',
    '意志与耐力的极限对决',
    '人可以被毁灭，但不能被打败',
    '巨鱼的征服与缚舟',
    '灰针鲨的残酷袭来',
    '黑暗中的生死决战',
    '白骨鱼架与狮子之梦',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''He was an old man who fished alone in a skiff in the Gulf Stream and he had gone eighty-four days now without taking a fish. In the first forty days a boy had been with him. But after forty days without a fish the boy's parents had told him that the old man was now definitely and finally salao, which is the worst form of unlucky, and the boy had gone at their orders in another boat which caught three good fish the first week.

It made the boy sad to see the old man come in each day with his skiff empty and he always went down to help him carry either the coiled lines or the gaff and harpoon and the sail that was furled around the mast. The sail was patched with flour sacks and, furled, it looked like the flag of permanent defeat.

The old man was thin and gaunt with deep wrinkles in the back of his neck. The brown blotches of the benevolent skin cancer the sun brings from its reflection on the tropic sea were on his cheeks.

"Santiago," the boy said to him as they climbed the bank from where the skiff was pulled up. "I could go with you again. We've made some money."

The old man had taught the boy to fish and the boy loved him. "No," the old man said. "You're with a lucky boat. Stay with them."''';
      case 1:
        return '''The next morning before sunrise, the old man woke the boy. They drank their coffee together from condensed milk cans at the early morning cafe that served the fishermen.

"How did you sleep, Old Man?" the boy asked.

"Very well, Manolin," the old man said. "I feel confident today."

They carried the gear down to the skiff in the dark. The old man stepped into the boat, unhooked the rope from the ring on the dock, and pushed off into the quiet harbor water.

He rowed out into the dark water, hearing the dip and swish of his oars. He loved the ocean, thinking of her as la mar, which is what people call her in Spanish when they love her. He rowed out beyond the light of the shore, out into the deep Gulf Stream where the big fish lived.''';
      case 2:
        return '''By four o'clock in the afternoon, the old man was floating miles away from land. The green sea turned deep dark blue as the water dropped off to a depth of seven hundred fathoms.

Suddenly, one of the green sticks dipped sharply. The line went tight under the old man's touch. Deep down, a hundred fathoms below, a great marlin was eating the sardines that covered the point and the shank of the hook.

"He's taking it," the old man whispered softly. "He has it now."

The old man held the line delicately between his thumb and forefinger, feeling the gentle tug. Then came a sudden, immense weight that pulled the skiff forward across the calm sea.

The fish began to tow the boat steadily toward the northwest. The old man braced his feet against the bow, taking the strain across his shoulders. "I wish I had the boy," he said aloud. "I'm hooked to a giant."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Ernest Hemingway's Nobel Prize-winning masterpiece, The Old Man and the Sea.

Santiago endured days of agonizing physical suffering and solitude on the open sea, bound to the giant marlin by the cord across his back. He admired the majesty and dignity of his adversary, calling the fish his brother.

"A man can be destroyed but not defeated," Santiago affirmed in his moment of greatest trial.

Though sharks eventually stripped the great fish down to a bare white skeleton before he reached the harbor, Santiago's unconquerable spirit proved that courage and dignity transcend material loss. Back in his shack, he slept peacefully, dreaming of the golden lions on the beaches of his youth.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''他是个独自在墨西哥湾流中的一条小艇上钓鱼的老人，如今出海八十四天了，一条鱼也没捕到。在前四十天里，有一个男孩和他在一起。但四十天没捕到鱼后，男孩的父母告诉他，老头子现在肯定彻底倒了霉（salao），这是最糟糕的运道，男孩听从父母的安排上了另一条船，那条船第一周就捕到了三条好鱼。

看到老人每天划着空船归来，男孩心里很难受，他总是跑下岸去帮老人拿卷好的钓线，或是搭钩、帮勾以及缠在桅杆上的帆。那面帆用面粉袋打过补丁，卷起来就像一面标志着永恒失败的旗帜。

老人消瘦而憔悴，颈后褶皱极深。由于热带海洋反射的阳光，他脸颊上布满了良性皮肤癌的褐色斑块。

“圣地亚哥，”从划子拉上岸的地方爬上山坡时，男孩对他说。“我可以再和你一起出海。我们已经挣了点钱了。”

老人教过男孩捕鱼，男孩很爱他。“不，”老人说。“你上了一条运气好的船。跟着他们吧。”''';
      case 1:
        return '''第二天黎明前，老人唤醒了男孩。他们在为渔民服务的早晨小咖啡馆里，用炼乳罐喝着咖啡。

“你睡得怎么样，老人家？”男孩问。

“很好，马诺林，”老人说。“我今天信心十足。”

他们在黑暗中把用具搬下小艇。老人踏进船里，解开码头环上的绳子，划向平静的港湾。

他划向黑暗的水域，听着桨叶划水的沉浮声。他热爱海洋，把她想象成 la mar，这是西班牙人在热爱海洋时对她的尊称。他划出了岸边的灯光之外，划向了大鱼生活的墨西哥湾流深处。''';
      case 2:
        return '''到了下午四点钟，老人已经漂流到了离陆地数英里之外的地方。随着水深降至七百英寻，绿色的海洋变成了深深的暗蓝色。

突然，其中一根绿色的木棍猛烈地沉了一下。老人手下的钓线瞬间拉紧了。在一百英寻深的地下，一条巨大的马林鱼正在吞食覆盖着钩尖和钩柄的沙丁鱼。

“它咬钩了，”老人轻轻地低语。“它吃下去了。”

老人用拇指和食指精细地捏着钓线，感受着那温和的拉力。接着传来一股突然而巨大的重量，拉着小艇跨越平静的海面向前冲去。

大鱼开始拉着小船稳步向西北方驶去。老人双脚抵住船头，用肩膀承受着拉力。“真希望男孩在这儿，”他大声说。“我钩住了一条巨物。”''';
      default:
        final chapterNum = index + 1;
        return '''这是海明威获得诺贝尔文学奖的巅峰名著《老人与海》的第 $chapterNum 章。

圣地亚哥在茫茫大海上忍受着数天极度的肉体痛苦与孤独，背上的缆绳紧紧系着那条巨大的马林鱼。他赞美对手的庄严与高贵，称这条鱼为自己的兄弟。

“人可以被毁灭，但不能被打败，”圣地亚哥在他最艰难的考验时刻坚定地宣告。

尽管在回到港口之前，鲨鱼最终将这条大鱼咬得只剩下一具白色的骨架，但圣地亚哥不可战胜的精神证明了勇气与尊严超越了物质的得失。回到小屋里，他安然入睡，梦见了他年轻时非洲海滩上的金黄狮子。''';
    }
  }
}
