import '../models/book.dart';
import '../models/article.dart';
import 'books/anne_of_green_gables.dart';
import 'books/the_little_prince.dart';
import 'books/alices_adventures.dart';
import 'books/wizard_of_oz.dart';
import 'books/treasure_island.dart';
import 'books/the_old_man_and_the_sea.dart';
import 'books/great_gatsby.dart';
import 'books/sherlock_holmes.dart';
import 'books/pride_and_prejudice.dart';
import 'books/tale_of_two_cities.dart';
import 'books/jane_eyre.dart';
import 'books/beauty_and_the_beast.dart';
import 'books/arabian_nights.dart';
import 'books/the_great_stone_face.dart';

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
        totalUnits: 38,
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
        totalUnits: 27,
        wordCount: 9800,
        readerCount: '191万人在读',
        targetVocab: '1000-3500词',
        tagLabel: '童话故事',
        coverBadge: '精读 · 经典名著',
      ),
      Book(
        id: 'book_alice',
        title: 'Alice’s Adventures in Wonderland',
        chineseTitle: '爱丽丝梦游仙境（名著原著全本拆解）',
        author: 'Lewis Carroll',
        coverUrl: 'assets/images/book_alice.png',
        description: '荒诞文学天花板，充满奇幻想象与英式幽默',
        category: '经典名著',
        difficulty: '初/中级难度',
        totalUnits: 12,
        wordCount: 10500,
        readerCount: '156.2万人在读',
        targetVocab: '1200-3500词',
        tagLabel: '奇幻童话',
        coverBadge: '经典 · 奇幻童话',
      ),
      Book(
        id: 'book_oz',
        title: 'The Wonderful Wizard of Oz',
        chineseTitle: '绿野仙踪（名著原著全本拆解）',
        author: 'L. Frank Baum',
        coverUrl: 'assets/images/book_oz.png',
        description: '经典奇幻童话冒险，寻找智慧、爱与勇气的史诗',
        category: '经典名著',
        difficulty: '初/中级难度',
        totalUnits: 24,
        wordCount: 14500,
        readerCount: '86.4万人在读',
        targetVocab: '1000-3000词',
        tagLabel: '奇幻冒险',
        coverBadge: '入门 · 经典童话',
      ),
      Book(
        id: 'book_treasure',
        title: 'Treasure Island',
        chineseTitle: '金银岛（名著原著全本拆解）',
        author: 'Robert Louis Stevenson',
        coverUrl: 'assets/images/book_treasure.png',
        description: '海盗冒险鼻祖，公海寻宝与机智对决',
        category: '经典名著',
        difficulty: '中级难度',
        totalUnits: 34,
        wordCount: 21000,
        readerCount: '112.3万人在读',
        targetVocab: '2000-4500词',
        tagLabel: '冒险小说',
        coverBadge: '精选 · 航海冒险',
      ),
      Book(
        id: 'book_sea',
        title: 'The Old Man and the Sea',
        chineseTitle: '老人与海（名著原著全本拆解）',
        author: 'Ernest Hemingway',
        coverUrl: 'assets/images/book_sea.png',
        description: '诺贝尔文学奖巨著，硬汉老人的勇气、尊严与永不服输',
        category: '经典名著',
        difficulty: '四/六级难度',
        totalUnits: 12,
        wordCount: 12800,
        readerCount: '245.6万人在读',
        targetVocab: '2000-4500词',
        tagLabel: '文学巨著',
        coverBadge: '必读 · 诺奖名著',
      ),
      Book(
        id: 'book_gatsby',
        title: 'The Great Gatsby',
        chineseTitle: '了不起的盖茨比（名著原著全本拆解）',
        author: 'F. Scott Fitzgerald',
        coverUrl: 'assets/images/book_gatsby.png',
        description: '爵士时代的华丽诗篇，极具美感与韵律的英文警世名篇',
        category: '经典名著',
        difficulty: '六级/考研难度',
        totalUnits: 9,
        wordCount: 16500,
        readerCount: '210.8万人在读',
        targetVocab: '3500-6500词',
        tagLabel: '爵士时代',
        coverBadge: '高阶 · 文学名著',
      ),
      Book(
        id: 'book_sherlock',
        title: 'The Adventures of Sherlock Holmes',
        chineseTitle: '福尔摩斯探案集（名著原著全本拆解）',
        author: 'Arthur Conan Doyle',
        coverUrl: 'assets/images/book_sherlock.png',
        description: '维多利亚时代悬疑侦探巅峰，极富逻辑与演义推理美感',
        category: '经典名著',
        difficulty: '六级/考研难度',
        totalUnits: 12,
        wordCount: 18500,
        readerCount: '178.2万人在读',
        targetVocab: '3500-6500词',
        tagLabel: '侦探悬疑',
        coverBadge: '精选 · 推理名著',
      ),
      Book(
        id: 'book_pride',
        title: 'Pride and Prejudice',
        chineseTitle: '傲慢与偏见（名著原著全本拆解）',
        author: 'Jane Austen',
        coverUrl: 'assets/images/book_pride.png',
        description: '简·奥斯汀浪漫文学天花板，优雅语言与人性心理的极致演绎',
        category: '经典名著',
        difficulty: '六级/考研难度',
        totalUnits: 61,
        wordCount: 32000,
        readerCount: '310.5万人在读',
        targetVocab: '4000-7000词',
        tagLabel: '浪漫小说',
        coverBadge: '典藏 · 爱情名著',
      ),
      Book(
        id: 'book_twocities',
        title: 'A Tale of Two Cities',
        chineseTitle: '双城记（名著原著全本拆解）',
        author: 'Charles Dickens',
        coverUrl: 'assets/images/book_twocities.png',
        description: '狄更斯史诗级名作，“这是最好的时代，也是最坏的时代”',
        category: '经典名著',
        difficulty: '考研/雅思托福',
        totalUnits: 45,
        wordCount: 35000,
        readerCount: '142.0万人在读',
        targetVocab: '4500-8000词',
        tagLabel: '历史巨著',
        coverBadge: '高阶 · 狄更斯名著',
      ),
      Book(
        id: 'book_jane',
        title: 'Jane Eyre',
        chineseTitle: '简·爱（名著原著全本拆解）',
        author: 'Charlotte Brontë',
        coverUrl: 'assets/images/book_jane.png',
        description: '独立女性与尊严的赞歌，永恒的灵魂对话名作',
        category: '经典名著',
        difficulty: '六级/考研难度',
        totalUnits: 38,
        wordCount: 29000,
        readerCount: '289.4万人在读',
        targetVocab: '4000-7500词',
        tagLabel: '女性成长',
        coverBadge: '必读 · 经典名著',
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

  static List<Article> getAnneChapters() => AnneOfGreenGablesMock.getChapters();
  static List<Article> getPrinceChapters() => LittlePrinceMock.getChapters();
  static List<Article> getAliceChapters() => AliceAdventuresMock.getChapters();
  static List<Article> getOzChapters() => WizardOfOzMock.getChapters();
  static List<Article> getTreasureChapters() => TreasureIslandMock.getChapters();
  static List<Article> getSeaChapters() => OldManAndSeaMock.getChapters();
  static List<Article> getGatsbyChapters() => GreatGatsbyMock.getChapters();
  static List<Article> getSherlockChapters() => SherlockHolmesMock.getChapters();
  static List<Article> getPrideChapters() => PrideAndPrejudiceMock.getChapters();
  static List<Article> getTwoCitiesChapters() => TaleOfTwoCitiesMock.getChapters();
  static List<Article> getJaneChapters() => JaneEyreMock.getChapters();
  static List<Article> getBeautyChapters() => BeautyAndBeastMock.getChapters();
  static List<Article> getNightsChapters() => ArabianNightsMock.getChapters();
  static List<Article> getStoneFaceChapters() => GreatStoneFaceMock.getChapters();
}
