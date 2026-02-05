import 'package:flutter/foundation.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';

/// Central Data Service for the Academic Tracker App
/// This service manages all app data and provides it to different screens
/// 
/// INTEGRATION POINT for teammates:
/// - Assignment module should populate assignments list
/// - Schedule module should populate sessions list
/// - Both modules can listen to changes via notifyListeners()
class AppDataService extends ChangeNotifier {
  // Private lists
  List<Assignment> _assignments = [];
  List<AcademicSession> _sessions = [];

  // Getters
  List<Assignment> get assignments => _assignments;
  List<AcademicSession> get sessions => _sessions;

  /// Get assignments due within next 7 days
  List<Assignment> get upcomingAssignments {
    return _assignments
        .where((assignment) => assignment.isDueSoon() && !assignment.isCompleted)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Get count of pending (incomplete) assignments
  int get pendingAssignmentsCount {
    return _assignments.where((a) => !a.isCompleted).length;
  }

  /// Get today's sessions
  List<AcademicSession> get todaysSessions {
    return _sessions.where((session) => session.isToday()).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Calculate attendance percentage
  double get attendancePercentage {
    final pastSessions = _sessions.where((s) => s.isPast()).toList();
    if (pastSessions.isEmpty) return 100.0;
    
    final attendedCount = pastSessions.where((s) => s.isAttended).length;
    return (attendedCount / pastSessions.length) * 100;
  }

  /// Check if attendance is below 75% (at risk)
  bool get isAttendanceAtRisk {
    return attendancePercentage < 75;
  }

  // ========== ASSIGNMENT METHODS ==========
  // For teammate working on Assignment module

  /// Add a new assignment
  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  /// Update an existing assignment
  void updateAssignment(String id, Assignment updatedAssignment) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = updatedAssignment;
      notifyListeners();
    }
  }

  /// Delete an assignment
  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  /// Toggle assignment completion
  void toggleAssignmentCompletion(String id) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = _assignments[index].copyWith(
        isCompleted: !_assignments[index].isCompleted,
      );
      notifyListeners();
    }
  }

  // ========== SESSION METHODS ==========
  // For teammate working on Schedule module

  /// Add a new academic session
  void addSession(AcademicSession session) {
    _sessions.add(session);
    notifyListeners();
  }

  /// Update an existing session
  void updateSession(String id, AcademicSession updatedSession) {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = updatedSession;
      notifyListeners();
    }
  }

  /// Delete a session
  void deleteSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  /// Toggle session attendance
  void toggleSessionAttendance(String id) {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(
        isAttended: !_sessions[index].isAttended,
      );
      notifyListeners();
    }
  }

  // ========== DEMO DATA ==========
  // Initialize with sample data for testing
  void loadDemoData() {
    _assignments = [
      Assignment(
        id: '1',
        title: 'Assignment 1',
        courseName: 'Introduction to Linux',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: 'High',
      ),
      Assignment(
        id: '2',
        title: 'Assignment 2',
        courseName: 'Front End Web Development',
        dueDate: DateTime.now().add(const Duration(days: 4)),
        priority: 'Medium',
        isCompleted: false,
      ),
      Assignment(
        id: '3',
        title: 'Group Project',
        courseName: 'Mobile App (Flutter)',
        dueDate: DateTime.now().add(const Duration(days: 6)),
        priority: 'High',
      ),
    ];

    _sessions = [
      AcademicSession(
        id: '1',
        title: 'ASSIGNMENT',
        date: DateTime.now(),
        startTime: '09:00',
        endTime: '10:30',
        location: 'Room 101',
        sessionType: 'Class',
        isAttended: true,
      ),
      AcademicSession(
        id: '2',
        title: 'Quiz 1',
        date: DateTime.now(),
        startTime: '11:00',
        endTime: '12:00',
        location: 'Room 202',
        sessionType: 'Class',
        isAttended: false,
      ),
      AcademicSession(
        id: '3',
        title: 'Assignment 2',
        date: DateTime.now(),
        startTime: '14:00',
        endTime: '15:30',
        location: 'Lab 3',
        sessionType: 'Mastery Session',
        isAttended: true,
      ),
      // Past sessions for attendance calculation
      AcademicSession(
        id: '4',
        title: 'Past Session 1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        startTime: '09:00',
        endTime: '10:30',
        sessionType: 'Class',
        isAttended: true,
      ),
      AcademicSession(
        id: '5',
        title: 'Past Session 2',
        date: DateTime.now().subtract(const Duration(days: 2)),
        startTime: '09:00',
        endTime: '10:30',
        sessionType: 'Class',
        isAttended: false,
      ),
      AcademicSession(
        id: '6',
        title: 'Past Session 3',
        date: DateTime.now().subtract(const Duration(days: 3)),
        startTime: '09:00',
        endTime: '10:30',
        sessionType: 'Class',
        isAttended: true,
      ),
      AcademicSession(
        id: '7',
        title: 'Past Session 4',
        date: DateTime.now().subtract(const Duration(days: 4)),
        startTime: '09:00',
        endTime: '10:30',
        sessionType: 'Class',
        isAttended: true,
      ),
    ];

    notifyListeners();
  }
}
