import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2F648E);
  static const Color secondary = Color(0xFF2FBBA4);
  static const Color background = Color(0xFFF9FAFB); // Premium Light Gray
  static const Color surface = Colors.white;
  
  // New Brand Colors requested
  static const Color myCoCyan = Color(0xFF08A4BB);
  static const Color backgroundPrimary = Color(0xFFFAFAFF);
  static const Color bgWhite = Color(0xFFFFFFFF);

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
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF475467);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textGray = Color(0xFF7C7C7C);

  // Surface Colors
  static const Color surfacePrimary = Color(0xFFF5F5F5);

  // Border Colors
  static const Color textfieldBorder = Color(0xFF98A2B3);

  // Gradient Colors
  static const Color gradient1 = Color(0xFF2E8EFF);
  static const Color gradient2 = Color(0xFF7155FF);

  // Onboarding Colors
  static const Color on_gradient1 = Color(0xFF7A5AF8);
  static const Color on_gradient2 = Color(0xFFFFFFFF);

  // Button Gradient Colors
  static const Color button_grad_1 = Color(0xFF8862F2);
  static const Color button_grad_2 = Color(0xFF7544FC);
  static const Color button_grad_3 = Color(0xFF5B2ED4);
  static const Color border = Color(0xFF7A5AF8);

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

  static const Gradient splashGradient = LinearGradient(
    colors: [gradient1, gradient2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Compatibility colors to prevent errors in dashboard widgets
  static const Color baseWhite = Colors.white;
  static const Color baseBlack = Color(0xFF101828);
  static const Color gray200 = Color(0xFFE4E7EC);
  static const Color gray400 = Color(0xFF98A2B3);
  static const Color gray500 = Color(0xFF667085);
  static const Color gray600 = Color(0xFF475467);
  static const Color purple100 = Color(0xFFEBE9FE);
  static const Color purple600 = Color(0xFF6938EF);
  static const Color error300 = Color(0xFFFDA29B);
  static const Color error500 = Color(0xFFF04438);
  static const Color blue500 = Color(0xFF3F81FF);
  static const Color blue600 = Color(0xFF2667E0);
}
