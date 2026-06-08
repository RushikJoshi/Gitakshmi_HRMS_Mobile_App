import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double minHeight;
  final double borderRadius;

  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.success,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.minHeight = 8.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LinearProgressIndicator(
        value: value,
        color: color,
        backgroundColor: backgroundColor,
        minHeight: minHeight,
      ),
    );
  }
}

class AppCircularProgress extends StatelessWidget {
  final double? value;
  final Color? color;
  final double strokeWidth;

  const AppCircularProgress({
    super.key,
    this.value,
    this.color,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
