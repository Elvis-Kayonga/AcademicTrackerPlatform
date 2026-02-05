import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_data_service.dart';
import '../utils/app_theme.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';

/// Dashboard Screen - Main Hub
/// Implemented by: Elvis (Dashboard + Integration Lead)
/// 
/// Features:
/// ✓ Current date and academic week display
/// ✓ Today's sessions list
/// ✓ Upcoming assignments (next 7 days)
/// ✓ Pending assignments count
/// ✓ Attendance percentage with warning indicator
/// ✓ Integration with assignments & attendance modules
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  /// Calculate academic week number
  /// Assumes semester starts on a Monday in late January
  int _getAcademicWeek() {
    final now = DateTime.now();
    // Semester start date (adjust as needed - using late January as reference)
    final semesterStart = DateTime(now.year, 1, 22);
    final difference = now.difference(semesterStart).inDays;
    return (difference / 7).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Profile action placeholder
            },
          ),
        ],
      ),
      body: Consumer<AppDataService>(
        builder: (context, dataService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Academic Week
                _buildDateSection(),
                const SizedBox(height: 20),

                // Attendance Warning (if at risk)
                if (dataService.isAttendanceAtRisk)
                  _buildAttendanceWarning(dataService.attendancePercentage),

                // Academic Metrics Cards
                _buildMetricsRow(dataService),
                const SizedBox(height: 24),

                // Today's Classes
                _buildSectionHeader(context, 'Today\'s Classes'),
                const SizedBox(height: 12),
                _buildTodaysSessions(dataService.todaysSessions),
                const SizedBox(height: 24),

                // Upcoming Assignments (Next 7 Days)
                _buildSectionHeader(context, 'Upcoming Assignments'),
                const SizedBox(height: 12),
                _buildUpcomingAssignments(dataService.upcomingAssignments),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Date and Academic Week Display
  Widget _buildDateSection() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMM d, y');
    final weekNumber = _getAcademicWeek();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(now),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Academic Week $weekNumber',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'W$weekNumber',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Attendance Warning Banner
  Widget _buildAttendanceWarning(double percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warningRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AT RISK WARNING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your attendance is ${percentage.toStringAsFixed(0)}%. Must be ≥75%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Academic Metrics Row
  Widget _buildMetricsRow(AppDataService dataService) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Active\nProjects',
            '${dataService.assignments.length}',
            AppTheme.accentYellow,
            Icons.folder_open,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Code\nFactors',
            '7',
            AppTheme.warningOrange,
            Icons.code,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Upcoming\nAgents',
            '${dataService.pendingAssignmentsCount}',
            AppTheme.warningRed,
            Icons.pending_actions,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  /// Today's Sessions List
  Widget _buildTodaysSessions(List<AcademicSession> sessions) {
    if (sessions.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_busy,
        message: 'No classes scheduled for today',
      );
    }

    return Column(
      children: sessions
          .map((session) => _buildSessionCard(session))
          .toList(),
    );
  }

  Widget _buildSessionCard(AcademicSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSessionIcon(session.sessionType),
              color: AppTheme.accentYellow,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.timeRange} • ${session.location}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  IconData _getSessionIcon(String type) {
    switch (type) {
      case 'Class':
        return Icons.school;
      case 'Mastery Session':
        return Icons.psychology;
      case 'Study Group':
        return Icons.groups;
      case 'PSL Meeting':
        return Icons.meeting_room;
      default:
        return Icons.event;
    }
  }

  /// Upcoming Assignments List
  Widget _buildUpcomingAssignments(List<Assignment> assignments) {
    if (assignments.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_turned_in,
        message: 'No upcoming assignments',
      );
    }

    return Column(
      children: assignments
          .map((assignment) => _buildAssignmentCard(assignment))
          .toList(),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final daysUntilDue = assignment.dueDate.difference(DateTime.now()).inDays;
    final priorityColor = AppTheme.getPriorityColor(assignment.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              assignment.priority,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: priorityColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  assignment.courseName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Due ${DateFormat('MMM d').format(assignment.dueDate)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                daysUntilDue == 0
                    ? 'Today'
                    : daysUntilDue == 1
                        ? 'Tomorrow'
                        : 'in $daysUntilDue days',
                style: TextStyle(
                  fontSize: 12,
                  color: daysUntilDue <= 1
                      ? AppTheme.warningRed
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Empty State Widget
  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
