import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo Accent
  static const Color secondary = Color(0xFF4F46E5); // Darker Indigo
  static const Color background = Color(0xFFF9FAFB); // Premium Light Gray
  static const Color surface = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color error = Color(0xFFEF4444); // Rose Red
  static const Color warning = Color(0xFFF59E0B); // Amber Yellow
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // Timer / Break Colors
  static const Color timerWorking = Color(0xFF3B82F6); // Blue
  static const Color timerLunch = Color(0xFFFBBF24); // Yellow
  static const Color timerShortBreak = Color(0xFFF97316); // Orange
  static const Color timerExtraBreak = Color(0xFFEF4444); // Red
  static const Color timerOvertime = Color(0xFF8B5CF6); // Purple
  static const Color timerEarlyOut = Color(0xFF6B7280); // Grey

  // Calendar Status Colors
  static const Color calPresent = Color(0xFF10B981); // Green
  static const Color calLeave = Color(0xFF8B5CF6); // Purple
  static const Color calAbsent = Color(0xFFEF4444); // Red
  static const Color calLate = Color(0xFFF97316); // Orange
  static const Color calEarlyOut = Color(0xFF6B7280); // Grey
  static const Color calHoliday = Color(0xFF3B82F6); // Blue
  static const Color calWeekOff = Color(0xFF111827); // Dark Slate/Black
  
  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textLight = Color(0xFF9CA3AF);
  
  // Custom Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
