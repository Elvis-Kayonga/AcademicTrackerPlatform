/// Model for tracking attendance statistics
class AttendanceStats {
  final int totalSessions;
  final int attendedSessions;
  final int missedSessions;
  final double attendancePercentage;
  final Map<String, SessionTypeAttendance> byType;

  AttendanceStats({
    required this.totalSessions,
    required this.attendedSessions,
    required this.missedSessions,
    required this.attendancePercentage,
    required this.byType,
  });

  /// Check if attendance is below warning threshold (75%)
  bool get isLowAttendance => attendancePercentage < 75;

  /// Check if attendance is critical (below 65%)
  bool get isCriticalAttendance => attendancePercentage < 65;

  /// Get status message based on attendance
  String get statusMessage {
    if (totalSessions == 0) {
      return 'No sessions recorded yet';
    } else if (attendancePercentage >= 90) {
      return 'Excellent attendance! Keep it up!';
    } else if (attendancePercentage >= 75) {
      return 'Good attendance. Stay consistent!';
    } else if (attendancePercentage >= 65) {
      return 'Warning: Attendance dropping. Improve now!';
    } else {
      return 'Critical: Attendance too low! Take action!';
    }
  }

  factory AttendanceStats.empty() {
    return AttendanceStats(
      totalSessions: 0,
      attendedSessions: 0,
      missedSessions: 0,
      attendancePercentage: 0,
      byType: {},
    );
  }
}

/// Attendance breakdown by session type
class SessionTypeAttendance {
  final String typeName;
  final int total;
  final int attended;
  final double percentage;

  SessionTypeAttendance({
    required this.typeName,
    required this.total,
    required this.attended,
    required this.percentage,
  });

  bool get isLowAttendance => percentage < 75;
}
