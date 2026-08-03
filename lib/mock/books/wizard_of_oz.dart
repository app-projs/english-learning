import '../../models/article.dart';

class WizardOfOzMock {
  static List<Article> getChapters() {
    final now = DateTime.now();
    return List.generate(24, (index) {
      final unitNum = index + 1;
      return Article(
        id: 'oz_u$unitNum',
        bookId: 'book_oz',
        unitIndex: unitNum,
        title: titles[index % titles.length],
        chineseTitle: '第 $unitNum 章：${chineseTitles[index % chineseTitles.length]}',
        content: _getContent(index),
        chineseContent: _getChineseContent(index),
        difficulty: 'Easy',
        category: '经典名著',
        tags: ['Classic', 'Fairy Tale', 'Adventure'],
        createdAt: now.subtract(Duration(days: index)),
        readTime: 9,
        coverUrl: 'assets/images/book_oz.png',
      );
    });
  }

  static final List<String> titles = [
    'Chapter 1: The Cyclone',
    'Chapter 2: The Council with the Munchkins',
    'Chapter 3: How Dorothy Saved the Scarecrow',
    'Chapter 4: The Road Through the Forest',
    'Chapter 5: The Rescue of the Tin Woodman',
    'Chapter 6: The Cowardly Lion',
    'Chapter 7: The Journey to the Great Oz',
    'Chapter 8: The Deadly Poppy Field',
    'Chapter 9: The Queen of the Field Mice',
    'Chapter 10: The Guardian of the Gate',
    'Chapter 11: The Wonderful Emerald City of Oz',
    'Chapter 12: The Search for the Wicked Witch',
    'Chapter 13: The Rescue',
    'Chapter 14: The Winged Monkeys',
    'Chapter 15: The Discovery of Oz the Terrible',
    'Chapter 16: The Magic Art of the Great Humbug',
    'Chapter 17: How the Balloon Was Launched',
    'Chapter 18: Away to the South',
    'Chapter 19: Attacked by the Fighting Trees',
    'Chapter 20: The Dainty China Country',
    'Chapter 21: The Lion Becomes the King of Beasts',
    'Chapter 22: The Country of the Quadlings',
    'Chapter 23: Glinda The Good Witch Grants Dorothy’s Wish',
    'Chapter 24: Home Again',
  ];

  static final List<String> chineseTitles = [
    '大龙卷风来袭',
    '与芒奇金人的集会',
    '多萝茜救出稻草人',
    '穿过森林的黄砖路',
    '解救铁皮木头人',
    '胆小的狮子现身',
    '前往伟大的奥兹国之旅',
    '致命的罂粟花海',
    '田鼠女王的感激与报答',
    '翡翠城城门的守护者',
    '神奇伟大的奥兹翡翠城',
    '寻觅西方恶魔女巫',
    '营救伙伴大作战',
    '飞猴的魔力与召唤',
    '揭穿可怕的奥兹真面目',
    '大骗子的神奇魔法术',
    '热气球是如何发射的',
    '向南方启程进发',
    '遭遇战斗树的袭击',
    '精致优雅的瓷器国',
    '狮子成为百兽之王',
    '奎德林人的领地',
    '好女巫格林达实现许愿',
    '重返温馨家园',
  ];

  static String _getContent(int index) {
    switch (index) {
      case 0:
        return '''Dorothy lived in the midst of the great Kansas prairies, with Uncle Henry, who was a farmer, and Aunt Em, who was the farmer's wife. Their house was small, for the lumber to build it had to be carried by wagon many miles. There were four walls, a floor and a roof, which made one room; and this room contained a rusty looking cookstove, a cupboard for the dishes, a table, three or four chairs, and the beds.

Uncle Henry and Aunt Em had a big bed in one corner, and Dorothy a little bed in another corner. There was no garret at all, and no cellar—except a small hole dug in the ground, called a cyclone cellar, where the family could go in case one of those great whirlpools of air arose, mighty enough to crush any building in its path.

When Dorothy stood in the doorway and looked around, she could see nothing but the great gray prairie on every side. Not a tree nor a house broke the broad sweep of flat country that reached to the edge of the sky in all directions.

Suddenly Uncle Henry stood up from the doorstep.

"There's a cyclone coming, Em," he called to his wife. "I'll go look after the stock."

The wind gave a low wail, and Uncle Henry ran toward the sheds where the cows and horses were kept.''';
      case 1:
        return '''The cyclone set the house down very gently—for a cyclone—in the midst of a country of marvelous beauty. There were lovely patches of greensward all about, with stately trees bearing rich and luscious fruits. Banks of gorgeous flowers blossomed on every hand, and birds with rare and brilliant plumage sang and fluttered in the trees and bushes.

While Dorothy stood looking eagerly at the strange and beautiful sights, she noticed coming toward her a group of the queerest people she had ever seen.

They were not as tall as the grown people she had always been used to, but neither were they very small. In fact, they seemed about as tall as Dorothy, who was a well-grown child for her age, although they were, so far as looks go, many years older.

There were three men and one woman, and all were oddly dressed. They wore round hats that rose to a point a foot above their heads, with little bells around the brims that tinkled sweetly as they moved.

The little woman walked up to Dorothy, made a low bow and said, in a sweet voice:

"You are welcome, most noble Sorceress, to the land of the Munchkins. We are so grateful to you for having killed the Wicked Witch of the East, and for setting our people free from bondage."''';
      default:
        final chapterNum = index + 1;
        return '''This is Chapter $chapterNum of L. Frank Baum's beloved American fairy tale, The Wonderful Wizard of Oz.

Dorothy, along with her loyal companions—the Scarecrow who sought a brain, the Tin Woodman who longed for a heart, and the Cowardly Lion who desired courage—traveled down the Yellow Brick Road toward the Emerald City.

Through every obstacle, from deadly poppy fields to fierce beasts, each companion demonstrated that they already possessed the very qualities they sought.

"No matter how dreary and gray our homes may be, we people of flesh and blood would rather live there than in any other country, be it ever so beautiful," Dorothy reflected. "There is no place like home!"''';
    }
  }

  static String _getChineseContent(int index) {
    switch (index) {
      case 0:
        return '''多萝茜住在堪萨斯州大草原的中央，和她的叔叔亨利（一个农夫）以及艾姆婶婶（农夫的妻子）住在一起。他们的房子很小，因为建造房屋的木材必须用马车运送数英里。房子有四面墙、一个地板和一个屋顶，构成了唯一的一间房间；这间房间里有一台看起来生锈的炊具、一个放碗碟的橱柜、一张桌子、三四张椅子和床。

亨利叔叔和艾姆婶婶在一个角落里有一张大床，多萝茜在另一个角落里有一张小床。根本没有阁楼，也没有地下室——除了在地上挖的一个小洞，叫做防风洞，如果刮起巨大的空气旋风，其威力足以粉碎路径上的任何建筑物，全家人就可以躲进去。

当多萝茜站在门口环顾四周时，她除了四面八方灰色的大草原之外什么也看不见。在四面八方直达天际的广阔平坦乡村里，没有一棵树也没有一栋房子打破这种单调。

突然亨利叔叔从门槛上站了起来。

“龙卷风来了，艾姆，”他向妻子喊道。“我去照顾牲口。”

风发出低沉的哀鸣，亨利叔叔向关着牛马的棚子跑去。''';
      case 1:
        return '''龙卷风把房子非常温柔地——对于龙卷风来说——降落在一片景色奇丽的国土中央。到处都是可爱的绿草地，挺拔的树上挂满了丰盛多汁的水果。手边盛开着一丛丛华丽的花朵，羽毛罕见绚丽的鸟儿在树木和灌木丛中歌唱飞翔。

当多萝茜站在那里急切地看着这奇异而美丽的景色时，她注意到有一群她见过的最古怪的人朝她走来。

他们不像她平时习惯看到的成年人那么高大，但也不算很矮小。事实上，他们看起来和多萝茜差不多高，多萝茜在她这个年龄算是一个发育良好的孩子，尽管就长相而言，他们要年长许多岁。

有三个男人和一个女人，全都穿戴得古奇怪异。他们戴着圆顶帽，帽子在头顶上方一英尺处升成一个尖顶，帽檐周围挂着小铃铛，走动时发出甜美的叮当声。

那个小妇人走到多萝茜面前，深深地躬了躬身，用甜美的声音说：

“欢迎你，最高尚的女巫，来到芒奇金人的土地。我们非常感激你杀死了东方的恶魔女巫，把我们的人民从奴役中解放出来。”''';
      default:
        final chapterNum = index + 1;
        return '''这是弗兰克·鲍姆备受喜爱的经典童话名著《绿野仙踪》的第 $chapterNum 章。

多萝茜与她忠诚的伙伴们——渴望拥有大脑的稻草人、渴望拥有一颗心的铁皮木头人，以及渴望拥有勇气的胆小狮子——沿着黄砖路向翡翠城进发。

穿过从致命的罂粟花海到凶猛野兽的每一个障碍，每一个伙伴都证明了他们其实早已拥有了自己所寻求的高尚品质。

“无论我们的家多么沉闷和灰色，我们这些血肉之躯宁愿住在那里，也不愿住在其他任何国家，哪怕那里再美丽，”多萝茜感慨道。“金窝银窝不如自己的狗窝！”''';
    }
  }
}
