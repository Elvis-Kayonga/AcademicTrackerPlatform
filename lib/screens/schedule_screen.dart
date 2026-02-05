import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Schedule Screen - PLACEHOLDER
/// TO BE IMPLEMENTED BY: Teammate assigned to Schedule Management
/// 
/// Required Features:
/// - Create new academic sessions (title, date, time, location, type)
/// - View weekly schedule
/// - Record attendance (Present/Absent toggle)
/// - Delete sessions
/// - Edit session details
/// 
/// Session Types: Class, Mastery Session, Study Group, PSL Meeting
/// 
/// Integration:
/// - Use AppDataService from Provider.of<AppDataService>(context)
/// - Call addSession(), updateSession(), deleteSession(), toggleSessionAttendance()
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
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
                Icons.calendar_today_outlined,
                size: 80,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Schedule Module',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'This screen will be implemented by\nthe teammate handling Schedule Management',
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
                    _buildFeatureItem('✓ Create session form'),
                    _buildFeatureItem('✓ Weekly calendar view'),
                    _buildFeatureItem('✓ Attendance toggle'),
                    _buildFeatureItem('✓ Edit & delete sessions'),
                    _buildFeatureItem('✓ Filter by session type'),
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
              content: Text('Add Session - To be implemented'),
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
