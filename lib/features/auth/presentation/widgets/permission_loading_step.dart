import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class PermissionLoadingStep extends StatelessWidget {
  const PermissionLoadingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Spacer(),
        Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        SizedBox(height: 24),
        Text(
          'Fetching Custom Permissions...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Building layout settings dynamically based on your enterprise role...',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        Spacer(),
      ],
    );
  }
}
