import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/cards/app_card.dart';
import 'package:gitakshmi_hrms_app/core/widgets/loaders/app_progress_indicator.dart';

class OvertimeAnalyticsCard extends StatelessWidget {
  const OvertimeAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Overtime Analytics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              _buildOTBar('Marketing Team', '14.5 Hrs', 0.65, AppColors.primary),
              const Divider(height: 24),
              _buildOTBar('Engineering Team', '22.0 Hrs', 0.85, AppColors.timerOvertime),
              const Divider(height: 24),
              _buildOTBar('Sales Team', '8.0 Hrs', 0.35, AppColors.info),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOTBar(String team, String hours, double ratio, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              team,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              hours,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppProgressBar(
          value: ratio,
          color: barColor,
          backgroundColor: Colors.grey.shade100,
          minHeight: 6,
        ),
      ],
    );
  }
}

