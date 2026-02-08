import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/attendance_stats.dart';
import '../models/session.dart';
import '../utils/app_theme.dart';
import 'attendance_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  AttendanceStats? _stats;
  List<Session> _todaySessions = [];
  List<Session> _upcomingSessions = [];
  bool _isLoading = true;
  bool _alertDismissed = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final stats = await _dbHelper.getAttendanceStats();
      final todaySessions = await _dbHelper.getTodaySessions();
      final upcomingSessions = await _dbHelper.getUpcomingSessions(limit: 5);
      
      setState(() {
        _stats = stats;
        _todaySessions = todaySessions;
        _upcomingSessions = upcomingSessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDarkBlue,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2845),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.accentYellow),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppTheme.accentYellow,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Low Attendance Alert
                    if (_stats != null && _stats!.isLowAttendance && !_alertDismissed)
                      _buildAttendanceAlert(),
                    
                    // Main Attendance Card
                    _buildAttendanceCard(),
                    const SizedBox(height: 16),
                    
                    // Today's Sessions
                    _buildTodaysSessions(),
                    const SizedBox(height: 16),
                    
                    // Upcoming Sessions
                    _buildUpcomingSessions(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAttendanceAlert() {
    final isCritical = _stats!.isCriticalAttendance;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCritical 
            ? AppTheme.attendanceDanger.withOpacity(0.1)
            : AppTheme.attendanceWarning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCritical ? AppTheme.attendanceDanger : AppTheme.attendanceWarning,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCritical ? Icons.error : Icons.warning,
            color: isCritical ? AppTheme.attendanceDanger : AppTheme.attendanceWarning,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your attendance is ${_stats!.attendancePercentage.toStringAsFixed(1)}%, '
              '${isCritical ? "which is critically low!" : "below the required 75%"}',
              style: TextStyle(
                color: isCritical ? AppTheme.attendanceDanger : AppTheme.attendanceWarning,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textSecondary),
            onPressed: () => setState(() => _alertDismissed = true),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    final stats = _stats ?? AttendanceStats.empty();
    final percentage = stats.attendancePercentage;
    final color = AppTheme.getAttendanceColor(percentage);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Attendance',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceHistoryScreen(),
                    ),
                  ).then((_) => _loadData());
                },
                icon: const Icon(Icons.history, size: 18),
                label: const Text('History'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryDarkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Circular Progress Indicator
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: stats.totalSessions > 0 ? percentage / 100 : 0,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentYellow),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Color(0xFF0F1627),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${stats.attendedSessions}/${stats.totalSessions}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Status Message
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1627).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Keep up with the attendance!',
              style: TextStyle(color: Color(0xFF0F1627), fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Attended',
                stats.attendedSessions.toString(),
                AppTheme.accentYellow,
                Icons.check_circle,
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              _buildStatItem(
                'Missed',
                stats.missedSessions.toString(),
                AppTheme.warningRed,
                Icons.cancel,
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              _buildStatItem(
                'Total',
                stats.totalSessions.toString(),
                AppTheme.primaryDarkBlue,
                Icons.calendar_today,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTodaysSessions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Sessions",
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('EEEE, MMM d').format(DateTime.now()),
                style: const TextStyle(color: AppTheme.primaryDarkBlue, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_todaySessions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No sessions scheduled for today',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            )
          else
            ..._todaySessions.map((session) => _buildSessionTile(session)).toList(),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Sessions',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_upcomingSessions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No upcoming sessions',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            )
          else
            ..._upcomingSessions.map((session) => _buildSessionTile(session, showDate: true)).toList(),
        ],
      ),
    );
  }

  Widget _buildSessionTile(Session session, {bool showDate = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            width: 3,
            color: session.isAttended ? AppTheme.accentYellow : Colors.grey,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${session.startTime} - ${session.endTime}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    if (showDate) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d').format(session.date),
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getTypeColor(session.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              session.type.displayName,
              style: TextStyle(
                color: _getTypeColor(session.type),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(SessionType type) {
    switch (type) {
      case SessionType.classSession:
        return AppTheme.accentYellow;
      case SessionType.masterySession:
        return Colors.purpleAccent;
      case SessionType.studyGroup:
        return Colors.tealAccent;
      case SessionType.pslMeeting:
        return Colors.orangeAccent;
    }
  }
}
