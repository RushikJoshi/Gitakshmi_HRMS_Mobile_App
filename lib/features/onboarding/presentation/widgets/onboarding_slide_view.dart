import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class OnboardingSlideView extends StatelessWidget {
  final Map<String, String> slide;

  const OnboardingSlideView({super.key, required this.slide});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'corporate_fare':
        return Icons.corporate_fare_rounded;
      case 'fingerprint':
        return Icons.fingerprint_rounded;
      case 'assignment_turned_in':
        return Icons.assignment_turned_in_rounded;
      default:
        return Icons.rocket_launch_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(slide["icon"]!),
              size: 100,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            slide["title"]!,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide["description"]!,
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
