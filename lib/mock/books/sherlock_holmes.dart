import '../../models/article.dart';

class SherlockHolmesMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'sherlock_u$unitNum',
        bookId: 'book_sherlock',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Mystery', 'Detective'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 13,
        coverUrl: 'assets/images/book_sherlock.png',
      );
    });
  }

  static final List<String> titles = [
    'A Scandal in Bohemia: The Mysterious Woman',
    'A Scandal in Bohemia: The Photograph',
    'The Red-Headed League: A Strange Advertisement',
    'The Red-Headed League: The Underground Vault',
    'A Case of Identity: Miss Mary Sutherland',
    'The Boscombe Valley Mystery',
    'The Five Orange Pips: The K.K.K. Warning',
    'The Man with the Twisted Lip',
    'The Adventure of the Blue Carbuncle',
    'The Adventure of the Speckled Band: Helen Stoner',
    'The Adventure of the Speckled Band: The Swamp Adder',
    'The Adventure of the Copper Beeches',
  ];

  static final List<String> chineseTitles = [
    '波希米亚丑闻：神秘的女性艾琳·艾德勒',
    '波希米亚丑闻：照片的智斗',
    '红发会：奇怪的招聘广告',
    '红发会：地下金库防卫战',
    '身份案：玛丽·萨瑟兰小姐的求助',
    '博斯库姆溪谷谜案',
    '五颗橘核：三K党的神秘警示',
    '歪唇男人',
    '蓝宝石案：鹅肚里的秘密',
    '斑点带子案：海伦·斯托纳的恐怖遭遇',
    '斑点带子案：致命的沼泽毒蛇',
    '铜山毛榉案',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''To Sherlock Holmes she is always THE woman. I have seldom heard him mention her under any other name. In his eyes she eclipses and predominates the whole of her sex. It was not that he felt any emotion akin to love for Irene Adler. All emotions, and that one particularly, were abhorrent to his cold, precise but admirably balanced mind.

He was, I take it, the most perfect reasoning and observing machine that the world has seen. But as a lover he would have placed himself in a false position.

It was on the twentieth of March, 1888, that I was returning from a journey to a patient, for I had now returned to civil practice, when my way led me through Baker Street.

As I passed the well-remembered door, I was seized with a keen desire to see Holmes again, and to know how he was employing his extraordinary powers. His rooms were brilliantly lit, and, even as I looked up, I saw his tall, spare figure pass twice in a dark silhouette against the blind. He was pacing the room swiftly, eagerly, with his head sunk upon his chest and his hands clasped behind him.

To me, who knew his every mood and habit, his attitude and manner told their own story. He was at work again. He had risen out of his drug-created dreams and was hot upon the scent of some new problem.''';
      case 1:
        return '''A slow heavy step, which had been heard upon the stairs and in the passage, paused immediately outside the door. Then there was a loud and authoritative tap.

"Come in!" said Holmes.

A man entered who could hardly have been less than six feet six inches in height, with the chest and limbs of a Hercules. His dress was rich with a richness which would, in England, be looked upon as akin to bad taste. Heavy bands of astrakhan were slashed across the sleeves and fronts of his double-breasted coat, while the deep blue cloak which was thrown over his shoulders was lined with flame-colored silk and secured at the neck with a brooch which consisted of a single flaming beryl.

A vizard mask, which he had apparently just adjusted, extended down from his forehead below the cheek-bones.

"You had my note?" he asked with a deep harsh voice and a strongly marked German accent. "I told you that I would call." He looked from one to the other of us, uncertain which to address.

"Pray take a seat," said Holmes. "This is my friend and colleague, Dr. Watson, who is occasionally good enough to help me in my cases. Whom have I the honor to address?"

"You may address me as the Count Von Kramm, a Bohemian nobleman."''';
      case 2:
        return '''I had called upon my friend, Mr. Sherlock Holmes, one day in the autumn of last year and found him in deep conversation with a very stout, florid-faced, elderly gentleman with fiery red hair.

With an apology for my intrusion, I was about to withdraw when Holmes pulled me abruptly into the room and closed the door behind me.

"You could not have come at a better time, my dear Watson," he said cordially.

"I was afraid that you were engaged."

"So I am. Very much so."

"Then I can wait in the next room."

"Not at all. This gentleman, Mr. Jabez Wilson, has been my partner and helper in many of my most successful accomplishments, and I have no doubt that he will be of the same service to me in your case. Try the settee, Mr. Wilson."

The stout gentleman rose and bowed, with a quick little questioning glance at me.

"You see, Watson," Holmes continued, "Mr. Wilson has been accepted as a member of the famous Red-Headed League, a foundation established by an American millionaire for red-headed men."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Sir Arthur Conan Doyle's immortal detective masterpiece, The Adventures of Sherlock Holmes.

From his iconic rooms at 221B Baker Street, Sherlock Holmes, alongside his loyal friend Dr. John H. Watson, tackled the most baffling and uncanny criminal mysteries of Victorian London.

Using his legendary powers of deduction, acute observation, and forensic logic, Holmes demonstrated time and again that "when you have eliminated the impossible, whatever remains, however improbable, must be the truth."

Each case revealed the dark complexities of human nature while celebrating the triumph of intellect and justice over crime and deceit.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''在福尔摩斯的眼里，她永远是“那位女性”。我极少听他用其他名字提及过她。在他的眼里，她超越并压倒了她整个性别中的所有人。这倒不是说他对艾琳·艾德勒产生了类似爱情的情感。所有的情感，尤其是爱情，对于他那冷酷、精准却又令人赞叹地平衡的大脑来说，都是格格不入的。

在我看来，他是世界上有史以来最完美的推理与观察机器。但如果作为一个情人，他就会把自己置于一个虚假的位置。

那是在 1888 年 3 月 20 日，我刚看完一个病人准备回家——因为当时我已经恢复了私人执业——路过贝克街。

当我经过那扇记忆犹新的大门时，心中突然涌起一股强烈的愿望，想再去看看福尔摩斯，看看他现在是如何运用他非凡能力。他的房间里灯火通明，就在我抬头看时，看到他那高大瘦削的身影在窗帘后映出黑色的剪影，掠过了两次。他头低垂在胸前，双手握在背后，在房间里迅速而热切地走动着。

对于熟悉他每一种情绪和习惯的我来说，他的姿态和举止本身就在诉说故事。他又在干活了。他已经从药物带来的梦幻中苏醒过来，正热切地追踪着某个新谜题的蛛丝马迹。''';
      case 1:
        return '''听到楼梯和走廊上传来一阵缓慢而沉重的脚步声，紧接着停在了门外。随后传来响亮而有威严的敲门声。

“请进！”福尔摩斯说。

进来了一个身高绝不下六英尺六英寸的男人，拥有赫拉克勒斯般的胸膛和四肢。他的穿戴极其华丽，在英国，这种华丽甚至会被看作是近乎品味低俗。他那双排扣大衣的袖口和正面斜裁着厚厚的羔皮饰边，而披在肩膀上的深蓝色斗篷衬着火红色的丝绸，领口用一枚由单颗闪烁绿柱石做成的胸针固定着。

一张显然刚刚调好的面具，从他的额头延伸到颧骨下方。

“接到我的信了吗？”他用低沉粗糙的声音问道，带有浓重的德国口音。“我告诉过你我会来拜访。”他看了看我们两个人，一时不确定该向谁开口。

“请坐，”福尔摩斯说。“这是我的朋友兼同事华生医生，他偶尔很乐意在案件中协助我。请问我有何荣幸如何称呼您？”

“你们可以称呼我为克拉姆伯爵，一位波希米亚贵族。”''';
      case 2:
        return '''去年秋天的一天，我去拜访我的朋友夏洛克·福尔摩斯先生，发现他正与一位非常肥胖、满脸红光、留着一头火红头发的老绅士深谈。

我为自己的闯入表示歉意，正准备退出来，福尔摩斯突然把我拉进房间，并在我身后关上了门。

“你来得正是舒适的时候，我亲爱的华生，”他热情地说。

“我担心你正在忙。”

“确实如此。非常忙。”

“那我可以去隔壁房间等。”

“完全不必。这位绅士，贾贝兹·威尔逊先生，在我许多最成功的破案中一直是我合作伙伴和帮手，我毫不怀疑在你的案子里他也会对我提供同样的帮助。威尔逊先生，请坐长椅上吧。”

那位胖绅士站起来朝我躬了躬身，带着快速而疑问的眼神看了我一眼。

“你看，华生，”福尔摩斯继续道，“威尔逊先生已经被接纳为著名的‘红发会’的成员，那是一个由一位美国百万富翁为红头发男人建立的基金会。”''';
      default:
        final chapterNum = index + 1;
        return '''这是柯南·道尔爵士不朽的侦探名著《福尔摩斯探案集》的第 $chapterNum 章。

从贝克街 221B 那间标志性的公寓出发，夏洛克·福尔摩斯与他忠诚的朋友约翰·H·华生医生一起，破解了维多利亚时代伦敦最为离奇神秘的刑事悬案。

运用他传奇般的演绎推理、敏锐的观察力和法医逻辑，福尔摩斯一次又一次地证明：“当你排除了所有不可能之后，剩下的无论多么不可思议，也必然是事实真相。”

每一个案子在揭示人性黑暗与复杂的同时，也颂扬了智慧与正义战胜罪恶与欺诈的伟大胜利。''';
    }
  }
}
