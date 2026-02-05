import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/session.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'alu_assistant.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        location TEXT,
        type TEXT NOT NULL,
        isAttended INTEGER DEFAULT 0
      )
    ''');
  }

  // Create
  Future<int> insertSession(Session session) async {
    final db = await database;
    return db.insert('sessions', session.toMap());
  }

  // Read
  Future<List<Session>> getSessions() async {
    final db = await database;
    final maps = await db.query('sessions', orderBy: 'date ASC, startTime ASC');
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  Future<List<Session>> getSessionsByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final maps = await db.query(
      'sessions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: 'startTime ASC',
    );
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  Future<List<Session>> getSessionsForWeek(DateTime weekStart) async {
    final db = await database;
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    final maps = await db.query(
      'sessions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [weekStart.toIso8601String(), weekEnd.toIso8601String()],
      orderBy: 'date ASC, startTime ASC',
    );
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  // Update
  Future<int> updateSession(Session session) async {
    final db = await database;
    return db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> toggleAttendance(int id, bool isAttended) async {
    final db = await database;
    return db.update(
      'sessions',
      {'isAttended': isAttended ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete
  Future<int> deleteSession(int id) async {
    final db = await database;
    return db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    _database?.close();
  }
}
