import '../../models/article.dart';

class ArabianNightsMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'nights_u$unitNum',
        bookId: 'book_nights',
        unitIndex: unitNum,
        title: titles[index],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Mythology', 'Adventure'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 14,
        coverUrl: 'assets/images/book_nights.png',
      );
    });
  }

  static final List<String> titles = [
    'The Story of King Shahryar and Scheherazade',
    'The Fisherman and the Genie',
    'The Tale of the Enchanted King',
    'The First Voyage of Sinbad the Sailor',
    'The Second Voyage: The Valley of Diamonds',
    'Ali Baba and the Forty Thieves: The Secret Cave',
    'Morgiana’s Courage and Intelligence',
    'Aladdin and the Wonderful Lamp: The Sorcerer',
    'The Genie of the Lamp Appears',
    'Aladdin Builds the Royal Palace',
    'The Sorcerer’s Revenge: New Lamps for Old',
    'The Triumph of Aladdin and Scheherazade',
  ];

  static final List<String> chineseTitles = [
    '山鲁亚尔国王与山鲁佐德的序曲',
    '渔夫与魔鬼的故事',
    '受诅咒国王的故事',
    '辛巴达航海记：第一次远航',
    '第二次远航：钻石峡谷与巨鸟',
    '阿里爸爸与四十大盗：芝麻开门',
    '女仆玛尔基娜的智慧与英勇',
    '阿拉丁与神灯：来自魔术师的阴谋',
    '神灯巨灵的现身',
    '阿拉丁建造金碧辉煌的宫殿',
    '魔法师的报复：旧灯换新灯',
    '阿拉丁的胜利与山鲁佐德的救赎',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''In the chronicles of the ancient kings of Persia, there lived two royal brothers, Shahryar and Shahzaman. King Shahryar ruled over India and Indochina with great justice and wisdom, loved by all his subjects. However, a terrible betrayal broke his heart and filled his soul with bitterness towards all womankind.

Swearing a dreadful oath, the King decreed that every night he would marry a young maiden of his city, and on the following morning he would order her execution, so that she could never deceive him. For three tragic years, grief and horror reigned throughout the realm.

The Grand Vizier, whose duty it was to carry out these cruel decrees, had two daughters. The elder was named Scheherazade, a woman of extraordinary intelligence, beauty, and wisdom. She had read all the books of poetry, philosophy, history, and science.

"Dear Father," Scheherazade declared courageously, "I pray you marry me to the King. Either I shall succeed in saving the maidens of our land, or I shall die in the noble attempt."

On her wedding night, Scheherazade began telling a captivating story of magic and wonder, but stopped just before the climax as dawn broke, promising to finish it the next night.''';
      case 1:
        return '''There was once an old fisherman who lived in extreme poverty with his wife and three children. Every day he cast his nets into the sea four times and no more.

One morning, after casting his net, he felt a great weight. Expecting a fine catch, he pulled it ashore, only to find the carcass of a dead donkey. He mended his broken net and cast it a second time, bringing up a large jar filled with mud and sand.

On the fourth cast, his net brought up a heavy copper jar, sealed tight with a lead stopper stamped with Solomon's royal seal. Overjoyed, the fisherman prised open the stopper with his knife.

Thick black smoke poured out of the vessel, rising into the sky and condensing into a colossal Genie of terrifying aspect.

"Prepare to die, old man!" roared the Genie in a voice like thunder. "Choose only the manner of your death!"

The fisherman, recovering from his terror, used his wits: "I cannot believe a giant like you could fit inside this tiny bottle unless I see it with my own eyes." Proud and angered, the Genie vanished into smoke and slid back inside, whereupon the quick-witted fisherman slammed the lead stopper tight!''';
      case 2:
        return '''Deep in the heart of a distant kingdom surrounded by four mysterious mountains lay an enchanted lake filled with fish of four distinct colors: red, white, yellow, and blue.

A young King, half of whose body had been turned into cold black marble by an evil enchantress, sat weeping in his deserted palace. He recounted to the Sultan how his wicked queen used dark magic to transform his people and kingdom.

Determined to break the curse, the brave Sultan tracked the enchantress to her secret sanctuary. Disguising himself in her wounded lover's robes, the Sultan tricked the sorceress into reciting the counter-spells.

With a stroke of his sword, the Sultan vanquished the enchantress forever. The marble prince was restored to life, the four-colored fish turned back into humans, and the enchanted city returned to its former glory under a peaceful sky.''';
      case 3:
        return '''My father left me a considerable fortune, which I foolishly squandered in my youth on luxury and idle pleasures. Realizing my error, I gathered what little remained and purchased goods for a sea voyage to trade in distant lands.

We set sail from Bussorah with a company of merchants, stopping at various islands along the Persian Gulf.

One day, our ship anchored near a small, green island covered in lush vegetation. We stepped ashore to rest and cook meals.

Suddenly, the island began to tremble violently. The captain shouted from the deck: "Reroute, quick! That is no island, but a giant sleeping whale!"

Before I could reach the boat, the creature dived into the ocean depths, washing me away into the foaming sea while the ship sailed off without me.''';
      case 4:
        return '''Washed ashore on a deserted island by the current, I wandered inland in search of food. I discovered a giant white dome of immense smooth stone. As I approached, the sky darkened suddenly.

Looking up, I saw a mythical bird of giant proportions—a Roc—descending upon its giant egg.

I waited until the bird fell asleep, then bound myself to its leg using my turban cloth. At dawn, the Roc flew high into the sky, carrying me across mountain peaks to a terrifying, enclosed valley.

The valley floor was carpeted with thousands of glittering diamonds, guarded by giant vipers that hid in caves during the day.

Merchants tossed huge pieces of raw meat into the canyon from the cliffs above. Diamonds stuck to the meat, and when the eagles carried the meat up to their nests, the merchants drove the birds away to collect the gems. I strapped a piece of meat to my back, and an eagle carried me out of the valley to safety.''';
      case 5:
        return '''In a city of Persia lived two brothers, Cassim and Ali Baba. Cassim married a rich wife and lived in luxury, while Ali Baba married a poor woman and earned a living cutting wood in the forest.

One day in the forest, Ali Baba saw a band of forty mounted robbers approaching. He climbed a tree to hide and watched their captain stand before a solid rock wall, shouting:

"Open, Sesame!"

The rock face split open, revealing a vast cavern filled with piles of gold coin, silver ingots, and precious jewels.

After the thieves left, Ali Baba stepped before the rock and repeated the magic words. The cave opened, and he loaded three donkeys with bags of gold before closing the door with "Shut, Sesame!"''';
      case 6:
        return '''Cassim learned of the cave from Ali Baba, but his greed proved his undoing. He entered the cave with ten mules, but once inside, forgot the magic word to open the door, shouting "Open, Barley!" in vain until the robbers returned and killed him.

The robber captain traced the gold back to Ali Baba's house and devised a cunning plan. He arrived disguised as an oil merchant, carrying thirty-nine large leather oil jars mounted on mules.

One jar contained real oil, while the remaining thirty-eight hidden robbers awaited his signal to launch a night attack.

Morgiana, Ali Baba's clever slave girl, went to fetch oil for a lamp and heard a robber whisper from inside a jar: "Is it time?"

Realizing the plot, she heated the real oil in a great cauldron and poured boiling oil into each jar, neutralizing the robbers silently. Later, during a feast, she performed a dagger dance and stabbed the captain before he could strike.''';
      case 7:
        return '''In a poor city of China lived a lazy boy named Aladdin, the son of a poor tailor. One day, a mysterious African sorcerer arrived, claiming to be Aladdin's long-lost uncle.

The sorcerer led Aladdin to a secret valley between two mountains and lit a magic fire, muttering incense incantations that caused the earth to open, revealing a stone slab with a brass ring.

"Under this stone lies a hidden treasure," said the sorcerer. "Go down into the cavern, touch nothing of the gold, and bring me the lit brass lamp resting in the inner garden."

Aladdin descended the stairs into a garden of trees bearing glowing jewel fruits. He placed the lamp in his bosom and gathered handfuls of rubies, emeralds, and diamonds.

When he reached the entrance, the sorcerer demanded the lamp before helping Aladdin out. Aladdin refused, whereupon the angry sorcerer sealed the cave entrance with a spell, leaving Aladdin trapped in the dark.''';
      case 8:
        return '''Trapped in the dark cavern for two days, Aladdin accidentally rubbed a small magic ring the sorcerer had placed on his finger for protection.

Instantly, a giant Genie of the Ring appeared before him in a flash of smoke, saying: "What wouldst thou have? I am thy slave, and the slave of him who holds the ring."

"Deliver me from this place!" cried Aladdin.

In a fraction of a second, Aladdin found himself standing outside on the mountain side, holding the old brass lamp.

Back home, when his mother tried to clean the dirty lamp with sand and water, an even more colossal Genie of the Lamp erupted into the room, declaring: "I am ready to obey thee as thy slave, and the slave of all those who have that lamp in their hands!"''';
      case 9:
        return '''With the unlimited wealth and wisdom provided by the Genie of the Lamp, Aladdin transformed from a lazy street boy into a noble, generous prince.

He fell in love with Princess Badroulbadour, the daughter of the Sultan, after seeing her beauty at the royal baths.

Aladdin sent his mother to the Sultan with a dish filled with giant, sparkling jewels from the enchanted garden. Overwhelmed by the priceless gift, the Sultan agreed to the marriage, provided Aladdin built a palace fit for his daughter.

Using the Genie's power, Aladdin constructed a magnificent marble palace overnight, adorned with twenty-four windows studded with diamonds, rubies, and sapphires, connected to the Sultan's palace by a carpet of velvet.''';
      case 10:
        return '''News of Aladdin's sudden rise to royal fame reached the evil African sorcerer in his distant homeland. Realizing Aladdin had escaped the cave with the Wonderful Lamp, he traveled to the city in disguise.

Carrying a basket of shiny new brass lamps, the sorcerer walked beneath the palace windows shouting: "New lamps for old! Who will exchange old brass lamps for new ones?"

The Princess, unaware of the old lamp's magic power, handed Aladdin's dusty lamp to the sorcerer in exchange for a bright new one.

Possessing the lamp, the sorcerer commanded the Genie to transport the entire palace, along with the Princess, across the sea to Africa in an instant.''';
      case 11:
        return '''Aladdin returned from hunting to find his palace and bride vanished into thin air. The angry Sultan gave him forty days to restore the Princess or face execution.

Using his magic ring, Aladdin summoned the Genie of the Ring and was transported to Africa outside his stolen palace.

He managed to sneak into the Princess's chamber, where they devised a plan. The Princess offered the sorcerer a poisoned cup of wine during a banquet.

When the sorcerer collapsed, Aladdin retrieved the Wonderful Lamp from his robe, rubbed it, and commanded the Genie to return the palace to its original place in Persia, where they lived in everlasting peace and happiness.''';
    }
    return '';
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''在古波斯国王的史册中，住着两位皇家兄弟，山鲁亚尔和山鲁佐曼。山鲁亚尔国王以极大的公正和智慧统治着印度和印度支那，受到所有臣民的爱戴。然而，一场可怕的背叛打破了他的心，让他的灵魂充满了对世间所有女性的苦涩与仇恨。

国王立下一个可怕的誓言，颁布法令说，每天晚上他都要迎娶城里的一个年轻少女，而在次日早晨下令将她处决，这样她就再也不能欺骗他了。在悲惨的三年里，悲伤和恐怖笼罩着整个王国。

负责执行这些残酷法令的大宰相有两个女儿。长女名叫山鲁佐德，是一位拥有非凡智慧、美丽与博学的女子。她读过所有的诗歌、哲学、历史和科学书籍。

“亲爱的父亲，”山鲁佐德勇敢地宣告，“请您把我嫁给国王吧。我要么能成功挽救我们土地上的少女们，要么将在高尚的尝试中牺牲。”

在洞房之夜，山鲁佐德开始讲述一个引人入胜的魔法与奇迹的故事，但在黎明破晓前恰好在最精彩的高潮处停了下来，许诺第二天晚上再讲完。''';
      case 1:
        return '''从前有一个老渔夫，和妻子及三个孩子生活在极度贫困中。他每天向海里撒网四次，绝不多撒。

一天早晨，撒网后，他感到沉甸甸的。本以为能捕到好鱼，他把网拉上岸，却只发现一具死驴的尸体。他补好了破网，第二次撒网，捞上来一个装满泥沙的大罐子。

第四次撒网时，他的网拉上来一个沉重的铜罐，上面用盖着所罗门王印章的铅塞紧紧密封着。老渔夫欣喜若狂，用小刀撬开了铅塞。

浓浓的黑烟从瓶子里喷涌而出，升入天空，凝结成一个面目狰狞的巨大巨灵。

“准备受死吧，老头！”巨灵用雷鸣般的声音怒吼道。“你只能选择你的死法！”

老渔夫从惊恐中恢复过来，运用了他的智慧：“我不相信像你这样的巨人能装进这个小瓶子里，除非我亲眼看到。”巨灵又傲慢又恼火，化作一阵烟雾溜回了瓶子里，见状，机智的渔夫猛地把铅塞重新关紧！''';
      case 2:
        return '''在被四座神秘大山环绕的遥远王国深处，有一个神奇的湖泊，里面游着四种不同颜色的鱼：红、白、黄、蓝。

一位年轻的国王，半个身体被邪恶的女巫变成了冰冷的黑大理石，坐在他废弃的宫殿里哭泣。他向苏丹讲述了他的邪恶王后如何用黑魔法转化了他的臣民和王国。

勇敢的苏丹决心打破诅咒，追踪女巫到了她的秘密圣所。苏丹伪装成她受伤的情人的长袍，诱骗女巫念出了解除诅咒的咒语。

苏丹挥剑斩断了女巫的邪恶。大理理石王子恢复了生命，四色鱼变回了人类，神奇的城市在和平的天空下重现往日的辉煌。''';
      case 3:
        return '''我的父亲给我留下了相当可观的财产，我在年轻时愚蠢地挥霍在奢华和空虚的享乐上。意识到自己的错误后，我收集了所剩无几的财产，购买了航海货物，去远方贸易。

我们与一家商人公司从布斯拉出发，在波斯湾沿岸的各个岛屿停靠。

一天，我们的船锚定在一个覆盖着郁郁葱葱植被的小绿岛附近。我们上岸休息并做饭。

突然，岛屿开始剧烈晃动。船长从甲板上喊道：“快掉头，快！那不是岛屿，而是一头巨大的沉睡鲸鱼！”

在我到达船之前，这个生物潜入了海洋深处，将我冲入了泡沫飞溅的大海，而船却没有我继续驶走了。''';
      case 4:
        return '''被洋流冲到一个荒无人烟的岛上后，我向内陆漫游寻找食物。我发现了一个巨大的光滑石头构成的巨大白色圆顶。当我靠近时，天空突然变暗了。

抬头一看，我看到了一只巨大比例的神话之鸟——大鹏鸟（Roc）——降落在大蛋上。

我等到鸟睡着了，然后用我的头巾布把自己绑在它的腿上。黎明时分，大鹏鸟飞向高空，带着我穿过山峰来到一个可怕的封闭山谷。

山谷地面铺满了数千颗闪闪发光的钻石，由白天藏在洞穴里的巨大毒蛇守护着。

商人从上面的悬崖向峡谷投掷大块生肉。钻石粘在肉上，当老鹰把肉带到它们的巢穴时，商人赶走鸟儿收集宝石。我把一块肉绑在背上，一只老鹰把我带出山谷到达安全地带。''';
      case 5:
        return '''在波斯的一座城市里住着卡西姆和阿里爸爸兄弟俩。卡西姆娶了一个富有的妻子，生活奢华，而阿里爸爸娶了一个贫穷的女人，在森林里砍柴维持生计。

一天在森林里，阿里爸爸看到一群四十名骑马的大盗靠近。他爬上一棵树躲起来，看着他们的队长站在一面坚硬的岩石墙前喊道：

“芝麻开门！”

岩石面分裂开来，露出了一个巨大的洞穴，里面堆满了金币、银锭和昂贵的珠宝。

强盗离开后，阿里爸爸走到岩石前重复了这个神奇的词。洞穴打开了，他在用“芝麻关门”关门之前，给三头驴装满了成袋的黄金。''';
      case 6:
        return '''卡西姆从阿里爸爸那里得知了洞穴的事，但他的贪婪证明了他的毁灭。他带着十头骡子进入洞穴，但一进入洞穴，他就忘记了开门的魔法词，徒劳地喊着“大麦开门！”直到强盗返回杀了他。

强盗队长将黄金追踪到了阿里爸爸的房子，并设计了一个狡猾的计划。他伪装成石油商到达，带着安装在骡子身上的三十九个大皮石油罐。

一个罐子装着真正的油，而剩下的三十八个隐藏的强盗等待他的信号发起夜袭。

阿里爸爸聪明的奴婢玛尔基娜去取灯油，听见一个强盗在罐子里低语：“时间到了吗？”

意识到这个阴谋，她在巨大的大锅里加热了真正的油，把沸腾的油倒进每个罐子里，静静地消灭了强盗。后来，在宴会上，她跳了匕首舞，在队长出击前刺死了他。''';
      case 7:
        return '''在中国的贫穷城市里住着一个名叫阿拉丁的懒惰男孩，是一个贫穷裁缝的儿子。一天，一个神秘的非洲魔法师到达，声称是阿拉丁失散多年的叔叔。

魔法师将阿拉丁带到两山之间的秘密山谷，点燃了神奇的火，念着香火咒语使大地打开，露出一块带有黄铜环的石板。

“在这块石头下面藏着宝藏，”魔法师说。“下到洞穴里，不要碰任何金子，把我停留在内部花园里的点亮的黄铜灯带给我。”

阿拉丁沿着楼梯下到挂满发光宝石水果的树木花园里。他把灯放在怀里，抓了几把红宝石、祖母绿和钻石。

当他到达入口时，魔法师在帮助阿拉丁出来之前索要灯。阿拉丁拒绝了，于是愤怒的魔法师用咒语封住了洞穴入口，把阿拉丁困在了黑暗中。''';
      case 8:
        return '''在黑暗的洞穴里被困了两天，阿拉丁不小心擦了魔法师放在他手指上起保护作用的小魔戒。

霎时间，一个巨大的戒指巨灵在烟雾中出现在他面前说：“你想要什么？我是你的奴隶，也是拥有那个戒指的人的奴隶。”

“把我从这个地方救出去！”阿拉丁喊道。

在一秒钟的分秒内，阿拉丁发现自己站在山边的外面，手里拿着旧黄铜灯。

回到家里，当他的母亲试图用沙子和水清洁脏灯时，一个更加巨大的神灯巨灵喷涌进房间宣告：“我准备服从你作为你的奴隶，以及所有手里有那盏灯的人的奴隶！”''';
      case 9:
        return '''凭借神灯巨灵提供的无限财富和智慧，阿拉丁从一个懒惰的街头男孩蜕变成了一位高尚、慷慨的王子。

在皇家浴室看到苏丹的女儿巴德鲁巴杜尔公主的美貌后，他爱上了她。

阿拉丁派他的母亲带着一个装满神奇花园里巨大的闪烁宝石的盘子去见苏丹。被无价的礼物所压倒，苏丹同意了这门亲事，前提是阿拉丁建造一座适合他女儿的宫殿。

利用巨灵的力量，阿拉丁一夜之间建造了一座宏伟的大理石宫殿，装饰着二十四个镶嵌着钻石、红宝石和蓝宝石的窗户，由毯子地毯连接到苏丹的宫殿。''';
      case 10:
        return '''阿拉丁突然声名鹊起的消息传到了远方家乡邪恶的非洲魔法师那里。意识到阿拉丁带着神奇的神灯逃出了洞穴，他伪装来到了这座城市。

带着一篮闪亮的新黄铜灯，魔法师在宫殿窗下走着喊道：“旧灯换新灯！谁要用旧黄铜灯换新灯？”

公主不知道旧灯的神奇力量，把阿拉丁落满灰尘的灯递给魔法师换取了一盏亮晶晶的新灯。

拥有了神灯，魔法师命令巨灵将整座宫殿连同公主一瞬间穿过大海运到了非洲。''';
      case 11:
        return '''阿拉丁打猎归来，发现他的宫殿和新娘凭空消失了。愤怒的苏丹给了他四十天的时间恢复公主，否则将面临处决。

利用他的魔戒，阿拉丁召唤了戒指巨灵，并被运到了他在被盗宫殿外面的非洲。

他成功溜进了公主的寝室，他们在那里制定了一个计划。在宴会期间，公主向魔法师提供了一杯有毒的葡萄酒。

当魔法师倒下时，阿拉丁从他的长袍里取回了神奇的神灯，擦了擦它，命令巨灵将宫殿带回波斯原来的地方，他们在那里过上了永恒平静幸福的生活。''';
    }
    return '';
  }
}
