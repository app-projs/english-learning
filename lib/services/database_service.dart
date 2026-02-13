import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'english_learning.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
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

  // Words
  Future<void> insertWord(Map<String, dynamic> word) async {
    await _database?.insert('words', word,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    return await _database?.query('words') ?? [];
  }

  Future<Map<String, dynamic>?> getWordById(String id) async {
    final results =
        await _database?.query('words', where: 'id = ?', whereArgs: [id]);
    return results?.isNotEmpty == true ? results!.first : null;
  }

  Future<void> updateWordFavorite(String id, bool isFavorite) async {
    await _database?.update('words', {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavoriteWords() async {
    return await _database
            ?.query('words', where: 'isFavorite = ?', whereArgs: [1]) ??
        [];
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
    await _database?.delete('user_progress');
    await _database?.delete('achievements');
    await _database?.delete('reading_history');
  }

  Future<void> close() async {
    await _database?.close();
  }
}
