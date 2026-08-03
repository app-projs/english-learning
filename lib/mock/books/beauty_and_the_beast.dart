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
        title: titles[index],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index]}',
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
      case 3:
        return '''When the merchant returned home in tears, he told his children of the terrible pledge he had made to the Beast. The elder sisters wept and blamed Beauty for demanding a rose that brought ruin upon their father.

"Since the rose was the cause of this misfortune," Beauty declared calmly, "it is right that I should suffer for it. I will go to the Beast's palace in your place, Father."

Her father and brothers protested, refusing to let her sacrifice herself, but Beauty's resolution was firm.

Three months later, the merchant accompanied Beauty back to the enchanted castle. They found a table set with two plates of gold, laden with a sumptuous feast.

As they finished eating, the heavy footsteps of the Beast echoed through the hall, and the terrifying creature stepped into the moonlight.''';
      case 4:
        return '''The Beast turned to Beauty and asked in a low, rumbling voice: "Did you come here of your own free will?"

"Yes, my Lord," Beauty replied, trembling, though she met his gaze with courage.

"You are a good girl," said the Beast, "and I am much obliged to you. Father, you must leave tomorrow morning and never return to this castle again."

The next day, after tearfully bidding her father farewell, Beauty expected to be killed and eaten before nightfall. Instead, she found a door marked: "Beauty's Apartment."

Inside was a magnificent suite of rooms filled with thousands of books, a harpsichord, and wardrobe full of royal gowns. A golden mirror bore the inscription: "Wish, command; you are queen and mistress here."''';
      case 5:
        return '''Every evening at nine o'clock, the Beast joined Beauty for dinner. Though his appearance remained terrifying and his voice harsh, his conversation was gentle, humble, and filled with thoughtful kindness.

Each night as he rose to depart, he asked her the same question: "Beauty, will you marry me?"

And each night, Beauty replied softly: "No, Beast, but I will always be your friend."

The Beast sighed deeply, his eyes filled with sorrow, and bowed before leaving her.

As the months passed, Beauty grew to look forward to their evening dinners, discovering that beneath his monstrous form lay a soul of extraordinary nobility and goodness.''';
      case 6:
        return '''In her dreams, Beauty was visited by a handsome prince who pleaded with her: "Do not let yourself be deceived by appearances, Beauty! Deliver me from the torment that binds me!"

Beauty also looked into her magic mirror every day, which allowed her to see whatever she wished in the world.

One morning, looking into the mirror, she saw her father lying gravely ill in their country cottage, weeping for his lost daughter.

Overcome with grief, Beauty begged the Beast to let her visit her family for just one week.

"I cannot refuse you anything, Beauty," said the Beast mournfully. "If you do not return in eight days, your Beast will die of a broken heart. Take this magic ring—place it on your table when you wish to return."''';
      case 7:
        return '''The next morning, Beauty awoke in her father's house. Her father wept with joy to see her alive, healthy, and dressed like a princess.

Her two elder sisters, who had married poor and arrogant men, were consumed with bitter jealousy when they saw Beauty's fine clothes and heard of her life in the enchanted palace.

"Why should she be happier than we are?" cried the eldest sister. "Let us trick her into staying beyond the eight days! The Beast will be furious and devour her when she returns!"

They feigned deep affection, crying and begging Beauty to stay a few days longer.

Moved by their tears, Beauty agreed to stay ten days instead of eight.''';
      case 8:
        return '''On the tenth night, Beauty had a terrible nightmare. She dreamed she was in the castle garden and saw the Beast lying unconscious on the grass beside a stream, dying of grief.

She woke up in a cold sweat, realizing how ungrateful and cruel she had been to break her promise to her kind benefactor.

"Is it his fault that he is ugly?" she reproached herself. "He is kind, noble, and generous, which is worth far more than beauty or wit. Why did I refuse to marry him?"

She quickly placed her magic ring on the table beside her bed and fell asleep again.

When she opened her eyes the following morning, she found herself back in her familiar rooms at the enchanted castle.''';
      case 9:
        return '''Beauty waited anxiously for nine o'clock, but when the hour struck, the Beast did not appear for dinner.

Fearing her dream had come true, Beauty ran through every room, hallway, and courtyard of the vast castle, calling his name in desperation.

Finally, she remembered the garden stream from her nightmare. She rushed to the spot and found the poor Beast lying motionless on the grass, his eyes closed, his breathing almost gone.

She threw herself upon his body, bathing his face in her tears.

"No, Beast! You must not die!" she sobbed. "Live to be my husband, for from this moment I give you my hand and swear to love only you!"''';
    }
    return '';
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

霎时间，一声可怕的吼声震动了大地，一只狰狞的野兽出现在他面前，双眼闪烁着怒芒。

“忘恩负义的东西！”野兽用粗糙恐怖的声音喊道。“我接纳你进我的城堡救了你的命，作为回报，你却偷了我最喜欢的玫瑰！犯下这种罪行，你必须死！”

商人跪倒在地，哭泣着求饶，说他只是为了小女儿才摘这朵花的。

野兽沉思了一下说：“我有一个条件可以原谅你：你的一个女儿必须自愿替你来死。如果她拒绝，你必须在三个月后回来接受你的命运。”''';
      case 3:
        return '''当商人满脸泪水回到家时，他把对野兽立下的可怕誓言告诉了孩子们。大姐姐们哭泣着抱怨贝儿要了一朵玫瑰，给父亲带来了灭顶之灾。

“既然这朵玫瑰是灾难的起因，”贝儿平静地宣告，“我为它受苦是理所应当的。父亲，我会替您去野兽的宫殿。”

她的父亲和哥哥们抗议，拒绝让她牺牲自己，但贝儿的决心非常坚定。

三个月后，商人陪同贝儿回到了这座魔法城堡。他们发现桌上摆着两张金盘子，上面摆满了丰盛的宴席。

当他们吃完饭时，野兽沉重的脚步声在客厅里回荡，可怕的生物走进了月光下。''';
      case 4:
        return '''野兽转向贝儿，用低沉轰鸣的声音问：“你是出自你自己的自由意志来到这里的吗？”

“是的，大人，”贝儿颤抖着回答，虽然她勇敢地迎上了他的目光。

“你是个好女孩，”野兽说，“我非常感激你。父亲，你必须在明天早晨离开，再也不要回到这座城堡。”

第二天，在含泪与父亲告别后，贝儿本以为会在夜幕降临前被杀死吃掉。相反，她发现了一扇门上写着：“贝儿的公寓”。

里面是一套宏伟的套房，装满了数千本书、一台羽管键琴和一个装满皇家礼服的衣柜。一面金色的镜子上刻着字：“许愿，下令；你在这里是女王和主人。”''';
      case 5:
        return '''每天晚上九点钟，野兽都会和贝儿一起吃晚餐。尽管他的外表依然恐怖，声音粗糙，但他的交谈温柔、谦逊，充满了体贴的善良。

每天晚上当他站起来准备离开时，他都会问她同一个问题：“贝儿，你愿意嫁给我吗？”

每天晚上，贝儿都温柔地回答：“不，野兽，但我永远是你的朋友。”

野兽深深地叹了口气，眼里充满了悲伤，在离开她之前躬身致意。

随着几个月的流逝，贝儿渐渐期待着他们的晚宴，发现建立在他狰狞外表之下的是一颗非凡高尚和善良的心灵。''';
      case 6:
        return '''在她的梦里，一位英俊的王子拜访了贝儿，央求她：“不要让自己被外表所蒙蔽，贝儿！把你从束缚我的痛苦中解救出来吧！”

贝儿每天也会看她的魔镜，魔镜能让她看到世上她想看的任何东西。

一天早晨，看着镜子，她看到父亲躺在乡下小屋里重病缠身，为失去的女儿流泪。

贝儿被悲伤压垮，求野兽允许她回家看望家人仅仅一周。

“我不能拒绝你任何事，贝儿，”野兽悲伤地说。“如果你八天内不回来，你的野兽就会死于心碎。拿着这枚魔戒——当你想回来时把它放在你的桌子上。”''';
      case 7:
        return '''第二天早晨，贝儿在她父亲的家里醒来。父亲看到她活着、健康且穿得像个公主，高兴得流下了眼泪。

她的两个大姐姐嫁给了贫穷而傲慢的男人，当她们看到贝儿漂亮的衣服并听说她在魔法宫殿里的生活时，心里充满了苦涩的嫉妒。

“为什么她应该比我们更幸福？”大姐姐喊道。“让我们骗她留下来超过八天吧！当她回去时，野兽会发怒并吞噬她的！”

她们伪装出深深的爱意，哭泣着求贝儿多留几天。

被她们的眼泪所打动，贝儿同意留十天而不是八天。''';
      case 8:
        return '''在第十个夜晚，贝儿做了一个可怕的噩梦。她梦见自己在城堡的花园里，看到野兽昏迷不醒地躺在溪边草地上，因悲伤而濒临死亡。

她出了一身冷汗醒来，意识到自己打破了对善良恩人的诺言是多么忘恩负义和残酷。

“他长得丑是他的错吗？”她自责道。“他善良、高尚、慷慨，这比美丽或聪慧更有价值得多。我为什么要拒绝嫁给他呢？”

她迅速把魔戒放在床边的桌子上，重新睡着了。

第二天早晨当她睁开眼睛时，她发现自己回到了魔法城堡里熟悉的房间里。''';
      case 9:
        return '''贝儿焦急地等待着九点钟，但当钟声敲响时，野兽并没有出现吃晚餐。

害怕她的梦变成了现实，贝儿跑遍了这座巨大城堡的每一个房间、走廊和庭院，在绝望中呼喊着他的名字。

最后，她想起了噩梦中的花园溪流。她冲到那个地方，发现可怜的野兽无动于衷地躺在草地上，闭着眼睛，呼吸几乎停止了。

她扑倒在他的身上，用眼泪打湿了他的脸。

“不，野兽！你不能死！”她抽泣道。“活下来做我的丈夫吧，因为从这一刻起，我把我的手交给你，发誓只爱你一个人！”''';
    }
    return '';
  }
}
