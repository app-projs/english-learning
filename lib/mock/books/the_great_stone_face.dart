import '../../models/article.dart';

class GreatStoneFaceMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'stoneface_u$unitNum',
        bookId: 'book_stoneface',
        unitIndex: unitNum,
        title: titles[index],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Advanced',
        category: '经典名著',
        tags: ['Classic', 'Philosophy', 'Literature'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 11,
        coverUrl: 'assets/images/book_stoneface.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Prophecy of the Valley',
    'Chapter 2: The Childhood of Ernest',
    'Chapter 3: Mr. Gathergold’s Return',
    'Chapter 4: The Fall of False Riches',
    'Chapter 5: Old Blood-and-Thunder',
    'Chapter 6: The Failure of Military Glory',
    'Chapter 7: Old Stony Phiz',
    'Chapter 8: The Eloquent Statesman',
    'Chapter 9: The Sublime Poet',
    'Chapter 10: The Fulfillment of the Great Stone Face',
  ];

  static final List<String> chineseTitles = [
    '山谷中关于巨石人面像的古老预言',
    '欧内斯特的童年与凝望',
    '富豪“聚金先生”的荣耀归来',
    '虚妄财富的幻灭',
    '“铁血老将军”的声浪',
    '军事荣光的虚幻与破灭',
    '“老石脸”政治家的雄辩',
    '崇高诗人的崇拜与寻觅',
    '欧内斯特日复一日的沉思与真诚',
    '预言的终极应验：真正的伟大心灵',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''One afternoon, when the sun was going down, a mother and her little boy sat at the door of their cottage, talking about the Great Stone Face. They had but to lift their eyes, and there it was plainly to be seen, though miles away, with the sunshine gilding all its features.

The Great Stone Face was a work of Nature in her mood of majestic playfulness, formed on the perpendicular side of a mountain by some immense rocks, which had been thrown together in such a manner as, when viewed at a proper distance, precisely to resemble the features of a human countenance.

It had a divine grandeur, a noble benevolence, and a smile so gentle that it seemed to embrace the whole valley.

"Mother," said the little boy, whose name was Ernest, "I wish that the Great Stone Face could speak, for it looks so very kindly that its voice must needs be pleasant. If I were to see a man with such a face, I should love him dearly!"

"If an old prophecy should come to pass," answered his mother, "we may see a man, some time or other, with exactly such a face as that, destined to become the greatest and noblest person of his time."''';
      case 1:
        return '''Ernest never forgot the story his mother told him. It was always in his mind whenever he looked upon the Great Stone Face. He spent his childhood in the quiet valley, assisting his mother in her daily work and attending the village school.

He grew up to be a mild, quiet, and thoughtful youth, educated by no teacher except the mountain face, which poured its silent wisdom into his heart.

As the years rolled on, Ernest grew from a boy into a young man. He attracted no attention from the world, for he was only a simple farmer who tilled his native soil.

Yet there was a quiet dignity about him that made men respect him without knowing why. Every day when his labor was over, he would sit and gaze at the Great Stone Face, learning lessons of patience, duty, and benevolence that no book could ever teach him.''';
      case 2:
        return '''News arrived in the valley that Mr. Gathergold, a native who had left years ago as a poor boy, had become so immensely rich that he bought ships, bank stock, and gold mines. Returning to his native valley in his golden carriage, the people cheered that he was the image of the prophecy.

The carriage rolled down the road, and inside sat an elderly man with yellow skin, wrinkled brow, and small, shrewd eyes that seemed incapable of looking at anything without calculating its money value.

The crowd shouted wildly: "The Great Stone Face is found! The prophecy is fulfilled!"

When Ernest looked upon Mr. Gathergold's wrinkled, yellow, and selfish visage, he shook his head sadly: "No, this is not the face of the prophecy. There is no love or grandeur here."''';
      case 3:
        return '''Time passed, and Mr. Gathergold's vast riches melted away as quickly as they had been acquired. His ships sank at sea, his bank stocks failed, and his gold mines proved worthless.

Before he died, he was as poor as on the day he first left the valley. People realized their mistake, and no one spoke of him as resembling the Great Stone Face any longer.

Ernest, now a mature man in the prime of life, continued his quiet labor in the fields. His face had acquired a noble expression from his lifelong habits of unselfish thought.

Though he still hoped to meet the great person predicted by the prophecy, he began to understand that true nobility is not found in accumulated wealth, but in a soul dedicated to the service of humanity.''';
      case 4:
        return '''Next came a famous general, known as 'Old Blood-and-Thunder,' who had won great battles for his country. The crowd cheered as the general rode through the valley on his white horse, declaring him the true fulfillment of the prophecy.

The townspeople built a great banquet hall and prepared a feast to welcome the military hero. Drums beat, trumpets sounded, and banners waved in the breeze as the old soldier stepped before his admirers.

Ernest stood among the crowd, eager to behold the face he had dreamed of since childhood.

He saw a countenance carved by hard service in war—bold, energetic, and commanding, with eyes that flashed like lightning.

Yet, when Ernest gazed into the commander's stern, battle-worn face, he saw determination and courage, but missed the gentle, universal love that glowed from the mountain face.''';
      case 5:
        return '''Years went by, and Old Blood-and-Thunder retired from public life, his military glory fading like the echoes of his battle trumpets. People recognized that despite his bravery, he was not the gentle and noble figure promised by the old prophecy.

Ernest was now an elderly man, his hair tinged with gray, though his eyes remained bright and clear.

He had become a preacher of sorts, though he held no official office. In the evenings after the sun went down, the inhabitants of the valley would gather around him to listen to his words of wisdom.

His words were simple, yet they possessed a profound power, for they came directly from a pure heart that had spent a lifetime contemplating the divine beauty of the mountain face.''';
      case 6:
        return '''The third candidate for the honor of resembling the Great Stone Face was a renowned statesman, known to his countrymen as 'Old Stony Phiz.' He was a man of extraordinary eloquence, capable of making the wrong appear the right, and moving crowds to tears or fury with a single speech.

When Old Stony Phiz visited the valley, a vast assembly gathered to hear him speak.

Ernest was among the listeners, hoping with all his heart that this brilliant orator might be the long-expected savior of the prophecy.

The statesman rose to speak, and his voice rolled through the valley like thunder. His words were magnificent, his presence commanding.

Yet as Ernest watched his features closely, he perceived that beneath the intellectual power lay a lack of deep spiritual truth. The face lacked the sublime peace of the mountain countenance.''';
      case 7:
        return '''Old Stony Phiz passed away, leaving behind a reputation for brilliant rhetoric but little lasting moral benefit to his country. Once again, the valley was left waiting for the fulfillment of the ancient prophecy.

Ernest was now an old man, with white hair falling over his shoulders and deep lines of thought carved upon his forehead.

He was widely respected throughout the region, not for any worldly achievements, but for his profound goodness and wisdom.

Travelers would come from far away to converse with him, finding in his humble cottage a peace and enlightenment that city palaces could never provide.''';
      case 8:
        return '''A great poet arrived in the valley. He was a native of the region who had spent his life in distant cities, writing verses that thrilled the hearts of readers across the world.

His poems celebrated the beauty of nature, the dignity of human labor, and the sacredness of love.

The poet had heard of Ernest and came to visit him at his humble dwelling. Sitting together at the doorway as the sun began to sink behind the mountains, the poet and the old man conversed on deep and spiritual themes.

The poet listened to Ernest with growing wonder and reverence, realizing that this humble farmer lived the very poetry that he himself had only written about.''';
      case 9:
        return '''As the sun set, Ernest and the poet walked together to the natural amphitheater where the villagers were accustomed to assemble. Ernest stood upon a raised bank of turf and began to address the people.

His words were not mere rhetoric, but thoughts of pure gold, forged in the furnace of a long and righteous life.

The poet sat among the audience, listening intently. Suddenly, his eyes shifted from Ernest's radiant, benevolent face to the Great Stone Face on the mountain side, illuminated by the golden rays of the setting sun.

The resemblance was unmistakable. The same noble forehead, the same compassionate eyes, the same gentle and divine smile.

The poet could contain himself no longer. He stood up and shouted to the crowd:

"Behold! Behold! Ernest himself is the image of the Great Stone Face!"

The crowd looked, and saw that it was true. Yet Ernest, taking the poet's arm, walked home slowly, still hoping that some wiser and better man than himself would one day appear, bearing the likeness of the Great Stone Face.''';
    }
    return '';
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''一天下午，当太阳落山时，一位母亲和她的小男孩坐在小屋门口，谈论着巨石人面像。他们只要抬头一看，就能清楚地看到它，虽然远在数英里之外，但阳光镀金般照亮了它所有的轮廓。

巨石人面像乃是大自然在庄严玩耍的心情下的杰作，它由悬崖峭壁上的几块巨大的岩石组合而成，当在适当的距离观看时，其轮廓精确地酷似一张人类的面孔。

它有一种神圣的庄严，一种高尚的慈爱，以及一种如此温和的微笑，仿佛在拥抱着整个山谷。

“妈妈，”名叫欧内斯特的小男孩说，“我希望巨石人面像能说话，因为它看起来是那么亲切，它的声音一定非常悦耳。如果我能看到一个拥有这样面孔的人，我一定会深深地爱他！”

“如果一个古老预言能够实现的话，”他的母亲回答说，“我们也许在将来的某个时刻，会看到一个拥有完全相同面孔的人，他注定要成为他那个时代最伟大、最高尚的人。”''';
      case 1:
        return '''欧内斯特从未忘记母亲给他讲的故事。每当他凝望巨石人面像时，那个故事总是浮现在他的脑海里。他在宁静的山谷里度过了童年，帮母亲做日常农活，并在村里的学校上学。

他长大成了个温和、安静、深思熟虑的青年，除了那张山石面孔外没有受过其他老师的教育，山石面孔将它无声的智慧注入了他的心田。

随着岁月的流逝，欧内斯特从一个男孩长成了一个青年。他没有引起世界的关注，因为他只是一个耕种本土土地的普通农夫。

然而他身上有一种安静的尊严，使人们在不知不觉中尊重他。每天当他的劳动结束时，他都会坐下来凝视巨石人面像，学习耐心、责任和慈爱的功课，这些是任何书本都无法教会他的。''';
      case 2:
        return '''山谷里传来消息，多年前贫穷离家出走的本乡人“聚金先生”变得极其富有，买下了船只、银行股票和金矿。他乘坐金马车回到家乡的山谷，人们欢呼他是预言中的化身。

马车沿着道路滚滚向前，里面坐着一位黄皮肤、满脸皱纹的老人，他那双精明的小眼睛似乎除了计算金钱价值之外，无法看任何东西。

人群狂热地喊道：“巨石人面像找到了！预言实现了！”

当欧内斯特看着聚金先生那张满是皱纹、发黄且自私的面孔时，他沮丧地摇了摇头：“不，这不是预言中的面孔。这里没有爱，也没有庄严。”''';
      case 3:
        return '''时光流逝，聚金先生的巨额财富就像获得时一样迅速地融化掉了。他的船只沉没在海里，他的银行股票破产了，他的金矿被证明一文不值。

在他去世之前，他变得像第一次离开山谷时一样贫穷。人们意识到了自己的错误，不再有人说他像巨石人面像了。

欧内斯特现在是一个处于盛年的成熟男子，继续在田间进行安静的劳动。由于他终生无私思考的习惯，他的脸庞呈现出高尚的表情。

尽管他仍然希望能见到预言所预示的伟大人物，但他开始明白，真正的尊贵并不存在于积累的财富中，而是存在于奉献给人类服务的心灵中。''';
      case 4:
        return '''接下来是一位著名的将军，被称为“铁血老将军”，他为国家赢得了伟大的战役。当将军骑着白马穿过山谷时，人群欢呼，宣称他是预言的真正实现。

镇上的人们建造了一个宏伟的宴会厅，准备了盛宴来欢迎这位军事英雄。鼓声敲响，小号吹响，旗帜在微风中飘扬，老兵走到了他的崇拜者面前。

欧内斯特站在人群中，急切地想看到他从小梦寐以求的面孔。

他看到了一张在战争的艰苦岁月中雕刻出来的面孔——大胆、充沛、威严，眼睛闪烁着闪电般的光芒。

然而，当欧内斯特凝视这位指挥官严厉、饱经沧桑的面孔时，他看到了决心和勇气，却错过了从山石面孔上熠熠生辉的温和、博大的爱。''';
      case 5:
        return '''许多年过去了，铁血老将军退出了公众生活，他的军事荣光就像他战场小号的回声一样消逝了。人们意识到，尽管他勇敢，但他并不是古老预言所许诺的那位温和高尚的人物。

欧内斯特现在是一位老人了，他的头发染上了灰色，尽管他的眼睛依然明亮清澈。

他成了某种意义上的传道者，尽管他没有担任任何官方职位。太阳落山后的傍晚，山谷里的居民会聚集在他周围，聆听他的智慧之言。

他的话语简单，却拥有深刻的力量，因为它们直接来自于一颗纯洁的心，这颗心花了一生的时间来凝视山石面孔的神圣之美。''';
      case 6:
        return '''获得酷似巨石人面像荣誉的第三位候选人是一位著名的政治家，被他的同胞称为“老石脸”。他是一位拥有非凡雄辩能力的人，能够颠倒黑白，用一次演讲就动员人群流泪或发怒。

当老石脸拜访山谷时，一大群人聚集在一起听他演讲。

欧内斯特也是听众之一，全心全意地希望这位出色的演说家可能是预言中期待已久的拯救者。

政治家站起来发言，他的声音像雷声一样在山谷中回荡。他的话语宏伟，他的仪态威严。

然而，当欧内斯特仔细观察他的轮廓时，他觉察到在智力力量的背后缺乏深刻的精神真理。这张脸缺乏山石面孔的崇高平静。''';
      case 7:
        return '''老石脸去世了，留下了出色的修辞名声，但给他的国家带来的持久道德益处却微乎其微。山谷再次被留下来等待古老预言的实现。

欧内斯特现在是个老人了，白发垂在肩膀上，额头上雕刻着深刻的思想线条。

他在整个地区广受尊重，不是因为任何世俗的成就，而是因为他深刻的善良和智慧。

旅行者会从远方赶来与他交谈，在他谦逊的小屋里找到城市宫殿永远无法提供的平静和启迪。''';
      case 8:
        return '''一位伟大的诗人来到了山谷。他是该地区的本乡人，在远方的城市里度过了一生，写出了令全世界读者心灵震撼的诗句。

他的诗歌赞美自然之美、人类劳动的尊严和爱的神圣。

诗人听说了欧内斯特，来到他谦逊的住所拜访他。当太阳开始沉入山后时，他们一起坐在门口，就深刻而精神的主题进行交谈。

诗人带着越来越大的惊奇和敬畏聆听欧内斯特，意识到这位谦逊的农夫生活在他自己只是写过的诗歌之中。''';
      case 9:
        return '''太阳落山时，欧内斯特和诗人一起走向村民们习惯聚集的自然露天剧场。欧内斯特站在高起的草皮岸上，开始向人们演讲。

他的话语不是纯粹的修辞，而是纯金的思想，在长久而正义的生活炉火中锤炼而成。

诗人坐在听众席中，专心致志地听着。突然，他的眼睛从欧内斯特容光焕发、慈祥的面孔转向了落日金辉照亮的山壁上的巨石人面像。

这种相似是毋庸置疑的。同样高尚的额头，同样富有同情心的眼睛，同样温和而神圣的微笑。

诗人再也忍不住了。他站起来朝人群喊道：

“看啊！看啊！欧内斯特自己就是巨石人面像的化身！”

人群看过去，发现果然如此。然而欧内斯特挽着诗人的手臂，缓缓走回家中，依然希望有某个比自己更睿智、更好的人有一天会出现，长得像巨石人面像一样。''';
    }
    return '';
  }
}
