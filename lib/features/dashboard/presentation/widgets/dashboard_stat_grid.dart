import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class DashboardStatGrid extends StatelessWidget {
  const DashboardStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.baseWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.baseBlack.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Total Runtime',
              value: '00:00 Hrs',
            ),
            _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Live Status',
              value: 'Off-duty',
            ),
            _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Leave Credit',
              value: '0 days',
            ),
            _buildStatCard(
              icon: Icons.close_rounded,
              title: 'Internal Roles',
              value: '0 application',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Off-white/gray50 background inside the main card
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.gray200, // Slightly darker grey for contrast
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: AppColors.gray500,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
