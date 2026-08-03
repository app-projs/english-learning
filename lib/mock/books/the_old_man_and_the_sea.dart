import '../../models/article.dart';

class OldManAndSeaMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'sea_u$unitNum',
        bookId: 'book_sea',
        unitIndex: unitNum,
        title: titles[index],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Courage', 'Literature'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 10,
        coverUrl: 'assets/images/book_sea.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Old Man and the Boy',
    'Chapter 2: Eighty-four Days Without a Fish',
    'Chapter 3: Setting Out Into the Gulf Stream',
    'Chapter 4: The Strike of the Great Marlin',
    'Chapter 5: The Endurance Test',
    'Chapter 6: A Man Can Be Destroyed But Not Defeated',
    'Chapter 7: The Capture of the Giant Fish',
    'Chapter 8: The Attack of the Mako Sharks',
    'Chapter 9: The Battle in the Dark',
    'Chapter 10: The Skeleton and the Dream of Lions',
  ];

  static final List<String> chineseTitles = [
    '老人与男孩的深情记忆',
    '连续八十四天没有捕到鱼',
    '独自驶向墨西哥湾流深处',
    '巨型大马林鱼的咬钩',
    '意志与耐力的极限对决',
    '人可以被毁灭，但不能被打败',
    '巨鱼的征服与缚舟',
    '灰针鲨的残酷袭来',
    '黑暗中的生死决战',
    '白骨鱼架与狮子之梦',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''He was an old man who fished alone in a skiff in the Gulf Stream and he had gone eighty-four days now without taking a fish. In the first forty days a boy had been with him. But after forty days without a fish the boy's parents had told him that the old man was now definitely and finally salao, which is the worst form of unlucky, and the boy had gone at their orders in another boat which caught three good fish the first week.

It made the boy sad to see the old man come in each day with his skiff empty and he always went down to help him carry either the coiled lines or the gaff and harpoon and the sail that was furled around the mast. The sail was patched with flour sacks and, furled, it looked like the flag of permanent defeat.

The old man was thin and gaunt with deep wrinkles in the back of his neck. The brown blotches of the benevolent skin cancer the sun brings from its reflection on the tropic sea were on his cheeks.

"Santiago," the boy said to him as they climbed the bank from where the skiff was pulled up. "I could go with you again. We've made some money."

The old man had taught the boy to fish and the boy loved him. "No," the old man said. "You're with a lucky boat. Stay with them."''';
      case 1:
        return '''The next morning before sunrise, the old man woke the boy. They drank their coffee together from condensed milk cans at the early morning cafe that served the fishermen.

"How did you sleep, Old Man?" the boy asked.

"Very well, Manolin," the old man said. "I feel confident today."

They carried the gear down to the skiff in the dark. The old man stepped into the boat, unhooked the rope from the ring on the dock, and pushed off into the quiet harbor water.

He rowed out into the dark water, hearing the dip and swish of his oars. He loved the ocean, thinking of her as la mar, which is what people call her in Spanish when they love her. He rowed out beyond the light of the shore, out into the deep Gulf Stream where the big fish lived.''';
      case 2:
        return '''By four o'clock in the afternoon, the old man was floating miles away from land. The green sea turned deep dark blue as the water dropped off to a depth of seven hundred fathoms.

Suddenly, one of the green sticks dipped sharply. The line went tight under the old man's touch. Deep down, a hundred fathoms below, a great marlin was eating the sardines that covered the point and the shank of the hook.

"He's taking it," the old man whispered softly. "He has it now."

The old man held the line delicately between his thumb and forefinger, feeling the gentle tug. Then came a sudden, immense weight that pulled the skiff forward across the calm sea.

The fish began to tow the boat steadily toward the northwest. The old man braced his feet against the bow, taking the strain across his shoulders. "I wish I had the boy," he said aloud. "I'm hooked to a giant."''';
      case 3:
        return '''The boat moved steadily, slowly, toward the northwest. The fish did not tire, nor did the old man lose his patience. Night fell, and the stars came out one by one in the clear tropical sky.

"I wonder what the big leagues look like tonight," the old man thought. He remembered the Great DiMaggio, the famous baseball player whose father was a fisherman. "The Great DiMaggio would be proud of me today, even with my bone spur."

He felt a deep sympathy for the giant marlin that was pulling him.

"I have never seen or heard of such a fish," Santiago said to himself. "He is wonderful and strange, and who knows how old he is. Never have I had such a strong opponent, nor one who behaved so calmly and nobly."''';
      case 4:
        return '''When the sun rose for the second time, the old man's left hand cramped into a tight, useless fist.

"What kind of hand is that?" he cursed softly. "Cramp if you want. Make yourself into a claw. It will do you no good."

He ate some raw tuna to gain strength, chewing slowly and carefully to nourish his aching body.

Suddenly the line surged upward, and the great marlin leaped clear of the ocean, a brilliant spectacle of silver and purple in the morning sun. He was two feet longer than the skiff itself, his bill as long as a baseball bat.

"He is two feet longer than the boat!" Santiago exclaimed. "I must hold him. I must never let him know how strong he is."''';
      case 5:
        return '''By the third morning, the old man was exhausted, his body bruised and bleeding from the cord, his eyes burning with fatigue.

The marlin began to circle the skiff slowly. With each pass, Santiago reeled in a few yards of line, straining every nerve and muscle to draw the magnificent creature closer.

"Fish," Santiago whispered, his voice hoarse and cracked. "You are going to have to die anyway. Do you have to kill me too?"

He summoned all of his remaining strength and pain and pride, and he drove his harpoon deep into the fish's side, right behind the big chest fin.

The marlin rose high out of the water in one final, glorious agony, then fell with a thunderous splash, floating motionless on the blue sea.''业绩案例''';
      case 6:
        return '''Santiago lashed the dead marlin alongside the skiff, raising the small sail to catch the light afternoon breeze.

He looked at the huge fish, greater than any he had ever seen or caught in his sixty years of fishing, and felt a profound respect for his defeated brother.

"A man can be destroyed but not defeated," Santiago declared to the empty sea.

He knew that the blood from the marlin's wound would spread through the water for miles around, attracting the scavengers of the deep. He checked his weapons: his harpoon was gone, bound to the fish's body, but he still had his knife lashed to the end of an oar.''';
      case 7:
        return '''The first Mako shark arrived an hour later, swimming fast and straight along the scent trail of the marlin's blood.

Its teeth were shaped like curved human fingers, sharp as razors, and its blue back cut through the water with terrifying speed.

As the shark struck the marlin's tail, tearing away forty pounds of valuable flesh, Santiago leaned over the gunwale and drove his knife deep into the shark's brain.

The Mako rolled over and sank slowly into the dark ocean depth, taking Santiago's knife with it.

"He took my knife," Santiago said quietly. "And he took the best meat from my fish. But I killed him."''';
      case 8:
        return '''By nightfall, a pack of shovel-nosed sharks attacked the skiff in the pitch darkness.

Santiago fought them in the dark with only a club, striking blindly at the fins and snouts that broke the surface beside his small boat.

He felt the wood shatter in his hands as he struck again and again, until his shoulders throbbed with agony and his hands bled freely onto the oars.

The sharks tore away the marlin's flesh piece by piece until nothing remained but the bare, gleaming white skeleton lashed to the side of the skiff.

"It is over," Santiago thought as the last shark turned away from the picked bones. "I have gone out too far."''';
      case 9:
        return '''Santiago rowed into the quiet harbor of his village in the small hours before dawn. Everyone was asleep in their huts.

He stepped ashore, untied the skiff, and looked back at the monstrous white skeleton tied alongside. The tail stood six feet high, and the backbone gleamed like a line of white marble in the starlight.

He carried the heavy mast up the hill on his shoulder, falling five times from sheer exhaustion before reaching his small shack.

He fell onto his bed, face down, and slept the deep sleep of a man who has given everything he possessed to the sea.''';
    }
    return '';
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''他是个独自在墨西哥湾流中的一条小艇上钓鱼的老人，如今出海八十四天了，一条鱼也没捕到。在前四十天里，有一个男孩和他在一起。但四十天没捕到鱼后，男孩的父母告诉他，老头子现在肯定彻底倒了霉（salao），这是最糟糕的运道，男孩听从父母的安排上了另一条船，那条船第一周就捕到了三条好鱼。

看到老人每天划着空船归来，男孩心里很难受，他总是跑下岸去帮老人拿卷好的钓线，或是搭钩、帮勾以及缠在桅杆上的帆。那面帆用面粉袋打过补丁，卷起来就像一面标志着永恒失败的旗帜。

老人消瘦而憔悴，颈后褶皱极深。由于热带海洋反射的阳光，他脸颊上布满了良性皮肤癌的褐色斑块。

“圣地亚哥，”从划子拉上岸的地方爬上山坡时，男孩对他说。“我可以再和你一起出海。我们已经挣了点钱了。”

老人教过男孩捕鱼，男孩很爱他。“不，”老人说。“你上了一条运气好的船。跟着他们吧。”''';
      case 1:
        return '''第二天黎明前，老人唤醒了男孩。他们在为渔民服务的早晨小咖啡馆里，用炼乳罐喝着咖啡。

“你睡得怎么样，老人家？”男孩问。

“很好，马诺林，”老人说。“我今天信心十足。”

他们在黑暗中把用具搬下小艇。老人踏进船里，解开码头环上的绳子，划向平静的港湾。

他划向黑暗的水域，听着桨叶划水的沉浮声。他热爱海洋，把她想象成 la mar，这是西班牙人在热爱海洋时对她的尊称。他划出了岸边的灯光之外，划向了大鱼生活的墨西哥湾流深处。''';
      case 2:
        return '''到了下午四点钟，老人已经漂流到了离陆地数英里之外的地方。随着水深降至七百英寻，绿色的海洋变成了深深的暗蓝色。

突然，其中一根绿色的木棍猛烈地沉了一下。老人手下的钓线瞬间拉紧了。在一百英寻深的地下，一条巨大的马林鱼正在吞食覆盖着钩尖和钩柄的沙丁鱼。

“它咬钩了，”老人轻轻地低语。“它吃下去了。”

老人用拇指和食指精细地捏着钓线，感受着那温和的拉力。接着传来一股突然而巨大的重量，拉着小艇跨越平静的海面向前冲去。

大鱼开始拉着小船稳步向西北方驶去。老人双脚抵住船头，用肩膀承受着拉力。“真希望男孩在这儿，”他大声说。“我钩住了一条巨物。”''';
      case 3:
        return '''小船稳步而缓慢地向西北方向移动。大鱼没有疲倦，老人也没有失去耐心。夜幕降临，一颗颗星星在晴朗的热带夜空中显现出来。

“不知道今晚的大联盟比赛怎么样了，”老人想。他想起了伟大的迪马吉奥，那位父亲是渔民的著名棒球运动员。“即使我有骨刺，伟大的迪马吉奥今天也会为我感到自豪的。”

他对拉着他的巨型马林鱼产生了深刻的同情。

“我从未见过或听说过这样的鱼，”圣地亚哥自言自语道。“他是如此奇妙和非凡，谁知道他活了多少年。我从来没有遇到过如此强悍的对手，也没有遇到过表现得如此平静高尚的对手。”''';
      case 4:
        return '''当太阳第二次升起时，老人的左手抽筋成了一个紧握的、无用的拳头。

“那是种什么手啊？”他轻声咒骂道。“想抽筋就抽筋吧。把你变成一只爪子。这对你没有任何好处。”

他吃了一些生金枪鱼来获取力量，缓慢而仔细地咀嚼，以滋养他酸痛的身体。

突然钓线向上涌起，巨大的马林鱼在晨光中跃出海面，在朝阳下展现出银色和紫色的辉煌奇观。它比小艇本身还要长两英尺，它的嘴像棒球棒一样长。

“他比船还要长两英尺！”圣地亚哥惊呼道。“我必须按住他。我绝对不能让他知道他有多强壮。”''';
      case 5:
        return '''到了第三天早晨，老人精疲力竭，身体因缆绳而满是淤青和流血，眼睛因疲劳而灼痛。

马林鱼开始绕着小艇缓缓转圈。每转一圈，圣地亚哥就拉回几码钓线，绷紧每一根神经和肌肉，将这尊伟大的生物拉得更近。

“鱼啊，”圣地亚哥低语道，声音沙哑破裂。“反正你都是要死的。难道你也非得杀了我不可吗？”

他召集了他剩下的所有力量、痛苦和尊严，将他的鱼钗深深地刺入了大鱼的侧腹，就在巨大胸鳍的正后方。

马林鱼在最后一刻辉煌的剧痛中高高跃出水面，然后伴随着雷鸣般的水花落入海中，无声无息地漂浮在蓝色的海面上。''';
      case 6:
        return '''圣地亚哥把死去的马林鱼紧紧绑在小艇旁，升起小帆以捕捉下午微弱的风。

他看着这条巨大的鱼，比他在六十年的捕鱼生涯中见到的或捕到的任何一条鱼都要大，对他被打败的兄弟产生了深深的敬意。

“人可以被毁灭，但不能被打败，”圣地亚哥对着空无一人的大海宣告。

他知道马林鱼伤口流出的血会在方圆数英里的水域中散开，吸引深海的食腐者。他检查了自己的武器：他的鱼钗丢了，绑在了鱼身上，但他仍然有一把绑在桨末端的刀。''';
      case 7:
        return '''一个小时后，第一条灰针鲨赶到了，顺着马林鱼血迹的气味快速而直接地游来。

它的牙齿形状像弯曲的人类手指，像剃刀一样锋利，它的蓝色后背以可怕的速度穿过水面。

当鲨鱼咬住马林鱼的尾巴，撕掉四十磅昂贵的鱼肉时，圣地亚哥探出船舷，将刀深深地刺入了鲨鱼的大脑。

灰针鲨翻过身来，缓缓沉入黑暗的海洋深处，把圣地亚哥的刀也带走了。

“他拿走了我的刀，”圣地亚哥平静地说。“他还拿走了我的鱼身上最好的肉。但我杀了他。”''';
      case 8:
        return '''夜幕降平时，一群铲头鲨在漆黑的夜色中袭击了小艇。

圣地亚哥在黑暗中仅凭一根木棍与它们搏斗，盲目地击打着在他小船旁露水面的鱼鳍和吻部。

当他一次又一次击打时，他感到手中的木头碎裂了，直到他的肩膀因剧痛而抽搐，他的双血自由地流在桨上。

鲨鱼一块接一块地撕咬着马林鱼的肉，直到除了绑在小艇旁边的白骨鱼架之外什么也没有剩下。

“结束了，”圣地亚哥在最后一条鲨鱼离开被啃光的骨头时想。“我出海太远了。”''';
      case 9:
        return '''圣地亚哥在黎明前最安静的时刻将船划进了他村庄平静的港湾。每个人都在他们的小屋里睡着了。

他踏上陆地，解开小艇，回头看着系在旁边的巨大的白色鱼骨架。尾巴有六英尺高，脊椎骨在星光下像一排白色大理石一样闪闪发光。

他把沉重的桅杆扛在肩上爬上山坡，在到达他那间破旧的小屋之前，因极度疲劳摔倒了五次。

他倒在床上，脸朝下，睡了一个把一切都奉献给了大海的人的深沉睡眠。''';
    }
    return '';
  }
}
