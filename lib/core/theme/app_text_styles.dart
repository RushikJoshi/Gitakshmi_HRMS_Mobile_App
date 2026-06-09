import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle get h1 => TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle get h3 => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );
}
