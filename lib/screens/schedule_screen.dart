import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';
import '../database/database_helper.dart';
import 'add_session_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late DateTime _weekStart;
  List<Session> _sessions = [];

  @override
  void initState() {
    super.initState();
    _setWeekStart(DateTime.now());
    _loadSessions();
  }

  void _setWeekStart(DateTime date) {
    final weekDay = date.weekday;
    _weekStart = date.subtract(Duration(days: weekDay - 1));
  }

  Future<void> _loadSessions() async {
    final sessions = await _dbHelper.getSessionsForWeek(_weekStart);
    setState(() {
      _sessions = sessions;
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
    _loadSessions();
  }

  void _goToNextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
    _loadSessions();
  }

  void _goToCurrentWeek() {
    final now = DateTime.now();
    _setWeekStart(now);
    _loadSessions();
  }

  Future<void> _addOrEditSession(Session? session) async {
    final result = await Navigator.of(context).push<Session>(
      MaterialPageRoute(
        builder: (context) => AddSessionScreen(
          session: session,
          onSessionSaved: (newSession) async {
            if (newSession.id == null) {
              // Create new session
              await _dbHelper.insertSession(newSession);
            } else {
              // Update existing session
              await _dbHelper.updateSession(newSession);
            }
            _loadSessions();
          },
        ),
      ),
    );
    if (result != null) {
      _loadSessions();
    }
  }

  Future<void> _deleteSession(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2845),
        title: const Text(
          'Delete Session',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this session?',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await _dbHelper.deleteSession(id);
      _loadSessions();
    }
  }

  Future<void> _toggleAttendance(Session session) async {
    await _dbHelper.toggleAttendance(
      session.id!,
      !session.isAttended,
    );
    _loadSessions();
  }

  Map<String, List<Session>> _groupSessionsByDay(List<Session> sessions) {
    final grouped = <String, List<Session>>{};
    for (final session in sessions) {
      final dayKey = DateFormat('EEE, MMM dd').format(session.date);
      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(session);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedSessions = _groupSessionsByDay(_sessions);
    final weekEnd = _weekStart.add(const Duration(days: 6));

    return Scaffold(
      backgroundColor: const Color(0xFF0F1627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2845),
        title: const Text(
          'Schedule',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Week Navigation
          Container(
            color: const Color(0xFF1B2845),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Color(0xFFFFC107)),
                      onPressed: _goToPreviousWeek,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Week of ${DateFormat('MMM dd').format(_weekStart)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${DateFormat('MMM dd').format(weekEnd)}',
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right,
                          color: Color(0xFFFFC107)),
                      onPressed: _goToNextWeek,
                    ),
                  ],
                ),
                if (_weekStart.year != DateTime.now().year ||
                    _weekStart.month != DateTime.now().month ||
                    _weekStart.day != DateTime.now().day)
                  TextButton(
                    onPressed: _goToCurrentWeek,
                    child: const Text(
                      'Go to Today',
                      style: TextStyle(color: Color(0xFFFFC107)),
                    ),
                  ),
              ],
            ),
          ),
          // Sessions List
          Expanded(
            child: _sessions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 64,
                          color: const Color(0xFF9E9E9E).withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No sessions this week',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: groupedSessions.length,
                    itemBuilder: (context, index) {
                      final dayKey = groupedSessions.keys.elementAt(index);
                      final daySessions = groupedSessions[dayKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              dayKey,
                              style: const TextStyle(
                                color: Color(0xFFFFC107),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...daySessions.map((session) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: _SessionCard(
                                session: session,
                                onEdit: () => _addOrEditSession(session),
                                onDelete: () => _deleteSession(session.id!),
                                onToggleAttendance: () =>
                                    _toggleAttendance(session),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        onPressed: () => _addOrEditSession(null),
        child: const Icon(Icons.add, color: Color(0xFF0F1627)),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAttendance;

  const _SessionCard({
    Key? key,
    required this.session,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAttendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1B2845),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: SizedBox(
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                session.startTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                session.endTime,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3D5C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    session.type.displayName,
                    style: const TextStyle(
                      color: Color(0xFFFFC107),
                      fontSize: 10,
                    ),
                  ),
                ),
                if (session.location != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.location_on,
                      size: 12, color: const Color(0xFF9E9E9E)),
                  const SizedBox(width: 4),
                  Text(
                    session.location!,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          color: const Color(0xFF1B2845),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    session.isAttended
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: session.isAttended
                        ? const Color(0xFFFFC107)
                        : const Color(0xFF9E9E9E),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.isAttended ? 'Mark Absent' : 'Mark Present',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onTap: onToggleAttendance,
            ),
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Color(0xFFFFC107), size: 18),
                  SizedBox(width: 8),
                  Text('Edit', style: TextStyle(color: Colors.white)),
                ],
              ),
              onTap: onEdit,
            ),
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Color(0xFFE53935), size: 18),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Color(0xFFE53935))),
                ],
              ),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
