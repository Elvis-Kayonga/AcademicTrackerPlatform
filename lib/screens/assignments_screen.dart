import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2845),
        title: const Text(
          'Assignments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 64,
              color: const Color(0xFFFFC107).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assignments - Coming Soon',
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
