import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class AttendanceStatsGrid extends StatelessWidget {
  final int presentDays;
  final int lateDays;
  final int earlyOutDays;
  final int absentDays;
  final int leaveDays;
  final String workingHours;
  final String overtimeHours;
  final bool mockGpsDetected;

  const AttendanceStatsGrid({
    super.key,
    required this.presentDays,
    required this.lateDays,
    required this.earlyOutDays,
    required this.absentDays,
    required this.leaveDays,
    required this.workingHours,
    required this.overtimeHours,
    required this.mockGpsDetected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 1.1,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildStatTile('Present', '$presentDays Days', AppColors.success),
        _buildStatTile('Late', '$lateDays Days', AppColors.warning),
        _buildStatTile('Early Out', '$earlyOutDays Day', AppColors.calEarlyOut),
        _buildStatTile('Absent', '$absentDays Day', AppColors.error),
        _buildStatTile('Leaves', '$leaveDays Days', AppColors.calLeave),
        _buildStatTile('Working', workingHours, AppColors.primary),
        _buildStatTile('OT Hours', overtimeHours, AppColors.timerOvertime),
        _buildStatTile(
          'Mock GPS',
          mockGpsDetected ? 'ALERT 🚨' : 'SAFE ✅',
          mockGpsDetected ? AppColors.error : AppColors.success,
        ),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
