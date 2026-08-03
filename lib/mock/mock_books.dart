import '../models/book.dart';
import '../models/article.dart';

class MockBooks {
  static List<Book> getSampleBooks() {
    return [
      Book(
        id: 'book_anne',
        title: 'Anne of Green Gables',
        chineseTitle: '绿山墙的安妮（名著原著全本拆解）',
        author: 'Lucy Maud Montgomery',
        coverUrl: 'assets/images/book_anne.png',
        description: '加拿大经典名著故事，红发少女安妮的乐观温暖与成长奇迹',
        category: '经典名著',
        difficulty: '中/高考难度',
        totalUnits: 12,
        wordCount: 15400,
        readerCount: '128.5万人在读',
        targetVocab: '1500-4000词',
        tagLabel: '名著小说',
        coverBadge: '精读 · 经典名著',
      ),
      Book(
        id: 'book_prince',
        title: 'The Little Prince',
        chineseTitle: '小王子（名著原著全本拆解）',
        author: 'Antoine de Saint-Exupéry',
        coverUrl: 'assets/images/book_prince.png',
        description: '给成年人的童话，探讨爱、责任与生命的哲理名作',
        category: '经典名著',
        difficulty: '初/中级难度',
        totalUnits: 10,
        wordCount: 9800,
        readerCount: '191万人在读',
        targetVocab: '1000-3500词',
        tagLabel: '童话故事',
        coverBadge: '精读 · 经典名著',
      ),
      Book(
        id: 'book_beauty',
        title: 'Beauty and the Beast',
        chineseTitle: '美女与野兽（名著原著全本拆解）',
        author: 'Gabrielle-Suzanne de Villeneuve',
        coverUrl: 'assets/images/book_beauty.jpg',
        description: '迪士尼同名经典原著故事，真爱与内在美的永恒诗篇',
        category: '经典名著',
        difficulty: '四级难度',
        totalUnits: 10,
        wordCount: 11200,
        readerCount: '32.8万人在读',
        tagLabel: '童话故事',
        coverBadge: '特辑 · 经典名著',
      ),
      Book(
        id: 'book_nights',
        title: 'The Arabian Nights',
        chineseTitle: '一千零一夜（名著原著全本拆解）',
        author: 'Arabian Folklore',
        coverUrl: 'assets/images/book_nights.png',
        description: '汇聚古老阿拉伯神话与东方传奇名篇的智慧瑰宝',
        category: '经典名著',
        difficulty: '六级/考研难度',
        totalUnits: 12,
        wordCount: 16800,
        readerCount: '19.8万人在读',
        targetVocab: '3500-6000词',
        tagLabel: '名著小说',
        coverBadge: '精读 · 经典名著',
      ),
      Book(
        id: 'book_stoneface',
        title: 'The Great Stone Face',
        chineseTitle: '巨石人面像（名著原著全本拆解）',
        author: 'Nathaniel Hawthorne',
        coverUrl: 'assets/images/book_stoneface.png',
        description: '纳撒尼尔·霍桑哲理名作，凝望崇高心灵的成长诗篇',
        category: '经典名著',
        difficulty: '高考/四级难度',
        totalUnits: 10,
        wordCount: 12500,
        readerCount: '4.2万人在读',
        targetVocab: '2000-4500词',
        tagLabel: '哲理小说',
        coverBadge: '精选 · 经典名著',
      ),
    ];
  }

  // --- 1. Anne of Green Gables Chapters (12 Units) ---
  static List<Article> getAnneChapters() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'anne_u$unitNum',
        bookId: 'book_anne',
        unitIndex: unitNum,
        title: anneTitles[index % anneTitles.length],
        chineseTitle: '第 $unitNum 单元：${anneChineseTitles[index % anneChineseTitles.length]}',
        content: _getAnneContent(index),
        chineseContent: _getAnneChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Literature', 'Growth'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_anne.png',
      );
    });
  }

  static final List<String> anneTitles = [
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
  ];

  static final List<String> anneChineseTitles = [
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
  ];

  static String _getAnneContent(int index) {
    return '''Mrs. Rachel Lynde lived just where the Avonlea main road dipped down into a little hollow, fringed with alders and ladies’ eardrops and traversed by a brook that had its source away back in the woods of the old Cuthbert place. It was known to be a quiet, intricate little stream in its upper course, but by the time it reached Lynde’s Hollow it was a quiet, well-conducted little brook.

Not even a brook could run past Mrs. Rachel Lynde’s door without due regard for decency and decorum; it probably felt conscious that Mrs. Rachel was sitting at her window, keeping a sharp eye on everything that passed, from brooks and children up. If she noticed anything odd or out of place, she would never rest until she had ferreted out the whys and wherefores thereof.

There are plenty of people, in Avonlea and out of it, who can attend closely to their neighbor’s business by dint of neglecting their own; but Mrs. Rachel Lynde was one of those capable creatures who can manage their own concerns and those of other folks into the bargain. She was a notable housewife; her work was always done and well done.

Yet here was Matthew Cuthbert, at three o’clock in the afternoon of a working day, driving calmly out of the lane, wearing his best suit of clothes and driving his sorrel mare! This meant that he was going out of Avonlea, and the buggy harness proved that he had a considerable distance to travel. Where on earth was Matthew going, and why was he going there?

Had it been any other man in Avonlea, Mrs. Rachel might have pieced information together and guessed his errand. But Matthew was so rarely away from home that there must be something extraordinary afoot. He was the shyest man alive, and hated going among strangers or to any place where he might have to talk.

Mrs. Rachel pondered until tea-time, and then, unable to bear the suspense any longer, she put on her bonnet and set out across the orchard to Green Gables. Green Gables was a big, white, green-shuttered house, sitting back comfortably among apple orchards and birch trees.

Marilla Cuthbert was sweeping the kitchen when Mrs. Rachel arrived. She was a tall, thin woman, with dark hair turned in a hard little knot behind, her crisp angles unsoftened by curves. But there was a saving gleam about her mouth which, if it had been developed, might have passed for a sense of humor.

"Good evening, Rachel," Marilla said briskly. "Take a seat. How are all your folks?" "We are all pretty well," said Mrs. Rachel, "only I was kind of afraid you weren’t, when I saw Matthew starting off today. I thought maybe he was going to the doctor’s."

Marilla’s lips twitched sympathetically. She understood Mrs. Rachel’s errand. "Oh, no, Matthew’s health is fine," she said. "He’s gone to Bright River. We’re getting a little boy from an orphan asylum in Nova Scotia, and he’s coming on the train tonight."

Mrs. Rachel dropped her knitting in sheer astonishment! If Marilla had told her that Matthew had gone to the moon to buy a rocket, she could not have been more amazed. "Marilla Cuthbert," she ejaculated, "are you telling me the truth? A boy from an orphan asylum? Whatever put such a notion into your heads?"''';
  }

  static String _getAnneChineseContent(int index) {
    return '''雷切尔·林德太太住在阿文莉主干道俯冲入小洼地的地方，洼地边缀满了桤木和倒挂金钟，一条小溪穿流而过，小溪发源于旧卡斯伯特庄园深处的树林里。在小溪上游，大家都知道它是一条隐蔽而曲折的小流，但等它流到林德洼地时，已经变成了一条清澈听话的明溪。

甚至连一条小溪从雷切尔·林德太太门前流过，都得顾及体面与规矩；它大概也感受到了林德太太正坐在窗前，敏锐地盯着路过的一切——从小溪到小孩无一例外。如果她注意到任何反常或不对劲的地方，在她彻查出其中的来龙去脉之前，她是绝不会罢休的。

在阿文莉村里村外，有的是靠忽视自家事务来密切操心邻居事情的人；但雷切尔·林德太太是那种精明强干的人，既能把自家的事料理得井井有条，还能顺带把别人的事也打理好。她是位出名的能干主妇，家务活总是做得又快又好。

然而就在一个工作日下午的三点钟，马修·卡斯伯特竟然穿着他最好的正装，赶着栗色母马平静地驶出了小巷！这意味着他要离开阿文莉村，而马车上的挽具表明他要走相当长的一段路。马修究竟要去哪里，又为什么要在这个时候出门？

换作阿文莉的任何其他人，雷切尔太太也许还能拼凑线索猜出他的去向。但马修极少出门，这次一定有什么不同寻常的大事发生。他是世上最害羞的人，最讨厌走在陌生人中间或去任何需要开口说话的地方。

雷切尔太太苦思冥想直到下午茶时间，终于无法忍受这悬念，她戴上软帽，穿过果园朝绿山墙走去。绿山墙是一座带有绿色百叶窗的白色大房子，舒适地坐落在苹果果园和白桦树林之中。

当雷切尔太太赶到时，马里拉·卡斯伯特正在打扫厨房。她是一位身材高挑瘦削的女性，黑发在脑后盘成一个坚硬的小髻，僵硬的轮廓没有一点柔和的曲线。不过她的嘴唇周围隐隐有一丝微光，如果加以发掘，也许可以算作一种幽默感。

“晚上好，雷切尔，”马里拉干脆地说。“请坐。你家里人都好吗？”“我们都挺好的，”雷切尔太太说，“只是今天看到马修出门时，我还挺担心你们家是不是出事了。我以为他要去看医生呢。”

马里拉的嘴唇微不可察地抽动了一下，充满了理解。她完全明白雷切尔太太的来意。“哦，不，马修身体好着呢，”她说。“他是去光明河车站了。我们正要从新斯克舍省的孤儿院领养一个小男孩，他今晚坐火车过来。”

雷切尔太太吃惊得手中的针线活直接掉在了地上！如果马里拉告诉她马修去月球买火箭了，她都不会比现在更震惊。“马里拉·卡斯伯特，”她脱口而出，“你说的都是真的吗？从孤儿院领养一个男孩？你们脑子里究竟是怎么冒出这种念头的？”''';
  }

  // --- 2. The Little Prince Chapters (10 Units) ---
  static List<Article> getPrinceChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'prince_u$unitNum',
        bookId: 'book_prince',
        unitIndex: unitNum,
        title: princeTitles[index % princeTitles.length],
        chineseTitle: '第 $unitNum 单元：${princeChineseTitles[index % princeChineseTitles.length]}',
        content: _getPrinceContent(index),
        chineseContent: _getPrinceChineseContent(index),
        difficulty: 'Beginner',
        category: '经典名著',
        tags: ['Fairy Tale', 'Philosophy', 'Classic'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 10,
        coverUrl: 'assets/images/book_prince.png',
      );
    });
  }

  static final List<String> princeTitles = [
    'Drawing No. 1 and Drawing No. 2',
    'The Crash in the Sahara Desert',
    'The Secret of the Little Prince',
    'The Asteroid B-612',
    'The Baobab Trees Danger',
    'The Sunset Watching',
    'The Flower and Her Thorns',
    'The King on the First Asteroid',
    'The Fox and the Taming Secret',
    'What is Essential is Invisible',
  ];

  static final List<String> princeChineseTitles = [
    '一号画作与二号画作的诞生',
    '撒哈拉沙漠里的意外坠机',
    '小王子的身世与秘密',
    '神秘的小行星 B-612',
    '猴面包树苗的巨大威胁',
    '看日落的心情与四十四次夕阳',
    '带刺的玫瑰花与玻璃罩',
    '第一颗星球上的专制国王',
    '狐狸与驯服的秘密',
    '本质的东西用眼睛是看不见的',
  ];

  static String _getPrinceContent(int index) {
    return '''Once when I was six years old I saw a magnificent picture in a book, called True Stories from Nature, about the primeval forest. It was a picture of a boa constrictor in the act of swallowing an animal. Here is a copy of the drawing.

The book said: "Boa constrictors swallow their prey whole, without chewing it. After that they are not able to move, and they sleep through the six months that they need for their digestion."

I pondered deeply, then, over the adventures of the jungle. And after some work with a colored pencil I succeeded in making my first drawing. My Drawing Number One. It showed a boa constrictor digesting an elephant.

I showed my masterpiece to the grown-ups, and asked them whether the drawing frightened them. But they answered: "Frighten? Why should any one be frightened by a hat?"

My drawing was not a picture of a hat. It was a picture of a boa constrictor digesting an elephant. But since the grown-ups were not able to understand it, I made another drawing: I drew the inside of a boa constrictor, so that the grown-ups could see it clearly. They always need to have things explained.

My Drawing Number Two looked like this: the grown-ups’ response, this time, was to advise me to lay aside my drawings of boa constrictors, whether from the inside or the outside, and devote myself instead to geography, history, arithmetic, and grammar.

That is why, at the age of six, I gave up what might have been a magnificent career as a painter. I had been disheartened by the failure of my Drawing Number One and my Drawing Number Two. Grown-ups never understand anything by themselves, and it is tiresome for children to be always and forever explaining things to them.

So then I chose another profession, and learned to pilot airplanes. I have flown a little over all parts of the world; and it is true that geography has been very useful, to me. At a glance I can distinguish China from Arizona. If one gets lost in the night, such knowledge is of great value.

In the course of this life I have had a great many encounters with a great many people who have been concerned with matters of consequence. I have lived a great deal among grown-ups. I have seen them intimately, close at hand. And that has not much improved my opinion of them.

Whenever I met one of them who seemed to me at all clear-sighted, I tried the experiment of showing him my Drawing Number One, which I have always kept. I would try to find out if this was a person of true understanding. But whoever it was, he, or she, would always say: "That is a hat."

Then I would never talk to that person about boa constrictors, or primeval forests, or stars. I would bring myself down to his level. I would talk to him about bridge, and golf, and politics, and neckties. And the grown-up would be greatly pleased to have met such a sensible man.''';
  }

  static String _getPrinceChineseContent(int index) {
    return '''当我六岁的时候，在一本描写原始森林的名为《真实的故事》的书里，看到了一幅壮观的图画。画的是一条巨蟒正在吞食一只野兽。这就是那幅画的摹本。

书里写道：“巨蟒把猎物整个吞进肚子里，根本不咀嚼。然后它们就动弹不得了，整整睡上六个月来进行消化。”

当时，我对丛林里的探险思考了很久。经过用彩色铅笔的一番努力，我成功画出了我的第一幅画。我的“一号画作”。它画的是一条正在消化大象的巨蟒。

我把我的杰作拿给大人看，问他们这幅画是否让他们感到害怕。但他们回答说：“害怕？一顶帽子有什么好害怕的？”

我的画根本不是一顶帽子。它是一条正在消化大象的巨蟒。但既然大人理解不了，我就又画了一幅：我画出了巨蟒肚子里面的样子，好让大人能看得清清楚楚。他们总是需要人把什么事都解释得明明白白。

我的“二号画作”是这样的：而大人这次的反应，则是劝我把巨蟒的画——无论是剖面图还是外观图——统统扔到一边，把精力放在地理、历史、算术和语法上。

就这样，在六岁那年，我放弃了本可以成为伟大画家的光辉前途。一号画作和二号画作的失败让我彻底丧失了信心。大人自己什么都不懂，却总是要孩子们一遍又一遍地给他们作解释，这真让人厌烦。

于是我选择了另一种职业，学会了开飞机。我在世界各地飞过不少地方；确实，地理知识对我大有裨益。一眼看过去，我就能区分出中国和亚利桑那。如果有人在夜间迷了路，这种知识是非常有价值的。

在这一生中，我与许许多多严肃的人有过许许多多的接触。我在大人中间生活了很久。我在很近的距离仔细观察过他们。但这并没有多少改善我对他们的看法。

每当我遇到一个看起来头脑还算清醒的大人时，我就会拿出我一直保存着的一号画作来考考他。我想知道这是否是一个真正有理解能力的人。但无论对方是谁，他总是回答：“这是一顶帽子。”

于是我就再也不跟他谈论巨蟒、原始森林或是星星了。我会降到他的水平。我会跟他谈论桥牌、高尔夫、政治和领带。而那个大人就会非常高兴认识了这么一位得体理智的人。''';
  }

  // --- 3. Beauty and the Beast Chapters (10 Units) ---
  static List<Article> getBeautyChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'beauty_u$unitNum',
        bookId: 'book_beauty',
        unitIndex: unitNum,
        title: beautyTitles[index % beautyTitles.length],
        chineseTitle: '第 $unitNum 单元：${beautyChineseTitles[index % beautyChineseTitles.length]}',
        content: _getBeautyContent(index),
        chineseContent: _getBeautyChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Fairy Tale', 'Romance', 'Classic'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 11,
        coverUrl: 'assets/images/book_beauty.jpg',
      );
    });
  }

  static final List<String> beautyTitles = [
    'The Merchant and His Three Daughters',
    'The Ruin of the Merchant’s Fortune',
    'The Lost Way in the Dark Forest',
    'The Enchanted Palace of the Beast',
    'The Rose Plucked from the Garden',
    'The Promise of the Father',
    'Beauty’s Departure to the Castle',
    'The Gentle Heart Behind the Frightful Form',
    'The Magic Mirror and the Sick Father',
    'The Spell Broken by True Love',
  ];

  static final List<String> beautyChineseTitles = [
    '商人与他的三个女儿',
    '商人家道的意外衰落',
    '迷失在漆黑森林里的旅人',
    '野兽那神秘神奇的魔法城堡',
    '采摘自花园里的那一朵红玫瑰',
    '老父亲那沉重的生死诺言',
    '贝儿踏上前往城堡的旅程',
    '丑陋外表掩盖下的温情心灵',
    '魔镜中的相思与重病的父亲',
    '真爱化解诅咒与王子的复苏',
  ];

  static String _getBeautyContent(int index) {
    return '''There was once a very rich merchant, who had six children, three sons and three daughters. As he was a man of sense, he spared no expense for their education, but provided them with all kinds of masters. His daughters were extremely handsome, especially the youngest. When she was little everybody admired her, and called her "The Little Beauty"; so that, as she grew up, she still went by the name of Beauty.

The two eldest had a great deal of pride, because they were rich. They gave themselves ridiculous airs, and would not visit other merchants’ daughters, nor keep company with any but persons of quality. They went out every day to parties, balls, and plays, and laughed at their youngest sister, who spent the greatest part of her time in reading good books.

As it was known that they were great fortunes, several eminent merchants made their addresses to them; but the two eldest said they would never marry, unless they could meet with a duke, or an earl at least. Beauty thanked those who courted her, but told them she was too young yet to marry, and chose to stay with her father to keep him company for some years longer.

All at once the merchant lost his whole fortune, except a small country house at a great distance from town, and told his children with tears in his eyes, they must go there and work for their living. The two eldest answered, that they would not leave the town, for they had several lovers, who they were sure would be glad to have them though they had no fortune; but in this they were mistaken, for their lovers turned their backs upon them in their poverty.

As they were not beloved on account of their pride, everybody said: "They do not deserve to be pitied; we are glad to see their pride humbled; but we are extremely concerned for Beauty, she was such a charming, sweet-tempered creature, spoke so kindly to poor people, and was of such an affable obliging nature."

When they were settled in the country house, the merchant and his three sons tilled the ground and sowed the fields. Beauty rose at four o'clock every morning, made haste to have the house clean, and prepared breakfast for the family. At first she found it very difficult, for she had not been used to work like a servant, but in less than two months she grew stronger and healthier than ever.

When she had done her work, she read, played upon the harpsichord, or sung while she was at her spinning-wheel. Her two sisters, on the contrary, knew not how to spend their time; they got up at eight, walked out all day, and talked of their former fine clothes and company. "Look at our youngest sister," said they one to another; "she is so poor-spirited and low-minded, that she is quite contented with her present miserable situation."

The merchant had lived about a year in this retirement, when he received a letter with an account that a vessel, on board of which he had some goods, was safely arrived. This news almost turned the heads of the two eldest daughters, who hoped now they should soon leave the country; and when they saw their father ready to set out, they begged of him to buy them new gowns, caps, rings, and all manner of trifles.

Beauty asked for nothing; for she thought to herself, that all the money her father was to receive would scarce be sufficient to purchase everything her sisters wished for. "Beauty," said the merchant, "you ask for nothing; what can I bring you, my child?" "Since you are so good as to think of me, dear father," said she, "I be take you to bring me a rose, for we have none in our garden."

The merchant set out, but when he came to the place, there was a lawsuit about his cargo, and after much trouble he returned as poor as he went. He was within thirty miles of his house, thinking on the pleasure he should have in seeing his children again, when he had to pass through a large forest, where he lost his way.''';
  }

  static String _getBeautyChineseContent(int index) {
    return '''从前有一位非常富有的大商人，他有六个孩子，三个儿子和三个女儿。由于他是一位有头脑的人，在孩子的教育上从不吝惜金钱，请了各种各样的名师。他的女儿们都非常漂亮，尤其是最小的那个。小的时候大家都夸赞她，叫她“小贝儿（小美人）”；因此随着她渐渐长大，大家依然习惯叫她贝儿。

两个大女儿因为家里富有而极其傲慢。她们摆出可笑的架子，根本不屑于去拜访其他商人的女儿，只与有社会地位的上流人士交往。她们每天出去参加聚会、舞会和看戏，还嘲笑小妹妹把大部分时间都花在了阅读好书上。

因为大家都知道她们家财万贯，有几位著名的商人向她们求婚；但两个大女儿说，除非能遇到公爵或者至少是伯爵，否则她们绝不出嫁。贝儿向那些求婚者表示感谢，但告诉他们自己年纪还小，想留给父亲多陪伴他几年。

突然之间，这位商人失去了所有的家产，只剩下一栋离城镇极其遥远的乡间小破屋。他眼含热泪告诉孩子们，他们必须去那里靠劳动维持生计。两个大女儿回答说她们绝不离开城镇，因为她们有几个追求者，她们确信即使自己没有财产，追求者也会乐意娶她们；但在这一点上她们想错了，追求者们一看到她们落魄便纷纷拂袖而去。

由于她们平日里心高气傲不受人喜欢，大家纷纷说：“她们不值得同情；看到她们的傲气落空我们挺高兴的；但我们非常关切贝儿，她是那么迷人、脾气那么温和的孩子，对穷人说话那么亲切，性格又是那么谦和讨人喜欢。”

当他们在乡间小屋安顿下来后，商人和他的三个儿子耕种土地、播种农田。贝儿每天清晨四点钟就起床，赶紧把屋子打扫干净，为全家准备早餐。起初她觉得非常辛苦，因为她从未像仆人那样干过重活，但不到两个月，她变得比以前更加健壮健康了。

做完家务后，她就读书、弹奏羽管键琴，或者一边摇纺车一边唱歌。相反，她的两个姐姐却根本不知如何消磨时间；她们早晨八点才起，整天在外面闲逛，念念不忘过去那些华丽的衣服和社交圈。“看看我们的小妹妹，”她们互相议论道，“她是多么没出息、多么低级趣味，竟然对现在这种惨兮兮的境况甘之如饴。”

商人在这种隐居生活中生活了大约一年，突然收到一封信，得知一艘装有他货物的大船安全抵港了。这个消息几乎让两个大女儿喜昏了头，她们希望现在很快就能离开农村了；当她们看到父亲准备出发时，纷纷恳求他给她们买新礼服、新帽子、戒指和各种各样稀奇古怪的小玩艺。

贝儿什么也没要；因为她心里想，父亲要收到的所有钱恐怕都不够购买姐姐们想要的那些东西。“贝儿，”商人说，“你什么也没要；我能给你带点什么呢，我的孩子？”“既然亲爱的爸爸您这么好能想着我，”她说，“那就请您给我带一朵玫瑰花吧，因为我们的花园里一朵也没有。”

商人出发了，但当他赶到目的地时，货物却陷入了一场官司中，经过一番折腾，他回去时和去时一样一贫如洗。在离家还有三十英里的地方，他一边想着很快就能重新见到孩子们的心情，一边不得不穿过一片密林，结果在林中迷失了方向。''';
  }

  // --- 4. The Arabian Nights Chapters (12 Units) ---
  static List<Article> getNightsChapters() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'nights_u$unitNum',
        bookId: 'book_nights',
        unitIndex: unitNum,
        title: nightsTitles[index % nightsTitles.length],
        chineseTitle: '第 $unitNum 单元：${nightsChineseTitles[index % nightsChineseTitles.length]}',
        content: _getNightsContent(index),
        chineseContent: _getNightsChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Folklore', 'Adventure', 'Magic'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_nights.png',
      );
    });
  }

  static final List<String> nightsTitles = [
    'Scheherazade and the Sultan’s Vow',
    'The Fisherman and the Brass Bottle Genie',
    'Aladdin and the Wonderful Lamp',
    'Ali Baba and the Forty Thieves',
    'Open Sesame and the Cave of Wealth',
    'Sindbad the Sailor’s First Voyage',
    'The Valley of Diamonds and the Roc',
    'The Enchanted Horse of Persia',
    'The Three Apples and the Caliph’s Quest',
    'Morgiana’s Courage and the Oil Jars',
    'The City of Brass and Ancient Wisdom',
    'The Dawn of One Thousand One Nights',
  ];

  static final List<String> nightsChineseTitles = [
    '山鲁佐德与苏丹的残酷誓言',
    '渔夫与黄铜瓶里的神灯魔瓶',
    '阿拉丁与神灯的惊世奇遇',
    '阿里巴巴与四十大盗的宝窟',
    '芝麻开门与神秘藏宝山洞',
    '航海家辛巴达的第一次远航',
    '钻石山谷与传说巨鸟大鹏',
    '波斯王国的魔法飞天木马',
    '三只苹果与哈里发的夜访',
    '莫吉娜的机智与大盗油罐',
    '黄铜之城与古老王国的智慧',
    '一千零一夜的破晓与救赎',
  ];

  static String _getNightsContent(int index) {
    return '''In the chronicles of the ancient Kings of Persia, there reigned a monarch named Shahryar, whose palace was renowned throughout the Orient for its marble courtyards and fragrant gardens. Yet a deep bitterness had filled his soul, causing him to take a terrible vow: each evening he would wed a maiden of his realm, and at the first ray of dawn, he would order her execution.

For three long years, terror held sway over the kingdom, and the voices of weeping fathers and mothers echoed through every city. The grand vizier, tasked with executing the Sultan’s cruel decrees, grieved in secret for the innocent lives sacrificed to the monarch’s wrath.

Now the vizier had two daughters, the elder of whom was named Scheherazade, a young woman of rare beauty and profound intellect. She had read all the books of the ancient scholars, knew by heart the stories of poets and historians, and possessed a courage unmatched by any warrior.

Seeing the sorrow that weighed upon her father, Scheherazade spoke to him in private: "My father, I beg of you to grant me a favor. Present me to the Sultan as his bride tonight, for I have devised a plan to deliver our people from this shadow of death."

The grand vizier wept and pleaded with her to abandon so perilous an undertaking, reminding her of the tragic fate of all who had preceded her. But Scheherazade remained resolute, declaring: "Either I shall succeed in saving the maidens of Persia, or I shall perish in the attempt."

That evening, Scheherazade was brought before Sultan Shahryar. As the lamps burned low in the royal chamber, she began to weep softly. When the monarch inquired the cause of her tears, she replied: "O King of the Age, I have a younger sister named Dunyazad, whom I love dearly. Grant me permission to send for her, that I may bid her farewell before dawn."

The Sultan consented, and Dunyazad was brought to the chamber. As arranged beforehand, the child sat near the couch and whispered: "Dear sister, if you are not asleep, tell us one of those wondrous tales with which you used to beguile the evening hours."

Scheherazade looked up at the Sultan, who nodded his royal head in curiosity. With a voice as melodious as a lutesong, she began the tale of the Merchant and the Genie, weaving a tapestry of enchantment, danger, and miraculous turns of fate.

As the story reached its most thrilling climax, the first golden rays of morning touched the palace windows. Scheherazade fell silent. Dunyazad cried out: "O sister, what a marvelous and fascinating story!" Scheherazade smiled gently: "It is nothing compared to what I could tell you tomorrow night, if the King permits me to live."

Sultan Shahryar, consumed by intense desire to hear the conclusion of the tale, thought to himself: "I shall spare her life for one more day, so that she may finish this story tonight." Thus passed the first night, and the dawn of a thousand and one miracle nights broke over the ancient land.''';
  }

  static String _getNightsChineseContent(int index) {
    return '''在古波斯诸王的历史编年史中，曾有一位名为山鲁亚尔的君主统治着这片土地，他的宫殿因大理石庭院和芳香花园而在整个东方享负盛名。然而一股深深的苦涩充斥了他的心灵，促使他立下一个可怕的誓言：每晚他都要迎娶一位本国的少女，而在拂晓的第一缕阳光照亮大地时，他便会下令将她处决。

整整三年间，恐怖罩着整个王国，悲伤父母的哭泣声响彻每一个城市。负责执行苏丹残忍法令的大宰相，在内心深处为那些沦为君主怒火牺牲品的无辜生命哀悼不已。

大宰相有两个女儿，大女儿名叫山鲁佐德，是一位容貌绝世、智慧超群的年轻女子。她研读过古代学者所有的典籍，对诗人与历史学家的故事了如指掌，并且拥有连勇士都难以企及的胆识。

看到父亲肩头上沉重的悲伤，山鲁佐德私下对他说：“父亲，我求您答应我一个请求。今晚请把我献给苏丹作为他的新娘吧，因为我已经想出一个计划，要把我们的百姓从这死亡的阴影中解救出来。”

大宰相流着眼泪恳求她放弃如此危险的举动，提醒她之前所有少女的悲惨命运。但山鲁佐德意志坚决，声明道：“要么我成功拯救波斯的少女们，要么我就在尝试中献出生命。”

那天晚上，山鲁佐德被带到了苏丹山鲁亚尔面前。当王室寝宫里的灯火渐渐暗淡时，她轻声哭泣起来。当君主询问她落泪的原因时，她回答道：“时代的君王啊，我有一个十分疼爱的小妹妹叫敦亚佐德。请允许我派人叫她来，好让我在拂晓前与她道别。”

苏丹同意了，敦亚佐德被带到了寝宫。按照事先的约定，小女孩坐在榻旁轻声说道：“亲爱的姐姐，如果你还没睡着，请给我们讲一个你以前常在夜晚用来消磨时光的神奇故事吧。”

山鲁佐德抬头看向苏丹，苏丹出于好奇微微颔首。她用如琵琶般悦耳动听的声音，开始讲述《商人与魔瓶》的故事，织就了一幅交织着魔法、危险与命运神奇转折的迷人卷轴。

当故事讲到最扣人心弦的高潮时，清晨的第一缕金光抚上了宫殿的窗棂。山鲁佐德戛然而止。敦亚佐德大声惊呼：“哦，姐姐，多么精彩迷人的故事啊！”山鲁佐德温柔地微笑：“如果国王陛下允许我活下去，这与我明晚能讲的故事相比简直微不足道。”

苏丹山鲁亚尔被听完故事结局的强烈欲望所吞噬，心想：“我就再留她一天性命，好让她今晚把这个故事讲完。”就这样，第一夜过去了，一千零一夜奇迹之夜的黎明在古老的土地上破晓而出。''';
  }

  // --- 5. The Great Stone Face Chapters (10 Units) ---
  static List<Article> getStonefaceChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'stoneface_u$unitNum',
        bookId: 'book_stoneface',
        unitIndex: unitNum,
        title: stonefaceTitles[index % stonefaceTitles.length],
        chineseTitle: '第 $unitNum 单元：${stonefaceChineseTitles[index % stonefaceChineseTitles.length]}',
        content: _getStonefaceContent(index),
        chineseContent: _getStonefaceChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Philosophy', 'Classic', 'Inspiration'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 11,
        coverUrl: 'assets/images/book_stoneface.png',
      );
    });
  }

  static List<Article> getStoneFaceChapters() => getStonefaceChapters();

  static final List<String> stonefaceTitles = [
    'The Valley and the Majestic Face',
    'The Ancient Prophecy of the Noble Man',
    'Gathergold’s Wealth and Disappointment',
    'Old Blood-and-Thunder the General',
    'Old Stony Phiz the Famous Statesman',
    'Ernest’s Quiet Life of Labor and Thought',
    'The Arrival of the Great Poet',
    'The Sunset Discourse in the Forest',
    'The Likeness Revealed in the Sunset Light',
    'The Eternal Wisdom of the Mountain Face',
  ];

  static final List<String> stonefaceChineseTitles = [
    '山谷与那座庄严宏伟的石面像',
    '关于高尚伟人的古老预言',
    '金币老人的财富与人们的失望',
    '血雷老将军的凯旋与真实面貌',
    '石面老政客的雄辩与幻灭',
    '欧内斯特平静的劳动与思考生活',
    '伟大学者诗人的到来与对谈',
    '日落时分森林里的真理布道',
    '落日余晖下惊现的面貌神似',
    '山石神貌遗留给人类的永恒智慧',
  ];

  static String _getStonefaceContent(int index) {
    return '''One afternoon, when the sun was going down, a mother and her little boy sat at the door of their cottage, talking about the Great Stone Face. They had but to lift their eyes, and there it was plainly to be seen, though miles away, with the sunshine gilding all its features.

The Great Stone Face was a work of Nature in her mood of majestic playfulness, formed on the perpendicular side of a mountain by some immense rocks, which had been thrown together in such a position as, when viewed at a proper distance, precisely resembled the features of a human countenance.

It seemed as if an enormous giant had carved his own likeness in the precipice. There was the broad front, with the hair of clinging pine trees; the nose, with its long bridge; and the vast lips, which, if they could have spoken, would have rolled their thunderous accents from one end of the valley to the other.

True it is, that if the spectator approached too near, he lost the outline of the gigantic visage, and could see only a heap of ponderous and gigantic rocks, piled one upon another in chaotic ruin. But seen from a distance, the Great Stone Face seemed positively to be alive.

It was a happy lot for children to grow up to manhood or womanhood with the Great Stone Face before their eyes, for all its features were noble, and the expression was at once grand and sweet, as if its vast heart contained a universal love for all mankind.

The mother and her little boy, whose name was Ernest, sat at their cottage door. "Mother," said Ernest, looking up at the majestic mountain, "I wish that it could speak, for it looks so very kindly that its voice must needs be pleasant. If I were to see a man with such a face, I should love him dearly."

"If an old prophecy should come to pass," answered his mother, "we may see a man, some time or other, with exactly such a face as that." "What prophecy do you mean, dear mother?" eagerly inquired Ernest. "Pray tell me all about it!"

So his mother told him a story that her own mother had told to her, when she herself was younger than little Ernest—a story owing its existence to the tradition of the Indian tribes who dwelt in the valley before the white men came.

The story went that at some future day, a child should be born in this neighborhood, who was destined to become the greatest and noblest personage of his time, and whose countenance, in manhood, should bear an exact resemblance to the Great Stone Face.

Ernest listened with rapt attention, and the image of the noble mountain face became engraved upon his young heart forever, guiding his every thought, word, and deed with its silent majesty.''';
  }

  static String _getStonefaceChineseContent(int index) {
    return '''一天下午，当太阳正要下山的时候，一位母亲和她的小男孩坐在自家小屋门前，谈论着巨石人面像。他们只需抬起眼睛，就能清晰地看到它，虽然隔着几英里远，但阳光镀金了它的每一个轮廓。

巨石人面像自然界在庄严嬉戏的心情下创作的杰作，由一些巨大的岩石形成于悬崖峭壁之上，这些岩石堆叠在一起的位置，当在适当的距离观看时，精确地酷似人类的面孔特征。

那感觉就像是一个巨大的巨人把自己的画像雕刻在了峭壁上。那里有宽阔的额头，上面覆盖着紧紧依附的松树假发；有长长鼻梁的鼻子；还有巨大的双唇，如果它们能开口说话，一定会把雷鸣般的声音从山谷的一端传到另一端。

确实，如果观看者走得太近，就会失去那张巨脸的轮廓，只能看到一堆笨重巨大的岩石，杂乱无章地堆叠在一起。但从远处看，巨石人面像似乎真的是活的。

对于孩子们来说，在巨石人面像的注视下成长为成年人是一种幸福的命运，因为它所有的面貌都是高尚的，表情既宏伟又甜美，仿佛它巨大的心灵包含了对全人类普遍的爱。

母亲和她的小男孩（名字叫欧内斯特）坐在小屋门前。“妈妈，”欧内斯特抬头看着那座庄严的大山说，“我希望它能开口说话，因为它看起来那么慈祥，声音一定非常悦耳。如果我能见到一个长着这样一张脸的人，我一定会深深地爱他。”

“如果一个古老预言能够实现的话，”他的母亲回答道，“我们早晚有一天会看到一个长着完全这样一张脸的人。”“您指的是什么预言，亲爱的妈妈？”欧内斯特急切地询问。“请快全都告诉我吧！”

于是他的母亲给他讲了一个她自己的母亲在她比小欧内斯特还小的时候讲给她的故事——一个源于白人到来之前居住在山谷里的印第安部落传统的故事。

故事说，在未来的某一天，这一带将出生一个孩子，他注定要成为他那个时代最伟大、最高尚的人物，而他成年后的面貌，将与巨石人面像有着极其精确的神似。

欧内斯特聚精会神地听着，那座高尚山峰面容的影像永远镌刻在了他年轻的心灵上，以其无声的庄严引导着他的每一个思想、言语和行动。''';
  }
}
