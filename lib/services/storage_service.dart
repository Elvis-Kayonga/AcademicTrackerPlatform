import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:alu_assistant/models/models.dart';

class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;
  StorageService._internal();

  // Database instance
  Database? _database;

  // Database name and version
  static const String _databaseName = 'academic_assistant.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _assignmentsTable = 'assignments';
  static const String _sessionsTable = 'sessions';
  static const String _userTable = 'user_data';

  /// Initialize the database
  /// Call this once in main() before running the app
  Future<void> init() async {
    if (_database != null) return; // Already initialized

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  /// Create database tables
  Future<void> _createDatabase(Database db, int version) async {
    // Assignments table
    await db.execute('''
      CREATE TABLE $_assignmentsTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        courseName TEXT NOT NULL,
        priority TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Sessions table
    await db.execute('''
      CREATE TABLE $_sessionsTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        location TEXT,
        sessionType TEXT NOT NULL,
        attended INTEGER,
        createdAt TEXT NOT NULL
      )
    ''');

    // User data table
    await db.execute('''
      CREATE TABLE $_userTable (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  /// Ensure database is initialized
  void _ensureInitialized() {
    if (_database == null) {
      throw Exception(
        'StorageService not initialized. Call StorageService.instance.init() in main()',
      );
    }
  }

  // ==================== ASSIGNMENT OPERATIONS ====================

  /// Save a single assignment
  Future<bool> saveAssignment(Assignment assignment) async {
    _ensureInitialized();

    try {
      await _database!.insert(
        _assignmentsTable,
        {
          'id': assignment.id,
          'title': assignment.title,
          'dueDate': assignment.dueDate.toIso8601String(),
          'courseName': assignment.courseName,
          'priority': assignment.priority?.name,
          'isCompleted': assignment.isCompleted ? 1 : 0,
          'createdAt': assignment.createdAt.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error saving assignment: $e');
      return false;
    }
  }

  /// Get all assignments
  Future<List<Assignment>> getAssignments() async {
    _ensureInitialized();

    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        _assignmentsTable,
        orderBy: 'dueDate ASC',
      );

      return maps
          .map((map) => Assignment(
                id: map['id'] as String,
                title: map['title'] as String,
                dueDate: DateTime.parse(map['dueDate'] as String),
                courseName: map['courseName'] as String,
                priority: map['priority'] != null
                    ? AssignmentPriority.values.firstWhere(
                        (e) => e.name == map['priority'],
                        orElse: () => AssignmentPriority.medium,
                      )
                    : null,
                isCompleted: (map['isCompleted'] as int) == 1,
                createdAt: DateTime.parse(map['createdAt'] as String),
              ))
          .toList();
    } catch (e) {
      print('Error loading assignments: $e');
      return [];
    }
  }

  /// Get assignments due within next 7 days
  Future<List<Assignment>> getUpcomingAssignments() async {
    final assignments = await getAssignments();
    return assignments.where((a) => a.isDueSoon && !a.isCompleted).toList();
  }

  /// Get pending (incomplete) assignments count
  Future<int> getPendingAssignmentsCount() async {
    _ensureInitialized();

    try {
      final result = await _database!.rawQuery(
        'SELECT COUNT(*) as count FROM $_assignmentsTable WHERE isCompleted = 0',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error counting assignments: $e');
      return 0;
    }
  }

  /// Delete an assignment by ID
  Future<bool> deleteAssignment(String assignmentId) async {
    _ensureInitialized();

    try {
      await _database!.delete(
        _assignmentsTable,
        where: 'id = ?',
        whereArgs: [assignmentId],
      );
      return true;
    } catch (e) {
      print('Error deleting assignment: $e');
      return false;
    }
  }

  /// Mark assignment as completed
  Future<bool> toggleAssignmentCompletion(String assignmentId) async {
    _ensureInitialized();

    try {
      // Get current status
      final List<Map<String, dynamic>> result = await _database!.query(
        _assignmentsTable,
        where: 'id = ?',
        whereArgs: [assignmentId],
      );

      if (result.isEmpty) return false;

      final currentStatus = (result.first['isCompleted'] as int) == 1;
      final newStatus = !currentStatus;

      await _database!.update(
        _assignmentsTable,
        {'isCompleted': newStatus ? 1 : 0},
        where: 'id = ?',
        whereArgs: [assignmentId],
      );

      return true;
    } catch (e) {
      print('Error toggling assignment: $e');
      return false;
    }
  }

  /// Clear all assignments
  Future<bool> clearAllAssignments() async {
    _ensureInitialized();

    try {
      await _database!.delete(_assignmentsTable);
      return true;
    } catch (e) {
      print('Error clearing assignments: $e');
      return false;
    }
  }

  // ==================== SESSION OPERATIONS ====================

  /// Save a single session
  Future<bool> saveSession(AcademicSession session) async {
    _ensureInitialized();

    try {
      await _database!.insert(
        _sessionsTable,
        {
          'id': session.id,
          'title': session.title,
          'date': session.date.toIso8601String(),
          'startTime': session.startTime,
          'endTime': session.endTime,
          'location': session.location,
          'sessionType': session.sessionType.name,
          'attended':
              session.attended == null ? null : (session.attended! ? 1 : 0),
          'createdAt': session.createdAt.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error saving session: $e');
      return false;
    }
  }

  /// Get all sessions
  Future<List<AcademicSession>> getSessions() async {
    _ensureInitialized();

    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        _sessionsTable,
        orderBy: 'date ASC',
      );

      return maps
          .map((map) => AcademicSession(
                id: map['id'] as String,
                title: map['title'] as String,
                date: DateTime.parse(map['date'] as String),
                startTime: map['startTime'] as String,
                endTime: map['endTime'] as String,
                location: map['location'] as String?,
                sessionType: SessionType.values.firstWhere(
                  (e) => e.name == map['sessionType'],
                  orElse: () => SessionType.classSession,
                ),
                attended: map['attended'] == null
                    ? null
                    : (map['attended'] as int) == 1,
                createdAt: DateTime.parse(map['createdAt'] as String),
              ))
          .toList();
    } catch (e) {
      print('Error loading sessions: $e');
      return [];
    }
  }

  /// Get today's sessions
  Future<List<AcademicSession>> getTodaySessions() async {
    final sessions = await getSessions();
    return sessions.where((s) => s.isToday).toList();
  }

  /// Get sessions for a specific week
  Future<List<AcademicSession>> getWeekSessions(DateTime weekStart) async {
    final sessions = await getSessions();
    final weekEnd = weekStart.add(Duration(days: 7));

    return sessions.where((s) {
      return s.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
          s.date.isBefore(weekEnd);
    }).toList();
  }

  /// Delete a session by ID
  Future<bool> deleteSession(String sessionId) async {
    _ensureInitialized();

    try {
      await _database!.delete(
        _sessionsTable,
        where: 'id = ?',
        whereArgs: [sessionId],
      );
      return true;
    } catch (e) {
      print('Error deleting session: $e');
      return false;
    }
  }

  /// Update session attendance
  Future<bool> updateSessionAttendance(String sessionId, bool attended) async {
    _ensureInitialized();

    try {
      await _database!.update(
        _sessionsTable,
        {'attended': attended ? 1 : 0},
        where: 'id = ?',
        whereArgs: [sessionId],
      );
      return true;
    } catch (e) {
      print('Error updating attendance: $e');
      return false;
    }
  }

  /// Clear all sessions
  Future<bool> clearAllSessions() async {
    _ensureInitialized();

    try {
      await _database!.delete(_sessionsTable);
      return true;
    } catch (e) {
      print('Error clearing sessions: $e');
      return false;
    }
  }

  // ==================== ATTENDANCE OPERATIONS ====================

  /// Calculate current attendance statistics
  Future<AttendanceStats> getAttendanceStats() async {
    _ensureInitialized();

    try {
      final totalResult = await _database!.rawQuery(
        'SELECT COUNT(*) as count FROM $_sessionsTable',
      );
      final total = Sqflite.firstIntValue(totalResult) ?? 0;

      final attendedResult = await _database!.rawQuery(
        'SELECT COUNT(*) as count FROM $_sessionsTable WHERE attended = 1',
      );
      final attended = Sqflite.firstIntValue(attendedResult) ?? 0;

      final absentResult = await _database!.rawQuery(
        'SELECT COUNT(*) as count FROM $_sessionsTable WHERE attended = 0',
      );
      final absent = Sqflite.firstIntValue(absentResult) ?? 0;

      final unrecorded = total - attended - absent;

      return AttendanceStats(
        totalSessions: total,
        attendedSessions: attended,
        absentSessions: absent,
        unrecordedSessions: unrecorded,
      );
    } catch (e) {
      print('Error calculating attendance: $e');
      return AttendanceStats(
        totalSessions: 0,
        attendedSessions: 0,
        absentSessions: 0,
        unrecordedSessions: 0,
      );
    }
  }

  // ==================== USER DATA OPERATIONS ====================

  /// Save user name
  Future<bool> saveUserName(String name) async {
    return _saveUserData('user_name', name);
  }

  /// Get user name
  Future<String?> getUserName() async {
    return _getUserData('user_name');
  }

  /// Save user email
  Future<bool> saveUserEmail(String email) async {
    return _saveUserData('user_email', email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return _getUserData('user_email');
  }

  /// Internal: Save user data
  Future<bool> _saveUserData(String key, String value) async {
    _ensureInitialized();

    try {
      await _database!.insert(
        _userTable,
        {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Internal: Get user data
  Future<String?> _getUserData(String key) async {
    _ensureInitialized();

    try {
      final List<Map<String, dynamic>> result = await _database!.query(
        _userTable,
        where: 'key = ?',
        whereArgs: [key],
      );

      if (result.isEmpty) return null;
      return result.first['value'] as String?;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Clear all data (reset app)
  Future<bool> clearAllData() async {
    _ensureInitialized();

    try {
      await _database!.delete(_assignmentsTable);
      await _database!.delete(_sessionsTable);
      await _database!.delete(_userTable);
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  /// Check if app has any data
  Future<bool> hasData() async {
    final assignments = await getAssignments();
    final sessions = await getSessions();
    return assignments.isNotEmpty || sessions.isNotEmpty;
  }

  /// Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
