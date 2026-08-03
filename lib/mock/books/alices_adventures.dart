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
        title: titles[index],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index]}',
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
    '无结果的赛跑与长尾巴',
    '兔子派来了小比尔',
    '毛毛虫的忠告',
    '小猪与胡椒粉',
    '疯狂的茶会',
    '红心王后的槌球场',
    '假海龟的故事',
    '龙虾龙代尔舞',
    '谁偷了馅饼？',
    '爱丽丝的证言与觉醒',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, "and what is the use of a book," thought Alice "without pictures or conversations?"

So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.

There was nothing so VERY remarkable in that; nor did Alice think it so VERY much out of the way to hear the Rabbit say to itself, "Oh dear! Oh dear! I shall be late!" but when the Rabbit actually TOOK A WATCH OUT OF ITS WASTECOAT-POCKET, and looked at it, and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and burning with curiosity, she ran across the field after it, and fortunately was just in time to see it pop down a large rabbit-hole under the hedge.

In another moment down went Alice after it, never once considering how in the world she was to get out again.''';
      case 1:
        return '''"Curiouser and curiouser!" cried Alice (she was so much surprised, that for the moment she quite forgot how to speak good English); "now I'm opening out like the largest telescope that ever was! Good-bye, feet!"

Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I'm sure I shan't be able! I shall be a great deal too far off to trouble myself about you.

Just then her head struck against the roof of the hall: in fact she was now more than nine feet high, and she at once took up the little golden key and hurried off to the garden door.

Poor Alice! It was as much as she could do, lying down on one side, to look through into the garden with one eye; but to get through was more hopeless than ever: she sat down and began to cry again.

"You ought to be ashamed of yourself," said Alice, "a great girl like you, to go on crying in this way! Stop this moment, I tell you!" But she went on all the same, shedding gallons of tears, until there was a large pool all round her, about four inches deep and reaching half down the hall.''';
      case 2:
        return '''They were indeed a queer-looking party that assembled on the bank—the birds with draggled feathers, the animals with their fur clinging close to them, and all dripping wet, cross, and uncomfortable.

The first question of course was, how to get dry again: they had a consultation about this, and after a few minutes it seemed quite natural to Alice to find herself talking familiarly with them, as if she had known them all her life.

"What I was going to say," said the Dodo in a solemn tone, "was, that the best thing to get us dry would be a Caucus-race."

"What IS a Caucus-race?" said Alice; not that she wanted much to know, but the Dodo had paused as if it thought that SOMEBODY ought to speak.

"Why," said the Dodo, "the best way to explain it is to do it." First it marked out a race-course, in a sort of circle, and then all the party were placed along the course, here and there. There was no "One, two, three, and away," but they began running when they liked, and left off when they liked, so that it was not easy to know when the race was over. However, when they had been running half an hour or so, the Dodo suddenly called out "The race is over!" and they all crowded round it, panting, and asking, "But who has won?"''';
      case 3:
        return '''It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself "The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She'll get me executed, as sure as ferrets are ferrets! Where CAN I have dropped them, I wonder?"

Alice guessed in a moment that it was looking for the fan and the pair of white kid gloves, and she very good-naturedly began hunting about for them, but they were nowhere to be seen—everything seemed to have changed since her swim in the pool.

Very soon the Rabbit noticed Alice, as she went hunting about, and called out to her in an angry tone, "Why, Mary Ann, what ARE you doing out here? Run home this moment, and fetch me a pair of gloves and a fan! Quick, now!"

Alice was so much frightened that she ran off at once in the direction it pointed to, without trying to explain the mistake it had made. "He took me for his housemaid," she said to herself as she ran. "How surprised he'll be when he finds out who I am!"''';
      case 4:
        return '''The Caterpillar and Alice looked at each other for some time in silence: at last the Caterpillar took the hookah out of its mouth, and addressed her in a languid, sleepy voice.

"Who are YOU?" said the Caterpillar.

This was not an encouraging opening for a conversation. Alice replied, rather shyly, "I—I hardly know, sir, just at present—at least I know who I WAS when I got up this morning, but I think I must have been changed several times since then."

"What do you mean by that?" said the Caterpillar sternly. "Explain yourself!"

"I can't explain MYSELF, I'm afraid, sir," said Alice, "because I'm not myself, you see."

"I don't see," said the Caterpillar.

"I'm afraid I can't put it more clearly," Alice replied very politely, "for I can't understand it myself to begin with; and being so many different sizes in a day is very confusing."''';
      case 5:
        return '''For a minute or two she stood looking at the house, and wondering what to do next, when suddenly a footman in livery came running out of the wood—she considered him to be a footman because he was in livery: otherwise, judging by his face only, she would have called him a fish.

He rapped loudly at the door with his knuckles. It was opened by another footman in livery, with a round face, and large eyes like a frog; and both footmen, Alice noticed, had powdered hair that curled all over their heads.

The Fish-Footman began by producing from under his arm a great letter, nearly as large as himself, and this he handed over to the other, saying, in a solemn tone, "For the Duchess. An invitation from the Queen to play croquet."

The Frog-Footman repeated, in the same solemn tone, only changing the order of the words a little, "From the Queen. An invitation for the Duchess to play croquet."

Then they both bowed low, and their curls got entangled together. Alice laughed so much at this, that she had to run back into the wood for fear of their hearing her.''';
      case 6:
        return '''There was a table set out under a tree in front of the house, and the March Hare and the Hatter were having tea at it: a Dormouse was sitting between them, fast asleep, and the other two were using it as a cushion, resting their elbows on it, and talking over its head.

"Very uncomfortable for the Dormouse," thought Alice; "only, as it's asleep, I suppose it doesn't mind."

The table was a large one, but the three were all crowded together at one corner of it: "No room! No room!" they cried out when they saw Alice coming.

"There's PLENTY of room!" said Alice indignantly, and she sat down in a large arm-chair at one end of the table.

"Have some wine," the March Hare said in an encouraging tone.

Alice looked all round the table, but there was nothing on it but tea. "I don't see any wine," she remarked.

"There isn't any," said the March Hare.

"Then it wasn't very civil of you to offer it," said Alice angrily.

"It wasn't very civil of you to sit down without being invited," said the March Hare.''';
      case 7:
        return '''A large rose-tree stood near the entrance of the garden: the roses growing on it were white, but there were three gardeners at it, busily painting them red. Alice thought this a very curious thing, and she went nearer to watch them.

Just as she came up to them she heard one of them say, "Look out now, Five! Don't go splashing paint over me like that!"

"I couldn't help it," said Five, in a sulky tone; "Seven jogged my elbow."

On which Seven looked up and said, "That's right, Five! Always lay the blame on others!"

"YOU'D better not talk!" said Five. "I heard the Queen say only yesterday you deserved to be beheaded!"

"What for?" said the one who had spoken first.

"That's none of YOUR business, Two!" said Seven.

"Yes, it IS his business!" said Five, "and I'll tell him—it was for bringing the cook tulip-roots instead of onions."

Alice stepped up to them and asked softly, "Would you tell me, please, why you are painting those roses?"''';
      case 8:
        return '''"You can't think how glad I am to see you again, you dear old thing!" said the Duchess, as she tucked her arm affectionately into Alice's, and they walked off together.

Alice was very glad to find her in such a pleasant temper, and thought to herself that perhaps it was only the pepper that had made her so savage when they met in the kitchen.

"When I'M a Duchess," she said to herself, (not in a very hopeful tone though), "I won't have any pepper in my kitchen AT ALL. Soup does very well without it."

"You're thinking about something, my dear, and that makes you forget to talk. I can't tell you just now what the moral of that is, but I shall remember it in a bit."

"Perhaps it hasn't one," Alice ventured to remark.

"Tut, tut, child!" said the Duchess. "Everything's got a moral, if only you can find it."''';
      case 9:
        return '''"They very soon obliged modify," the Mock Turtle went on, "and then they played the Lobster Quadrille."

"What is that?" asked Alice.

"Why," said the Gryphon, "you first form a line along the sea-shore—"

"Two lines!" cried the Mock Turtle. "Seals, turtles, salmon, and so on; then, when you've cleared all the jelly-fish out of the way—"

"THAT generally takes some time," interrupted the Gryphon.

"—you advance twice—"

"Each with a lobster as a partner!" cried the Gryphon.

"Of course," the Mock Turtle said: "advance twice, set to partners—"

"—change lobsters, and retire in same order," continued the Gryphon.

"Then, you know," the Mock Turtle went on, "you throw the—"

"The lobsters!" shouted the Gryphon, with a bound into the air.

"—as far out to sea as you can—"

"Swim after them!" screamed the Gryphon.''';
      case 10:
        return '''The King and Queen of Hearts were seated on their throne when they arrived, with a great crowd assembled about them—all sorts of little birds and beasts, as well as the whole pack of cards: the Knave was standing before them, in chains, with a soldier on each side to guard him; and near the King was the White Rabbit, with a trumpet in one hand, and a scroll of parchment in the other.

In the very middle of the court was a table, with a large dish of tarts upon it: they looked so good, that it made Alice quite hungry to look at them.

"I wish they'd get the trial done," she thought, "and hand round the refreshments!" But there seemed to be no chance of this, so she began looking at everything about her, to pass away the time.

The King was the judge; and as he wore his crown over his wig, he did not look at all comfortable, and it was certainly not becoming.

"First witness!" cried the King. And the White Rabbit blew three blasts on the trumpet, and called out, "First witness!"''';
      case 11:
        return '''"Here!" cried Alice, quite forgetting in the flurry of the moment how large she had grown in the last few minutes, and she jumped up in such a hurry that she tipped over the jury-box with the edge of her skirt, upsetting all the jurymen on to the heads of the crowd below, and there they lay sprawling about, reminding her very much of a globe of goldfish she had accidentally upset the week before.

"Oh, I BEG your pardon!" she exclaimed in a tone of great dismay, and began picking them up again as quickly as she could.

"The trial cannot proceed," said the King in a very grave voice, "until all the jurymen are back in their proper places—ALL," he repeated with great emphasis, looking hard at Alice as he said so.

Alice looked at the jury-box, and saw that, in her haste, she had put the Lizard in head downwards, and the poor little thing was waving its tail about in a melancholy way, being quite unable to move.

"No, 'they're nothing but a pack of cards!" Alice said loudly. At this the whole pack rose up into the air, and came flying down upon her; she gave a little scream, half of fear and half of anger, and tried to beat them off, and found herself lying on the bank, with her head in the lap of her sister, who was gently brushing away some dead leaves that had fluttered down from the trees upon her face.''';
    }
    return '';
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''爱丽丝在河岸边陪姐姐坐了很久，无所事事，渐渐感到非常厌倦：她偶一两次瞅了瞅姐姐正在读的那本书，但里面既没有插图也没有对话，“要是书里既没有插图也没有对话，”爱丽丝想，“那这本书还有什么用呢？”

于是她正在心里盘算着（尽她所能，因为炎热的天气使她感到又昏昏欲睡又木讷），做一串雏菊项链的乐趣是否值得她站起来去采摘雏菊，突然一只粉红眼睛的白兔子贴着她跑了过去。

这并没有什么非常了不起的；爱丽丝听见兔子自言自语地说：“天哪！天哪！我要迟到了！”时，也并不觉得特别离奇；但当那只兔子真的从马甲口袋里掏出一块怀表，看了看，然后急匆茫茫地继续往前跑时，爱丽丝一跃而起，因为她脑海里突然闪过一个念头：她以前从来没有见过哪只兔子穿马甲口袋，更不用说从里面掏出怀表来了。在好奇心的驱使下，她穿过田野追了过去，幸运的是，正好赶上看到它跳进了篱笆下的一个大兔子洞里。

下一刻，爱丽丝也跟着跳了下去，压根儿没考虑过将来到底该怎么出来。''';
      case 1:
        return '''“越来越奇妙了！”爱丽丝大声叫道（她是如此吃惊，以至于一时竟忘了怎么说标准英语了）；“现在我像有史以来最大的望远镜一样拉长了！再见，脚丫们！”

哦，我可怜的小脚丫们，我不知道现在谁来帮你们穿鞋穿袜了，亲爱的们？我敢肯定我是无能为力了！我离得太远了，顾不上你们了。

就在这时，她的头撞到了大厅的顶棚：事实上她现在已经九英尺多高了，她立刻拿起来那把小金钥匙，急忙向花园门跑去。

可怜的爱丽丝！她侧身躺下，最多只能用一只眼睛透过去看看花园；但要穿过去比以往任何时候都更加没有希望了：她坐下来，又开始哭了起来。

“你真该为自己感到羞耻，”爱丽丝说，“像你这么大的女孩，居然这样哭个不停！立刻给我停止哭泣！”但她还是一样哭个不停，流下了成加仑的眼泪，直到在她周围形成了一个巨大的水池，大约四英寸深，漫过了大厅的一半。''';
      case 2:
        return '''聚集在河岸上的确实是一群古怪的家伙——羽毛耷拉着的鸟儿，毛紧贴在身上的动物，一个个全都湿漉漉的，脾气暴躁，极不舒服。

第一个问题当然是如何重新变干：他们对此进行了商议，几分钟后，爱丽丝觉得和他们熟悉地交谈起来似乎非常自然，仿佛她一辈子都认识他们一样。

“我想说的是，”渡渡鸟用庄严的语气说，“能让我们变干的最好办法就是进行一次无结果的赛跑（Caucus-race）。”

“什么是无结果的赛跑？”爱丽丝说；倒不是她非常想知道，而是渡渡鸟停了下来，似乎认为总该有人说点什么。

“哎呀，”渡渡鸟说，“解释它的最好办法就是亲身去做。”首先它标出了一条赛道，大致呈圆形，然后把所有的伙伴散落在赛道的各处。没有“预备，跑”的口令，而是他们想什么时候跑就什么时候跑，想什么时候停就什么时候停，所以很难知道比赛什么时候结束。然而，当他们跑了半个小时左右时，渡渡鸟突然喊道“比赛结束！”他们全都喘着粗气围了过来，问：“但是谁赢了？”''';
      case 3:
        return '''那是白兔子，又慢慢地小跑着回来了，边走边焦急地环顾四周，仿佛丢了什么东西；她听见它自言自语地嘟囔着：“公爵夫人！公爵夫人！哦，我可怜的爪子！哦，我的毛和胡须！她会把我处决的，就像雪貂就是雪貂一样确定！我究竟把它们丢到哪里去了呢？”

爱丽丝立刻猜到它是在找扇子和那双白小羊皮手套，她非常善意地帮着到处寻找，但到处都找不到——自从她在水池里游过泳之后，一切似乎都变了。

很快兔子在到处寻找时注意到了爱丽丝，用生气的语气朝她喊道：“哎呀，玛丽·安，你在这里干什么？立刻给我跑回家去，拿一双手套和一把扇子来！快点！”

爱丽丝吓得够呛，二话不说立刻朝它指的方向跑去，压根没试图解释它犯的错误。“它把我当成它的女仆了，”她边跑边自言自语。“当它发现我是谁时，它该有多惊讶啊！”''';
      case 4:
        return '''毛毛虫和爱丽丝互相沉默地对视了一会儿：最后毛毛虫把水烟嘴从嘴里拿了出来，用疲倦、昏昏欲睡的声音向她开口。

“你是谁？”毛毛虫说。

对于谈话来说，这可不是个令人鼓舞的开场白。爱丽丝相当害羞地回答说：“我——我目前几乎不知道了，先生——至少我知道今天早上起床时我是谁，但我认为从那时起我已经改变了好几次了。”

“你这么说是什么意思？”毛毛虫严厉地说。“给我解释清楚！”

“恐怕我无法解释我自己，先生，”爱丽丝说，“因为您看，我不是我自己了。”

“我没看不出来，”毛毛虫说。

“恐怕我无法说得更清楚了，”爱丽丝非常有礼貌地回答，“因为首先我自己就无法理解它；一天之内改变这么多次身材是非常令人困惑的。”''';
      case 5:
        return '''她在那里站了一两分钟，看着房子，不知道下一步该怎么办，这时突然一个身穿制服的仆役从树林里跑了出来——她认为他是个仆役，因为他穿着制服：否则仅凭他的脸来判断，她会称他为一条鱼。

他用手关节在门上敲得很响。门被另一个身穿制服的仆役打开了，那个仆役长着一张圆脸，眼睛像青蛙一样大；爱丽丝注意到，两个仆役头上都涂着白粉，烫满了卷发。

鱼仆役首先从胳膊下掏出一封巨大的信，几乎和他自己一样大，他把信递给另一个仆役，用庄严的语气说：“给公爵夫人。红心王后邀请参加槌球比赛的请柬。”

青蛙仆役用同样庄严的语气重复道，只是稍微改变了词序：“来自王后。给公爵夫人参加槌球比赛的请柬。”

然后他们都深深地躬了躬身，他们的卷发缠在了一起。爱丽丝对此大笑起来，以至于她不得不跑回树林里，生怕被他们听见。''';
      case 6:
        return '''房子前面的一棵树下摆着一张桌子，三月兔和帽匠正在喝茶：睡鼠坐在他们中间，睡得香甜，另外两个人把它当成靠垫，把胳膊肘支在它身上，隔着它的头在说话。

“对睡鼠来说太不舒服了，”爱丽丝想，“不过既然它睡着了，我想它大概不会介意吧。”

桌子很大，但三个人全挤在一个角上：“没地方了！没地方了！”当他们看到爱丽丝走过来时大声喊道。

“这里有的是地方！”爱丽丝愤愤地说，在桌子一端的一张大安乐椅上坐了下来。

“喝点酒吧，”三月兔用鼓励的语气说。

爱丽丝环顾了桌子四周，但桌上除了茶之外什么也没有。“我没看到有什么酒，”她说道。

“根本就没有酒，”三月兔说。

“那你邀请我喝就不太有礼貌了，”爱丽丝生气的说。

“你不请自来坐下也不太有礼貌，”三月兔说。''';
      case 7:
        return '''花园入口附近立着一株巨大的玫瑰树：上面开的玫瑰是白色的，但有三个园丁在那里忙着把它们涂成红色。爱丽丝觉得这是一件非常奇特的事，她走近去观察他们。

当她走到他们跟前时，听见其中一个说：“当心点，五号！别把漆溅了我一身！”

“我不是故意的，”五号用脾气坏的声音说，“七号碰了我的胳膊肘。”

对此七号抬头说：“对极了，五号！总是把责任推给别人！”

“你最好少说话！”五号说。“我昨天刚听见王后说你该被砍头！”

“为什么？”最先说话的那个人问。

“那不关你的事，二号！”七号说。

“不，这关他的事！”五号说，“我会告诉他——是因为给厨师送去了郁金香根而不是洋葱。”

爱丽丝走到他们面前，轻轻地问：“请问，你们为什么要涂那些玫瑰花呢？”''';
      case 8:
        return '''“你无法想象再次见到你我是多么高兴，你这个亲爱的老家伙！”公爵夫人说，她亲热地把手臂套进爱丽丝的手臂里，她们一起向前走去。

爱丽丝非常高兴发现她的脾气变得这么好，心里想也许只是胡椒粉让她们在厨房相遇时变得那么蛮横。

“当我成为公爵夫人时，”她自言自语道（虽然语气不太抱希望），“我的厨房里根本就不会有任何胡椒粉。汤里没有它也很好。”

“你在想事情呢，亲爱的，这让你忘了说话。我现在无法告诉你那其中的教训是什么，但我过一会儿就会想起来的。”

“也许它根本就没有任何教训，”爱丽丝冒昧地说道。

“嘘，嘘，孩子！”公爵夫人说。“任何事情都有教训，只要你能找到它。”''';
      case 9:
        return '''“他们很快就不得不修改，”假海龟继续说道，“然后他们跳了龙虾龙代尔舞。”

“那是什么？”爱丽丝问。

“哎呀，”狮鹫说，“你首先沿着海岸站成一排——”

“两排！”假海龟喊道。“海豹、海龟、三文鱼等等；然后，当你把所有的水母都清除出赛道时——”

“那通常需要一些时间，”狮鹫插嘴道。

“——你前进两次——”

“每个人都以一只龙虾为舞伴！”狮鹫喊道。

“当然了，”假海龟说：“前进两次，向舞伴致意——”

“——交换龙虾，按同样的顺序退回，”狮鹫继续道。

“然后，你知道的，”假海龟继续说，“你扔出——”

“把龙虾！”狮鹫大声喊着，朝空中一跃。

“——尽你所能扔向大海深处——”

“游过去追它们！”狮鹫尖叫道。''';
      case 10:
        return '''当他们到达时，红心国王和王后正坐在他们的王座上，周围聚集了一大群人——各种各样的小鸟和小兽，以及整副扑克牌：侍从被锁链锁着站在他们面前，两边各有一个士兵看守着他；在国王附近是白兔子，一手拿着喇叭，另一手拿着一卷羊皮纸。

在法庭的正中央摆着一张桌子，上面有一大盘馅饼：它们看起来太诱人了，爱丽丝看着看着都饿了。

“我希望他们快点把审判搞定，”她想，“然后把茶点分给大家！”但似乎没有这种可能，于是她开始观察周围的一切，以消磨时间。

国王是法官；因为他把皇冠戴在假发上面，他看起来一点也不舒服，而且显然很不相称。

“传第一个证人！”国王喊道。白兔子在喇叭上吹了三声，大声喊道：“传第一个证人！”''';
      case 11:
        return '''“到！”爱丽丝喊道，在当下的慌乱中完全忘了自己在这最后几分钟里长了多高，她急忙站起来，以至于裙子边缘撞翻了陪审席，把所有的陪审员都倒到了下面人群的头上，他们横七竖八地躺在那里，让她强烈地想起了她上周不小心打翻的一缸金鱼。

“哦，非常抱歉！”她极其吃惊地大声呼喊，开始尽可能快地把他们重新捡起来。

“审判无法继续，”国王用非常严肃的声音说，“直到所有的陪审员都回到他们适当的位置——全部，”他极其强调地重复道，说话时狠狠地盯着爱丽丝。

爱丽丝看了看陪审席，看到在慌乱中，她把蜥蜴头朝下放了进去，那个可怜的小东西正凄惨地摇晃着尾巴，完全无法动弹。

“不，你们不过是一副扑克牌罢了！”爱丽丝大声说。听到这话，整副牌都飞到了空中，朝她扑面飞来；她发出了一声小小的尖叫，半是害怕半是愤怒，试图把它们打掉，发现自己躺在河岸上，头靠在姐姐的腿上，姐姐正温柔地拂去从树上飘落到她脸上的枯叶。''';
    }
    return '';
  }
}
