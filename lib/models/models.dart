import 'dart:convert';

/// Assignment Priority Levels
enum AssignmentPriority {
  high,
  medium,
  low;

  String get displayName {
    switch (this) {
      case AssignmentPriority.high:
        return 'High';
      case AssignmentPriority.medium:
        return 'Medium';
      case AssignmentPriority.low:
        return 'Low';
    }
  }
}

/// Assignment Model
class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final String courseName;
  final AssignmentPriority? priority;
  final bool isCompleted;
  final DateTime createdAt;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.courseName,
    this.priority,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Copy with method for updating assignment
  Assignment copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    String? courseName,
    AssignmentPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      courseName: courseName ?? this.courseName,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'courseName': courseName,
      'priority': priority?.name,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      courseName: json['courseName'] as String,
      priority: json['priority'] != null
          ? AssignmentPriority.values.firstWhere(
              (e) => e.name == json['priority'],
              orElse: () => AssignmentPriority.medium,
            )
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Check if assignment is due within next 7 days
  bool get isDueSoon {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    return difference.inDays <= 7 && difference.inDays >= 0;
  }

  /// Check if assignment is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(dueDate) && !isCompleted;
  }
}

/// Session Type
enum SessionType {
  classSession,
  masterySession,
  studyGroup,
  pslMeeting;

  String get displayName {
    switch (this) {
      case SessionType.classSession:
        return 'Class';
      case SessionType.masterySession:
        return 'Mastery Session';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.pslMeeting:
        return 'PSL Meeting';
    }
  }
}

/// Academic Session Model
class AcademicSession {
  final String id;
  final String title;
  final DateTime date;
  final String startTime; // Format: "HH:mm"
  final String endTime; // Format: "HH:mm"
  final String? location;
  final SessionType sessionType;
  final bool? attended; // null = not recorded, true = present, false = absent
  final DateTime createdAt;

  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.sessionType,
    this.attended,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Copy with method
  AcademicSession copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    SessionType? sessionType,
    bool? attended,
    DateTime? createdAt,
  }) {
    return AcademicSession(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      attended: attended ?? this.attended,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'sessionType': sessionType.name,
      'attended': attended,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    return AcademicSession(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      location: json['location'] as String?,
      sessionType: SessionType.values.firstWhere(
        (e) => e.name == json['sessionType'],
        orElse: () => SessionType.classSession,
      ),
      attended: json['attended'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Check if session is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if session is in the past
  bool get isPast {
    return date.isBefore(DateTime.now());
  }
}

/// Attendance Statistics Model
class AttendanceStats {
  final int totalSessions;
  final int attendedSessions;
  final int absentSessions;
  final int unrecordedSessions;

  AttendanceStats({
    required this.totalSessions,
    required this.attendedSessions,
    required this.absentSessions,
    required this.unrecordedSessions,
  });

  /// Calculate attendance percentage
  double get percentage {
    if (totalSessions == 0) return 0.0;
    final recordedSessions = totalSessions - unrecordedSessions;
    if (recordedSessions == 0) return 0.0;
    return (attendedSessions / recordedSessions) * 100;
  }

  /// Check if attendance is at risk (below 75%)
  bool get isAtRisk {
    return percentage < 75.0;
  }

  /// Get risk level
  String get riskLevel {
    if (percentage >= 80.0) return 'Safe';
    if (percentage >= 75.0) return 'Warning';
    return 'At Risk';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalSessions': totalSessions,
      'attendedSessions': attendedSessions,
      'absentSessions': absentSessions,
      'unrecordedSessions': unrecordedSessions,
    };
  }

  /// Create from JSON
  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      totalSessions: json['totalSessions'] as int? ?? 0,
      attendedSessions: json['attendedSessions'] as int? ?? 0,
      absentSessions: json['absentSessions'] as int? ?? 0,
      unrecordedSessions: json['unrecordedSessions'] as int? ?? 0,
    );
  }
}
