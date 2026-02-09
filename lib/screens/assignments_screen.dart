import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../database/database_helper.dart';
import '../utils/app_theme.dart';
import 'assignment_form_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> with SingleTickerProviderStateMixin {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late TabController _tabController;
  List<Assignment> _allAssignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAssignments();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  List<Assignment> _getFilteredAssignments(int tabIndex) {
    switch (tabIndex) {
      case 0: // All
        return _allAssignments;
      case 1: // Formative (we'll use this for pending assignments)
        return _allAssignments.where((a) => !a.isCompleted).toList();
      case 2: // Summative (we'll use this for completed assignments)
        return _allAssignments.where((a) => a.isCompleted).toList();
      default:
        return _allAssignments;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppTheme.highPriority;
      case 'Medium':
        return AppTheme.mediumPriority;
      case 'Low':
        return AppTheme.lowPriority;
      default:
        return AppTheme.mediumPriority;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    final difference = dueDate.difference(today).inDays;

    if (difference == 0) {
      return 'Due Today';
    } else if (difference == 1) {
      return 'Due Tomorrow';
    } else if (difference < 0) {
      return 'Overdue';
    } else {
      return 'Due ${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDarkBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryNavyBlue,
        title: const Text(
          'Assignments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.accentYellow,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.accentYellow,
          onTap: (index) {
            setState(() {}); // Refresh to show filtered data
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentYellow,
              ),
            )
          : _buildAssignmentsList(),
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

  Widget _buildAssignmentsList() {
    return TabBarView(
      controller: _tabController,
      children: List.generate(3, (index) {
        final filteredAssignments = _getFilteredAssignments(index);
        
        if (filteredAssignments.isEmpty) {
          return _buildEmptyState(index);
        }

        return RefreshIndicator(
          onRefresh: _loadAssignments,
          color: AppTheme.accentYellow,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredAssignments.length,
            itemBuilder: (context, idx) {
              final assignment = filteredAssignments[idx];
              return _buildAssignmentCard(assignment);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(int tabIndex) {
    String message;
    IconData icon;
    
    switch (tabIndex) {
      case 0:
        message = 'No assignments yet\nTap + to create one';
        icon = Icons.assignment;
        break;
      case 1:
        message = 'No pending assignments\nYou\'re all caught up!';
        icon = Icons.check_circle_outline;
        break;
      case 2:
        message = 'No completed assignments yet\nKeep working!';
        icon = Icons.assignment_turned_in;
        break;
      default:
        message = 'No assignments';
        icon = Icons.assignment;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.accentYellow.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final isOverdue = assignment.isOverdue();
    final isDueSoon = assignment.isDueSoon() && !assignment.isCompleted;

    return Card(
      color: AppTheme.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOverdue && !assignment.isCompleted
              ? AppTheme.warningRed.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToEditAssignment(assignment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Completion Checkbox
                  InkWell(
                    onTap: () => _toggleCompletion(assignment),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: assignment.isCompleted
                            ? AppTheme.successGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: assignment.isCompleted
                              ? AppTheme.successGreen
                              : AppTheme.textSecondary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: assignment.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Title and Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment.title,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: assignment.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignment.courseName,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(assignment.priority).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getPriorityColor(assignment.priority),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      assignment.priority,
                      style: TextStyle(
                        color: _getPriorityColor(assignment.priority),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Due Date and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isOverdue && !assignment.isCompleted
                            ? AppTheme.warningRed
                            : isDueSoon
                                ? AppTheme.warningOrange
                                : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDueDate(assignment.dueDate),
                        style: TextStyle(
                          color: isOverdue && !assignment.isCompleted
                              ? AppTheme.warningRed
                              : isDueSoon
                                  ? AppTheme.warningOrange
                                  : AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: isOverdue || isDueSoon
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  
                  // Action Buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: AppTheme.accentYellow,
                        onPressed: () => _navigateToEditAssignment(assignment),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: AppTheme.warningRed,
                        onPressed: () => _deleteAssignment(assignment),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
