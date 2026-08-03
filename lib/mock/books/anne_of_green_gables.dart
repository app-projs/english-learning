import '../../models/article.dart';

class AnneOfGreenGablesMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(38, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'anne_u$unitNum',
        bookId: 'book_anne',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Literature', 'Growth'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_anne.png',
      );
    });
  }

  static final List<String> titles = [
    'Mrs. Rachel Lynde is Surprised',
    'Matthew Cuthbert is Surprised',
    'Marilla Cuthbert is Surprised',
    'Morning at Green Gables',
    'Anne’s Early History',
    'Marilla Makes Up Her Mind',
    'Anne Says Her Prayers',
    'Anne’s Solemn Vow',
    'A Delightful Invitation',
    'The Queen’s Academy Class',
    'The Queen’s Honor',
    'The Bend in the Road',
    'Anne’s Impression of Avonlea',
    'A Tempest in a Teapot',
    'Anne’s First Day at School',
    'An Unfortunate Incident of Tea',
    'A New Interest in Life',
    'Anne to the Rescue',
    'A Concert, a Catastrophe and a Confession',
    'A Good Imagination Gone Wrong',
    'A New Departure in Flavoring',
    'Anne is Invited Out to Tea',
    'A Matter of Conscience',
    'Anne’s Hair is Dyed Green',
    'The Unfortunate Lily Maid',
    'A Milestone in Life',
    'The Story Club is Formed',
    'An Epoch in Anne’s Life',
    'The Queen’s Class is Formed',
    'The Pass List is Out',
    'The Hotel Concert',
    'The Queen’s Girl',
    'The Winter at Queen’s',
    'The Glory and the Dream',
    'The Reaper Whose Name is Death',
    'The Bend in the Road',
    'The Final Resolution',
    'An Everlasting Hope',
  ];

  static final List<String> chineseTitles = [
    '雷切尔·林德太太的惊奇',
    '马修·卡斯伯特的惊奇',
    '马里拉·卡斯伯特的惊奇',
    '绿山墙的清晨',
    '安妮的童年身世',
    '马里拉下定决心',
    '安妮的晚祷',
    '安妮的庄严誓言',
    '令人愉快的邀请',
    '皇后学院准备班',
    '皇后学院的荣誉榜首',
    '人生路上的转折弯道',
    '安妮对阿文莉的第一印象',
    '茶壶里的一场风波',
    '安妮上学的第一天',
    '一次不幸的下午茶事件',
    '生活中的新乐趣',
    '安妮奋勇救人',
    '音乐会、灾难与坦白',
    '想象力走向了极端',
    '调味品调配的新风波',
    '安妮受邀参加茶会',
    '良心与原则问题',
    '安妮把头发染成了绿色',
    '不幸的百合少女',
    '人生中的里程碑',
    '故事俱乐部的成立',
    '安妮生活中的新纪元',
    '皇后学院准备班的成立',
    '录用榜单揭晓',
    '饭店音乐演奏会',
    '皇后学院的女学生',
    '在皇后学院的冬天',
    '荣耀与梦想',
    '名为死亡的割麦人',
    '路途上的弯道',
    '最终的抉择',
    '永恒不变的希望',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Mrs. Rachel Lynde lived just where the Avonlea main road dipped down into a little hollow, fringed with alders and ladies' eardrops and traversed by a brook that had its source away back in the woods of the old Cuthbert place. It was known to be a intricate, headlong brook in its earliest course through those woods, with dark secrets of pool and cascade; but by the time it reached Lynde's Hollow it was a quiet, well-conducted little stream.

Not even a brook could run past Mrs. Rachel Lynde's door without due regard for decency and decorum; it probably was conscious that Mrs. Rachel sat at her window, keeping a sharp eye on everything that passed, from brooks and children up; and that if she noticed anything odd or out of place she would never rest until she had ferreted out the whys and wherefores thereof.

Yet here was Matthew Cuthbert, at three o'clock on a summer afternoon, driving calmly out of his lane in his best suit of clothes and his buggy, which was plain proof that he was going out of Avonlea! Where on earth was Matthew going, and why was he going there?

Mrs. Rachel pondered until tea-time, and then set out across the orchard to Green Gables. Marilla Cuthbert greeted her warmly in the tidy kitchen.

"Matthew has gone to Bright River," Marilla explained with a calm, unruffled smile. "We are adopting a little boy from an orphan asylum in Nova Scotia to help us on the farm."''';
      case 1:
        return '''Matthew Cuthbert reached the Bright River station just as the evening train was departing. No boy was in sight on the long wooden platform, only a slender girl with long red braids sitting on a pile of shingles.

She wore a faded, oversized yellow dress and held a worn carpetbag tightly in her lap. Her large eyes shone with imagination and vivid wonder as she approached Matthew with eager steps.

"I suppose you are Mr. Matthew Cuthbert of Green Gables?" she asked in a clear, sweet voice. "I was beginning to fear you weren't coming for me after all! I was imagining all the things that might have happened to you."

Matthew's shy heart melted as they drove home beneath the blossoming wild plum and apple trees. The girl chattered endlessly about the beauty of Prince Edward Island, naming the avenue of birch trees the 'White Way of Delight'.''';
      case 2:
        return '''When Matthew and the red-haired girl arrived at Green Gables, Marilla Cuthbert met them at the kitchen doorway in sheer bewilderment and sudden dismay.

"Matthew, where is the boy?" Marilla exclaimed, staring at the child in utter surprise. "We asked Mrs. Spencer to bring us a boy from the asylum!"

The little girl dropped her carpetbag onto the floor and burst into passionate tears. "You don't want me!" she cried. "I might have known it was too beautiful to last! Nobody ever wanted me!"

"Well, well, don't cry, child," Marilla said gently, softening her tone. "We won't turn you out into the night. What is your name?" "Call me Cordelia," she pleaded, "or at least Anne spelled with an E."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of L. M. Montgomery's timeless classic, Anne of Green Gables.

Anne Shirley continued to grow up at Green Gables under the loving care of Marilla and Matthew Cuthbert. Her boundless imagination, fiery spirit, and fierce loyalty transformed the lives of everyone in Avonlea.

From her rivalry and friendship with Gilbert Blythe to her solemn friendship with Diana Barry, Anne faced each adventure with humor, passion, and resilience. She proved that love, kindness, and imagination can turn an unwanted orphan into a cherished daughter and brilliant scholar.

"Isn't it splendid that there are so many things to like in this world?" Anne declared with her characteristic optimism. "And tomorrow is always fresh, with no mistakes in it yet!"''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''雷切尔·林德太太住的地方，正是阿文莉主干道俯冲进一个小低谷的位置。低谷两旁环绕着桤木和吊钟花，一条小溪穿流而过，小溪的源头一直延伸到旧卡斯伯特庄园的树林深处。据人们所知，那条小溪在最初穿过树林时是一条水流急促、曲折蜿蜒的小溪，藏着水潭和瀑布的神秘暗流；但当它流到林德低谷时，已变成了一条安静、循规蹈矩的小溪流。

甚至连一条小溪从雷切尔·林德太太门前流过，也得恪守体面与礼貌；它大概也意识到了雷切尔太太正坐在窗前，用敏锐的眼睛注视着经过的一切，从小溪到小孩无一例外；如果她注意到任何奇怪或离谱的事，不把其中的来龙去脉打听个水落石出，她就决不罢休。

然而，在夏季一个下午的三点钟，马修·卡斯伯特竟然穿着他最好的衣服，驾着小马车平平静静地从巷子里开出来，这清楚地证明了他要离开阿文莉！马修究竟要去哪里？他为什么要去那里？

雷切尔太太思索到下午茶时间，然后穿过果园前往绿山墙。马里拉·卡斯伯特在整洁的厨房里热情地招呼了她。

“马修去亮河镇了，”马里拉带着平静镇定的微笑解释道。“我们正准备从新斯科舍省的孤儿院领养一个小男孩，来农场帮马修干活。”''';
      case 1:
        return '''马修·卡斯伯特到达亮河车站时，晚班火车正准备驶离。长长的木制站台上看不到任何男孩的影子，只有一个瘦弱的女孩坐在木瓦堆上，扎着两条长长的红辫子。

她穿着一件褪色的、过大的黄衣服，腿上紧紧抱包着一只破旧的毯子提包。当她带着热切的脚步走向马修时，她的双眼闪烁着想象力与生动的惊奇。

“我想您一定就是绿山墙的马修·卡斯伯特先生吧？”她用清脆甜美的声音问道。“我刚才都在担心您是不是不来接我了呢！我一直在想象您可能遇到的各种意外。”

当他们驾车行驶在盛开的野李树和苹果树下回家时，马修害羞的心融化了。女孩滔滔不绝地讲述着爱德华王子岛的美丽，将桦树大道命名为“欢愉的白光大道”。''';
      case 2:
        return '''当马修和红发女孩到达绿山墙时，马里拉·卡斯伯特在厨房门口接到了他们，眼中满是茫然与突如其来的沮丧。

“马修，男孩在哪里？”马里拉惊呼道，十分吃惊地盯着这个孩子。“我们明明让斯宾塞太太从孤儿院带个男孩回来的！”

小女孩把毯子包掉在地上，大声痛哭起来。“你们不要我！”她哭喊道。“我早该知道这太美好了，不可能长久！从来没有人要过我！”

“好了，好了，别哭了，孩子，”马里拉温和地说，语气缓和了下来。“我们不会把你赶到夜色里的。你叫什么名字？”“叫我科迪莉亚吧，”她央求道，“或者至少叫我带 E 的安妮（Anne）。”''';
      default:
        final chapterNum = index + 1;
        return '''这是露西·莫德·蒙哥马利经典名著《绿山墙的安妮》的第 $chapterNum 章。

在马里拉和马修·卡斯伯特的爱心照料下，安妮·雪莉在绿山墙渐渐长大。她无限的想象力、炽热的灵魂和无比的忠诚改变了阿文莉每一个人的生活。

从她与吉尔伯特·布莱斯的竞争与友谊，到她与戴安娜·巴里的庄严誓言，安妮用幽默、热情感恩与坚韧面对每一次冒险。她证明了爱、善良和想象力能把一个没人要的孤儿变成受人珍爱的女儿和杰出的学者。

“这世界上有这么多值得喜欢的东西，难道不是很棒吗？”安妮用她特有的乐观宣告着。“而且明天永远是全新的，里面还没有犯过任何错误呢！”''';
    }
  }
}
