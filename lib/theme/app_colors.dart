import 'package:flutter/material.dart';

/// ALU Academic Assistant - Official Color Palette
/// Extracted from the official design screenshot
///
/// Usage: Import this file and use AppColors.colorName
/// Example: Container(color: AppColors.primaryNavy)

class AppColors {
  // Primary Colors
  static const Color primaryNavy = Color(
    0xFF0A1628,
  ); // Deep navy blue - main background
  static const Color accentYellow = Color(
    0xFFFFC107,
  ); // Bright yellow - buttons, highlights

  // Status Colors
  static const Color dangerRed = Color(
    0xFFE53935,
  ); // Red - warnings, at-risk status
  static const Color warningOrange = Color(
    0xFFFF9800,
  ); // Orange - medium priority
  static const Color successGreen = Color(0xFF4CAF50); // Green - success states

  // Card & Container Colors
  static const Color cardBackground = Color(
    0xFF1A2332,
  ); // Slightly lighter navy for cards
  static const Color darkCard = Color(
    0xFF0D1620,
  ); // Even darker for nested cards

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White - primary text
  static const Color textSecondary = Color(
    0xFFB0BEC5,
  ); // Light gray - secondary text
  static const Color textMuted = Color(
    0xFF78909C,
  ); // Muted gray - hints, labels

  // Border & Divider Colors
  static const Color borderColor = Color(0xFF263238); // Subtle borders
  static const Color dividerColor = Color(
    0xFF37474F,
  ); // Dividers between sections

  // Tag Colors (for assignment status, priority levels)
  static const Color tagYellow = Color(
    0xFFFFF9C4,
  ); // Light yellow tag background
  static const Color tagYellowText = Color(
    0xFF827717,
  ); // Dark text on yellow tag
  static const Color tagBlue = Color(0xFFBBDEFB); // Light blue tag
  static const Color tagGreen = Color(0xFFC8E6C9); // Light green tag

  // Risk Status Colors (for attendance tracking)
  static const Color riskHigh = Color(0xFFE53935); // 75% - Red
  static const Color riskMedium = Color(0xFFFFC107); // 80% - Yellow
  static const Color riskLow = Color(0xFF66BB6A); // 63% - Green (safe)

  // Bottom Navigation
  static const Color navSelected = Color(0xFFFFC107); // Yellow when selected
  static const Color navUnselected = Color(0xFF78909C); // Gray when unselected

  // Form Elements
  static const Color inputBackground = Color(0xFF1A2332);
  static const Color inputBorder = Color(0xFF37474F);
  static const Color inputFocusBorder = Color(0xFFFFC107);

  // Disabled state
  static const Color disabled = Color(0xFF546E7A);
  static const Color disabledText = Color(0xFF90A4AE);

  // Prevent instantiation
  AppColors._();
}
