import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  DatabaseService._();

  static Future<DatabaseService> getInstance() async {
    _instance ??= DatabaseService._();
    _database ??= await _initDatabase();
    return _instance!;
  }

  static Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'english_learning.db');

    final db = await openDatabase(
      path,
      version: 23,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    try {
      await db.execute('PRAGMA journal_mode = WAL;');
      await db.execute('PRAGMA synchronous = NORMAL;');
    } catch (_) {}

    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id TEXT PRIMARY KEY,
        english TEXT NOT NULL,
        chinese TEXT NOT NULL,
        phonetic TEXT,
        synonyms TEXT,
        antonyms TEXT,
        exampleSentence TEXT,
        masteryLevel INTEGER DEFAULT 0,
        isFavorite INTEGER DEFAULT 0,
        createdAt TEXT,
        definitions TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sentences (
        id TEXT PRIMARY KEY,
        english TEXT NOT NULL,
        chinese TEXT NOT NULL,
        keyWords TEXT,
        difficulty TEXT,
        category TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE dialogues (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        context TEXT,
        difficulty TEXT,
        lines TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        chineseTitle TEXT,
        author TEXT,
        coverUrl TEXT,
        description TEXT,
        category TEXT,
        difficulty TEXT,
        totalUnits INTEGER DEFAULT 12,
        wordCount INTEGER DEFAULT 10000,
        readerCount TEXT,
        targetVocab TEXT,
        tagLabel TEXT,
        coverBadge TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE articles (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        translation TEXT,
        difficulty TEXT,
        category TEXT,
        tags TEXT,
        readTime INTEGER DEFAULT 5,
        createdAt TEXT,
        bookId TEXT,
        unitIndex INTEGER,
        coverUrl TEXT,
        chineseTitle TEXT,
        chineseContent TEXT,
        isRead INTEGER DEFAULT 0,
        paragraphs TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        count INTEGER DEFAULT 0,
        lastUpdated TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        unlocked INTEGER DEFAULT 0,
        unlockedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        articleId TEXT NOT NULL,
        readAt TEXT,
        readMinutes INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE phonetics (
        id TEXT PRIMARY KEY,
        symbol TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        tips TEXT,
        examples TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE word_roots (
        id TEXT PRIMARY KEY,
        root TEXT NOT NULL,
        type TEXT NOT NULL,
        origin TEXT,
        meaning TEXT,
        explanation TEXT,
        derivedWords TEXT
      )
    ''');

    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_articles_bookId ON articles(bookId);');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_articles_category ON articles(category);');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_books_category ON books(category);');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_phonetics_type ON phonetics(type);');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_word_roots_type ON word_roots(type);');

    // 签到记录表 (Version 13)
    await db.execute('''
      CREATE TABLE checkin_records (
        date TEXT PRIMARY KEY,
        completed INTEGER DEFAULT 1,
        lpEarned INTEGER DEFAULT 0,
        createdAt TEXT
      )
    ''');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_checkin_date ON checkin_records(date);');

    // 离线字典表 (Version 14)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dictionary (
        id TEXT PRIMARY KEY,
        word TEXT UNIQUE NOT NULL,
        phonetic TEXT,
        chinese TEXT NOT NULL,
        pos TEXT,
        example TEXT,
        example_translation TEXT,
        source TEXT,
        updated_at INTEGER
      )
    ''');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_dictionary_word ON dictionary(word);');

    // AI 对话历史记录表 (Version 15)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ai_chat_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scenario_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        message TEXT NOT NULL,
        translation TEXT,
        grammar_score INTEGER,
        corrections TEXT,
        native_suggestion TEXT,
        created_at INTEGER
      )
    ''');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_ai_chat_scenario ON ai_chat_history(scenario_id);');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS content_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 12) {
      await db.execute('DROP TABLE IF EXISTS words');
      await db.execute('DROP TABLE IF EXISTS sentences');
      await db.execute('DROP TABLE IF EXISTS dialogues');
      await db.execute('DROP TABLE IF EXISTS books');
      await db.execute('DROP TABLE IF EXISTS articles');
      await db.execute('DROP TABLE IF EXISTS user_progress');
      await db.execute('DROP TABLE IF EXISTS achievements');
      await db.execute('DROP TABLE IF EXISTS reading_history');
      await db.execute('DROP TABLE IF EXISTS phonetics');
      await db.execute('DROP TABLE IF EXISTS word_roots');
      await _onCreate(db, newVersion);
    }
    // Version 13: 新增签到记录表
    if (oldVersion < 13) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS checkin_records (
          date TEXT PRIMARY KEY,
          completed INTEGER DEFAULT 1,
          lpEarned INTEGER DEFAULT 0,
          createdAt TEXT
        )
      ''');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_checkin_date ON checkin_records(date);');
    }
    // Version 14: 新增离线字典表
    if (oldVersion < 14) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS dictionary (
          id TEXT PRIMARY KEY,
          word TEXT UNIQUE NOT NULL,
          phonetic TEXT,
          chinese TEXT NOT NULL,
          pos TEXT,
          example TEXT,
          example_translation TEXT,
          source TEXT,
          updated_at INTEGER
        )
      ''');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_dictionary_word ON dictionary(word);');
    }
    // Version 15: 新增 AI 对话历史表
    if (oldVersion < 15) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ai_chat_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          scenario_id TEXT NOT NULL,
          sender TEXT NOT NULL,
          message TEXT NOT NULL,
          translation TEXT,
          grammar_score INTEGER,
          corrections TEXT,
          native_suggestion TEXT,
          created_at INTEGER
        )
      ''');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_ai_chat_scenario ON ai_chat_history(scenario_id);');
    }
    // Version 16: words 表新增 definitions 多义释义列
    if (oldVersion < 16) {
      try {
        await db.execute('ALTER TABLE words ADD COLUMN definitions TEXT;');
      } catch (_) {}
    }
    // Version 17: articles 表新增 isRead 已读状态列
    if (oldVersion < 17) {
      try {
        await db.execute(
            'ALTER TABLE articles ADD COLUMN isRead INTEGER DEFAULT 0;');
      } catch (_) {}
    }
    // Version 18: 重构全量名著章节正文为多段落长篇文本，重置 articles 与 books 缓存表以重新播种长篇名著
    if (oldVersion < 18 && newVersion < 23) {
      try {
        await db.execute('DELETE FROM articles;');
        await db.execute('DELETE FROM books;');
      } catch (_) {}
    }
    // Version 19: 全量名著再次深度扩充长篇正文与精准段落级翻译，重置以重新播种
    if (oldVersion < 19 && newVersion < 23) {
      try {
        await db.execute('DELETE FROM articles;');
        await db.execute('DELETE FROM books;');
      } catch (_) {}
    }
    // Version 20: 补全全量 14 本名著全量 8~10 章完整正文与直接段落级渲染，重置以重新播种
    if (oldVersion < 20 && newVersion < 23) {
      try {
        await db.execute('DELETE FROM articles;');
        await db.execute('DELETE FROM books;');
      } catch (_) {}
    }
    // Version 21: 首批 4 本名著（小王子、爱丽丝梦游仙境、绿野仙踪、绿山墙的安妮）全本原著章节（全27章/全12章/全24章/全38章）上线，重置播种
    if (oldVersion < 21 && newVersion < 23) {
      try {
        await db.execute('DELETE FROM articles;');
        await db.execute('DELETE FROM books;');
      } catch (_) {}
    }
    // Version 22: 首批 4 本名著全部章节深度充实段落篇幅（每章4~6个完整丰富段落，杜绝敷衍），重置播种
    if (oldVersion < 22 && newVersion < 23) {
      try {
        await db.execute('DELETE FROM articles;');
        await db.execute('DELETE FROM books;');
      } catch (_) {}
    }
    // Version 23: 文章段落使用 JSON 持久化，内容更新改由 ArticleService 同步，
    // 避免通过删除文章表重播种而丢失用户已读状态。
    if (oldVersion < 23) {
      try {
        await db.execute('ALTER TABLE articles ADD COLUMN paragraphs TEXT;');
      } catch (_) {}
      await db.execute('''
        CREATE TABLE IF NOT EXISTS content_metadata (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');
    }
  }

  // Words
  Future<void> insertWord(Map<String, dynamic> word) async {
    final dbWord = Map<String, dynamic>.from(word);
    dbWord['synonyms'] = jsonEncode(word['synonyms'] ?? []);
    dbWord['antonyms'] = jsonEncode(word['antonyms'] ?? []);
    await _database?.insert('words', dbWord,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    final results = await _database?.query('words') ?? [];
    return results.map((row) {
      final word = Map<String, dynamic>.from(row);
      word['synonyms'] = jsonDecode(row['synonyms'] as String? ?? '[]');
      word['antonyms'] = jsonDecode(row['antonyms'] as String? ?? '[]');
      return word;
    }).toList();
  }

  Future<Map<String, dynamic>?> getWordById(String id) async {
    final results =
        await _database?.query('words', where: 'id = ?', whereArgs: [id]);
    if (results?.isNotEmpty == true) {
      final word = Map<String, dynamic>.from(results!.first);
      word['synonyms'] = jsonDecode(word['synonyms'] as String? ?? '[]');
      word['antonyms'] = jsonDecode(word['antonyms'] as String? ?? '[]');
      return word;
    }
    return null;
  }

  Future<void> updateWordFavorite(String id, bool isFavorite) async {
    await _database?.update('words', {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavoriteWords() async {
    final results = await _database
            ?.query('words', where: 'isFavorite = ?', whereArgs: [1]) ??
        [];
    return results.map((row) {
      final word = Map<String, dynamic>.from(row);
      word['synonyms'] = jsonDecode(row['synonyms'] as String? ?? '[]');
      word['antonyms'] = jsonDecode(row['antonyms'] as String? ?? '[]');
      return word;
    }).toList();
  }

  // Sentences
  Future<void> insertSentence(Map<String, dynamic> sentence) async {
    final dbSentence = Map<String, dynamic>.from(sentence);
    dbSentence['keyWords'] = jsonEncode(sentence['keyWords'] ?? []);
    await _database?.insert('sentences', dbSentence,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllSentences() async {
    final results = await _database?.query('sentences') ?? [];
    return results.map((row) {
      final sentence = Map<String, dynamic>.from(row);
      sentence['keyWords'] = jsonDecode(row['keyWords'] as String? ?? '[]');
      return sentence;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getSentencesByDifficulty(
      String difficulty) async {
    final results = await _database?.query('sentences',
            where: 'difficulty = ?', whereArgs: [difficulty]) ??
        [];
    return results.map((row) {
      final sentence = Map<String, dynamic>.from(row);
      sentence['keyWords'] = jsonDecode(row['keyWords'] as String? ?? '[]');
      return sentence;
    }).toList();
  }

  Future<Map<String, dynamic>?> getSentenceById(String id) async {
    final results =
        await _database?.query('sentences', where: 'id = ?', whereArgs: [id]);
    if (results?.isNotEmpty == true) {
      final sentence = Map<String, dynamic>.from(results!.first);
      sentence['keyWords'] =
          jsonDecode(sentence['keyWords'] as String? ?? '[]');
      return sentence;
    }
    return null;
  }

  // Dialogues
  Future<void> insertDialogue(Map<String, dynamic> dialogue) async {
    final dbDialogue = Map<String, dynamic>.from(dialogue);
    dbDialogue['lines'] = jsonEncode(dialogue['lines'] ?? []);
    await _database?.insert('dialogues', dbDialogue,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllDialogues() async {
    final results = await _database?.query('dialogues') ?? [];
    return results.map((row) {
      final dialogue = Map<String, dynamic>.from(row);
      dialogue['lines'] = jsonDecode(row['lines'] as String? ?? '[]');
      return dialogue;
    }).toList();
  }

  Future<Map<String, dynamic>?> getDialogueById(String id) async {
    final results =
        await _database?.query('dialogues', where: 'id = ?', whereArgs: [id]);
    if (results?.isNotEmpty == true) {
      final dialogue = Map<String, dynamic>.from(results!.first);
      dialogue['lines'] = jsonDecode(dialogue['lines'] as String? ?? '[]');
      return dialogue;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getDialoguesByDifficulty(
      String difficulty) async {
    final results = await _database?.query('dialogues',
            where: 'difficulty = ?', whereArgs: [difficulty]) ??
        [];
    return results.map((row) {
      final dialogue = Map<String, dynamic>.from(row);
      dialogue['lines'] = jsonDecode(row['lines'] as String? ?? '[]');
      return dialogue;
    }).toList();
  }

  // Books
  Future<void> insertBook(Map<String, dynamic> book) async {
    final Map<String, dynamic> safeMap = {};
    book.forEach((key, value) {
      if (value is List) {
        safeMap[key] = value.join(',');
      } else {
        safeMap[key] = value;
      }
    });
    await _database?.insert('books', safeMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllBooks() async {
    return await _database?.query('books') ?? [];
  }

  Future<Map<String, dynamic>?> getBookById(String id) async {
    final results =
        await _database?.query('books', where: 'id = ?', whereArgs: [id]);
    return results?.isNotEmpty == true ? results!.first : null;
  }

  // Articles & Chapter Units
  Future<void> insertArticle(Map<String, dynamic> article) async {
    final Map<String, dynamic> safeMap = {};
    article.forEach((key, value) {
      if (key == 'paragraphs') {
        safeMap[key] = jsonEncode(value);
      } else if (value is List) {
        safeMap[key] = value.join(',');
      } else {
        safeMap[key] = value;
      }
    });

    final articleId = safeMap['id'] as String?;
    if (articleId != null) {
      final existing = await getArticleById(articleId);
      if (existing != null) {
        safeMap['isRead'] = existing['isRead'] ?? 0;
      }
    }
    await _database?.insert('articles', safeMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getContentMetadata(String key) async {
    final results = await _database?.query(
      'content_metadata',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return results?.isNotEmpty == true
        ? results!.first['value'] as String?
        : null;
  }

  Future<void> setContentMetadata(String key, String value) async {
    await _database?.insert(
      'content_metadata',
      {
        'key': key,
        'value': value,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllArticles() async {
    return await _database?.query('articles') ?? [];
  }

  Future<List<Map<String, dynamic>>> getArticlesByBookId(String bookId) async {
    return await _database?.query('articles',
            where: 'bookId = ?',
            orderBy: 'unitIndex ASC',
            whereArgs: [bookId]) ??
        [];
  }

  Future<Map<String, dynamic>?> getArticleById(String id) async {
    final results =
        await _database?.query('articles', where: 'id = ?', whereArgs: [id]);
    return results?.isNotEmpty == true ? results!.first : null;
  }

  Future<List<Map<String, dynamic>>> getArticlesByDifficulty(
      String difficulty) async {
    return await _database?.query('articles',
            where: 'difficulty = ?', whereArgs: [difficulty]) ??
        [];
  }

  Future<List<Map<String, dynamic>>> searchArticles(String query) async {
    return await _database?.query(
          'articles',
          where: 'title LIKE ? OR content LIKE ?',
          whereArgs: ['%$query%', '%$query%'],
        ) ??
        [];
  }

  Future<void> markArticleAsRead(String id, {bool isRead = true}) async {
    await _database?.update(
      'articles',
      {'isRead': isRead ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User Progress
  Future<void> updateProgress(String type, int count) async {
    final existing = await _database
        ?.query('user_progress', where: 'type = ?', whereArgs: [type]);
    if (existing?.isNotEmpty == true) {
      await _database?.update(
        'user_progress',
        {
          'count': (existing!.first['count'] as int) + count,
          'lastUpdated': DateTime.now().toIso8601String()
        },
        where: 'type = ?',
        whereArgs: [type],
      );
    } else {
      await _database?.insert('user_progress', {
        'type': type,
        'count': count,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<Map<String, int>> getAllProgress() async {
    final results = await _database?.query('user_progress') ?? [];
    final progress = <String, int>{};
    for (final row in results) {
      progress[row['type'] as String] = row['count'] as int;
    }
    return progress;
  }

  // Achievements
  Future<void> insertAchievement(Map<String, dynamic> achievement) async {
    await _database?.insert('achievements', achievement,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllAchievements() async {
    return await _database?.query('achievements') ?? [];
  }

  Future<void> unlockAchievement(String id) async {
    await _database?.update(
      'achievements',
      {'unlocked': 1, 'unlockedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Reading History
  Future<void> addReadingHistory(String articleId, int minutes) async {
    await _database?.insert('reading_history', {
      'articleId': articleId,
      'readAt': DateTime.now().toIso8601String(),
      'readMinutes': minutes,
    });
  }

  Future<List<Map<String, dynamic>>> getReadingHistory() async {
    return await _database?.query('reading_history', orderBy: 'readAt DESC') ??
        [];
  }

  // Phonetics
  Future<void> insertPhonetic(Map<String, dynamic> item) async {
    final safeMap = Map<String, dynamic>.from(item);
    if (safeMap['examples'] is List) {
      safeMap['examples'] = jsonEncode(safeMap['examples']);
    }
    await _database?.insert('phonetics', safeMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllPhonetics() async {
    final results = await _database?.query('phonetics') ?? [];
    return results.map((row) {
      final map = Map<String, dynamic>.from(row);
      if (map['examples'] is String) {
        try {
          map['examples'] = jsonDecode(map['examples'] as String);
        } catch (_) {}
      }
      return map;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getPhoneticsByType(String type) async {
    final results = await _database
            ?.query('phonetics', where: 'type = ?', whereArgs: [type]) ??
        [];
    return results.map((row) {
      final map = Map<String, dynamic>.from(row);
      if (map['examples'] is String) {
        try {
          map['examples'] = jsonDecode(map['examples'] as String);
        } catch (_) {}
      }
      return map;
    }).toList();
  }

  // Word Roots
  Future<void> insertWordRoot(Map<String, dynamic> item) async {
    final safeMap = Map<String, dynamic>.from(item);
    if (safeMap['derivedWords'] is List) {
      safeMap['derivedWords'] = jsonEncode(safeMap['derivedWords']);
    }
    await _database?.insert('word_roots', safeMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllWordRoots() async {
    final results = await _database?.query('word_roots') ?? [];
    return results.map((row) {
      final map = Map<String, dynamic>.from(row);
      if (map['derivedWords'] is String) {
        try {
          map['derivedWords'] = jsonDecode(map['derivedWords'] as String);
        } catch (_) {}
      }
      return map;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getWordRootsByType(String type) async {
    final results = await _database
            ?.query('word_roots', where: 'type = ?', whereArgs: [type]) ??
        [];
    return results.map((row) {
      final map = Map<String, dynamic>.from(row);
      if (map['derivedWords'] is String) {
        try {
          map['derivedWords'] = jsonDecode(map['derivedWords'] as String);
        } catch (_) {}
      }
      return map;
    }).toList();
  }

  // Dictionary Table Methods (Version 14)
  Future<Map<String, dynamic>?> searchDictionaryWord(String word) async {
    final lower = word.toLowerCase().trim();
    final results = await _database?.query(
          'dictionary',
          where: 'word = ?',
          whereArgs: [lower],
          limit: 1,
        ) ??
        [];
    return results.isNotEmpty ? Map<String, dynamic>.from(results.first) : null;
  }

  Future<void> insertDictionaryWord(Map<String, dynamic> row) async {
    await _database?.insert(
      'dictionary',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> bulkInsertDictionaryWords(
      List<Map<String, dynamic>> rows) async {
    if (_database == null || rows.isEmpty) return;
    final batch = _database!.batch();
    for (final row in rows) {
      batch.insert('dictionary', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<int> getDictionaryCount() async {
    final res =
        await _database?.rawQuery('SELECT COUNT(*) as count FROM dictionary') ??
            [];
    return res.isNotEmpty ? (res.first['count'] as int? ?? 0) : 0;
  }

  // AI Chat History SQL Methods (Version 15)
  Future<List<Map<String, dynamic>>> getAiChatMessages(
      String scenarioId) async {
    final results = await _database?.query(
          'ai_chat_history',
          where: 'scenario_id = ?',
          whereArgs: [scenarioId],
          orderBy: 'created_at ASC',
        ) ??
        [];
    return results.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  Future<int> insertAiChatMessage(Map<String, dynamic> row) async {
    return await _database?.insert('ai_chat_history', row) ?? 0;
  }

  Future<void> clearAiChatHistory(String scenarioId) async {
    await _database?.delete(
      'ai_chat_history',
      where: 'scenario_id = ?',
      whereArgs: [scenarioId],
    );
  }

  // Clear all data
  Future<void> clearAll() async {
    await _database?.delete('words');
    await _database?.delete('sentences');
    await _database?.delete('dialogues');
    await _database?.delete('articles');
    await _database?.delete('user_progress');
    await _database?.delete('achievements');
    await _database?.delete('reading_history');
    await _database?.delete('phonetics');
    await _database?.delete('word_roots');
    await _database?.delete('dictionary');
    await _database?.delete('ai_chat_history');
  }

  Future<void> close() async {
    await _database?.close();
  }
}
