/// Academic Session Model
/// Used by: Elvis (Dashboard), Teammate handling Schedule module
class AcademicSession {
  final String id;
  final String title;
  final DateTime date;
  final String startTime; // Format: "HH:mm"
  final String endTime; // Format: "HH:mm"
  final String location;
  final String sessionType; // 'Class', 'Mastery Session', 'Study Group', 'PSL Meeting'
  final bool isAttended;

  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.sessionType,
    this.isAttended = false,
  });

  /// Check if session is today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if session is in the past
  bool isPast() {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  /// Get formatted time range
  String get timeRange => '$startTime - $endTime';

  /// Copy with method for updating session
  AcademicSession copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? sessionType,
    bool? isAttended,
  }) {
    return AcademicSession(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      isAttended: isAttended ?? this.isAttended,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'sessionType': sessionType,
      'isAttended': isAttended,
    };
  }

  /// Create from JSON
  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    return AcademicSession(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'] ?? '',
      sessionType: json['sessionType'],
      isAttended: json['isAttended'] ?? false,
    );
  }
}
