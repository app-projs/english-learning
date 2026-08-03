import '../../models/article.dart';

class PrideAndPrejudiceMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(61, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'pride_u$unitNum',
        bookId: 'book_pride',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Romance', 'Literature'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_pride.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: A Truth Universally Acknowledged',
    'Chapter 2: Mr. Bingley Arrives at Netherfield',
    'Chapter 3: The Assembly Ball at Meryton',
    'Chapter 4: Jane and Elizabeth’s Confidence',
    'Chapter 5: Charlotte Lucas and Sir William',
    'Chapter 6: Darcy’s Growing Attraction',
    'Chapter 7: Jane’s Illness at Netherfield',
    'Chapter 8: Elizabeth’s Journey in the Mud',
    'Chapter 9: Mrs. Bennet’s Visit',
    'Chapter 10: The Conversation in the Drawing Room',
    'Chapter 11: Mr. Collins Arrives at Longbourn',
    'Chapter 12: The Proposal and Beyond',
    'Chapter 13: Mr. Collins’ Letter',
    'Chapter 14: Mr. Wickham’s Arrival',
    'Chapter 15: The Walk to Meryton',
    'Chapter 16: Wickham’s Story of Darcy',
    'Chapter 17: The Netherfield Ball Preparations',
    'Chapter 18: The Netherfield Ball',
    'Chapter 19: Mr. Collins Proposes to Elizabeth',
    'Chapter 20: Mrs. Bennet’s Anger',
    'Chapter 21: Departure of the Bingleys',
    'Chapter 22: Charlotte Accepts Mr. Collins',
    'Chapter 23: Sir William’s News',
    'Chapter 24: Jane’s Disappointment',
    'Chapter 25: The Gardiners’ Visit',
    'Chapter 26: Jane Goes to London',
    'Chapter 27: Elizabeth’s Journey to Hunsford',
    'Chapter 28: Arrival at the Parsonage',
    'Chapter 29: Lady Catherine de Bourgh',
    'Chapter 30: Darcy Arrives at Rosings',
    'Chapter 31: Music at Rosings',
    'Chapter 32: Darcy’s Solitary Walks',
    'Chapter 33: Colonel Fitzwilliam’s Revelations',
    'Chapter 34: Darcy’s First Proposal',
    'Chapter 35: The Letter of Explanation',
    'Chapter 36: Elizabeth’s Self-Examination',
    'Chapter 37: Departure from Rosings',
    'Chapter 38: Return to Longbourn',
    'Chapter 39: Meeting Lydia and Kitty',
    'Chapter 40: Sharing the Secret with Jane',
    'Chapter 41: Lydia Goes to Brighton',
    'Chapter 42: Tour of the Lakes',
    'Chapter 43: Pemberley and the Housekeeper',
    'Chapter 44: Meeting Miss Darcy',
    'Chapter 45: Visit to Pemberley',
    'Chapter 46: Distress and News of Lydia',
    'Chapter 47: The Elopement Search',
    'Chapter 48: Letters from London',
    'Chapter 49: Lydia is Found',
    'Chapter 50: Terms of Marriage',
    'Chapter 51: Lydia and Wickham Return',
    'Chapter 52: Mrs. Gardiner’s Letter',
    'Chapter 53: Bingley Returns to Netherfield',
    'Chapter 54: Bingley’s Proposal to Jane',
    'Chapter 55: The Engagement Announced',
    'Chapter 56: Lady Catherine’s Unexpected Visit',
    'Chapter 57: Mr. Bennet’s Amusement',
    'Chapter 58: Darcy’s Second Proposal',
    'Chapter 59: Elizabeth Tells Her Family',
    'Chapter 60: Letters of Marriage Announcement',
    'Chapter 61: Conclusion and Happy Futures',
  ];

  static final List<String> chineseTitles = [
    '举世公认的真理：单身汉与富贵妻子',
    '宾利先生入住尼瑟菲尔德庄园',
    '麦里屯舞会上的初次遭遇与傲慢',
    '简与伊丽莎白姐妹间的闺中知心话',
    '夏洛特·卢卡斯与威廉爵士',
    '达西先生悄然萌生的吸引与关注',
    '简在尼瑟菲尔德庄园突发重感冒',
    '伊丽莎白踏着泥泞前往探望长姐',
    '班奈特太太高调拜访庄园',
    '起居室里的交锋与智斗',
    '柯林斯先生抵达朗博恩',
    '柯林斯先生的拜访信函',
    '韦翰先生的帅气现身',
    '散步前往麦里屯小镇',
    '韦翰讲述关于达西的“悲惨”遭遇',
    '尼瑟菲尔德舞会的准备',
    '精彩纷呈的尼瑟菲尔德舞会',
    '柯林斯先生向伊丽莎白求婚',
    '班奈特太太的愤怒与坚决',
    '宾利一家突然离开庄园',
    '夏洛特接受了柯林斯先生的求婚',
    '威廉爵士带来的震撼消息',
    '简的失望与内心的伤痛',
    '加德纳夫妇的到来',
    '简前往伦敦探亲',
    '伊丽莎白启程前往亨斯福德',
    '抵达牧师住宅',
    '傲慢高贵的凯瑟琳·德·波尔夫人',
    '达西先生抵达罗辛斯庄园',
    '罗辛斯庄园里的钢琴音乐会',
    '达西先生独自散步与沉思',
    '费茨威廉上校揭露的真相',
    '达西先生的第一次求婚与被拒',
    '达西先生长篇解释信件',
    '伊丽莎白深刻的反思与自我剖析',
    '离开罗辛斯庄园',
    '重返朗博恩家园',
    '迎接莉迪亚与凯蒂',
    '向简坦白达西信件的秘密',
    '莉迪亚获准前往布莱顿',
    '湖区之旅的规划与转变',
    '抵达彭伯里庄园与管家的赞誉',
    '结识达西小姐',
    '拜访彭伯里庄园',
    '噩耗传来：莉迪亚私奔了',
    '伦敦紧急搜寻私奔者',
    '来自伦敦的信件',
    '莉迪亚与韦翰终于被找到',
    '结婚协议与经济条件',
    '莉迪亚与韦翰新婚归来',
    '加德纳太太的回信与真相',
    '宾利重返尼瑟菲尔德庄园',
    '宾利向简正式求婚成功',
    '订婚消息的公布',
    '凯瑟琳夫人的深夜突袭警告',
    '班奈特先生的幽默与调侃',
    '达西先生的第二次求婚与告白',
    '伊丽莎白向家人坦白真情',
    '向亲友寄出结婚喜讯信件',
    '尾声：圆满的婚姻与美好未来',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife.

However little known the feelings or views of such a man may be on his first entering a neighbourhood, this truth is so well fixed in the minds of the surrounding families, that he is considered the rightful property of some one or other of their daughters.

"My dear Mr. Bennet," said his lady to him one day, "have you heard that Netherfield Park is let at last?"

Mr. Bennet replied that he had not.

"But it is," returned she; "for Mrs. Long has just been here, and she told me all about it."

Mr. Bennet made no answer.

"Do you not want to know who has taken it?" cried his wife impatiently.

"You want to tell me, and I have no objection to hearing it."

This was invitation enough.

"Why, my dear, you must know, Mrs. Long says that Netherfield is taken by a young man of large fortune from the north of England; that he came down on Monday in a chaise and four to see the place, and was so much delighted with it, that he agreed with Mr. Morris immediately."''';
      case 1:
        return '''Mr. Bennet was among the earliest of those who waited on Mr. Bingley. He had always intended to visit him, though to the last always assuring his wife that he should not go; and till the evening after the visit was paid she had no knowledge of it.

The news was then disclosed in the following manner. Observing his second daughter employed in trimming a hat, he suddenly addressed her with:

"I hope Mr. Bingley will like it, Lizzy."

"We are not in a way to know what Mr. Bingley likes," said her mother resentfully, "since we are not to visit."

"But you forget, mamma," said Elizabeth, "that we shall meet him at the assemblies, and that Mrs. Long has promised to introduce him."

"I do not believe Mrs. Long will do any such thing. She has two nieces of her own. She is a selfish, hypocritical woman, and I have no opinion of her."

"No more have I," said Mr. Bennet; "and I am glad to find that you do not depend on her serving you."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Jane Austen's immortal romantic masterpiece, Pride and Prejudice.

Elizabeth Bennet's sharp wit and fierce independence clashed continuously with the reserved pride of Mr. Fitzwilliam Darcy. Through misunderstandings, social pressures, and family trials, both were forced to confront their own flaws—Darcy his arrogance, and Elizabeth her hasty prejudice.

"I have been a selfish being all my life, in practice, though not in principle," Darcy confessed, his heart transformed by his deep devotion to Elizabeth.

As their mutual respect and love dissolved all barriers of pride and prejudice, Austen crafted one of the most sublime and enduring love stories in world literature.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''凡是有钱的单身汉，总想娶位太太，这一定律早已举世公认。

这样的人每逢新到一个地方，尽管人们对他本人的感受或看法知之甚少，但这一定律在四周的家族心中是如此根深蒂固，以至于大家都把他看作是自己某个女儿理所应得的财产。

“我亲爱的班奈特先生，”有一天他的太太对他说，“你听说尼瑟菲尔德庄园终于租出去了吗？”

班奈特先生回答说没听说过。

“可确实租出去了呀，”她接着说，“朗格太太刚才来过，她把这一切都告诉我了。”

班奈特先生没有作声。

“难道你不想知道是谁租去的吗？”他的妻子耐不住性子大叫道。

“既然你想告诉我，我也就不反对听听。”

有这句话就足够了。

“哎呀，亲爱的，你得知道，朗格太太说租下尼瑟菲尔德的是个来自英格兰北部的有钱青年；他星期一坐着一辆四匹马拉的轻便马车来看房，对庄园满意极了，当下就和莫里斯先生达成了协议。”''';
      case 1:
        return '''班奈特先生是第一批拜访宾利先生的人之一。他一直打算去拜访他，尽管直到最后他还一直向妻子保证说他不会去；直到拜访后的那天晚上，妻子才知道这件事。

消息是按以下方式透露的。看到二女儿正在修饰一顶帽子，他突然对 shorthand 说了句：

“我希望宾利先生会喜欢这顶帽子，丽兹。”

“我们又没法去拜访，”她的母亲愤愤地说，“哪能知道宾利先生喜欢什么。”

“可你忘了，妈妈，”伊丽莎白说，“我们会在舞会上遇到他，朗格太太答应过把它介绍给我们的。”

“我不相信朗格太太会做这种事。她自己有两个侄女。她是个自私、虚伪的女人，我对她一点好印象也没有。”

“我也一样，”班奈特先生说，“很高兴发现你不指望她为你服务。”''';
      default:
        final chapterNum = index + 1;
        return '''这是简·奥斯汀不朽的浪漫文学巅峰名著《傲慢与偏见》的第 $chapterNum 章。

伊丽莎白·班奈特的敏锐机智与独立性格，与斐茨威廉·达西先生内敛的傲慢不断发生碰撞。通过误解、社会压力和家庭考验，两人都被迫面对自己的缺陷——达西面对他的傲慢，而伊丽莎白面对她轻率的偏见。

“在实际上，尽管不是在原则上，我一生都是个自私的人，”达西坦白道，他的心被对伊丽莎白深深的奉献所改变。

随着他们相互的尊重与真爱融化了傲慢与偏见的所有屏障，奥斯汀塑造了世界文学史上最崇高、最永恒的爱情故事之一。''';
    }
  }
}
