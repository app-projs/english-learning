import '../../models/article.dart';

class GreatGatsbyMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(9, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'gatsby_u$unitNum',
        bookId: 'book_gatsby',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Jazz Age', 'Tragedy'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_gatsby.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Green Light across the Bay',
    'Chapter 2: The Valley of Ashes and Doctor T. J. Eckleburg',
    'Chapter 3: The Extravagant Parties at West Egg',
    'Chapter 4: Lunch with Gatsby and Meyer Wolfsheim',
    'Chapter 5: Tea with Daisy—The Reunion',
    'Chapter 6: The True Origin of James Gatz',
    'Chapter 7: The Confrontation at the Plaza Hotel',
    'Chapter 8: The Fatal Accident and the Pool',
    'Chapter 9: The Last Green Light and the Tide',
  ];

  static final List<String> chineseTitles = [
    '海湾对岸码头凝望的绿光',
    '灰烬之谷与艾克尔堡医生的巨幅眼睛',
    '西卵庄园奢华迷离的奢靡夜宴',
    '与盖茨比及沃尔夫什姆的午餐',
    '与黛西重逢：下午茶与漫长岁月',
    '詹姆斯·盖茨真实的身世之谜',
    '广场酒店里的正面摊牌与撕裂',
    '致命的车祸与水池边沉寂的枪声',
    '最后的绿光：逆水行舟的潮水',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''In my younger and more vulnerable years my father gave me some advice that I've been turning over in my mind ever since.

"Whenever you feel like criticizing any one," he told me, "just remember that all the people in this world haven't had the advantages that you've had."

He didn't say any more, but we've always been unusually communicative in a reserved way, and I understood that he meant a great deal more than that. In consequence, I'm inclined to reserve all judgments, a habit that has opened up many curious natures to me and also made me the victim of not a few veteran bores.

When I came back from the East last autumn I felt that I wanted the world to be in uniform and at a sort of moral attention forever; I wanted no more riotous excursions with privileged glimpses into the human heart. Only Gatsby, the man who gives his name to this book, was exempted from my reaction—Gatsby, who represented everything for which I have an unaffected scorn.

If personality is an unbroken series of successful gestures, then there was something gorgeous about him, some heightened sensitivity to the promises of life, as if he were related to one of those intricate machines that register earthquakes ten thousand miles away.''';
      case 1:
        return '''About half way between West Egg and New York the motor road hastily joins the railroad and runs beside it for a quarter of a mile, so as to shrink away from a certain desolate area of land. This is a valley of ashes—a fantastic farm where ashes grow like wheat into ridges and hills and grotesque gardens; where ashes take the forms of houses and chimneys and rising smoke and, finally, with a transcendent effort, of men who move dimly and already crumbling through the powdery air.

Occasionally a line of gray cars crawls along an invisible track, gives out a ghastly creak, and comes to rest, and immediately the ash-gray men swarm up with leaden spades and stir up an impenetrable cloud, which hides their obscure operations from your sight.

But above the gray land and the spasms of bleak dust which drift endlessly over it, you perceive, after a moment, the eyes of Doctor T. J. Eckleburg. The eyes of Doctor T. J. Eckleburg are blue and gigantic—their irises are one yard high. They look out of no face, but, instead, from a pair of enormous yellow spectacles which pass over a non-existent nose.

Evidently some wild wag of an oculist set them there to fatten his practice in the borough of Queens, and then sank himself into eternal blindness, or forgot them and moved away.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of F. Scott Fitzgerald's masterpiece of the Jazz Age, The Great Gatsby.

Through the eyes of narrator Nick Carraway, the tragedy of Jay Gatsby unfolded—a man who built an empire of wealth and illusions solely to recapture his lost love, Daisy Buchanan.

"Gatsby believed in the green light, the orgastic future that year by year recedes before us," Nick reflected in the haunted silence following Gatsby's death.

"So we beat on, boats against the current, borne back ceaselessly into the past."''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''在我年纪更轻、更容易受伤害的岁月里，父亲给我过一句忠告，从那以后我一直在脑海里反复琢磨。

“每当你觉得想要批评任何人的时候，”他告诉我，“只要记住，这世上并不是所有人都有过你拥有的优越条件。”

他没有再多说，但我们总是以一种含蓄的方式保持着非同寻常的沟通，我明白他的意思远不止于此。结果，我倾向于保留所有的判断，这一习惯向我展示了许多离奇的本性，也使我成为了不少久经沙场的无聊之人的受害者。

去年秋天我从东方回来时，我觉得我希望这个世界永远处于某种道德的立正状态；我不再希望进行那些特权窥视人心深处的放荡远行。只有盖茨比，这个把名字赋予这本书的人，是个例外——盖茨比，他代表了我所发自内心鄙视的一切。

如果性格是一连串成功的姿态，那么他身上有一种华丽的东西，某种对生命的许诺高度敏感的感受力，仿佛他与万英里之外记录地震的那些精密机器相连。''';
      case 1:
        return '''在西卵和纽约大约一半的地方，汽车公路急忙与铁路会合，在它旁边延伸四分之一英里，以便避开一片荒凉的土地。这是一片灰烬之谷——一个神奇的农场，灰烬像小麦一样长成山脊、丘陵和怪诞的花园；灰烬在这里化作房屋、烟囱和升起的烟雾的形式，最后，伴随着超凡的努力，化作在粉末状空气中隐约移动并已在崩溃的人。

偶尔有一排灰色的汽车沿着看不见的轨道爬行，发出惨白的吱吱声，然后停下来，灰灰色的人们立刻带着铅色的铲子蜂拥而至，搅起一阵不可穿透的云雾，将他们模糊的操作隐藏在你的视线之外。

但是在灰色的土地和无休止地漂浮在上面的荒凉尘土的阵痛之上，过了一会儿，你就会察觉到 T. J. 艾克尔堡医生的眼睛。T. J. 艾克尔堡医生的眼睛是蓝色的，而且巨大——它们的虹膜有一码高。它们没有从脸上看出来，而是从一对巨大的黄色眼镜中看出来，这对眼镜横跨在一只不存在的鼻子上。

显然，某个疯狂滑稽的眼科医生把它们放在那里是为了增加他在皇后区的业务，然后他自己沉入永恒的失明，或者忘记了它们并搬走了。''';
      default:
        final chapterNum = index + 1;
        return '''这是菲茨杰拉德爵士时代的巅峰名著《了不起的盖茨比》的第 $chapterNum 章。

通过叙述者尼克·卡拉威的眼睛，杰伊·盖茨比的悲剧展现了出来——一个建立财富和幻象帝国只为了重新赢得他失去的爱人黛西·布坎南的人。

“盖茨比相信那盏绿光，相信那个一年年离我们远去的极乐未来，”尼克在盖茨比死后幽灵般的沉寂中反思道。

“于是我们奋力前行，逆水行舟，不停地被浪潮推回到过去。”''';
    }
  }
}
