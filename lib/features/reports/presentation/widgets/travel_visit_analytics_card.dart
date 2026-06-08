import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/cards/app_card.dart';

class TravelVisitAnalyticsCard extends StatelessWidget {
  const TravelVisitAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Travel Visit Analytics',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTravelMetric('Assigned', '18'),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  _buildTravelMetric('Completed', '12'),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  _buildTravelMetric('Pending', '6'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTravelMetric(String label, String count) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

