import '../../models/article.dart';

class GreatStoneFaceMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'stoneface_u$unitNum',
        bookId: 'book_stoneface',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Philosophy', 'Literature'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 11,
        coverUrl: 'assets/images/book_stoneface.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Prophecy of the Valley',
    'Chapter 2: The Childhood of Ernest',
    'Chapter 3: Mr. Gathergold’s Return',
    'Chapter 4: The Fall of False Riches',
    'Chapter 5: Old Blood-and-Thunder',
    'Chapter 6: The Failure of Military Glory',
    'Chapter 7: Old Stony Phiz',
    'Chapter 8: The Eloquent Statesman',
    'Chapter 9: The Sublime Poet',
    'Chapter 10: The Fulfillment of the Great Stone Face',
  ];

  static final List<String> chineseTitles = [
    '山谷中关于巨石人面像的古老预言',
    '欧内斯特的童年与凝望',
    '富豪“聚金先生”的荣耀归来',
    '虚妄财富的幻灭',
    '“铁血老将军”的声浪',
    '军事荣光的虚幻与破灭',
    '“老石脸”政治家的雄辩',
    '崇高诗人的崇拜与寻觅',
    '欧内斯特日复一日的沉思与真诚',
    '预言的终极应验：真正的伟大心灵',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''One afternoon, when the sun was going down, a mother and her little boy sat at the door of their cottage, talking about the Great Stone Face. They had but to lift their eyes, and there it was plainly to be seen, though miles away, with the sunshine gilding all its features.

The Great Stone Face was a work of Nature in her mood of majestic playfulness, formed on the perpendicular side of a mountain by some immense rocks, which had been thrown together in such a manner as, when viewed at a proper distance, precisely to resemble the features of a human countenance.

It had a divine grandeur, a noble benevolence, and a smile so gentle that it seemed to embrace the whole valley.

"Mother," said the little boy, whose name was Ernest, "I wish that the Great Stone Face could speak, for it looks so very kindly that its voice must needs be pleasant. If I were to see a man with such a face, I should love him dearly!"

"If an old prophecy should come to pass," answered his mother, "we may see a man, some time or other, with exactly such a face as that, destined to become the greatest and noblest person of his time."''';
      case 1:
        return '''Ernest never forgot the story his mother told him. It was always in his mind whenever he looked upon the Great Stone Face. He spent his childhood in the quiet valley, assisting his mother in her daily work and attending the village school.

He grew up to be a mild, quiet, and thoughtful youth, educated by no teacher except the mountain face, which poured its silent wisdom into his heart.

News arrived in the valley that Mr. Gathergold, a native who had left years ago as a poor boy, had become so immensely rich that he bought ships, bank stock, and gold mines. Returning to his native valley in his golden carriage, the people cheered that he was the image of the prophecy.

When Ernest looked upon Mr. Gathergold's wrinkled, yellow, and selfish visage, he shook his head sadly: "No, this is not the face of the prophecy."''';
      case 2:
        return '''Years passed away, and Ernest grew into a hardworking, contemplative man. Though simple and unpretentious, his eyes radiated a quiet wisdom that attracted the admiration of his neighbors.

Mr. Gathergold died in poverty, proving that riches alone could never match the divine majesty of the Great Stone Face.

Next came a famous general, known as 'Old Blood-and-Thunder,' who had won great battles for his country. The crowd cheered as the general rode through the valley on his white horse, declaring him the true fulfillment of the prophecy.

Yet, when Ernest gazed into the commander's stern, battle-worn face, he saw determination and courage, but missed the gentle, universal love that glowed from the mountain face.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Nathaniel Hawthorne's masterpiece, The Great Stone Face.

Ernest continued to live his life in quiet humility, delivering wise and inspiring sermons to his fellow villagers at sunset. Though he remained an unpretentious farmer, thinkers, poets, and statesmen traveled from afar to listen to his noble thoughts.

A great poet arrived in the valley and sat among the audience as Ernest spoke beneath the setting sun. Looking from Ernest's radiant, benevolent face to the Great Stone Face on the mountain, the poet suddenly shouted:

"Behold! Behold! Ernest himself is the image of the Great Stone Face!"

The crowd looked and saw that it was true. Yet Ernest, taking the poet's arm, walked home slowly, still hoping that some wiser and better man than himself would one day appear, bearing the likeness of the Great Stone Face.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''一天下午，当太阳落山时，一位母亲和她的小男孩坐在小屋门口，谈论着巨石人面像。他们只要抬头一看，就能清楚地看到它，虽然远在数英里之外，但阳光镀金般照亮了它所有的轮廓。

巨石人面像乃是大自然在庄严玩耍的心情下的杰作，它由悬崖峭壁上的几块巨大的岩石组合而成，当在适当的距离观看时，其轮廓精确地酷似一张人类的面孔。

它有一种神圣的庄严，一种高尚的慈爱，以及一种如此温和的微笑，仿佛在拥抱着整个山谷。

“妈妈，”名叫欧内斯特的小男孩说，“我希望巨石人面像能说话，因为它看起来是那么亲切，它的声音一定非常悦耳。如果我能看到一个拥有这样面孔的人，我一定会深深地爱他！”

“如果一个古老预言能够实现的话，”他的母亲回答说，“我们也许在将来的某个时刻，会看到一个拥有完全相同面孔的人，他注定要成为他那个时代最伟大、最高尚的人。”''';
      case 1:
        return '''欧内斯特从未忘记母亲给讲的故事。每当他凝望巨石人面像时，那个故事总是浮现在他的脑海里。他在宁静的山谷里度过了童年，帮母亲做日常农活，并在村里的学校上学。

他长大成了一个温和、安静、深思熟虑的青年，除了那张山石面孔外没有受过其他老师的教育，山石面孔将它无声的智慧注入了他的心田。

山谷里传来消息，多年前贫穷离家出走的本乡人“聚金先生”变得极其富有，买下了船只、银行股票和金矿。他乘坐金马车回到家乡的山谷，人们欢呼他是预言中的化身。

当欧内斯特看着聚金先生那张满是皱纹、发黄且自私的面孔时，他沮丧地摇了摇头：“不，这不是预言中的面孔。”''';
      case 2:
        return '''许多年过去了，欧内斯特长成了一个勤劳、沉思的中年人。虽然朴实无华，但他的眼睛里放射出一种安静的智慧，赢得了邻居们的赞赏。

聚金先生在贫困中死去，证明了单凭财富永远无法媲美巨石人面像的神圣庄严。

接下来是一位著名的将军，被称为“铁血老将军”，他为国家赢得了伟大的战役。当将军骑着白马穿过山谷时，人群欢呼，宣称他是预言的真正实现。

然而，当欧内斯特凝视这位指挥官严厉、饱经沧桑的面孔时，他看到了决心和勇气，却错过了从山石面孔上熠熠生辉的温和、博大的爱。''';
      default:
        final chapterNum = index + 1;
        return '''这是纳撒尼尔·霍桑哲理名作《巨石人面像》的第 $chapterNum 章。

欧内斯特继续在安静的谦逊中度过他的生活，在日落时分向他的村民们发表睿智而令人振奋的讲道。尽管他仍然是一个朴实无华的农夫，但思想家、诗人和平民政治家都从远方赶来聆听他高尚的思想。

一位伟大的诗人来到山谷，在落日余晖下当欧内斯特演讲时坐在听众席中。诗人看着欧内斯特容光焕发、慈祥的面孔，又看着山上上的巨石人面像，突然喊道：

“看啊！看啊！欧内斯特自己就是巨石人面像的化身！”

人群看过去，发现果然如此。然而欧内斯特挽着诗人的手臂，缓缓走回家中，依然希望有某个比自己更睿智、更好的人有一天会出现，长得像巨石人面像一样。''';
    }
  }
}
