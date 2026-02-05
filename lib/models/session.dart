enum SessionType {
  classSession,
  masterySession,
  studyGroup,
  pslMeeting,
}

extension SessionTypeExtension on SessionType {
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

  static SessionType fromString(String value) {
    switch (value) {
      case 'Class':
        return SessionType.classSession;
      case 'Mastery Session':
        return SessionType.masterySession;
      case 'Study Group':
        return SessionType.studyGroup;
      case 'PSL Meeting':
        return SessionType.pslMeeting;
      default:
        return SessionType.classSession;
    }
  }
}

class Session {
  final int? id;
  final String title;
  final DateTime date;
  final String startTime; // HH:MM format
  final String endTime; // HH:MM format
  final String? location;
  final SessionType type;
  final bool isAttended;

  Session({
    this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.type,
    this.isAttended = false,
  });

  Session copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    SessionType? type,
    bool? isAttended,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      isAttended: isAttended ?? this.isAttended,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'type': type.displayName,
      'isAttended': isAttended ? 1 : 0,
    };
  }

  static Session fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      location: map['location'] as String?,
      type: SessionTypeExtension.fromString(map['type'] as String),
      isAttended: (map['isAttended'] as int?) == 1,
    );
  }
}
