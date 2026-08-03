import '../../models/article.dart';

class BeautyAndBeastMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'beauty_u$unitNum',
        bookId: 'book_beauty',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Fairy Tale', 'Romance'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 10,
        coverUrl: 'assets/images/book_beauty.jpg',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Merchant and His Daughters',
    'Chapter 2: The Mysterious Palace',
    'Chapter 3: The Rose and the Beast',
    'Chapter 4: Beauty’s Sacrifice',
    'Chapter 5: Life at the Enchanted Castle',
    'Chapter 6: The Magic Mirror and Dreams',
    'Chapter 7: The Visit Home',
    'Chapter 8: The Broken Promise',
    'Chapter 9: The Beast’s Despair',
    'Chapter 10: True Love and the Prince',
  ];

  static final List<String> chineseTitles = [
    '商人与他的女儿们',
    '神秘的城堡宫殿',
    '玫瑰花与野兽现身',
    '贝儿的自我牺牲',
    '魔法城堡里的生活',
    '魔镜与神秘梦境',
    '重返家乡探亲',
    '延误的归期与誓言',
    '野兽的绝望与绝食',
    '真爱觉醒与王子变身',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Once upon a time, in a far-off country, there lived a very wealthy merchant who had six children, three sons and three daughters. His daughters were all very beautiful, but the youngest was the most admired of all. When she was small she was known as "Little Beauty," and the name stuck to her as she grew up, which made her sisters extremely jealous.

The youngest daughter was not only handsomer than her sisters, but also far kinder and more noble in spirit. The two eldest were arrogant because they were rich. They gave themselves great airs and refused to visit other merchants' daughters, considering only noble persons worthy of their company.

Suddenly, a sudden misfortune struck the family. Their large house caught fire and burned to the ground, containing all their valuable merchandise. At the same time, news arrived that all their ships carrying goods across the ocean had been wrecked in a terrible storm.

Reduced to poverty, the merchant retired to a small cottage deep in the countryside, where he and his sons worked hard tilling the land. While the older sisters complained bitterly, Beauty rose before dawn to clean the house and prepare meals with a cheerful heart.''';
      case 1:
        return '''After two years of hard living in the country, the merchant received a letter stating that one of his ships, thought to be lost, had safely arrived in port with valuable cargo. The two elder sisters immediately demanded fine dresses, silk robes, and diamond jewels for his return.

"And what shall I bring for you, Beauty?" asked the father as he prepared his horse.

"Bring me only a fresh rose, dear Father," Beauty replied gently, "for none grow in our country garden."

However, upon reaching the city, the merchant found his cargo seized by creditors, leaving him as poor as before. Dejected and weary, he set out on his long journey home in a blinding snowstorm.

Losing his way in the dense forest, he stumbled upon a magnificent palace illuminated by warm lights. The grand doors stood open, and inside a banquet table was laden with delicious food, yet no host or servant was anywhere to be seen.''';
      case 2:
        return '''After eating and resting comfortably in a luxurious bedchamber, the merchant awoke the next morning feeling refreshed. As he walked through the castle's garden, he saw a bush covered in exquisite crimson roses. Remembering Beauty's request, he plucked a single rose.

Instantly, a terrible roaring sound shook the earth, and a monstrous Beast appeared before him, eyes flashing with anger.

"Ingrate!" cried the Beast in a harsh, terrifying voice. "I saved your life by receiving you into my castle, and in return you steal my favorite roses! For this offense, you must die!"

The merchant fell on his knees, weeping and pleading that he had only taken the flower for his youngest daughter.

The Beast pondered and said: "I will forgive you on one condition: one of your daughters must come voluntarily to die in your place. If she refuses, you must return in three months to meet your fate."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of the original classic, Beauty and the Beast.

Beauty agreed to go to the Beast's palace to save her father's life. Expecting to be devoured, she was surprised to find herself treated like a queen, surrounded by luxury, music, and enchantment. Each evening, the Beast asked her: "Beauty, will you marry me?" and each evening she gently refused, though she grew fond of his kind nature.

When she eventually saw through the Beast's terrifying appearance to his noble heart, her tears of true love broke the wicked fairy's curse, transforming the Beast back into a handsome prince.

"Virtue and kindness of heart are far more precious than beauty or cleverness," the prince declared as they were wedded in joy.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''很久很久以前，在一个遥远的国家，住着一位非常富有的大商人，他有六个孩子，三个儿子和三个女儿。他的女儿们都长得非常漂亮，但小女儿最受大家的赞赏。当她还小的时候，人们就叫她“小美女”（贝儿），随着她长大，这个名字就一直跟着她，这让她的两个姐姐嫉妒不已。

这个小女儿不仅比姐姐们漂亮，而且心灵也远比她们善良高尚。两个大女儿因为富有而傲慢自大。她们摆足了架子，拒绝拜访其他商人的女儿，认为只有贵族才配与她们为伍。

突然间，一场突如其来的灾难打击了这个家庭。他们的大宅子着火烧光了，里面装满了所有昂贵的货物。与此同时，有消息传来，他们运送货物的船队在风暴中全部遇难。

商人落得一贫如洗，带着家人退隐到深山农村的一间小茅屋里，他和儿子们在那里辛勤耕作。当大姐姐们怨天尤人、痛苦抱怨时，贝儿却在黎明前起身，怀着愉快的心情打扫房屋、准备饭菜。''';
      case 1:
        return '''在乡下艰难生活了两年之后，商人收到一封信，信中说他以为已经失踪的一艘货船带着昂贵的货物安全抵港了。两个大姐姐立刻要求父亲回来时给她们带漂亮的礼服、丝绸长袍和钻石珠宝。

“那我给你带点什么呢，贝儿？”父亲在准备骑马出发时问道。

“亲爱的爸爸，只给我带一朵新鲜的玫瑰花吧，”贝儿温柔地回答，“因为我们乡村的花园里一朵也没开。”

然而，到达城市后，商人发现他的货物被债权人没收了，他变得像以前一样贫穷。沮丧而疲惫的他，在刺眼的暴风雪中踏上了漫长的归途。

在密林中迷路后，他偶然发现了一座被温暖灯光照亮的光彩夺目的宫殿。宏伟的大门敞开着，里面摆满了丰盛食物的宴会桌，却看不到任何主人或仆人的影子。''';
      case 2:
        return '''在舒适的寝室里吃饱休息好后，商人第二天早晨醒来感到神清气爽。当他走过城堡的花园时，看到一株灌木上开满了精致的深红色玫瑰。想起贝儿的请求，他摘下了一朵玫瑰。

霎时间，一声可怕的吼声震动了大地，一只狰狞的野兽出现在他面前，双眼闪烁着怒火。

“忘恩负义的东西！”野兽用粗糙恐怖的声音喊道。“我接纳你进我的城堡救了你的命，作为回报，你却偷了我最喜欢的玫瑰！犯下这种罪行，你必须死！”

商人跪倒在地，哭泣着求饶，说他只是为了小女儿才摘这朵花的。

野兽沉思了一下说：“我有一个条件可以原谅你：你的一个女儿必须自愿替你来死。如果她拒绝，你必须在三个月后回来接受你的命运。”''';
      default:
        final chapterNum = index + 1;
        return '''这是经典原著《美女与野兽》的第 $chapterNum 章。

贝儿同意前往野兽的宫殿以挽救父亲的生命。本以为会被吞噬，她却惊讶地发现自己像女王一样受到款待，周围环绕着奢华、音乐和魔法。每天晚上，野兽都会问她：“贝儿，你愿意嫁给我吗？”每天晚上她都温柔地拒绝了，尽管她越来越喜欢他善良的本性。

当她最终透过野兽恐怖的外表看到他高尚的心灵时，她真爱的眼泪破除了邪恶仙女的诅咒，将野兽变回了一位英俊的王子。

“美德与心灵的善良远比美丽或聪慧更为珍贵，”王子在他们幸福成婚时宣告道。''';
    }
  }
}
