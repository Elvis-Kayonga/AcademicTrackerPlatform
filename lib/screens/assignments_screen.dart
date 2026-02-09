import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../models/assignment.dart';
import '../utils/app_theme.dart';
import 'assignment_form_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = const ['All', 'Due Soon', 'High', 'Completed'];

  String _activeFilter = 'All';
  String _searchQuery = '';
  List<Assignment> _allAssignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAssignments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final assignments = await _dbHelper.getAssignments();
      setState(() {
        _allAssignments = assignments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading assignments: $e'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }
  }

  Future<void> _navigateToAddAssignment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignmentFormScreen(),
      ),
    );

    if (result == true) {
      _loadAssignments();
    }
  }

  Future<void> _navigateToEditAssignment(Assignment assignment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentFormScreen(assignment: assignment),
      ),
    );

    if (result == true) {
      _loadAssignments();
    }
  }

  Future<void> _toggleCompletion(Assignment assignment) async {
    try {
      await _dbHelper.toggleAssignmentCompletion(
        assignment.id,
        !assignment.isCompleted,
      );
      _loadAssignments();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              assignment.isCompleted
                  ? 'Assignment marked as incomplete'
                  : 'Assignment marked as completed',
            ),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating assignment: $e'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }
  }

  Future<void> _deleteAssignment(Assignment assignment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.warningRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _dbHelper.deleteAssignment(assignment.id);
        _loadAssignments();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assignment deleted successfully'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting assignment: $e'),
              backgroundColor: AppTheme.warningRed,
            ),
          );
        }
      }
    }
  }

  List<Assignment> get _filteredAssignments {
    final query = _searchQuery.toLowerCase();

    return _allAssignments.where((assignment) {
      final matchesQuery = query.isEmpty ||
          assignment.title.toLowerCase().contains(query) ||
          assignment.courseName.toLowerCase().contains(query);

      bool matchesFilter = true;
      if (_activeFilter == 'Due Soon') {
        matchesFilter = assignment.isDueSoon() && !assignment.isCompleted;
      } else if (_activeFilter == 'High') {
        matchesFilter = assignment.priority.toLowerCase() == 'high' && !assignment.isCompleted;
      } else if (_activeFilter == 'Completed') {
        matchesFilter = assignment.isCompleted;
      }

      return matchesQuery && matchesFilter;
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _allAssignments.where((a) => !a.isCompleted).length;
    final dueSoonCount = _allAssignments.where((a) => a.isDueSoon() && !a.isCompleted).length;
    final completedCount = _allAssignments.where((a) => a.isCompleted).length;

    return Scaffold(
      backgroundColor: AppTheme.primaryDarkBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryNavyBlue,
        title: const Text(
          'Assignments',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAssignments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentYellow,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadAssignments,
              color: AppTheme.accentYellow,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroHeader(pendingCount, dueSoonCount),
                    const SizedBox(height: 16),
                    _buildQuickStats(pendingCount, dueSoonCount, completedCount),
                    const SizedBox(height: 20),
                    _buildSearchAndFilters(),
                    const SizedBox(height: 16),
                    _buildAssignmentsSection(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAssignment,
        backgroundColor: AppTheme.accentYellow,
        child: const Icon(
          Icons.add,
          color: AppTheme.primaryDarkBlue,
        ),
      ),
    );
  }

  Widget _buildHeroHeader(int pendingCount, int dueSoonCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B2845),
            const Color(0xFF24365F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: AppTheme.accentYellow,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stay ahead',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pendingCount pending • $dueSoonCount due soon',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Focus on the next 48 hours to keep momentum.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(int pendingCount, int dueSoonCount, int completedCount) {
    return Row(
      children: [
        _buildStatCard('Pending', pendingCount.toString(), Icons.timelapse, AppTheme.accentYellow),
        const SizedBox(width: 12),
        _buildStatCard('Due Soon', dueSoonCount.toString(), Icons.bolt, AppTheme.warningOrange),
        const SizedBox(width: 12),
        _buildStatCard('Done', completedCount.toString(), Icons.check_circle, AppTheme.successGreen),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.secondaryNavyBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search assignments or courses',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            filled: true,
            fillColor: AppTheme.secondaryNavyBlue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filters.map((filter) {
            final isActive = filter == _activeFilter;
            return ChoiceChip(
              label: Text(filter),
              selected: isActive,
              onSelected: (_) => setState(() => _activeFilter = filter),
              selectedColor: AppTheme.accentYellow,
              labelStyle: TextStyle(
                color: isActive ? AppTheme.primaryDarkBlue : Colors.white70,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
              backgroundColor: AppTheme.secondaryNavyBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAssignmentsSection() {
    final assignments = _filteredAssignments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Assignments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${assignments.length} items',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (assignments.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildAssignmentCard(assignments[index]),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryNavyBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            color: AppTheme.accentYellow.withOpacity(0.6),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'No assignments match your filters',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try clearing the search or switching filters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final dueDate = DateFormat('MMM d').format(assignment.dueDate);
    final isOverdue = assignment.isOverdue();
    final isDueSoon = assignment.isDueSoon();
    final priorityColor = AppTheme.getPriorityColor(assignment.priority);

    return InkWell(
      onTap: () => _navigateToEditAssignment(assignment),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.secondaryNavyBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.courseName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _toggleCompletion(assignment),
                      icon: Icon(
                        assignment.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: assignment.isCompleted
                            ? AppTheme.successGreen
                            : Colors.white54,
                      ),
                      tooltip: assignment.isCompleted ? 'Mark incomplete' : 'Mark completed',
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        assignment.priority.toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              assignment.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: assignment.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isOverdue ? Icons.error : Icons.calendar_today,
                  size: 16,
                  color: isOverdue
                      ? AppTheme.warningRed
                    : (isDueSoon ? AppTheme.warningOrange : Colors.white60),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isOverdue ? 'Overdue • $dueDate' : 'Due $dueDate',
                    style: TextStyle(
                      color: isOverdue
                          ? AppTheme.warningRed
                          : (isDueSoon ? AppTheme.warningOrange : Colors.white60),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusPill(assignment.isCompleted),
                    IconButton(
                      onPressed: () => _deleteAssignment(assignment),
                      icon: const Icon(Icons.delete, size: 18),
                      color: AppTheme.warningRed,
                      tooltip: 'Delete assignment',
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isCompleted ? AppTheme.successGreen : AppTheme.warningOrange).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? 'COMPLETED' : 'IN PROGRESS',
        style: TextStyle(
          color: isCompleted ? AppTheme.successGreen : AppTheme.warningOrange,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
