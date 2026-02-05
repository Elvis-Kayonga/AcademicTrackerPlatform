import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Assignments Screen - PLACEHOLDER
/// TO BE IMPLEMENTED BY: Teammate assigned to Assignment Management
/// 
/// Required Features:
/// - Create new assignments (title, due date, course, priority)
/// - View all assignments sorted by due date
/// - Mark assignments as completed
/// - Delete assignments
/// - Edit assignment details
/// 
/// Integration:
/// - Use AppDataService from Provider.of<AppDataService>(context)
/// - Call addAssignment(), updateAssignment(), deleteAssignment(), toggleAssignmentCompletion()
class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 80,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Assignments Module',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'This screen will be implemented by\nthe teammate handling Assignment Management',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentYellow),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.accentYellow),
                        const SizedBox(width: 8),
                        Text(
                          'TODO: Implement Features',
                          style: TextStyle(
                            color: AppTheme.accentYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem('✓ Create assignment form'),
                    _buildFeatureItem('✓ Assignment list view'),
                    _buildFeatureItem('✓ Mark as completed'),
                    _buildFeatureItem('✓ Edit & delete assignments'),
                    _buildFeatureItem('✓ Filter by priority'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Assignment - To be implemented'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: AppTheme.accentYellow,
        child: const Icon(Icons.add, color: AppTheme.primaryDarkBlue),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }
}
