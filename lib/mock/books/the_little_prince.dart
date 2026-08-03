import '../../models/article.dart';

class LittlePrinceMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(27, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'prince_u$unitNum',
        bookId: 'book_prince',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Intermediate',
        category: '经典名著',
        tags: ['Classic', 'Philosophy', 'Fairy Tale'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 8,
        coverUrl: 'assets/images/book_prince.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Boa Constrictor',
    'Chapter 2: In the Sahara Desert',
    'Chapter 3: The Little Prince’s Planet',
    'Chapter 4: The Discovery of Asteroid B-612',
    'Chapter 5: The Baobab Trees',
    'Chapter 6: The Sunsets',
    'Chapter 7: The Secret of the Flowers',
    'Chapter 8: The Rose Arrives',
    'Chapter 9: The Flight from the Planet',
    'Chapter 10: The King’s Realm',
    'Chapter 11: The Conceited Man',
    'Chapter 12: The Tipper',
    'Chapter 13: The Businessman',
    'Chapter 14: The Lamplighter',
    'Chapter 15: The Geographer',
    'Chapter 16: The Earth',
    'Chapter 17: The Snake in the Desert',
    'Chapter 18: The Flower in the Desert',
    'Chapter 19: High Mountains',
    'Chapter 20: The Garden of Roses',
    'Chapter 21: Taming the Fox',
    'Chapter 22: The Railway Switchman',
    'Chapter 23: The Pill Merchant',
    'Chapter 24: Searching for a Well',
    'Chapter 25: The Water of Life',
    'Chapter 26: The Little Prince’s Departure',
    'Chapter 27: Six Years Later',
  ];

  static final List<String> chineseTitles = [
    '吞象的巨蟒画作',
    '撒哈拉沙漠的相遇',
    '小王子的神秘星球',
    '发现 B-612 小行星',
    '可怕的猴面包树',
    '四十四次日落',
    '花朵与刺的秘密',
    '骄傲优雅的玫瑰花',
    '离开小行星的飞行',
    '统治一切的专制国王',
    '爱慕虚荣的奇怪男人',
    '借酒浇愁的酒鬼',
    '数星星的实业家',
    '忠诚辛劳的点灯人',
    '足不出户的地理学家',
    '降落地球',
    '沙漠里的金黄毒蛇',
    '三瓣花的问候',
    '高山上的回音',
    '盛开五千朵玫瑰的花园',
    '驯服狐狸的真谛',
    '扳道工与列车',
    '卖止渴药丸的商人',
    '沙漠求水与水井',
    '如音乐般清甜的井水',
    '告别与回归星球',
    '六年后的怀念',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Once when I was six years old I saw a magnificent picture in a book, called True Stories from Nature, about the primeval forest. It was a picture of a boa constrictor in the act of swallowing an animal. Here is a copy of the drawing.

In the book it said: "Boa constrictors swallow their prey whole, without chewing it. After that they are not able to move, and they sleep through the six months that they need for digestion."

I pondered deeply, then, over the adventures of the jungle. And after some work with a colored pencil I succeeded in making my first drawing. My Drawing Number One. It looked something like this:

I showed my masterpiece to the grown-ups, and asked them whether the drawing frightened them.

But they answered: "Frightened? Why should any one be frightened by a hat?"

My drawing was not a picture of a hat. It was a picture of a boa constrictor digesting an elephant. But since the grown-ups were not able to understand it, I made another drawing: I drew the inside of a boa constrictor, so that the grown-ups could see it clearly. They always need to have things explained. My Drawing Number Two looked like this:

The grown-ups' response, this time, was to advise me to lay aside my drawings of boa constrictors, whether from the inside or the outside, and devote myself instead to geography, history, arithmetic, and grammar. That is why, at the age of six, I gave up what might have been a magnificent career as a painter. I had been disheartened by the failure of my Drawing Number One and my Drawing Number Two. Grown-ups never understand anything by themselves, and it is tiresome for children to be always and forever explaining things to them.''';
      case 1:
        return '''So I lived my life alone, without anyone that I could really talk to, until I had an accident with my plane in the Desert of Sahara, six years ago. Something was broken in my engine. And as I had with me neither a mechanic nor any passengers, I set myself to attempt the difficult repair job, all alone. It was a question of life or death for me: I had scarcely enough drinking water to last a week.

The first night, then, I went to sleep on the sand, a thousand miles from any inhabited territory. I was more isolated than a shipwrecked sailor on a raft in the middle of the ocean. Thus you can imagine my amazement, at sunrise, when I was awakened by an odd little voice. It said:

"If you please—draw me a sheep!"

"What!"

"Draw me a sheep..."

I jumped to my feet, completely thunderstruck. I blinked my eyes hard. I looked carefully all around me. And I saw a most extraordinary small person, who stood there examining me with great seriousness. Here you may see the best portrait that, later on, I was able to make of him.

Now I stared at this sudden apparition with my eyes starting out of my head in astonishment. Remember, I had crashed in the desert a thousand miles from any inhabited region. And yet my little man did not seem to be straying in the desert, nor dying of fatigue, of hunger, of thirst, or of fear. He did not give the impression of a child lost in the middle of the desert, a thousand miles from any human habitation.

When at last I was able to speak, I said to him: "But—what are you doing here?"

And in answer he repeated, very slowly, as if he were speaking of a matter of great consequence: "If you please—draw me a sheep..."''';
      case 2:
        return '''It took me a long time to learn where he came from. The little prince, who asked me so many questions, never seemed to hear the ones I asked him. It was from words dropped by chance that, little by little, everything was revealed to me.

The first time he caught sight of my airplane, for instance (I shall not draw my airplane; that would be much too complicated for me), he asked:

"What is that object?"

"That is not an object. It flies. It is an airplane. It is my airplane."

And I was proud to have him learn that I could fly. He cried out then:

"What! You dropped down from the sky?"

"Yes," I answered modestly.

"Oh! That is funny!"

And the little prince broke into a lovely peal of laughter, which irritated me. I like my misfortunes to be taken seriously. Then he added:

"So you, too, come from the sky! Which is your planet?"

At that moment I caught a gleam of light in the mystery of his presence, and I demanded abruptly: "Do you come from another planet, then?"

But he did not answer. He tossed his head gently, without taking his eyes from my plane: "It is true that on that thing you couldn't have come from very far away..." And he sank into a reverie, which lasted a long time. Then, taking my sheep out of his pocket, he buried himself in the contemplation of his treasure.''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of Saint-Exupéry's classic, The Little Prince.

The little prince continued his journey across the cosmos, exploring the nature of human relationships, love, and responsibility. As he encountered various inhabitants across different asteroids—from kings and conceited men to geographers and foxes—he realized that what makes things truly essential is invisible to the eye.

"It is only with the heart that one can see rightly; what is essential is invisible to the eye," the fox told the little prince.

Throughout this chapter, the narrative uncovers deep philosophical insights about friendship, devotion, and the beauty of caring for those we love. The prince remembered his rose back on Asteroid B-612, understanding that the time he had wasted for his rose made his rose so important.''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''在我六岁的时候，在一本描写原始森林的名叫《真实的故事》的书中，看到过一副精彩的插图。那是一幅巨蟒正在吞食野兽的图画。这是那幅画的复刻版。

书中写道：“巨蟒把猎物整个吞进肚子里，咀嚼都不咀嚼。然后它们就不能动弹了，要在长达六个月的睡眠中消化食物。”

当时，我对丛林里的冒险思想了很久。于是，我用彩色铅笔成功画出了我的第一幅画。我的第一号作品。它看起来像这样：

我把我的杰作拿给大人看，问他们我的画是不是吓着他们了。

可他们回答说：“吓人？一顶帽子有什么好吓人的？”

我的画画的不是一顶帽子。那是一条巨蟒在消化一只大象。但是大人们看不懂，所以我又画了另一幅：我画了巨蟒肚子里面的情形，好让大人能看得清清楚楚。他们总是需要解释。我的第二号作品是这样的：

大人们对这幅画的反应是，劝我把巨蟒的画——无论是外面的还是里面的——放在一边，把精力投到地理、历史、算术和语法上去。就这样，在六岁那年，我放弃了本可以成为伟大画家的光辉前途。我的第一号作品和第二号作品的失败让我灰了心。大人们自己什么也弄不懂，单要孩子们一遍又一遍地给他们作解释，真是太累人了。''';
      case 1:
        return '''就这样，我独自一人生活着，没有一个真正谈得来的人，直到六年前我的飞机在撒哈拉沙漠出了故障。我的发动机里有什么东西给卡住了。因为我既没带机械师，也没带乘客，我便一个人干起了这项艰难的维修工作。这对我来说是生死攸关的事：我带的饮用水只够维持一个星期的。

第一天晚上，我在离有人烟的地方一千英里的沙漠上睡着了。我比在茫茫大海中依靠木筏漂流的落难水手还要孤立无援。因此，当太阳升起时，我被一个奇异的小声音唤醒，你可以想象我是多么惊讶了。那个声音说：

“请……给我画一只羊吧！”

“什么！”

“给我画一只羊……”

我一跃而起，像被雷劈了一样。我用力眨了眨眼睛。仔细地看了看周围。我看到一个非常非凡的小人儿，站在那里非常严肃地审视着我。这里就是我后来能够为他画出的最好的一副肖像。

此时，我张大眼睛惊讶地看着这个突然显现的小人。别忘了，我当时正身处远离人烟千里的沙漠之中。可这个小家伙看起来既不像是在沙漠中迷了路，也不像是因为疲倦、饥饿、口渴或害怕而要死去的样子。他一点也不像一个在远离人烟千里的沙漠中央迷路的小孩。

当我看终于能说出话来时，我对他说：“可是……你在干什么呢？”

作为回答，他非常缓慢地重复着，仿佛在说一件非常重大的事情：“请……给我画一只羊……”''';
      case 2:
        return '''我很长时间才明白他是从哪里来的。小王子问了我许多问题，却好像从来听不见我问他的问题。我是从他无意中吐露的字眼里，才一点一点了解了一切。

比如，当他第一次看到我的飞机时（我不画我的飞机，那对我来说太复杂了），他问：

“那是个什么东西？”

“那不是个东西。它会飞。那是一架飞机。是我的飞机。”

我很自豪地让他知道我会飞。这时他大声叫道：

“什么！你是从天上掉下来的？”

“是的，”我谦虚地回答。

“啊！这真滑稽！”

小王子发出一阵清脆愉悦的笑声，这让我有点恼火。我希望别人严肃对待我的不幸。接着他又补充道：

“这么说，你也是从天上来的！你是哪颗星球上的？”

那一刻，我在他降临的谜团中捕捉到了一缕微光，我突然问道：“那么，你是从另一颗星球上来的吗？”

但他没有回答。他轻轻地摇了摇头，眼睛没有离开我的飞机：“确实，坐着这玩意儿，你不可能从很远的地方来……”接着他就陷入了长久的沉思。然后，他从口袋里掏出我画的羊，沉浸在对自己宝贝的凝视中。''';
      default:
        final chapterNum = index + 1;
        return '''这是圣埃克苏佩里名著《小王子》的第 $chapterNum 章。

小王子继续他在宇宙中的旅程，探索人际关系、爱与责任的本质。当他在不同的外行星遇到各种各样的居民——从国王、爱慕虚荣的人，到地理学家和狐狸——他渐渐领悟到，真正重要的东西是眼睛看不见的。

“只有用心才能看得清。实质性的东西，用眼睛是看不见的，”狐狸对小王子说。

在这一章里，故事展现了关于友情、奉献以及关爱我们所爱之人的深刻哲理。小王子想起了他在 B-612 星球上的那朵玫瑰，明白了正是他在玫瑰身上倾注的时间，才使他的玫瑰变得如此重要。''';
    }
  }
}
