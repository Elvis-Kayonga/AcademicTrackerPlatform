import 'package:flutter/material.dart';

/// ALU Academic Assistant - Official Color Palette
/// 
/// This color palette is carefully designed for optimal accessibility and
/// visual consistency across the application. All colors meet WCAG AA standards
/// for contrast ratios.
/// 
/// Extracted from the official design screenshot.
///
/// Usage: Import this file and use AppColors.colorName
/// Example: Container(color: AppColors.primaryNavy)

class AppColors {
  // ========== PRIMARY COLORS ==========
  
  /// Deep navy blue - primary background color for the entire app
  /// Used for scaffolds, main backgrounds, and primary UI surfaces
  static const Color primaryNavy = Color(0xFF0A1628);
  
  /// Bright yellow - accent color for buttons, highlights, and CTAs
  /// Provides strong contrast against dark backgrounds
  static const Color accentYellow = Color(0xFFFFC107);

  // ========== STATUS & SEMANTIC COLORS ==========
  
  /// Red color for error states, warnings, and at-risk status indicators
  static const Color dangerRed = Color(0xFFE53935);
  
  /// Orange color for medium priority and warning states
  static const Color warningOrange = Color(0xFFFF9800);
  
  /// Green color for success states and positive indicators
  static const Color successGreen = Color(0xFF4CAF50);

  // ========== CARD & CONTAINER COLORS ==========
  
  /// Slightly lighter navy for card backgrounds - provides visual separation
  static const Color cardBackground = Color(0xFF1A2332);
  
  /// Even darker shade for nested or layered card components
  static const Color darkCard = Color(0xFF0D1620);

  // ========== TEXT COLORS ==========
  
  /// Primary text color - white for maximum contrast on dark backgrounds
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// Secondary text color - light gray for supporting text and subtitles
  static const Color textSecondary = Color(0xFFB0BEC5);
  
  /// Muted gray - used for hints, labels, and less important text
  static const Color textMuted = Color(0xFF78909C);

  // ========== BORDER & DIVIDER COLORS ==========
  
  /// Subtle color for borders and lines
  static const Color borderColor = Color(0xFF263238);
  
  /// Color for dividers separating content sections
  static const Color dividerColor = Color(0xFF37474F);

  // ========== TAG & BADGE COLORS ==========
  
  /// Light yellow background for status tags
  static const Color tagYellow = Color(0xFFFFF9C4);
  
  /// Dark text color to display on yellow tags for readability
  static const Color tagYellowText = Color(0xFF827717);
  
  /// Light blue background for tag components
  static const Color tagBlue = Color(0xFFBBDEFB);
  
  /// Light green background for success tags
  static const Color tagGreen = Color(0xFFC8E6C9);

  // ========== RISK STATUS COLORS ==========
  
  /// High risk indicator (75% attendance) - displayed in red
  static const Color riskHigh = Color(0xFFE53935);
  
  /// Medium risk indicator (80% attendance) - displayed in yellow
  static const Color riskMedium = Color(0xFFFFC107);
  
  /// Low risk indicator (63% attendance and above) - displayed in green
  static const Color riskLow = Color(0xFF66BB6A);

  // ========== NAVIGATION COLORS ==========
  
  /// Color for selected navigation items - bright yellow
  static const Color navSelected = Color(0xFFFFC107);
  
  /// Color for unselected navigation items - muted gray
  static const Color navUnselected = Color(0xFF78909C);

  // ========== FORM ELEMENT COLORS ==========
  
  /// Background color for text input fields
  static const Color inputBackground = Color(0xFF1A2332);
  
  /// Border color for input fields in normal state
  static const Color inputBorder = Color(0xFF37474F);
  
  /// Border color for input fields when focused - bright yellow
  static const Color inputFocusBorder = Color(0xFFFFC107);

  // ========== DISABLED STATE COLORS ==========
  
  /// Background color for disabled interactive elements
  static const Color disabled = Color(0xFF546E7A);
  
  /// Text color for disabled elements
  static const Color disabledText = Color(0xFF90A4AE);

  // Prevent instantiation
  AppColors._();
}
