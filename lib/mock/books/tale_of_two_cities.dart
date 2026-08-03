import '../../models/article.dart';

class TaleOfTwoCitiesMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(45, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'twocities_u$unitNum',
        bookId: 'book_twocities',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'History', 'Sacrifice'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 13,
        coverUrl: 'assets/images/book_twocities.png',
      );
    });
  }

  static final List<String> titles = [
    'Book 1: The Period (It Was the Best of Times)',
    'Book 1: The Mail Coach to Dover',
    'Book 1: The Night Shadows',
    'Book 1: The Preparation at the Royal George',
    'Book 1: The Wine-shop in Saint Antoine',
    'Book 1: The Shoemaker’s Garret',
    'Book 2: Five Years Later at Tellson’s',
    'Book 2: A Sight at the Old Bailey',
    'Book 2: A Disappointment and the Acquittal',
    'Book 2: The Two Jackals',
    'Book 2: The Monseigneur in Town',
    'Book 2: The Monseigneur in the Country',
    'Book 2: The Gorgon’s Head',
    'Book 2: Two Promises',
    'Book 2: The Fellow of Delicacy',
    'Book 2: The Fellow of No Delicacy',
    'Book 2: The Honest Tradesman',
    'Book 2: Knitting—Madame Defarge',
    'Book 2: Still Knitting',
    'Book 2: One Night in Paris',
    'Book 2: Nine Days',
    'Book 2: An Opinion on Dr. Manette',
    'Book 2: A Sight of the Golden Thread',
    'Book 2: Drawing Near the Storm',
    'Book 2: Echoing Footsteps',
    'Book 2: The Sea Still Rises',
    'Book 2: Fire Rises',
    'Book 2: Drawn to the Loadstone Rock',
    'Book 3: In Secret at La Force',
    'Book 3: The Grindstone',
    'Book 3: The Shadow of Madame Defarge',
    'Book 3: Calm in the Storm',
    'Book 3: The Wood-sawyer',
    'Book 3: The Tribunal',
    'Book 3: Knock at the Door',
    'Book 3: A Hand at Cards',
    'Book 3: The Game Made',
    'Book 3: The Substance of the Shadow',
    'Book 3: Darkness and Silence',
    'Book 3: Fifty-two Prisoners',
    'Book 3: The Sacrifice of Sydney Carton',
    'Book 3: The Revolution at Its Height',
    'Book 3: The Knitting Done',
    'Book 3: The Tumbrils Roll',
    'Book 3: It Is a Far, Far Better Thing I Do',
  ];

  static final List<String> chineseTitles = [
    '这是最好的时代，这是最坏的时代',
    '前往多佛的邮政马车',
    '夜色下的阴影',
    '皇家乔治宾馆的准备',
    '圣安东尼区的老酒馆',
    '阁楼里的老鞋匠马奈特',
    '五年后的泰尔森银行',
    '老贝利法庭审判',
    '令人失望的无罪释放',
    '两只豺狼与卡顿',
    '城里的阁下',
    '乡间的阁下马车马匹',
    '美杜莎蛇发女怪的头雕',
    '两个庄严的诺言',
    '有教养的追求者',
    '毫无教养的追求者',
    '老实的商人',
    '编织者德法热太太',
    '依然在编织仇恨名单',
    '巴黎的一夜',
    '为期九天的发作',
    '关于马奈特医生的医学意见',
    '金线的交织',
    '风暴的逼近',
    '回荡的脚步声',
    '怒海依然在翻腾',
    '烈火在熊蔓延',
    '吸铁石磐石的召唤',
    '秘密囚禁于拉福尔斯监狱',
    '狂热的磨刀石',
    '德法热太太的阴影',
    '风暴中的平静',
    '锯木匠与断头台',
    '法庭的决断',
    '夜半敲门声',
    '牌局中的手牌底牌',
    '局成的交锋',
    '阴影的实质档案',
    '黑暗与沉寂',
    '五十二名被判死刑的囚犯',
    '悉尼·卡顿的伟大牺牲',
    '革命风暴的高潮',
    '编织的终结',
    '死刑车在滚滚向前',
    '这是我所做过的最好最好的事',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way—in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.

There were a king with a large jaw and a queen with a plain face, on the throne of England; there were a king with a large jaw and a queen with a fair face, on the throne of France. In both countries it was clearer than crystal to the lords of the State preserves of loaves and fishes, that things in general were settled for ever.

It was the year of Our Lord one thousand seven hundred and seventy-five. Spiritual revelations were conceded to England at that favoured period, as at this.''';
      case 1:
        return '''It was the Dover road that lay, on a Friday night late in November, before the first personages with whom this history has business. The Dover road lay dark and heavy through the night, as the Dover mail struggled up Shooter's Hill.

He walked uphill in the mire by the side of the mail, as the rest of the passengers did. Not because they had the least relish for walking exercise, but because the hill, and the harness, and the mud, and the mail were so heavy that the horses had already stopped three times.

With drooping heads and tremulous tails, the horses walked through the deep mud, floundering as if they were in a quicksand.

The driver reined up and called out: "Who goes there? Stand, or I fire!"

A voice replied out of the darkness: "Is that the Dover mail? I want Joe Lorry, of Tellson's Bank in London."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Charles Dickens's sublime historical masterpiece, A Tale of Two Cities.

Set against the violent backdrop of the French Revolution between London and Paris, the novel reached its heroic climax through the extraordinary sacrifice of Sydney Carton.

Carton traded places with Charles Darnay in the condemned cell of La Force to save the happiness of Lucie Manette, whom he loved with a pure, unselfish devotion.

"It is a far, far better thing that I do, than I have ever done; it is a far, far better rest that I go to than I have ever known," Carton declared as he faced the guillotine.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望的春天，这是绝望的冬天；我们面前应有尽有，我们面前一无所有；我们都在直奔天堂，我们都在直奔相反的方向——简而言之，那个时代与当下的时代是如此相似，以至于它那些最喧嚣的权威人士坚持认为，无论是好是坏，只能用最高级的比较级来衡量它。

英国的王座上坐着一位大下巴的国王和一位长相平平的王后；法国的王座上坐着一位大下巴的国王和一位长相端庄的王后。在两个国家里，对于面包和鱼的国家保护区的领主们来说，比水晶还要清晰的是，大体上的事情已经永远定局了。

那是主历一千七百七十五年。在这个受宠的时期，正如在现在一样，精神上的启示被授予了英国。''';
      case 1:
        return '''十一月下旬的一个星期五晚上，多佛公路伸展在这部历史所关涉的第一批要人面前。多佛公路在夜色中显得沉重而黑暗，多佛邮政马车正在向射手山艰难爬行。

他和其余的乘客一样，在马车旁的泥泞中步行上山。倒不是因为他们对步行锻炼有什么兴趣，而是因为山坡、挽具、泥泞和邮件太重了，马匹已经停了三次。

马匹耷拉着头，摇晃着尾巴，在深深的泥泞中行走，挣扎着仿佛陷入了流沙之中。

车夫拉紧缰绳喊道：“谁在那里？站住，否则我就开枪了！”

黑暗中有一个声音回答道：“那是多佛邮政马车吗？我要找伦敦泰尔森银行的乔·洛里。”''';
      default:
        final chapterNum = index + 1;
        return '''这是查尔斯·狄更斯史诗级历史名著《双城记》的第 $chapterNum 章。

以伦敦和巴黎之间法国大革命的暴烈背景为舞台，这部小说通过悉尼·卡顿非凡的牺牲达到了英雄主义的高潮。

卡顿在拉福尔斯死囚牢房里与查尔斯·达奈互换了身份，以拯救他用纯洁无私的奉献所深爱的露西·马奈特的幸福。

“我所做的事，远比我做过的任何事都要好得多；我所去的地方，远比我所知道的任何休息都要好得多，”卡顿在面对断头台时宣告。''';
    }
  }
}
