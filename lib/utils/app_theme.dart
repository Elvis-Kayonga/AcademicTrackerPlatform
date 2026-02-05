import 'package:flutter/material.dart';

/// ALU Brand Colors Theme
/// Maintains consistency across all screens
class AppTheme {
  // Primary ALU Colors
  static const Color primaryDarkBlue = Color(0xFF0A1929);
  static const Color secondaryNavyBlue = Color(0xFF1A2332);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color warningRed = Color(0xFFE74C3C);
  static const Color warningOrange = Color(0xFFFF9800);
  
  // Additional Colors
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color successGreen = Color(0xFF4CAF50);
  
  // Status Colors
  static const Color highPriority = Color(0xFFE74C3C);
  static const Color mediumPriority = Color(0xFFFF9800);
  static const Color lowPriority = Color(0xFF4CAF50);
  
  // Attendance Status Colors
  static const Color attendanceGood = Color(0xFF4CAF50); // >= 75%
  static const Color attendanceWarning = Color(0xFFFF9800); // 65-74%
  static const Color attendanceDanger = Color(0xFFE74C3C); // < 65%

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDarkBlue,
      scaffoldBackgroundColor: primaryDarkBlue,
      colorScheme: const ColorScheme.dark(
        primary: accentYellow,
        secondary: warningRed,
        surface: cardBackground,
        onPrimary: primaryDarkBlue,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDarkBlue,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryNavyBlue,
        selectedItemColor: accentYellow,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentYellow,
          foregroundColor: primaryDarkBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
    );
  }

  /// Get color based on priority level
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return highPriority;
      case 'medium':
        return mediumPriority;
      case 'low':
        return lowPriority;
      default:
        return mediumPriority;
    }
  }

  /// Get color based on attendance percentage
  static Color getAttendanceColor(double percentage) {
    if (percentage >= 75) {
      return attendanceGood;
    } else if (percentage >= 65) {
      return attendanceWarning;
    } else {
      return attendanceDanger;
    }
  }
}
