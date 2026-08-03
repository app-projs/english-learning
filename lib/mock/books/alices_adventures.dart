import '../../models/article.dart';

class AliceAdventuresMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'alice_u$unitNum',
        bookId: 'book_alice',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Easy',
        category: '经典名著',
        tags: ['Classic', 'Fantasy', 'Adventure'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 9,
        coverUrl: 'assets/images/book_alice.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: Down the Rabbit-Hole',
    'Chapter 2: The Pool of Tears',
    'Chapter 3: A Caucus-Race and a Long Tale',
    'Chapter 4: The Rabbit Sends in a Little Bill',
    'Chapter 5: Advice from a Caterpillar',
    'Chapter 6: Pig and Pepper',
    'Chapter 7: A Mad Tea-Party',
    'Chapter 8: The Queen’s Croquet-Ground',
    'Chapter 9: The Mock Turtle’s Story',
    'Chapter 10: The Lobster Quadrille',
    'Chapter 11: Who Stole the Tarts?',
    'Chapter 12: Alice’s Evidence',
  ];

  static final List<String> chineseTitles = [
    '掉进兔子洞',
    '泪水之池',
    '无结果的赛跑与长长的尾巴',
    '兔子派来了小比尔',
    '毛毛虫的忠告',
    '小猪与胡椒粉',
    '疯狂的茶会',
    '红心王后的槌球场',
    '假海龟的故事',
    '龙虾龙代尔舞',
    '谁偷了馅饼？',
    '爱丽丝的证词与觉醒',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, "and what is the use of a book," thought Alice "without pictures or conversations?"

So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.

There was nothing so VERY remarkable in that; nor did Alice think it so VERY much out of the way to hear the Rabbit say to itself, "Oh dear! Oh dear! I shall be late!" (when she thought it over afterwards, it occurred to her that she ought to have wondered at this, but at the time it all seemed quite natural); but when the Rabbit actually TOOK A WATCH OUT OF ITS WASTECOAT-POCKET, and looked at it, and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and burning with curiosity, she ran across the field after it, and fortunately was just in time to see it pop down a large rabbit-hole under the hedge.

In another moment down went Alice after it, never once considering how in the world she was to get out again.''';
      case 1:
        return '''"Curiouser and curiouser!" cried Alice (she was so much surprised, that for the moment she quite forgot how to speak good English); "now I'm opening out like the largest telescope that ever was! Good-bye, feet!" (for when she looked down at her feet, they seemed to be almost out of sight, they were getting so far off). "Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I'm sure I shan't be able! I shall be a great deal too far off to trouble myself about you: you must manage the best way you can;—but I must be kind to them," thought Alice, "or perhaps they won't walk the way I want to go!"

Just then her head struck against the roof of the hall: in fact she was now more than nine feet high, and she at once took up the little golden key and hurried off to the garden door.

Poor Alice! It was as much as she could do, lying down on one side, to look through into the garden with one eye; but to get through was more hopeless than ever: she sat down and began to cry again.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Lewis Carroll's timeless masterpiece, Alice's Adventures in Wonderland.

Alice navigated the absurd, whimsical, and illogical logic of Wonderland, meeting unforgettable characters like the Cheshire Cat, the Mad Hatter, the March Hare, and the tyrannical Queen of Hearts.

"Why, they're nothing but a pack of cards!" Alice exclaimed as the illusion dissolved and she woke up on the sunny bank beside her sister.

Her magical dream journey stands as an enduring masterpiece of literary nonsense and imaginative storytelling.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''爱丽丝在河岸边陪姐姐坐了很久，无所事事，渐渐感到非常厌倦：她偶一两次瞅了瞅姐姐正在读的那本书，但里面既没有插图也没有对话，“要是书里既没有插图也没有对话，”爱丽丝想，“那这本书还有什么用呢？”

于是她正在心里盘算着（尽她所能，因为炎热的天气使她感到又昏昏欲睡又木讷），做一串雏菊项链的乐趣是否值得她站起来去采摘雏菊，突然一只粉红眼睛的白兔子贴着她跑了过去。

这并没有什么非常了不起的；爱丽丝听见兔子自言自语地说：“天哪！天哪！我要迟到了！”时，也并不觉得特别离奇（后来当她仔细琢磨时，她觉得当时本该感到惊奇的，但当时这一切似乎都很自然）；但当那只兔子真的从马甲口袋里掏出一块怀表，看了看，然后急匆茫茫地继续往前跑时，爱丽丝一跃而起，因为她脑海里突然闪过一个念头：她以前从来没有见过哪只兔子穿马甲口袋，更不用说从里面掏出怀表来了。在好奇心的驱使下，她穿过田野追了过去，幸运的是，正好赶上看到它跳进了篱笆下的一个大兔子洞里。

下一刻，爱丽丝也跟着跳了下去，压根儿没考虑过将来到底该怎么出来。''';
      case 1:
        return '''“越来越奇妙了！”爱丽丝大声叫道（她是如此吃惊，以至于一时竟忘了怎么说标准英语了）；“现在我像有史以来最大的望远镜一样拉长了！再见，脚丫们！”（因为当她低头看自己的脚时，它们似乎快要从视野里消失了，变得那么遥远）。“哦，我可怜的小脚丫们，我不知道现在谁来帮你们穿鞋穿袜了，亲爱的们？我敢肯定我是无能为力了！我离得太远了，顾不上你们了：你们必须尽力照料好自己；——但我必须对它们好一点，”爱丽丝想，“否则也许它们就不会朝我想去的方向走了！”

就在这时，她的头撞到了大厅的顶棚：事实上她现在已经九英尺多高了，她立刻拿起来那把小金钥匙，急忙向花园门跑去。

可怜的爱丽丝！她侧身躺下，最多只能用一只眼睛透过去看看花园；但要穿过去比以往任何时候都更加没有希望了：她坐下来，又开始哭了起来。''';
      default:
        final chapterNum = index + 1;
        return '''这是路易斯·卡罗尔经典荒诞名著《爱丽丝梦游仙境》的第 $chapterNum 章。

爱丽丝穿梭在仙境荒诞、奇妙而违背常理的逻辑中，遇到了柴郡猫、疯帽匠、三月兔以及暴虐的红心王后等令人难忘的角色。

“为什么，你们不过是一副扑克牌罢了！”当幻象破灭、爱丽丝在姐姐身旁阳光明媚的河岸边醒来时，她惊呼道。

她神奇的梦境之旅成为了荒诞文学与想象力叙事的永恒巅峰杰作。''';
    }
  }
}
