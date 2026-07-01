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
    } else if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'english_learning.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
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
        createdAt TEXT
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
      CREATE TABLE articles (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        translation TEXT,
        difficulty TEXT,
        category TEXT,
        createdAt TEXT
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
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS words');
      await db.execute('DROP TABLE IF EXISTS sentences');
      await db.execute('DROP TABLE IF EXISTS dialogues');
      await db.execute('DROP TABLE IF EXISTS articles');
      await db.execute('DROP TABLE IF EXISTS user_progress');
      await db.execute('DROP TABLE IF EXISTS achievements');
      await db.execute('DROP TABLE IF EXISTS reading_history');
      await _onCreate(db, newVersion);
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

  Future<List<Map<String, dynamic>>> getSentencesByDifficulty(String difficulty) async {
    final results = await _database?.query('sentences', where: 'difficulty = ?', whereArgs: [difficulty]) ?? [];
    return results.map((row) {
      final sentence = Map<String, dynamic>.from(row);
      sentence['keyWords'] = jsonDecode(row['keyWords'] as String? ?? '[]');
      return sentence;
    }).toList();
  }

  Future<Map<String, dynamic>?> getSentenceById(String id) async {
    final results = await _database?.query('sentences', where: 'id = ?', whereArgs: [id]);
    if (results?.isNotEmpty == true) {
      final sentence = Map<String, dynamic>.from(results!.first);
      sentence['keyWords'] = jsonDecode(sentence['keyWords'] as String? ?? '[]');
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
    final results = await _database?.query('dialogues', where: 'id = ?', whereArgs: [id]);
    if (results?.isNotEmpty == true) {
      final dialogue = Map<String, dynamic>.from(results!.first);
      dialogue['lines'] = jsonDecode(dialogue['lines'] as String? ?? '[]');
      return dialogue;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getDialoguesByDifficulty(String difficulty) async {
    final results = await _database?.query('dialogues', where: 'difficulty = ?', whereArgs: [difficulty]) ?? [];
    return results.map((row) {
      final dialogue = Map<String, dynamic>.from(row);
      dialogue['lines'] = jsonDecode(row['lines'] as String? ?? '[]');
      return dialogue;
    }).toList();
  }

  // Articles
  Future<void> insertArticle(Map<String, dynamic> article) async {
    await _database?.insert('articles', article,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllArticles() async {
    return await _database?.query('articles') ?? [];
  }

  Future<Map<String, dynamic>?> getArticleById(String id) async {
    final results = await _database?.query('articles', where: 'id = ?', whereArgs: [id]);
    return results?.isNotEmpty == true ? results!.first : null;
  }

  Future<List<Map<String, dynamic>>> getArticlesByDifficulty(String difficulty) async {
    return await _database?.query('articles', where: 'difficulty = ?', whereArgs: [difficulty]) ?? [];
  }

  Future<List<Map<String, dynamic>>> searchArticles(String query) async {
    return await _database?.query(
      'articles',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    ) ?? [];
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

  // Clear all data
  Future<void> clearAll() async {
    await _database?.delete('words');
    await _database?.delete('sentences');
    await _database?.delete('dialogues');
    await _database?.delete('articles');
    await _database?.delete('user_progress');
    await _database?.delete('achievements');
    await _database?.delete('reading_history');
  }

  Future<void> close() async {
    await _database?.close();
  }
}
