import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/session.dart';
import '../utils/app_theme.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Session> _sessions = [];
  bool _isLoading = true;
  String _filterType = 'All';
  String _filterStatus = 'All';

  final List<String> _typeFilters = ['All', 'Class', 'Mastery Session', 'Study Group', 'PSL Meeting'];
  final List<String> _statusFilters = ['All', 'Attended', 'Missed'];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    try {
      final sessions = await _dbHelper.getAttendanceHistory();
      setState(() {
        _sessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Session> get _filteredSessions {
    return _sessions.where((session) {
      // Filter by type
      if (_filterType != 'All' && session.type.displayName != _filterType) {
        return false;
      }
      // Filter by status
      if (_filterStatus == 'Attended' && !session.isAttended) {
        return false;
      }
      if (_filterStatus == 'Missed' && session.isAttended) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<String, List<Session>> get _groupedSessions {
    final grouped = <String, List<Session>>{};
    for (final session in _filteredSessions) {
      final dateKey = DateFormat('MMMM yyyy').format(session.date);
      grouped.putIfAbsent(dateKey, () => []).add(session);
    }
    return grouped;
  }

  Future<void> _toggleAttendance(Session session) async {
    await _dbHelper.toggleAttendance(session.id!, !session.isAttended);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDarkBlue,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2845),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Attendance History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(),
          
          // Stats Summary
          _buildStatsSummary(),
          
          // Session List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.accentYellow),
                  )
                : _filteredSessions.isEmpty
                    ? _buildEmptyState()
                    : _buildSessionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.cardBackground,
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              value: _filterType,
              items: _typeFilters,
              onChanged: (value) => setState(() => _filterType = value!),
              label: 'Type',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
              value: _filterStatus,
              items: _statusFilters,
              onChanged: (value) => setState(() => _filterStatus = value!),
              label: 'Status',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
          )).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryDarkBlue),
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    final filtered = _filteredSessions;
    final attended = filtered.where((s) => s.isAttended).length;
    final total = filtered.length;
    final percentage = total > 0 ? (attended / total) * 100 : 0.0;
    final color = AppTheme.getAttendanceColor(percentage);

    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total', total.toString(), AppTheme.primaryDarkBlue),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildSummaryItem('Attended', attended.toString(), AppTheme.successGreen),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildSummaryItem('Missed', (total - attended).toString(), AppTheme.warningRed),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildSummaryItem('Rate', '${percentage.toStringAsFixed(0)}%', color),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No attendance records found',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
          if (_filterType != 'All' || _filterStatus != 'All')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () => setState(() {
                  _filterType = 'All';
                  _filterStatus = 'All';
                }),
                child: const Text('Clear Filters', style: TextStyle(color: AppTheme.primaryDarkBlue)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    final grouped = _groupedSessions;
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final month = grouped.keys.elementAt(index);
        final sessions = grouped[month]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                month,
                style: const TextStyle(
                  color: AppTheme.primaryDarkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...sessions.map((session) => _buildSessionCard(session)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildSessionCard(Session session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            width: 4,
            color: session.isAttended ? AppTheme.successGreen : AppTheme.warningRed,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          session.title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  DateFormat('EEEE, MMM d, yyyy').format(session.date),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${session.startTime} - ${session.endTime}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTypeColor(session.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    session.type.displayName,
                    style: TextStyle(
                      color: _getTypeColor(session.type),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () => _toggleAttendance(session),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: session.isAttended 
                  ? AppTheme.successGreen.withOpacity(0.1)
                  : AppTheme.warningRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              session.isAttended ? Icons.check_circle : Icons.cancel,
              color: session.isAttended ? AppTheme.successGreen : AppTheme.warningRed,
              size: 28,
            ),
          ),
        ),
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
