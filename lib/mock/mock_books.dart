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
        description: '给成年人的童话，探讨爱、责任与生命的哲理',
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
        description: '迪士尼制作成了电影和动画片同名经典故事',
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
        description: '《一千零一夜》以山鲁佐德讲故事为线索，汇聚古老神话与东方传奇',
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
        description: '纳撒尼尔·霍桑哲理名作，凝望巨石与崇高心灵的成长诗篇',
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

  // --- 1. Anne of Green Gables Chapters (12 Units - Substantial Original Passages) ---
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
        content: anneContents[index % anneContents.length],
        chineseContent: anneChineseContents[index % anneChineseContents.length],
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Literature', 'Growth'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 8,
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

  static final List<String> anneContents = [
    '''Mrs. Rachel Lynde lived just where the Avonlea main road dipped down into a little hollow, fringed with alders and ladies’ eardrops and traversed by a brook that had its source away back in the woods of the old Cuthbert place. It was known to be a quiet, intricate little stream in its upper course, but by the time it reached Lynde’s Hollow it was a quiet, well-conducted little brook.

Matthew Cuthbert was driving out of the lane, wearing his best suit of clothes and driving his sorrel mare. Mrs. Rachel stepped into the house with her eyes wide with curiosity. Matthew Cuthbert was thirty-five years a bachelor, and it was three o'clock in the afternoon of a working day. Where on earth was Matthew going, and why was he going there?

Mrs. Rachel got up early next morning and hurried across the orchard to Green Gables. Green Gables was a big, white, green-shuttered house, sitting back comfortably among apple orchards and birch trees. Marilla Cuthbert was sweeping the kitchen, a tall, thin woman with dark hair turned in a hard little knot behind.''',

    '''The train was late, and Matthew waited at Bright River station. Sitting on a pile of shingles in the furthest corner was a child of about eleven, wearing a ridiculously short, tight dress of yellowish-gray wincey, and a faded brown velvet sailor hat.

Matthew walked awkwardly over to the child. The moment her eyes met his, she stood up, extending a thin, freckled hand. "I suppose you are Mr. Matthew Cuthbert of Green Gables?" she asked in a remarkably clear, sweet voice. "I was beginning to be afraid you weren't coming for me."

"I'm sorry I'm late," Matthew stammered, taking the small hand into his big one. He was astonished by her vibrant spirit and her passionate flow of conversation as they drove through the white fragrance of the Avenue of Apple Trees.''',

    '''Marilla came out to the kitchen door to greet them. But when her eyes fell on the slender little girl in the rusty garment, with glowing red hair and big gray eyes, she stopped short in sheer amazement.

"Matthew Cuthbert, where is the boy?" Marilla demanded, holding her broom in mid-air. "There was no boy," Matthew answered meekly. "There was only her at the station."

The little girl gasped, dropping her carpet-bag to the floor. "You don't want me!" she cried passionately, her face flushing crimson. "You don't want me because I'm not a boy! Oh, this is the most tragical moment of my whole life!"''',

    '''Anne opened her eyes to the morning sunlight pouring through the window of the east gable. For a second she could not remember where she was, but then a wave of delightful memory rushed over her. She jumped out of bed and ran to the window.

The big cherry tree outside the window was in full bloom, a cloud of snowy fragrance covering the whole orchard. Below in the garden, the lilac bushes were bursting into purple buds, and the air was filled with the fresh scent of green moss and pine needles.

"Oh, Marilla," Anne cried, running downstairs into the kitchen with shining eyes, "this is a world where there are so many things to love! Green Gables is the most beautiful place on the face of the whole earth!"''',

    '''Anne folded her hands in her lap and looked out at the rolling hills. "I was born in Bolingbroke, Nova Scotia. My father’s name was Walter Shirley, and he was a teacher in the high school. My mother was Bertha Shirley."

"They were both poor, and when I was three months old they both died of yellow fever. I was left an orphan, and nobody wanted me until Mrs. Thomas took me in because she had four small children to look after."

"After Mr. Thomas died, Mrs. Hammond took me to her house in the woods. I looked after three pairs of twins! But when Mr. Hammond died, there was nowhere for me to go but the asylum in Hopeton until you sent for me."''',

    '''"Well, Marilla," said Matthew softly, sitting on the porch steps after supper, "we can\'t send her back to Mrs. Blewett. Mrs. Blewett is a hard, sharp woman, and she will work that poor little girl to death."

Marilla looked down at her knitting needles, her heart wavering. She thought of the child’s passionate gratitude and her lonely background. She knew Matthew was right.

"Very well, Matthew," Marilla said at last, her voice softening slightly. "She shall stay. I will do my duty by her, and try to raise her into a useful, good woman."''',

    '''Anne knelt by her window in her thin nightgown, looking up at the vast starry sky above the whispering pines. She squeezed her small hands together and began her bedtime prayer.

"Dear Heavenly Father," Anne whispered softly, "I thank Thee for Green Gables and for Mr. Matthew and Miss Marilla. I ask Thee to let me stay here forever and make me good and beautiful."

"Please bless the apple trees and the cherry blossom, and help me to be a dutiful child. God is in His heaven and all is right with the world. Amen."''',

    '''Anne and Diana Barry stood by the garden spring, holding hands beneath the blooming lilac trees. The water bubbled quietly over the mossy stones, reflecting the golden afternoon light.

"Let us swear a solemn vow of eternal friendship," Anne proposed solemnly. "We must hold hands thus, and say: \'I solemnly swear to be faithful to my bosom friend, Diana Barry, for ever and ever.\'"

Diana repeated the words with a delighted smile, and from that day forth, their hearts were bound together in an unbreakable bond of sisterhood.''',

    '''Diana invited Anne to tea in her mother\'s parlor on a sunny Tuesday afternoon. Anne dressed in her best blue muslin dress with puffed sleeves, her heart fluttering with joy and anticipation.

They sat at the small mahogany table, sipping tea from dainty china cups and eating raspberry tarts. Anne talked with grand eloquence about books, poetry, and dreams.

"It was the most elegant afternoon of my life," Anne declared to Marilla that evening. "Diana is a true lady, and I felt just like a heroine in a real romance novel."''',

    '''Miss Stacy, the new teacher at Avonlea school, formed an advanced class to prepare her brightest students for the entrance examination at Queen\'s Academy in Charlottetown.

Anne and Gilbert Blythe studied under the lamplight late into the cold winter nights, competing fiercely for the top marks in Latin, mathematics, and English literature.

"I must work hard," Anne told Matthew, her eyes burning with ambition. "I want to make you and Marilla proud of me when the results are announced."''',

    '''The pass list was posted on the bulletin board at the entrance of Queen\'s Academy. A large crowd of nervous students gathered around to search for their names.

Suddenly, a loud cheer erupted. Anne Shirley had won the prestigious Avery Scholarship! Her name led all applicants in Nova Scotia and Prince Edward Island in English honors.

Matthew\'s eyes filled with tears of quiet pride as he read the telegram. "Well now, Anne," he whispered, "I always knew you\'d beat them all."''',

    '''"The road has a bend in it," Anne thought softly, standing on the crest of the hill and looking down at the quiet gable roofs of Green Gables.

Although her heart ached with the changes of time, her spirit remained radiant and unbowed. She knew that around the bend lay new duties, new friendships, and new horizons.

"I don\'t know what lies around the bend," Anne whispered to the evening star, "but I believe the very best will be there. God is in His heaven, and all is well."''',
  ];

  static final List<String> anneChineseContents = [
    '''雷切尔·林德太太住在阿文莉主干道俯冲入小洼地的地方，洼地边缀满了桤木和倒挂金钟，一条小溪穿流而过，小溪发源于旧卡斯伯特庄园深处的树林里。在小溪上游，大家都知道它是一条隐蔽而曲折的小流，但等它流到林德洼地时，已经变成了一条清澈听话的明溪。

马修·卡斯伯特穿着他最好的衣服，正赶着栗色母马驶出小巷。雷切尔太太睁大好奇的眼睛走进了屋里。马修·卡斯伯特独身了三十五年，现在正是工作日下午三点钟。马修究竟要去哪里，又为什么要在这个时候出门？

第二天清晨雷切尔太太早早起床，穿过果园赶往绿山墙。绿山墙是一座带有绿色百叶窗的白色大房子，舒适地坐落在苹果果园和白桦树林之中。马里拉·卡斯伯特正在打扫厨房，她是一位身材高挑瘦削的女性，黑发在脑后盘成一个坚硬的小髻。''',

    '''火车晚点了，马修在光明河车站耐心等候。在最偏远角落的一堆木瓦上，坐着一个大约十一岁的孩子，穿着一件极其短小紧身的黄灰色粗棉布连衣裙，头上戴着一顶褪色的棕色天鹅绒水手帽。

马修有些尴尬地朝孩子走去。就在她的目光与他交汇的瞬间，她站了起来，伸出一只布满雀斑的纤细小手。“想必您就是绿山墙的马修·卡斯伯特先生吧？”她用极其清脆甜美的声音问道。“我刚才还真担心您不来接我了呢。”

“很抱歉我迟到了，”马修口吃着说，用自己的大手握住了那只娇小的手。当他们驾车穿过满是白色芳香的苹果树大道时，他被她蓬勃的生命力与滔滔不绝的情感所深深震撼。''',

    '''马里拉走到厨房门口迎接他们。但当她的目光落在那个身穿破旧衣裳、留着一头耀眼红发和大灰色眼睛的纤瘦小女孩身上时，她吃惊得当场愣住了。

“马修·卡斯伯特，男孩在哪里？”马里拉把扫帚举在半空中质问道。“没有男孩，”马修温顺地回答。“车站里只有她一个人。”

小女孩喘着粗气，手里的布袋掉在了地上。“你们不要我！”她激动地哭喊起来，脸色变得绯红。“你们不要我是因为我不是男孩！哦，这是我一生中最悲惨的时刻！”''',

    '''安妮睁开眼睛，晨光正透过东山墙的窗户倾泻进来。有那么一瞬间她记不起自己身在何处，但紧接着一阵令人愉悦的回忆涌上心头。她跳下床奔向窗前。

窗外高大的樱桃树盛开着，如同一片雪白的云霞罩住了整个果园。在下方的花园里，丁香灌木正吐出紫色的花苞，空气中弥漫着青苔与松针的清新芬芳。

“哦，马里拉，”安妮眼神闪烁着喜悦奔下楼走进厨房大声说道，“这是一个有那么多事物值得去爱的世界！绿山墙是全天下最美丽的地方！”''',

    '''安妮双手交叠放在膝头上，凝望着起伏的丘陵。“我出生在新斯克舍省的波林布罗克。我父亲叫沃尔特·雪莉，是高中里的一位教师。我母亲叫伯莎·雪莉。”

“他们都很贫穷，在我三个月大时，他们都因患黄热病去世了。我成了孤儿，没人要我，直到托马斯太太收留了我，因为她有四个小孩子需要照料。”

“托马斯先生去世后，汉蒙德太太把我带到了她在树林里的家。我照顾了三对双胞胎！但当汉蒙德先生也去世后，我除了去霍普顿的孤儿院别无去处，直到你们派人来接我。”''',

    '''“嗯，马里拉，”晚饭后马修坐在走廊台阶上温柔地说，“我们不能把她送回布鲁伊特太太那里。布鲁伊特太太是个苛刻严厉的女人，她会把那个可怜的小女孩累死的。”

马里拉低头看着手中的针线，内心在摇摆。她想起了孩子那炽热的感激之情和孤独的身世。她知道马修是对的。

“那好吧，马修，”马里拉终于开口了，声音有些放软。“让她留下来吧。我会尽我的责任教导她，争取把她培养成一个有用、善良的女子。”''',

    '''安妮穿着薄薄的睡衣跪在窗前，仰望着低语松树上方浩瀚的星空。她紧握着双手，开始了她的睡前祷告。

“亲爱的天父，”安妮轻声祷告道，“感谢您赐予我绿山墙，感谢马修先生和马里拉小姐。求您让我永远留在这里，让我变得善良而美丽。”

“请保佑苹果树和樱花，帮助我做一个听话的孩子。上帝在他的天国里，世间万物一切安好。阿门。”''',

    '''安妮和戴安娜·巴里站在花园泉水旁，在盛开的丁香树下紧紧牵手。泉水在苔藓石上静静地冒着泡，折射着午后的金色阳光。

“让我们立下永远友谊的庄严誓言吧，”安妮庄重地提议。“我们必须这样牵着手说：‘我庄严宣誓，永远忠于我亲密无间的心灵知己戴安娜·巴里。’”

戴安娜带着欢欣的微笑重复了这番话，从那天起，她们的心紧紧连接在一起，结下了永不破裂的姐妹情谊。''',

    '''在一个阳光明媚的周二午后，戴安娜邀请安妮去她母亲的客厅喝茶。安妮穿上了她最好的带有泡泡袖的蓝绵绸裙，心里充满了欢喜与期待。

她们坐在小巧的红木桌旁，用精美的瓷杯品着茶，吃着覆盆子塔。安妮滔滔不绝地谈论着书籍、诗歌与梦想。

“这是我一生中最优雅的下午，”那天晚上安妮向马里拉宣告。“戴安娜是一位真正的淑女，我觉得自己就像一本浪漫小说里的女主角。”''',

    '''阿文莉学校的新老师史密斯小姐成立了一个高级班，辅导最优秀的学生准备夏洛特顿皇后学院的入学考试。

在寒冷冬夜的灯光下，安妮与吉尔伯特·布莱斯苦读直至深夜，在拉丁语、数学和英国文学上展开激烈的竞争。

“我必须努力学习，”安妮对马修说，眼里燃烧着雄心。“当成绩公布时，我想让你和马里拉为我感到骄傲。”''',

    '''录取名单贴在了皇后学院入口处的公告栏上。一大群紧张的学生聚集在一起寻找自己的名字。

突然间人群中爆发出热烈的欢呼声。安妮·雪莉赢得了尊贵的埃弗里奖学金！她的名字在新斯克舍省和爱德华王子岛的所有考生中荣登英语荣誉榜首。

当马修读到电报时，眼中充满了默默骄傲的泪水。“嗯，安妮，”他低语道，“我早就知道你能战胜所有人。”''',

    '''“这条路拐了个弯，”安妮静静地想着，站在山顶仰望着绿山墙低语的松树和小屋安静的屋顶。

尽管她的内心因时光的变迁而有些隐隐作痛，但她的精神依然明亮而坚韧。她知道在弯道后面，有着新的责任、新的友谊与新的地平线。

“我不知道弯道后面有什么，”安妮对着晚星轻声低语，“但我相信最好的景色一定在那里。上帝在他的天国里，一切安好。”''',
  ];

  // --- 2. The Little Prince Chapters (10 Units - Substantial Original Passages) ---
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
        content: princeContents[index % princeContents.length],
        chineseContent: princeChineseContents[index % princeChineseContents.length],
        difficulty: 'Beginner',
        category: '经典名著',
        tags: ['Fairy Tale', 'Philosophy', 'Love'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 7,
        coverUrl: 'assets/images/book_prince.png',
      );
    });
  }

  static final List<String> princeTitles = [
    'Drawing Number One',
    'The Crash in the Sahara',
    'The Little Prince Appears',
    'Asteroid B-612',
    'The Baobab Danger',
    'The Pride of the Rose',
    'The King and the Conceited Man',
    'The Geographer’s Advice',
    'The Secret of the Fox',
    'What Is Essential Is Invisible',
  ];

  static final List<String> princeChineseTitles = [
    '一号画作与第一幅画',
    '撒哈拉沙漠的坠机',
    '小王子的神奇显现',
    'B-612 小行星的故事',
    '危险的猴面包树',
    '玫瑰花的娇矜与骄傲',
    '国王与自负的人',
    '地理学家的宏伟建议',
    '小狐狸的驯服秘密',
    '本质的东西用眼睛看不见',
  ];

  static final List<String> princeContents = [
    '''Once when I was six years old I saw a magnificent picture in a book, called True Stories from Nature, about the primeval forest. It was a picture of a boa constrictor in the act of swallowing an animal. Here is a copy of the drawing.

In the book it said: "Boa constrictors swallow their prey whole, without chewing it. After that they are not able to move, and they sleep through the six months that they need for their digestion."

I pondered deeply, then, over the adventures of the jungle. And after some work with a colored pencil I succeeded in making my first drawing. My Drawing Number One. It showed a boa constrictor digesting an elephant.

I showed my masterpiece to the grown-ups, and asked them whether the drawing frightened them. But they answered: "Frighten? Why should any one be frightened by a hat?" My drawing was not a picture of a hat. It was a picture of a boa constrictor digesting an elephant. But since the grown-ups were not able to understand it, I made another drawing.''',

    '''Six years ago I had an accident with my plane in the Desert of Sahara. Something was broken in my engine. And as I had with me neither a mechanic nor any passengers, I set myself to attempt the difficult repair all alone. It was a question of life or death for me. I had scarcely enough drinking water for eight days.

The first night, then, I went to sleep on the sand, a thousand miles from any inhabited land. I was more isolated than a shipwrecked sailor on a raft in the middle of the ocean.

Thus you can imagine my amazement, at sunrise, when I was awakened by an odd little voice. It said: "If you please—draw me a sheep!" "What!" "Draw me a sheep..."''',

    '''I jumped to my feet, completely thunderstruck. I blinked my eyes hard. I looked carefully. And I saw a most extraordinary small person, who stood there examining me with great seriousness.

Now I stared at this sudden apparition with my eyes starting out of my head in astonishment. Remember, I had crashed in the desert a thousand miles from any inhabited region. And yet my little man seemed neither to be straying, nor dying of fatigue, hunger, thirst, or fear.

"When a mystery is too overpowering, one dare not disobey," I said to him, taking a piece of paper and my fountain pen out of my pocket. "Draw me a sheep," he repeated gently.''',

    '''I had thus learned a second very important fact: the planet from which the little prince came was scarcely any larger than a house! That did not really surprise me much. I knew very well that in addition to the great planets like Earth, Jupiter, Mars, Venus, there are hundreds of others which are sometimes so small that it is difficult to see them through the telescope.

When an astronomer discovers one of these, he does not give it a name, but only a number. He calls it, for example, "Asteroid 3251." I have serious reason to believe that the planet from which the little prince came is the asteroid known as B-612.

This asteroid has only once been seen through the telescope. That was by a Turkish astronomer, in 1909. He had made a grand demonstration of his discovery at an International Astronomical Congress.''',

    '''Every day I would learn something about the little prince’s planet, about his departure, about his journey. On the third day, I learned about the catastrophe of the baobabs.

"It is a question of discipline," the little prince said to me later. "When you've finished washing yourself in the morning, you must tend to the planet. You must pull up the baobabs regularly, as soon as they can be distinguished from the rosebushes."

If a baobab is not pulled up in time, you can never get rid of it. It spreads over the entire planet. It drives its roots right through. And if the planet is too small, and the baobabs are too many, they split it to pieces.''',

    '''The little prince’s flower soon began to show herself in her beautiful glowing red petals. She adjusted her vanity carefully under her glass globe. She chose her colors with the greatest care. She dressed herself slowly, fitting her petals one by one.

She did not wish to go out into the world all crumpled, like the poppies. She wished to appear only in the full radiance of her beauty. Ah! She was a coquettish creature!

"Ah! I am scarcely awake," she whispered, her voice like a tiny bell. "I beg your pardon... My petals are still all disarranged..." The little prince could not contain his admiration: "How beautiful you are!"''',

    '''On the first asteroid lived a king who sat upon a throne clad in royal purple and ermine. "Ah! Here is a subject!" cried the king when he saw the little prince. The king demanded that everyone obey his commands, but he was a reasonable monarch and ordered only what was possible.

On the second planet lived a conceited man. "Ah! An admirer!" he exclaimed from afar. "Clap your hands one against the other," he directed the little prince. The little prince clapped his hands, and the conceited man raised his hat in a modest bow.

"The grown-ups are certainly very odd," the little prince said to himself as he continued his journey across the stars.''',

    '''The sixth planet was ten times larger than the last. It was inhabited by an old gentleman who wrote enormous books. "Oh, look! Here is an explorer!" he exclaimed to the little prince.

"I am a geographer," the old gentleman explained. "A geographer is a scholar who knows where the seas, the rivers, the cities, the mountains, and the deserts are located. But I do not leave my desk to explore."

"What about my rose?" asked the little prince. "We do not record flowers," said the geographer, "because flowers are ephemeral." "What does ephemeral mean?" "It means: threatened by speedy disappearance."''',

    '''It was then that the fox appeared. "Good morning," said the fox. "Good morning," the little prince responded politely. "Come and play with me," proposed the little prince. "I am so sad." "I cannot play with you," the fox said. "I am not tamed."

"What does 'tame' mean?" asked the little prince. "It is an act too often neglected," said the fox. "It means to establish ties."

"To me, you are still nothing more than a little boy who is just like a hundred thousand other little boys," the fox said. "But if you tame me, then we shall need each other. To me, you will be unique in all the world. To you, I shall be unique in all the world."''',

    '''The little prince went away, to look again at the roses. "You are not at all like my rose," he told them. "As yet you are nothing. No one has tamed you, and you have tamed no one. You are beautiful, but you are empty."

He returned to the fox. "Goodbye," he said. "Goodbye," said the fox. "And now here is my secret, a very simple secret: It is only with the heart that one can see rightly; what is essential is invisible to the eye."

"What is essential is invisible to the eye," the little prince repeated, so that he would be sure to remember. "It is the time you have wasted for your rose that makes your rose so important."''',
  ];

  static final List<String> princeChineseContents = [
    '''当我六岁的时候，在一本叫《真实的故事》的书里看到了一幅关于原始森林的壮丽插图。它画的是一条巨蟒正在吞食一只野兽。这是那幅画的复刻。

书里写道：“巨蟒吞食猎物时从不嚼碎，而是整吞下去。之后它们就再也不能动弹，在长达六个月的沉睡中完成消化。”

我当时对丛林的探险进行了深入的思考。经过用彩色铅笔的努力，我成功画出了我的第一幅画。我的一号作品。它画的是一条巨蟒正在消化一只大象。

我把我的杰作拿给大人看，问他们这幅画是否吓人。但他们回答：“吓人？一顶帽子有什么好吓人的？”我的画不是一顶帽子。它是一条正在消化大象的巨蟒。但因为大人看不懂，我又画了第二幅画。''',

    '''六年前，我的飞机在撒哈拉沙漠出了故障。发动机里有什么东西断裂了。因为我既没带机械师也没带乘客，我只能独自尝试完成这项艰难的修理。这对我来说是生死关头。我带的饮用水勉强只够喝八天。

第一天晚上，我在远离人烟千里的沙漠沙地上睡着了。我比在茫茫大海中漂流在木筏上的求生船员还要孤独。

因此你可以想象，当太阳升起时，我被一个奇特的小声音唤醒时的惊奇。它说：“请……帮我画一只羊吧！”“什么！”“帮我画一只羊……”''',

    '''我像被雷击了一般跳了起来。我狠狠眨了眨眼。我仔细看去。眼前站着一个极其非同寻常的小家伙，正极其严肃地审视着我。

现在我目瞪口呆地盯着这个突然显现的小人。记住，我当时坠毁在远离人烟千里的沙漠深处。但这个小家伙看起来既不像迷了路，也不像要因疲惫、饥饿、口渴或恐惧而死去。

“当神秘感过于震撼时，人是不敢违抗的，”我对他说着，从口袋里掏出了一张纸和钢笔。“帮我画一只羊，”他温柔地重复道。''',

    '''就这样，我了解到了第二个非常重要的事实：小王子来自的那个星球，几乎不比一座房子大！这并没有太让我感到吃惊。我很清楚，除了地球、木星、火星、金星这些大行星之外，还有成百上千颗小行星，有的甚至小得用望远镜都很破费才能看清。

当天文学家发现其中一颗时，他不会给它取名字，而只给它一个编号。例如叫它“3251 号小行星”。我有充分的理由相信，小王子来自的那个星球就是编号 B-612 的小行星。

这颗小行星只在 1909 年被一位土耳其天文学家通过望远镜观测到过一次。当时他在国际天文学大会上对他的发现做了一次伟大的演示。''',

    '''每天我都会了解到关于小王子的星球、他的离开以及他的旅程的新事情。第三天，我知道了猴面包树的灾难。

“这是纪律问题，”小王子后来对我说。“当你早晨梳洗完毕后，你就必须仔细打理你的星球。一旦能分清猴面包树和玫瑰幼苗，就必须定期拔掉猴面包树。”

如果猴面包树拔得不及时，你就再也无法除掉它。它会盘踞整个星球。它的根会刺穿星球。如果星球太小，而猴面包树太多，它们就会把星球胀得粉碎。''',

    '''小王子的那朵花很快在鲜艳娇红的花瓣中展现出她的容颜。她在玻璃罩下小心翼翼地整理着她的娇矜。她极其仔细地挑选着颜色。她缓缓穿着衣裳，一片片整理着花瓣。

她可不想像虞美人那样皱巴巴地出场。她希望只在她美丽的盛放光彩中现身。啊！她真是个娇气的小东西！

“啊！我才刚刚睡醒呢，”她低语道，声音宛如清脆的小铃铛。“请原谅我……我的花瓣还乱糟糟的呢……”小王子忍不住赞叹：“你真美啊！”''',

    '''在第一颗小行星上住着一位国王，坐在铺着紫袍和貂皮的宝座上。“啊！看哪，来了一位臣民！”国王一看到小王子就喊道。国王要求每个人都听从他的命令，但他是一位理智的君主，只下达可行的指令。

在第二颗星球上住着一个自负的人。“啊！一位崇拜者！”他远远地喊道。“把你的双手拍打起来，”他指示小王子。小王子拍起手来，自负的人便举起帽子谦逊地致意。

“大人真是奇奇怪怪，”小王子继续穿梭星际旅行时对自己说。''',

    '''第六颗星球比前面的大十倍。上面住着一位撰写宏伟大部头书的老绅士。“哦，看哪！来了一位探险家！”他向小王子惊呼道。

“我是一名地理学家，”老绅士解释道。“地理学家就是知道大海、河流、城市、山脉和沙漠分布在哪里的学者。但我不会离开我的书桌去亲身探险。”

“那我的玫瑰花呢？”小王子问。“我们不记录花朵，”地理学家说，“因为花朵是短暂易逝的。”“短暂易逝是什么意思？”“意思是：面临迅速消逝的危险。”''',

    '''就在那时，小狐狸出现了。“早上好，”狐狸说。“早上好，”小王子礼貌地回应。“来和我一起玩吧，”小王子提议。“我太伤心了。”“我不能和你玩，”狐狸说。“我还没被驯服呢。”

“‘驯服’是什么意思？”小王子问。“这是人们常常遗忘的一件事，”狐狸说。“它的意思就是‘建立联系’。”

“对我来说，你还只是一个小男孩，和千千万万个小男孩没什么两样，”狐狸说。“但如果你驯服了我，我们就互相不可或缺了。对我来说，你在全世界是独一无二的；对你来说，我在全世界也是独一无二的。”''',

    '''小王子跑开去重新看那些玫瑰。“你们一点也不像我的玫瑰，”他对它们说。“你们现在什么也不是。没有人驯服过你们，你们也没有驯服过任何人。你们很美，但你们是空虚的。”

他回到狐狸身边。“再见，”他说。“再见，”狐狸说。“现在这是我的秘密，一个非常简单的秘密：只有用心灵才能看得清事物；本质的东西，用眼睛是看不见的。”

“本质的东西，用眼睛是看不见的，”小王子重复道，以便牢牢记住。“正是在你的玫瑰身上浪费的时间，让你的玫瑰变得如此重要。”''',
  ];

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
        content: beautyContents[index % beautyContents.length],
        chineseContent: beautyChineseContents[index % beautyChineseContents.length],
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Fairy Tale', 'Romance', 'Magic'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 8,
        coverUrl: 'assets/images/book_beauty.jpg',
      );
    });
  }

  static final List<String> beautyTitles = [
    'The Merchant and His Daughters',
    'The Loss of Fortune',
    'The Enchanted Palace',
    'The Plucking of the Rose',
    'The Beast’s Ultimatum',
    'Beauty Goes to the Castle',
    'Life in the Magic Castle',
    'The Vision in the Magic Mirror',
    'The Broken Promise',
    'Love Breaks the Enchantment',
  ];

  static final List<String> beautyChineseTitles = [
    '富商与他的女儿们',
    '家族财富的破灭',
    '暴雪中的神奇宫殿',
    '摘取致命的玫瑰花',
    '野兽的冰冷最后通牒',
    '贝儿前往神秘城堡',
    '魔法城堡里的生活',
    '魔镜中的悲伤幻象',
    '违背归期的誓言',
    '真爱化解古老魔咒',
  ];

  static final List<String> beautyContents = [
    '''A very rich merchant once lived in a grand mansion with his six children, three sons and three daughters. His youngest daughter was so gentle, kind, and extraordinarily lovely that everyone called her Beauty.

While her elder sisters spent their time at balls and grand parties, boasting of their wealth, Beauty spent her days reading good books and helping her father manage the household.

One day, terrible news arrived: a violent ocean storm had destroyed the merchant\'s entire fleet of merchant ships. In a single night, the family lost their entire fortune and were forced to move to a small wooden cottage in the distant countryside.''',

    '''The family had to work hard in the fields from morning till night. Beauty woke up before dawn to sweep the cottage, prepare meals, and mend the clothing without a word of complaint.

After a year of humble country life, news came that one of the merchant\'s lost ships had arrived in port. The elder sisters excitedly demanded expensive silk gowns, lace, and jewels.

"And what shall I bring for you, Beauty?" her father asked gently. "Bring me a single red rose, Father," Beauty replied with a sweet smile, "for none grow in our country garden."''',

    '''When the merchant arrived in port, he found his cargo seized by creditors, leaving him as poor as before. Dejected and weary, he set off on his long journey home through a howling winter blizzard.

Night fell, and the wind blew snow into blinded eyes. Suddenly, through the bare trees, the merchant saw a bright golden light. He followed it and discovered a magnificent enchanted palace.

He walked into the grand hall where a warm fire crackled on the hearth and a rich feast was spread upon a golden table. Though no host appeared, he ate and slept peacefully in a plush bed.''',

    '''The next morning, refreshed and fed, the merchant walked out into the palace gardens, where thousands of fragrant red roses bloomed in spite of the surrounding snow.

Remembering Beauty’s modest request, he reached out and snapped a heavy red rose from a thorny bush. Instantly, a terrifying roaring sound shook the earth.

A hideous Beast, clad in regal velvet, sprang forward with glowing eyes. "Ungrateful man!" the Beast roared. "I saved your life, and in return you steal my most prized roses! For this, you must die!"''',

    '''The merchant fell to his knees in terror, begging for mercy and explaining that he had picked the rose only for his sweet daughter Beauty.

The Beast’s eyes softened slightly. "I will pardon your life on one condition," the Beast growled sternly. "Either you return in three months to face your punishment, or one of your daughters must come willingly to take your place!"

The heartbroken merchant swore to return, taking a chest of gold coins offered by the Beast, and rode home to bid his children a painful farewell.''',

    '''When the merchant reached home and told his sorrowful tale, Beauty immediately stepped forward with quiet courage. "I will go to the Beast’s castle, Father," she said softly.

Despite the weeping of her brothers and father, Beauty insisted on keeping the sacred promise. A few days later, she rode behind her father through the dark, whispered forest to the palace.

When they entered the castle, a grand banquet awaited them. Soon the Beast appeared. "Have you come willingly, fair maiden?" he asked in a deep, booming voice. "Yes, my lord," Beauty answered bravely.''',

    '''The Beast treated Beauty with profound gentleness and respect. He gave her a magnificent suite of rooms filled with rare instruments, thousands of leather-bound books, and splendid gowns.

Every evening at nine o\'clock, the Beast would join Beauty for dinner, conversing with surprising intelligence and modesty. Before leaving, he would ask: "Beauty, will you be my wife?"

Beauty would gently decline: "No, Beast, but I will always be your faithful friend." Though disappointed, the Beast accepted her answer without anger.''',

    '''Months passed in quiet contentment, but Beauty grew homesick. Looking into a magic mirror given to her by the Beast, she saw her father lying ill in bed, grieving for her.

Tears streamed down Beauty’s cheeks. She begged the Beast: "Please let me visit my sick father for just seven days! I promise on my life to return!"

The Beast sighed mournfully. "I cannot refuse your tears, Beauty. Take this golden ring. Lay it on your table when you wish to return, and you shall be transported back."''',

    '''When Beauty arrived home, her father wept with joy and quickly recovered his health. But her envious elder sisters, seeing her fine clothes and hearing of her palace life, plotted to destroy her.

They feigned deep affection and persuaded Beauty to stay past the promised seven days, hoping the furious Beast would devour her upon her return.

On the tenth night, Beauty had a terrifying dream: she saw the Beast lying unconscious beside the palace fountain, dying of a broken heart. She woke up in terror, realizing how deeply she cared for him.''',

    '''Beauty placed the magic ring upon her bedside table and instantly woke up in the enchanted castle. She ran frantically through the moonlit gardens, calling the Beast’s name.

She found him lying lifeless beside the fountain. Throwing herself upon his body, she wept bitterly: "No, Beast, you shall not die! Live to be my husband, for I love you with all my heart!"

Instantly, a brilliant flash of light filled the sky. The Beast vanished, and in his place stood a handsome prince. The ancient curse was broken, and they lived together in eternal joy.''',
  ];

  static final List<String> beautyChineseContents = [
    '''曾经有一位非常富有的商人，和他的六个孩子（三个儿子和三个女儿）住在一座宏伟的宅邸里。他最小的女儿性格温和、善良，而且长得极其美丽，大家称她为“贝儿”（意为美女）。

当她的姐姐们把时间花在舞会和奢华派对上炫耀财富时，贝儿每天都在阅读好书，帮父亲打理家务。

有一天，可怕的消息传来：一场猛烈的海上暴风雨摧毁了商人的整个商船队。在一夜之间，全家失去了所有财产，不得不搬到远方乡村的一间木屋里生活。''',

    '''全家人不得不从早到晚在田间辛苦劳作。贝儿清晨天不亮就起床打扫小屋、准备饭菜、缝补衣服，没有一句怨言。

在过了一年的谦逊乡村生活后，传来消息说商人失踪的一只船驶进了港口。姐姐们兴奋地索要昂贵的丝绸礼服、蕾丝和珠宝。

“那么我为你带点什么呢，贝儿？”父亲温柔地问。“请为我带一朵红玫瑰吧，父亲，”贝儿甜甜地笑着回答，“因为我们乡村的花园里一朵也没开。”''',

    '''当商人赶到港口时，他发现货物已被债主没收，他依然像以前一样贫困。沮丧而疲惫的他，踏上了冒着呼啸冬日暴雪回家的漫长旅程。

夜幕降临，大风把雪花吹进模糊的眼睛里。突然，穿过光秃秃的树木，商人看到了一道璀璨的金光。他顺着光芒走去，发现了一座宏伟神奇的宫殿。

他走进大厅，看到火炉里噼啪作响地烧着暖火，金桌上摆满了丰盛的盛宴。虽然不见主人，但他大快朵颐，并在舒适的床上安然入睡。''',

    '''第二天清晨，神清气爽吃饱喝足的商人走进宫殿花园，尽管周围大雪纷飞，这里却盛开着成千上万朵芳香的红玫瑰。

想起贝儿谦逊的请求，他伸手从带刺的灌木上折下了一朵沉甸甸的红玫瑰。瞬间，一声可怕的怒吼震动了大底。

一只身穿华丽天鹅绒的丑陋野兽跳了出来，双眼发光。“忘恩负义的人！”野兽咆哮道。“我救了你的命，你却偷走我最珍贵的玫瑰！为此，你必须死！”''',

    '''商人吓得跪倒在地，求野兽饶命，并解释说他摘这朵玫瑰只是为了他可爱的女儿贝儿。

野兽的眼神稍微软化了一些。“看在你女儿的分上，我可以饶你一命，但有一个条件，”野兽严厉地咆哮道。“要么你在三个月内返回接受惩罚，要么你的一个女儿心甘情愿代你受过！”

心碎的商人发誓归来，接过了野兽赠送的一箱金币，骑马回家向孩子们作痛心的告别。''',

    '''当商人回到家讲述了他悲惨的遭遇后，贝儿带着沉静的勇气立即上前。“我去野兽的城堡，父亲，”她轻声说。

尽管哥哥们和父亲痛哭流涕，贝儿依然坚持履行这项神圣的誓言。几天后，她骑在父亲身后穿过黑夜中低语的森林来到宫殿。

当他们走进城堡时，一场盛大的宴会等待着他们。不久野兽出现了。“你是心甘情愿来的吗，美丽的姑娘？”他用低沉洪亮的声音问。“是的，大人，”贝儿勇敢地回答。''',

    '''野兽对贝儿极其温柔和尊重。他给她准备了一套宏伟的房间，里面装满了稀有的乐器、成千上万册皮面精装书和精美的礼服。

每天晚上九点，野兽都会陪贝儿共进晚餐，用令人惊叹的智慧和谦逊与她交谈。在离开前，他总会问：“贝儿，你愿意做我的妻子吗？”

贝儿总会温柔地拒绝：“不，野兽，但我永远是你忠实的朋友。”虽然失望，野兽却没有发怒，接受了她的回答。''',

    '''几个月在宁静满足中过去了，但贝儿开始思念家乡。凝视着野兽送给她的魔镜，她看到父亲因思念她卧病在床。

泪水流下了贝儿的双颊。她哀求野兽：“请让回家看望我生病的父亲七天吧！我拿生命保证一定会回来！”

野兽悲伤地叹了口气。“我无法拒绝你的眼泪，贝儿。拿着这枚金戒。当你想回来时把它放在桌上，你就会被传送回来。”''',

    '''当贝儿回到家时，父亲高兴得流下了眼泪，身体迅速康复。但她嫉妒的姐姐们看到她华丽的衣服，听到她的城堡生活后，密谋摧毁她。

她们假装深情，说服贝儿留下了超过承诺的七天，希望愤怒的野兽会在她归来时吞噬她。

在第十天晚上，贝儿做了一个可怕的梦：她看到野兽毫无生气地躺在宫殿喷泉旁，因心碎濒临死亡。她惊恐地醒来，意识到自己竟如此深深地在乎他。''',

    '''贝儿把魔镜和金戒放在床头桌上，瞬间在神奇的城堡中醒来。她疯狂地穿过月光照耀的花园，呼唤着野兽的名字。

她发现他无精打采地躺在喷泉旁。她扑在他的身上痛苦地哭泣：“不，野兽，你不能死！活下来做我的丈夫吧，因为我全心全意地爱你！”

瞬间，一道耀眼的光芒照亮了天空。野兽消失了，取而代之的是一位英俊的王子。古老的魔咒被打破了，他们永远幸福地生活在一起。''',
  ];

  // --- 4. Arabian Nights Chapters (12 Units - Substantial Original Passages) ---
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
        content: nightsContents[index % nightsContents.length],
        chineseContent: nightsChineseContents[index % nightsChineseContents.length],
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Folklore', 'Adventure', 'Myth'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 9,
        coverUrl: 'assets/images/book_nights.png',
      );
    });
  }

  static final List<String> nightsTitles = [
    'Scheherazade’s Courage',
    'The Merchant and the Genie',
    'The First Old Man’s Tale',
    'Aladdin and the Magic Lamp',
    'The Wonderful Palace',
    'Ali Baba and the Cave',
    'Treasures of Sesame',
    'Morgiana’s Wisdom',
    'Sinbad’s First Voyage',
    'The Valley of Diamonds',
    'The Fisherman and the Jar',
    'Dawn of One Thousand Nights',
  ];

  static final List<String> nightsChineseTitles = [
    '山鲁佐德的勇气',
    '商人与魔鬼的故事',
    '老人的故事',
    '阿拉丁与神灯',
    '奇迹宫殿',
    '阿里巴巴与大盗洞穴',
    '芝麻开门的宝藏',
    '莫吉娜的超凡智慧',
    '航海家辛巴达的远航',
    '钻石之谷的惊险',
    '渔夫与海中铜瓶',
    '一千零一夜的黎明',
  ];

  static final List<String> nightsContents = [
    '''In ancient Persia, Sultan Shahryar ruled over a vast empire. Betrayed by his unfaithful queen, the Sultan vowed to marry a new bride each night and execute her at dawn, plunging the whole city into grief and terror.

The Vizier’s eldest daughter, Scheherazade, was a maiden of extraordinary wisdom, courage, and literary talent. She had read thousands of historical chronicles, poetry, and ancient fables.

"My noble father," Scheherazade declared firmly, "I shall marry the Sultan tonight. By God’s help, I will either save the maidens of our land or perish in the attempt."''',

    '''On the wedding night, Scheherazade made a gentle request to bid farewell to her younger sister, Dunyazad. At midnight, Dunyazad asked: "Sister, if you are not asleep, tell us one of your enchanting stories."

Scheherazade looked at the Sultan, who granted permission. She began the tale of the Merchant and the Genie: A wealthy merchant was eating dates under a palm tree when a towering Efreet suddenly materialized from smoke.

"Stand up so I may slay thee!" the Genie roared, holding a glittering scimitar. "Thou hast killed my son with a thrown date stone!" As dawn broke, Scheherazade stopped at the most dramatic climax, leaving the Sultan eager for the continuation.''',

    '''The Sultan spared Scheherazade\'s life for one more day to hear the resolution of the story. Night after night, she wove tales within tales of magicians, kings, sea monsters, and hidden caverns.

She told of the first old man who arrived leading a charmed hind, offering to tell his strange story to redeem a portion of the merchant\'s life from the vengeful Genie.

The Sultan was so captivated by the beauty and wisdom of the narratives that morning after morning he postponed her execution, listening breathless to her words.''',

    '''In a far city of China lived Aladdin, a poor tailor’s son. An African sorcerer disguised as his uncle led Aladdin to a secret valley surrounded by black mountains.

Lighting a magical fire, the magician opened a heavy stone slab revealing a subterranean cave. "Descend into the darkness," the sorcerer commanded, "and bring me the rusty brass lamp!"

When Aladdin touched the lamp, he accidentally rubbed its surface. A colossal Genie of terrifying power appeared, bellowing: "I am the slave of the Lamp! What is thy command, my master?"''',

    '''With the magical assistance of the Genie, Aladdin grew into a noble, generous prince. He requested the Genie to erect a luminous palace of white marble, gold, and jade opposite the Sultan\'s royal court.

Overnight, the miraculous palace appeared, dazzling the whole kingdom. Aladdin married Princess Badroulbadour, winning the profound love of the citizens through his charity.

Though the evil sorcerer tried to steal the lamp by trickery, Aladdin and his brave princess outwitted the magician and reclaimed their peaceful realm.''',

    '''In a town of Persia lived two brothers, Cassim and Ali Baba. Ali Baba was a poor woodcutter who gained his living by gathering firewood in the forest upon three donkeys.

One day, while working near a steep mountain cliff, Ali Baba saw a cloud of dust approaching. Forty heavily armed horsemen rode up and dismounted before a massive rock wall.

The captain of the thieves stepped forward and shouted in a booming voice: "Open, Sesame!" Instantly, a hidden door in the solid stone swung open.''',

    '''Ali Baba watched in awe as the thieves carried heavy bags of gold into the cavern. After they departed, chanting "Close, Sesame!", Ali Baba stepped up to the rock and repeated the magic words.

The cave opened, revealing a vast cavern glittering with mounds of gold, diamonds, silk carpets, and silver vessel. Ali Baba loaded his donkeys with bags of gold coins.

He brought the fortune home to his wife, burying the gold in their garden while swearing absolute secrecy to protect his family from the wrath of the thieves.''',

    '''When the thieves discovered their cave had been pillaged, their captain tracked down Ali Baba\'s house and disguised himself as an oil merchant carrying thirty-eight large leather jars.

One jar contained oil, but the remaining thirty-seven jars concealed armed thieves waiting for midnight to attack the house.

The clever maid Morgiana discovered the plot while seeking oil for a lamp. With supreme courage, she boiled oil and poured it into the jars, neutralizing the thieves and saving Ali Baba\'s household.''',

    '''Sinbad the Sailor recounted his legendary voyages across uncharted seas to a poor porter named Hindbad. On his very first voyage, Sinbad\'s merchant ship anchored beside a green island.

The sailors built fires and cooked food, but suddenly the ground trembled violently. The "island" was actually the moss-covered back of a colossal sleeping whale!

The monster plunged into the deep ocean. Sinbad was swept away by raging waves, clinging desperately to a floating wooden plank until he washed ashore on a magical kingdom.''',

    '''On his second voyage, Sinbad was accidentally abandoned on a desert island. Wandering into a deep mountain canyon, he discovered a floor carpeted with giant sparkling diamonds.

The canyon was guarded by giant serpents and frequented by colossal Roc eagles. Sinbad devised a brilliant escape by tying heavy pieces of raw meat to his back.

A giant eagle swooped down, grasped the meat in its talons, and carried Sinbad up to its nest atop the high mountain peaks, where merchants rescued him.''',

    '''A poor old fisherman cast his nets into the sea four times. On the fourth cast, he pulled up a heavy brass vessel sealed with a lead cap bearing the magical seal of King Solomon.

When the fisherman opened the cap with his knife, a thick dark smoke poured out, coalescing into a monstrous Efreet of giant proportions.

"Prepare to die, fisherman!" the Efreet roared. "I swore to slay whoever released me!" But the fisherman outwitted the monster by challenging him: "Thou couldst never fit thy vast body inside this small jar!" To prove it, the Efreet shrank into smoke, and the fisherman sealed him back inside.''',

    '''Night after night, for one thousand and one nights, Scheherazade fascinated the Sultan with her boundless store of stories, wisdom, and moral parables.

During those years, she bore him three healthy sons. On the one thousand and first night, she presented the children before the throne, asking for her life to be spared.

The Sultan embraced her with tears of joy, declaring: "I have long since repented of my cruel vow. Thou art pure, noble, and wise, my Queen!" And they lived together in everlasting peace and prosperity.''',
  ];

  static final List<String> nightsChineseContents = [
    '''在古代波斯，苏丹山鲁亚尔统治着一片辽阔的帝国。因遭受叛逆王后的背叛，苏丹发下酷誓，每晚迎娶一位新新娘并在黎明时将其处决，使整个城市陷入悲伤与恐惧。

宰相的大女儿山鲁佐德是一位拥有非凡智慧、勇气与文学才华的女子。她阅读过数千册历史典籍、诗歌与古老寓言。

“我高尚的父亲，”山鲁佐德坚定地宣告，“今晚我要嫁给苏丹。在上帝的帮助下，我要么拯救我们土地上的女子，要么在尝试中牺牲。”''',

    '''在新婚之夜，山鲁佐德提出了一个温柔的请求，向她的妹妹敦亚佐德告别。半夜时分，敦亚佐德问：“姐姐，如果你还没睡着，给我们讲一个你那迷人的故事吧。”

山鲁佐德看向苏丹，苏丹准许了。她开始讲述商人与魔鬼的故事：一位富有商人正在棕榈树下吃枣，一个高耸入云的魔鬼突然从烟雾中显现。

“站起来让我杀了你！”魔鬼挥舞着闪烁的弯刀咆哮道。“你扔出的枣核砸死了我的儿子！”当黎明破晓时，山鲁佐德在最扣人心弦的高潮处停住了，让苏丹急切地想听续集。''',

    '''苏丹饶了山鲁佐德又一天的生命，以听完故事的结局。夜复一夜，她把关于巫师、国王、海怪与隐秘洞穴的故事环环相扣地织就出来。

她讲述了第一位牵着神奇母鹿赶来的老者，提出讲述他奇特的故事，以向复仇的魔鬼赎回商人三分之一的生命。

苏丹被故事的美妙与智慧所深深吸引，以至于一个又一个清晨他都推迟了处决，屏住呼吸倾听着她的讲述。''',

    '''在遥远的中国一座城市里住着阿拉丁，一个贫穷裁缝的儿子。一个伪装成他叔叔的非洲巫师把阿拉丁带到了一座被黑山环绕的神秘山谷。

巫师点燃魔法之火，打开了一块沉重的石板，露出了一个地下洞穴。“降到黑暗深处去，”巫师命令道，“把我那盏锈蚀的铜灯拿来！”

当阿拉丁碰到铜灯时，他不小心擦拭了灯面。一位拥有可怕力量的巨大精灵在烟雾中显现，咆哮道：“我是神灯的奴仆！我的主人，你有何吩咐？”''',

    '''在精灵神奇的协助下，阿拉丁成长为一位高尚慷慨的王子。他请求精灵在苏丹王宫对面建造一座由白大理石、黄金与翡翠构成的明亮宫殿。

一夜之间，奇迹般的宫殿显现了，令整个王国目眩神迷。阿拉丁迎娶了巴布鲁巴多公主，通过善行赢得了民众深厚的爱戴。

尽管邪恶的巫师试图用诡计偷走神灯，但阿拉丁与他勇敢的公主用智慧战胜了巫师，收复了他们和平的王国。''',

    '''在波斯的一座城镇里住着一对兄弟，卡西姆和阿里巴巴。阿里巴巴是一个贫穷的樵夫，靠用三头驴子在森林里砍柴维持生计。

有一天，当他在高耸的石壁附近干活时，阿里巴巴看到一团尘土扑面而来。四十名装备精良的骑兵骑马赶来，在一座巨大的岩壁前下马。

强盗首领上前一步，用洪亮的声音喊道：“芝麻开门！”瞬间，坚硬石壁上的一扇隐秘大门轰然打开。''',

    '''阿里巴巴惊奇地看着强盗们把成袋的金子搬进洞穴。在他们吟诵着“芝麻关门！”离开后，阿里巴巴走到岩石前重复了这句神秘的口诀。

洞穴打开了，显现出一个闪烁着成堆金币、钻石、丝绸地毯与银器的巨大宝窟。阿里巴巴在驴子背上装满了成袋的金币。

他把财宝带回家给妻子，把金子埋在花园里，同时发下绝对保密的誓言，以保护家人免受强盗的怒火。''',

    '''当强盗们发现他们的洞穴被盗后，首领追踪到了阿里巴巴的家，伪装成携带着三十八个大皮革油桶的油商。

一个桶里装着油，但其余三十七个桶里却藏着武装强盗，等待半夜袭击这户人家。

聪明的女佣莫吉娜在为油灯找油时发现了这个阴谋。带着超凡的勇气，她烧开滚油倒入桶中，制服了强盗，拯救了阿里巴巴全家。''',

    '''航海家辛巴达向一位叫辛巴德的贫穷搬运工讲述了他穿越未知大洋的传奇远航。在他的第一次远航中，辛巴达的商船在一座绿色岛屿旁抛锚。

水手们生火做饭，但地面突然猛烈地震动起来。这座“岛屿”实际上是一头巨大的沉睡海怪苔藓露背！

海怪潜入深海。辛巴达被汹涌的波涛卷走，紧紧抓住一块漂浮的木板，直到被冲上了神奇王国的海岸。''',

    '''在他的第二次远航中，辛巴达不幸被遗弃在一座荒岛上。当他漫步走进一条深山峡谷时，他发现地面上铺满了巨大的闪烁钻石。

峡谷由巨蛇看守，并有巨大的大鹏鸟出没。辛巴达设计了一个绝妙的逃生计划，把大块鲜肉绑在自己的肩膀上。

一只巨鹰俯冲下来，用爪子抓起鲜肉，把辛巴达带到了高山顶上的巢穴里，那里的商人救了他。''',

    '''一位贫穷的老渔夫四次将网撒入大海。在第四次撒网时，他拉出了一只沉重的铜瓶，上面盖着带有所罗门封印的铅盖。

当渔夫用刀打开铅盖时，浓浓的黑烟喷涌而出，凝结成一个体型巨大的凶恶魔鬼。

“准备受死吧，渔夫！”魔鬼咆哮道。“我曾发誓要杀死释放我的任何人！”但渔夫用质问战胜了魔鬼：“你这么庞大的身体绝不可能装进这么小的瓶子里！”为了证明这一点，魔鬼缩成烟雾，渔夫顺势重新封上了瓶盖。''',

    '''夜复一夜，在一千零一夜里，山鲁佐德用她无尽的故事、智慧与道德寓言深深吸引着苏丹。

在这几年里，她为他生下了三个健康的儿子。在第一千零一夜，她把孩子们带到宝座前，请求饶她一命。

苏丹流着高兴的眼泪拥抱了她，宣告道：“我很久以前就对自己残酷的誓言感到悔恨了。你是纯洁、高尚而聪慧的，我的王后！”他们永远幸福繁荣地生活在一起。''',
  ];

  // --- 5. The Great Stone Face Chapters (10 Units - Substantial Original Passages) ---
  static List<Article> getStoneFaceChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'stoneface_u$unitNum',
        bookId: 'book_stoneface',
        unitIndex: unitNum,
        title: stonefaceTitles[index % stonefaceTitles.length],
        chineseTitle: '第 $unitNum 单元：${stonefaceChineseTitles[index % stonefaceChineseTitles.length]}',
        content: stonefaceContents[index % stonefaceContents.length],
        chineseContent: stonefaceChineseContents[index % stonefaceChineseContents.length],
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Philosophy', 'Growth'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 8,
        coverUrl: 'assets/images/book_stoneface.png',
      );
    });
  }

  static final List<String> stonefaceTitles = [
    'The Valley and the Face',
    'The Ancient Prophecy',
    'Mr. Gathergold Returns',
    'The Failure of Wealth',
    'Blood-and-Thunder the General',
    'Illusion of Military Glory',
    'Old Stony Phiz the Politician',
    'Ernest’s Quiet Virtues',
    'The Poet and the Sunset',
    'The True Resemblance',
  ];

  static final List<String> stonefaceChineseTitles = [
    '山谷与巨石人面像',
    '古老的伟人预言',
    '聚金先生重返山谷',
    '财富的虚妄与破灭',
    '血雷将军的功勋',
    '军事荣光的虚幻',
    '老石脸政治家',
    '欧内斯特的高尚美德',
    '诗人与晚霞下的心灵',
    '真正的相貌契合',
  ];

  static final List<String> stonefaceContents = [
    '''High upon the precipitous mountain wall, nature had sculpted a noble giant face. The Great Stone Face was a work of nature, formed by immense rocks piled together in such mood that when viewed from a distance, they resembled a magnificent human countenance.

Little Ernest spent his childhood gazing at its calm and benevolent expression from the doorway of his mother\'s log cottage. The face seemed to smile upon the valley, showering peaceful light over the humble farms.

"Mother," Ernest asked one evening, "shall I ever see a man who looks like that Face?" "If an ancient prophecy comes true," his mother replied softly, "we shall see a person whose features are the exact image of the Great Stone Face."''',

    '''The prophecy had been handed down from Indian ancestors: A child born in this valley should grow up to become the greatest and noble person of his time, bearing an exact resemblance to the Great Stone Face.

Many villagers scoffed at the legend, but Ernest kept the prophecy deep within his heart. Whenever he finished his work in the cornfields, he would sit staring at the mountain face for hours.

The mountain seemed to educate the boy, filling his young soul with noble aspirations, quiet wisdom, and deep compassion for humanity.''',

    '''Years passed, and news spread that Mr. Gathergold, a native of the valley who had become an immensely wealthy merchant in distant cities, was returning to spend his remaining days in his birthplace.

A golden carriage drawn by four white horses arrived. Crowds of excited villagers gathered along the road, cheering: "He is the exact image of the Great Stone Face! The prophecy is fulfilled!"

As Gathergold leaned out of his carriage window and dropped a copper coin to a beggar woman, Ernest caught sight of his yellow, wrinkled face and cold, scheming eyes. Ernest turned away with a heavy heart, knowing this was not the hero.''',

    '''Gathergold built a vast marble palace in the valley, but his vast wealth could not bring him peace or true nobility. Within a few years, his speculative investments failed, and he lost his fortune.

He died in poverty and obscurity, proving to the whole valley that gold and greed could never embody the noble soul of the Great Stone Face.

Ernest, now a young man, continued to work humbly on his small farm, still gazing upward at the mountain face every evening with unextinguished hope.''',

    '''The next candidate for the prophecy was General Blood-and-Thunder, a famous military commander who had spent his youth fighting battles across distant frontiers.

Now old and infirm, the general retired to his native valley. The villagers organized grand parades, firing cannons and playing brass bands to welcome the famous warrior.

Banners waved in the breeze as the general stood before the crowd. "Look!" the villagers shouted. "The resemblance is perfect! He is the Great Stone Face!"''',

    '''Ernest looked earnestly into the general\'s energetic face, searching for the noble compassion of his mountain friend. But he saw only stern ambition and the fiery habit of command.

"No," Ernest whispered softly to himself, "this is not the promised man." As he looked up at the cliff, the Great Stone Face seemed to whisper: "Fear not, Ernest; the man will come."

Ernest grew into manhood, earning the respect of his neighbors through his quiet wisdom, unselfish deeds, and gentle speech.''',

    '''Decades later, an eloquent orator named Old Stony Phiz arrived in the valley. He had become a famous politician, running for the highest office in the land.

His voice was like music, swaying crowds with powerful emotions and grand promises. The villagers marveled at his eloquence, declaring him to be the long-awaited hero.

Ernest listened attentively to his grand speeches, but beneath the silver words, he felt a void of genuine truth and noble purpose. The politician was not the likeness of the Face.''',

    '''Ernest had now grown into an old man with white hair. Without seeking fame or power, he lived a life of quiet virtue, speaking daily with his neighbors on spiritual truths.

His words possessed a natural power, for they sprang from a heart filled with love, sincerity, and unselfish wisdom. Travelers came from far away to converse with the humble mountain sage.

Yet Ernest remained simple and modest, still gazing at the Great Stone Face each night, praying that a wiser man than himself would one day appear.''',

    '''A renowned poet, born in the valley, published magnificent poems celebrating nature and the human spirit. Reading his poems, Ernest felt his heart leap with joy, believing the poet might be the promised hero.

The poet traveled to the valley to visit Ernest\'s humble cottage. As the sun began to set behind the mountains, the two men sat on the porch conversing on high and holy themes.

The poet listened in awe to Ernest\'s profound wisdom, realizing that Ernest\'s life was a far grander poem than any verse he had ever written.''',

    '''As the golden rays of the setting sun bathed the mountain cliff, the Great Stone Face shone with a divine glow. The poet looked from the mountain face to Ernest, and then back again.

Suddenly, the poet threw his arms into the air and shouted: "Behold! Behold! Ernest himself is the exact image of the Great Stone Face!"

The crowd looked, and saw that it was true: decades of gazing upon the noble face and living a life of virtue had transformed Ernest into the very likeness of the Great Stone Face.''',
  ];

  static final List<String> stonefaceChineseContents = [
    '''在高耸的悬崖之上，大自然雕琢出了一面高尚的巨型人脸。巨石人面像是一件大自然的杰作，由成堆的庞大岩石构成，当从远处凝视时，它们宛如一面雄伟的人类容颜。

小欧内斯特在母亲木屋门口凝视着它平静慈祥的容颜中度过了童年。那面容似乎在向山谷微笑，将和平的光芒洒向谦逊的农舍。

“母亲，”一天晚上欧内斯特问，“我能见到长得像那面容的人吗？”“如果古老的预言成真，”母亲温柔地回答，“我们一定会见到一位容貌与巨石人面像一模一样的人。”''',

    '''预言是从印第安先祖那里流传下来的：山谷中出生的一位孩子长大后将成为他那个时代最高尚、最伟大的思想家，并且面貌与巨石人面像一模一样。

许多村民对这个传说嗤之以鼻，但欧内斯特把预言深深藏在心里。每当他在玉米地里干完活，他都会坐在那里凝视着山崖人面像好几个小时。

群山似乎在教育这个男孩，用高尚的抱负、沉静的智慧与对人类深厚的同情滋养着他年轻的灵魂。''',

    '''许多年过去了，消息传来，在远方城市成为巨富的本土居民“聚金”先生要重返故乡度过余生。

一辆由四匹白拉着的金色马车驶来。兴奋的村民聚集在路边欢呼：“他与巨石人面像一模一样！预言实现了！”

当聚金先生探出车窗向一个女乞丐扔下一枚铜板时，欧内斯特看到了他那黄澄澄、满是皱纹的面孔和冷酷算计的眼睛。欧内斯特带着沉重的心情转过身去，知道这绝不是英雄。''',

    '''聚金先生在山谷里建造了一座庞大的大理石宫殿，但他庞大的财富无法带给他平静或真正的高尚。几年内，他的投机投资失败了，散尽了家财。

他在贫困与默默无闻中死去，向整个山谷证明了黄金与贪婪永远无法体现巨石人面像的高尚灵魂。

欧内斯特现在是一个年轻人了，继续在他那小农场上谦逊地耕作，每天晚上依然带着未灭的希望仰望着山崖人面像。''',

    '''预言的下一个候选人是“血雷将军”，一位在远方边疆历经百战的著名军事将领。

现在将军年老体衰，退隐回故乡山谷。村民们组织了盛大的游行，鸣炮并演奏铜管乐队迎接待这位名将。

旗帜在微风中飘扬，将军站在人群面前。“看哪！”村民们喊道。“相貌太完美了！他就是巨石人面像！”''',

    '''欧内斯特热切地注视着将军精力充沛的面庞，寻找着他山崖朋友的高尚慈悲。但他只看到了严酷的野心和发号施令的火爆习惯。

“不，”欧内斯特轻声对自己低语，“这不是预言中的人。”当他仰望山崖时，巨石人面像似乎在低语：“别怕，欧内斯特；那个人会来的。”

欧内斯特步入成年，通过他沉静的智慧、无私的善行和温和的言辞赢得了邻里的尊重。''',

    '''几十年后，一位叫“老石脸”的雄辩演说家来到山谷。他成为了一位著名的政治家，正在竞选最高职位。

他的声音宛如音乐，用强大的情感和宏伟的许诺动摇着人群。村民们惊叹于他的雄辩，宣称他就是期待已久的英雄。

欧内斯特认真聆听了他的宏伟演说，但在巧妙的言辞之下，他感到缺乏真挚的真理与高尚的目的。这位政治家不是人面像的化身。''',

    '''欧内斯特现在成长为一位满头白发的老人。他不追求名利，过着高尚美德的生活，每天与邻里探讨精神真理。

他的言辞拥有自然的力量，因为它们源于一颗充满爱、真诚与无私智慧的心。旅行者从远方赶来，与这位谦逊的山谷智者交谈。

然而欧内斯特依然朴实谦逊，每天晚上依然凝望着巨石人面像，祈祷着比自己更智慧的人有一天会出现。''',

    '''一位生于山谷的著名诗人出版了赞美自然与人类精神的宏伟诗篇。阅读他的诗句，欧内斯特感到内心欢欣跳动，相信诗人或许就是预言中的英雄。

诗人来到山谷拜访欧内斯特简朴的小屋。当太阳开始落入群山之后时，两人坐在走廊上探讨着高尚神圣的主题。

诗人带着敬畏聆听着欧内斯特深邃的智慧，意识到欧内斯特的生活是一首比他写过的任何诗篇都更为宏伟的诗。''',

    '''当落日的金色余晖洒在山崖上时，巨石人面像散发着神圣的光芒。诗人从山崖人面像看向欧内斯特，又看回山崖。

突然，诗人挥舞着双手大声呼喊：“看啊！看啊！欧内斯特自己就是巨石人面像的化身！”

人群看去，发现这果然是事实：几十年来对高尚面容的凝视与美德生活，已将欧内斯特塑造为了巨石人面像的化身。''',
  ];
}
