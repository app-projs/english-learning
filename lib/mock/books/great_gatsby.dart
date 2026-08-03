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
        title: titles[index],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index]}',
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
      case 2:
        return '''There was music from my neighbor's house through the summer nights. In his blue gardens men and girls came and went like moths among the whisperings and the champagne and the stars. At high tide in the afternoon I watched his guests diving from the tower of his raft, or taking the sun on the hot sand of his beach while his two motor-boats slit the waters of the Sound, drawing aquaplanes over cascades of foam.

On week-ends his Rolls-Royce became an omnibus, bearing parties to and from the city between eight o'clock in the morning and long past midnight, while his station wagon scampered like a brisk yellow bug to meet all trains.

And on Mondays eight servants, including an extra gardener, toiled all day with mops and scrubbing-brushes and hammers and garden-shears, repairing the ravages of the night before.

Every Friday five crates of oranges and lemons arrived from a fruiterer in New York—every Monday these same oranges and lemons left his back door in a pyramid of pulpless halves. There was a machine in the kitchen which could extract the juice of two hundred oranges in half an hour if a little button was pressed two hundred times by a butler's thumb.''';
      case 3:
        return '''At nine o'clock one morning late in July, Gatsby's gorgeous car lurched up the rocky drive to my door and gave out a burst of melody from its three-note horn. It was the first time he had called on me, though I had gone to two of his parties, mounted in his hydroplane, and, at his urgent invitation, made use of his beach.

"Good morning, old sport. You're having lunch with me today and I thought we'd ride up together."

He was balancing himself on the dashboard of his car with that resourcefulness of movement that is so peculiarly American—that comes, I suppose, with the absence of lifting work or rigid sitting in youth and, even more, with the formless grace of our nervous, sporadic games.

This quality was continually breaking through his punctilious manner in the shape of restlessness. He was never quite still; there was always a tapping of a foot somewhere or the impatient opening and closing of a hand.''';
      case 4:
        return '''When I came home to West Egg that night I was afraid for a moment that my house was on fire. Two o'clock in the morning and the whole corner of the peninsula was blazing with light, which fell unreal on the shrubbery and made thin elongations of it across the road.

Turning a corner, I saw that it was Gatsby's house, lit from tower to cellar.

"Your place looks like the World's Fair," I said.

"Does it?" He looked at it absently. "I have been glancing into some of the rooms. Let's go to Louisville and get Daisy tomorrow."

The day agreed upon for the tea arrived. It poured with rain. At eleven o'clock a man in a raincoat, dragging a lawn-mower, tapped at my front door and said that Mr. Gatsby had sent him to cut my grass.''';
      case 5:
        return '''The truth was that Jay Gatsby of West Egg, Long Island, sprang from his platonic conception of himself. He was a son of God—a phrase which, if it means anything, means just that—and he must be about His Father's business, the service of a vast, vulgar, and meretricious beauty.

So he invented just the sort of Jay Gatsby that a seventeen-year-old boy would be likely to invent, and to this conception he was faithful to the end.

His parents were shiftless and unsuccessful farm people—his imagination had never really accepted them as his parents at all.

The truth was that James Gatz of North Dakota had changed his name at the age of seventeen and at the specific moment that witnessed the beginning of his career—when he saw Dan Cody's yacht drop anchor over the most treacherous flat in Lake Superior.''';
      case 6:
        return '''It was on the same day that Gatsby's career as Gatsby began. Dan Cody was fifty years old then, a millionaire manufactured by a little soft-headedness in Nevada, in the silver rushes of Seventy-five.

He had been a physical wreck, but he retained an immense vitality and a streak of madness.

For five years Gatsby worked for him, traveling with him aboard the Tuolomee to the West Indies and the Barbary Coast.

When Dan Cody died, he left Gatsby twenty-five thousand dollars. He didn't get the money. A rumor reached him that Cody's mistress, Ella Kaye, used legal tricks to secure the entire fortune.

He was left with a singular understanding of the world and an indestructible ambition that would eventually build his empire on West Egg.''';
      case 7:
        return '''The next day was stiflingly hot, almost the hottest day of the summer. We sat in the drawing-room of Tom and Daisy's house in East Egg, drinking gin rickeys while the heat pressed down like a heavy blanket.

"Let's go to town!" cried Daisy impatiently. "It's so hot! Everything's so confused!"

We drove to New York in two cars, renting a suite at the Plaza Hotel.

The tension in the room snapped as Tom Buchanan turned on Gatsby, questioning his past and his Oxford education.

"I know I'm not very popular," Tom sneered. "I don't give big parties. But you're not going to make trouble in my house."

"Your wife doesn't love you," said Gatsby quietly. "She's never loved you. She loves me."''';
      case 8:
        return '''After the accident on the dark road where Myrtle Wilson was struck and killed by Gatsby's yellow car—driven by Daisy—I couldn't sleep all night.

I went over to Gatsby's house at dawn. The heavy front door was open, and the vast rooms smelled faintly of dead flowers and stale tobacco.

"You ought to go away," I told him. "They'll trace your car."

"Go away now, old sport?" He shook his head. "I couldn't leave Daisy. Not until I know what she's going to do."

Later that afternoon, while Gatsby floated in his swimming pool on a rubber mattress, waiting for a phone call from Daisy that would never come, George Wilson crept through the bushes with a revolver in his hand.''';
    }
    return '';
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
      case 2:
        return '''在夏夜里，我邻居的房子里传来音乐声。在他蓝色的花园里，男男女女像飞蛾一样在低语、香槟和繁星中来来往往。在下午潮水高涨时，我看着他的客人从他木筏的塔上跳水，或者在他沙滩的热沙上晒太阳，而他的两艘汽艇切开海峡的水面，在泡沫瀑布上拖着水上滑板。

在周末，他的劳斯莱斯变成了一辆公交车，在早上八点到午夜过后很久之间接送前往城市的聚会者，而他的客货两用车则像一只敏捷的黄色昆虫一样飞奔去迎接所有的火车。

在星期一，八个仆人，包括一个额外的园丁，整天带着抹布、刷子、锤子和园艺剪刀辛苦劳作，修复前一天晚上的破坏。

每到星期五，五箱橙子和柠檬从纽约的一家水果商那里运来——每到星期一，这些相同的橙子和柠檬就从他的后门离开，堆成金字塔状的无果肉半块。厨房里有一台机器，如果男仆的拇指按两百次小按钮，半小时内就能榨出两百个橙子的汁。''';
      case 3:
        return '''七月下旬的一个早晨九点，盖茨比华丽的汽车在我门口的岩石驶道上摇晃着停了下来，它那三音符的喇叭喷发出阵阵旋律。这是他第一次来拜访我，尽管我参加过他的两次聚会，乘坐过他的水上飞机，而且在他热情的邀请下使用过他的沙滩。

“早安，老伙计。你今天和我一起吃午饭，我想我们一起坐车去。”

他平衡地站在汽车的仪表盘上，带着那种极具美国特色的机敏动作——我想，这种动作来自于年轻时没有体力劳动或僵硬的坐姿，更有甚者，来自于我们紧张、偶发的运动的不规则优雅。

这种品质不断以不安的形式突破他拘谨的举止。他从来没有完全安静过；总是有脚在某个地方叩击，或者手在不耐烦地张开和闭合。''';
      case 4:
        return '''那天晚上我回到西卵的家里时，有一瞬间我害怕我的房子着火了。凌晨两点，半岛的整个角落都散发着光芒，这些光芒虚幻地落在灌木丛上，使它们在马路上形成细长的延伸。

转过一个弯，我看到那是盖茨比的房子，从塔楼到地下室都点亮着。

“你的地方看起来像世界博览会，”我说。

“是吗？”他漫不经心地看着它。“我一直在看看一些房间。我们明天去路易斯维尔把黛西接来吧。”

约好喝茶的那一天到了。下着大雨。十一点钟，一个穿雨衣的人拖着割草机敲了我前门，说盖茨比先生派他来割我的草。''';
      case 5:
        return '''事实是，长岛西卵的杰伊·盖茨比源于他对自己柏拉图式的概念。他是上帝之子——这个短语如果意味着什么的话，就意味着正是如此——他必须从事他父亲的事业，服务于一种广大、庸俗和虚荣的美。

所以他发明了一个十七岁男孩可能会发明的那种杰伊·盖茨比，并对这个概念忠诚到了终点。

他的父母是无能且不成功的农夫——他的想象力从未真正接受他们是他的父母。

事实是，北达科他州的詹姆斯·盖茨在十七岁时改了名字，那正是见证他职业生涯开始的具体时刻——当时他看到丹·科迪的游艇在苏必利尔湖最危险的浅滩上降下锚。''';
      case 6:
        return '''就在同一天，盖茨比作为盖茨比的职业生涯开始了。丹·科迪当时五十岁，是一个在七五年内华达州软头脑银矿热潮中制造出来的百万富翁。

他曾是一个身体残破的人，但他保留了巨大的活力和一丝狂热。

五年来盖茨比为他工作，乘坐“图奥勒米号”与他一起前往西印度群岛和巴巴里海岸。

当丹·科迪去世时，他给盖茨比留下了两万五千美元。他没有拿到那笔钱。一个传言传来，科迪的情妇艾拉·凯利用法律手段获得了全部财产。

他被留下了对世界的独特理解和不可摧毁的雄心，这种雄心最终将在西卵建立他的帝国。''';
      case 7:
        return '''第二天闷热无比，几乎是夏天最热的一天。我们坐在东卵汤姆和黛西家里的客厅里，喝着金汤力，而热气像厚厚的毯子一样压下来。

“我们去城里吧！”黛西不耐烦地喊道。“太热了！一切都太混乱了！”

我们坐两辆车开往纽约，在广场酒店租了一套套房。

随着汤姆·布坎南转向盖茨比，质问他的过去和他在牛津的教育，房间里的紧张气氛陡然打破。

“我知道我不太受欢迎，”汤姆冷笑道。“我不举办大型聚会。但你不能在我的房子里挑起事端。”

“你的妻子不爱你，”盖茨比平静地说。“她从来没有爱过你。她爱我。”''';
      case 8:
        return '''在漆黑马路上发生惨烈车祸、默特尔·威尔逊被黛西驾驶的盖茨比黄色汽车撞死之后，我整晚都无法入睡。

黎明时分我去了盖茨比的房子。沉重的前门开着，巨大的房间里隐约散发着枯花和陈旧烟草的气味。

“你该离开了，”我告诉他。“他们会追踪你的车。”

“现在离开，老伙计？”他摇了摇头。“我不能离开黛西。直到我知道她打算怎么办。”

那天下午晚些时候，当盖茨比浮在他的游泳池里的橡胶垫上，等待着黛西永远不会打来的电话时，乔治·威尔逊手里拿着左轮手枪从灌木丛中溜了过来。''';
    }
    return '';
  }
}
