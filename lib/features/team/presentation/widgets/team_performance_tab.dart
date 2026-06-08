import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class TeamPerformanceTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final bool active;

  const TeamPerformanceTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.active,
  });

  Widget _buildLockedView(String permissionRequired) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.textLight),
            const SizedBox(height: 16),
            const Text('Feature Restricted', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              'Requires "$permissionRequired" permissions in active context.',
              style: const TextStyle(fontSize: 11, color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimesheetStat(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!active) return _buildLockedView('view_team_timesheet');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: helper.teamTimesheets.length,
      itemBuilder: (context, index) {
        final ts = helper.teamTimesheets[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ts.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                    Chip(
                      label: Text(ts.dept, style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      backgroundColor: primaryColor.withValues(alpha: 0.08),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimesheetStat('Hours', ts.workingHours),
                    _buildTimesheetStat('Late', '${ts.lateCount}x'),
                    _buildTimesheetStat('Absent', '${ts.absentCount}x'),
                    _buildTimesheetStat('OT', ts.overtime),
                    _buildTimesheetStat('Breaks', ts.breakDuration),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
