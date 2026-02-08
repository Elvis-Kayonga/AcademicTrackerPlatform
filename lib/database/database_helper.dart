import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/session.dart';
import '../models/attendance_stats.dart';

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
  

  /// Get overall attendance statistics
  Future<AttendanceStats> getAttendanceStats() async {
    final db = await database;
    final now = DateTime.now();
    
    // Only count past sessions (sessions that have already occurred)
    final maps = await db.query(
      'sessions',
      where: 'date < ?',
      whereArgs: [now.toIso8601String()],
    );

    if (maps.isEmpty) {
      return AttendanceStats.empty();
    }

    final sessions = List.generate(maps.length, (i) => Session.fromMap(maps[i]));
    final totalSessions = sessions.length;
    final attendedSessions = sessions.where((s) => s.isAttended).length;
    final missedSessions = totalSessions - attendedSessions;
    final attendancePercentage = totalSessions > 0 
        ? (attendedSessions / totalSessions) * 100 
        : 0.0;

    // Group by session type
    final byType = <String, SessionTypeAttendance>{};
    final typeGroups = <SessionType, List<Session>>{};
    
    for (final session in sessions) {
      typeGroups.putIfAbsent(session.type, () => []).add(session);
    }

    for (final entry in typeGroups.entries) {
      final typeSessions = entry.value;
      final typeTotal = typeSessions.length;
      final typeAttended = typeSessions.where((s) => s.isAttended).length;
      final typePercentage = typeTotal > 0 ? (typeAttended / typeTotal) * 100 : 0.0;
      
      byType[entry.key.displayName] = SessionTypeAttendance(
        typeName: entry.key.displayName,
        total: typeTotal,
        attended: typeAttended,
        percentage: typePercentage,
      );
    }

    return AttendanceStats(
      totalSessions: totalSessions,
      attendedSessions: attendedSessions,
      missedSessions: missedSessions,
      attendancePercentage: attendancePercentage,
      byType: byType,
    );
  }

  /// Get attendance stats for a specific date range
  Future<AttendanceStats> getAttendanceStatsForRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    
    final maps = await db.query(
      'sessions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    if (maps.isEmpty) {
      return AttendanceStats.empty();
    }

    final sessions = List.generate(maps.length, (i) => Session.fromMap(maps[i]));
    final totalSessions = sessions.length;
    final attendedSessions = sessions.where((s) => s.isAttended).length;
    final missedSessions = totalSessions - attendedSessions;
    final attendancePercentage = totalSessions > 0 
        ? (attendedSessions / totalSessions) * 100 
        : 0.0;

    // Group by session type
    final byType = <String, SessionTypeAttendance>{};
    final typeGroups = <SessionType, List<Session>>{};
    
    for (final session in sessions) {
      typeGroups.putIfAbsent(session.type, () => []).add(session);
    }

    for (final entry in typeGroups.entries) {
      final typeSessions = entry.value;
      final typeTotal = typeSessions.length;
      final typeAttended = typeSessions.where((s) => s.isAttended).length;
      final typePercentage = typeTotal > 0 ? (typeAttended / typeTotal) * 100 : 0.0;
      
      byType[entry.key.displayName] = SessionTypeAttendance(
        typeName: entry.key.displayName,
        total: typeTotal,
        attended: typeAttended,
        percentage: typePercentage,
      );
    }

    return AttendanceStats(
      totalSessions: totalSessions,
      attendedSessions: attendedSessions,
      missedSessions: missedSessions,
      attendancePercentage: attendancePercentage,
      byType: byType,
    );
  }

  /// Get attendance history (past sessions) ordered by date
  Future<List<Session>> getAttendanceHistory({int? limit}) async {
    final db = await database;
    final now = DateTime.now();
    
    final maps = await db.query(
      'sessions',
      where: 'date < ?',
      whereArgs: [now.toIso8601String()],
      orderBy: 'date DESC, startTime DESC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  /// Get today's sessions
  Future<List<Session>> getTodaySessions() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    return getSessionsByDate(startOfDay);
  }

  /// Get upcoming sessions (future sessions)
  Future<List<Session>> getUpcomingSessions({int? limit}) async {
    final db = await database;
    final now = DateTime.now();
    
    final maps = await db.query(
      'sessions',
      where: 'date >= ?',
      whereArgs: [now.toIso8601String()],
      orderBy: 'date ASC, startTime ASC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }
}
