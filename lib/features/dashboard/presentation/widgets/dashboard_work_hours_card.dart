import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class DashboardWorkHoursCard extends StatelessWidget {
  const DashboardWorkHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Work Hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      _buildLegendDot(AppColors.purple600, 'Hours'),
                      const SizedBox(width: 14),
                      DropdownButton<String>(
                        value: 'This Week',
                        items: ['This Week', 'Last Week'].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (_) {},
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Custom painted weekly bar chart representation
              SizedBox(
                height: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildWeeklyBar('Mon', 0.6),
                    _buildWeeklyBar('Tue', 0.4),
                    _buildWeeklyBar('Wed', 0.6),
                    _buildWeeklyBar('Thu', 0.7),
                    _buildWeeklyBar('Fri', 0.9),
                    _buildWeeklyBar('Sat', 0.8),
                    _buildWeeklyBar('Sun', 0.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyBar(String day, double percent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: 90 * percent,
          decoration: BoxDecoration(
            color: AppColors.purple600,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
