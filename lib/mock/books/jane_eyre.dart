import '../../models/article.dart';

class JaneEyreMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(38, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'jane_u$unitNum',
        bookId: 'book_jane',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Romance', 'Independence'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 12,
        coverUrl: 'assets/images/book_jane.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Red-Room at Gateshead',
    'Chapter 2: The Punishment in the Red-Room',
    'Chapter 3: The Doctor and the Decision',
    'Chapter 4: Departure for Lowood School',
    'Chapter 5: Arrival at Lowood School',
    'Chapter 6: Helen Burns and Fortitude',
    'Chapter 7: Mr. Brocklehurst’s Inspection',
    'Chapter 8: vindication and Hope',
    'Chapter 9: The Typhus Epidemic',
    'Chapter 10: Eight Years at Lowood',
    'Chapter 11: Arrival at Thornfield Hall',
    'Chapter 12: The Meeting on the Road with Rochester',
    'Chapter 13: Conversation at Thornfield',
    'Chapter 14: Mr. Rochester’s Character',
    'Chapter 15: The Fire in Mr. Rochester’s Chamber',
    'Chapter 16: The Mystery of Grace Poole',
    'Chapter 17: The Guests at Thornfield',
    'Chapter 18: The Gypsy Fortune-Teller',
    'Chapter 19: The Secret of the North Tower',
    'Chapter 20: The Attack on Mr. Mason',
    'Chapter 21: Return to Gateshead',
    'Chapter 22: Return to Thornfield',
    'Chapter 23: The Proposal in the Chestnut Garden',
    'Chapter 24: Preparation for the Wedding',
    'Chapter 25: The Split Veil',
    'Chapter 26: The Interrupted Wedding',
    'Chapter 27: The Secret in the Attic Revealed',
    'Chapter 28: Flight from Thornfield',
    'Chapter 29: Moor House and the Rivers',
    'Chapter 30: Life as a Country Teacher',
    'Chapter 31: St. John’s Proposal',
    'Chapter 32: The Inheritance',
    'Chapter 33: The Mysterious Call in the Night',
    'Chapter 34: Return to Thornfield in Ruins',
    'Chapter 35: Ferndean Manor',
    'Chapter 36: Reunion with Rochester',
    'Chapter 37: Reader, I Married Him',
    'Chapter 38: Conclusion and Everlasting Peace',
  ];

  static final List<String> chineseTitles = [
    '盖茨黑德庄园的红房子事件',
    '红房子里的关押与恐怖折磨',
    '医生劳埃德与改变命运的决定',
    '前往洛伍德义学的启程',
    '初抵洛伍德学校的艰苦生活',
    '海伦·彭斯的坚忍与信仰',
    '勃洛克赫斯特先生的冷酷检查',
    '清白洗刷与新的希望',
    '伤寒疫情与海伦的离世',
    '在洛伍德八年的蜕变与成长',
    '抵达桑菲尔德庄园',
    '路上与罗切斯特先生的偶遇',
    '桑菲尔德客厅里的谈话',
    '罗切斯特先生复杂高傲的性格',
    '罗切斯特卧室里的神秘大火',
    '格雷斯·普尔的谜团',
    '桑菲尔德庄园的贵宾们',
    '吉普赛算命妇人的秘密试探',
    '北塔楼上的惊天秘密',
    '梅森先生遭遇神秘袭击',
    '重返盖茨黑德探望临终的舅母',
    '归来桑菲尔德的喜悦',
    '栗树花园里的真情告白与求婚',
    '婚礼前夕的筹备',
    '被撕裂的面纱与不祥之兆',
    '被中断的婚礼',
    '阁楼里疯妻子的秘密揭晓',
    '决绝地逃离桑菲尔德',
    '荒原房屋与里弗斯兄妹',
    '乡村女教师的平静生活',
    '圣约翰的求婚与宗教抉择',
    '意外继承的遗产与身世',
    '夜色中神秘而清晰的召唤声音',
    '重返废墟中的桑菲尔德庄园',
    '芬丁庄园的隐居寻找',
    '与盲眼的罗切斯特重逢',
    '读者，我嫁给了他',
    '尾声：平淡而永恒的幸福',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''There was no possibility of taking a walk that day. We had been wandering, indeed, in the leafless shrubbery an hour in the morning; but since dinner (Mrs. Reed, when there was no company, dined early) the cold winter wind had brought with it clouds so sombre, and a rain so penetrating, that further out-door exercise was now out of the question.

I was glad of it: I never liked long walks, especially on chilly afternoons: dreadful to me was the coming home in the raw twilight, with nipped fingers and toes, and a heart saddened by the chidings of Bessie, the nurse, and humbled by the consciousness of my physical inferiority to John, Eliza, and Georgiana Reed.

The said John, Eliza, and Georgiana were now clustered round their mama in the drawing-room: she lay reclined on a sofa by the fireside, and with her darlings about her look completely happy.

Me, she had dispensed from joining the group; saying, "She regretted to be under the necessity of keeping me at a distance; but that until she heard from Bessie that I was endeavouring in good earnest to acquire a more sociable and childlike disposition, she must really exclude me from privileges intended only for contented, happy, little children."''';
      case 1:
        return '''The red-room was a cold room, because it seldom had a fire; it was silent, because remote from the nursery and kitchen; solemn, because it was so seldom entered.

My heart beat thick, my head grew hot; a sound filled my ears which I deemed the rushing of wings; something seemed near me; I was oppressed, suffocated: my endurance broke. I rushed to the door and shook the lock in desperate effort.

Bessie and Sarah ran up; the key turned, the door opened.

"Oh, Bessie! take me out! Make her let me go!" I cried.

"What is the matter? What a dreadful noise!" exclaimed Mrs. Reed, sweeping into the hall. "Jane Eyre, I abhor artifice and deceit! You shall remain here one hour longer."

And she thrust me back into the dark room, locking the heavy door against my screams.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Charlotte Brontë's immortal masterpiece, Jane Eyre.

Jane Eyre's passionate journey for independence, dignity, and true love transformed her from a penniless orphan into a woman of unbreakable moral strength.

"Do you think, because I am poor, obscure, plain, and little, I am soulless and heartless? You think wrong!—I have as much soul as you,—and full as much heart!" Jane declared to Rochester in one of literature's most powerful assertions of human equality.

"Reader, I married him," Jane wrote, celebrating a love built on mutual respect, freedom, and spiritual unity.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''那天不可能出去散步了。确实，早晨我们在没有叶子的灌木丛里散了一个小时的步；但自午饭后（里德太太在没有客人时吃得早），寒冷的冬风带来了如此昏暗的云彩和如此刺骨的雨水，以至于进一步的户外活动现在是不可能的了。

我很高兴：我从来不喜欢长途散步，尤其是在寒冷的下午：对我来说，在湿冷的黄昏中回家，手指和脚趾冻得发麻，心里因为保姆贝西的斥责而悲伤，又因为意识到自己在身体上不如约翰、伊丽莎白和乔治亚娜·里德而感到卑微，这是很可怕的。

刚才提到的约翰、伊丽莎白和乔治亚娜现在簇拥在他们妈妈周围在客厅里：她斜躺在火炉旁的沙发上，宝贝们围在身边，看起来完全幸福。

我呢，她免除了我加入这个圈子；说：“她很遗憾有必要与我保持距离；但在她从贝西那里听说我正在认真努力获得更加随和、孩子气的性格之前，她必须确实把我排除在只为满足、快乐的小孩准备的特权之外。”''';
      case 1:
        return '''红房子是一间寒冷的房间，因为它很少生火；它很安静，因为它远离育儿室和厨房；庄严，因为它很少有人进去。

我的心跳得厉害，头脑发热；一种声音填满了我的耳朵，我认为是翅膀的扑腾声；有什么东西似乎靠近了我；我感到压抑、窒息：我的忍耐力破灭了。我冲到门前，拼命晃动门锁。

贝西和萨拉跑了上来；钥匙转动，门开了。

“哦，贝西！带我出去！让她放我走！”我哭喊着。

“怎么回事？多么可怕的吵闹声！”里德太太惊呼道，扫视着走进大厅。“简·爱，我厌恶矫揉造作和欺骗！你要在这里再待一个小时。”

她把我推回黑暗的房间，重重地锁上大门，把我挡在我的尖叫声之外。''';
      default:
        final chapterNum = index + 1;
        return '''这是夏洛蒂·勃朗特不朽的文学巅峰名著《简·爱》的第 $chapterNum 章。

简·爱对独立、尊严和真爱的炽热追求，将她从一个一贫如洗的孤儿塑造成为一位拥有不可摧毁的道德力量的女性。

“你以为，因为我贫穷、卑微、不美、矮小，我就没有灵魂也没有心吗？你犯错了！——我的灵魂和你一样丰富，心也和你一样充实！”简在文学史上关于人类平等最强有力的宣言之一中对罗切斯特宣告道。

“读者，我嫁给了他，”简写道，歌颂了一种建立在相互尊重、自由和精神统一基础上的真爱。''';
    }
  }
}
