import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class TeamOrgChartTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final bool active;

  const TeamOrgChartTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.active,
  });

  Widget _buildKPI(String label, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    if (!active) return _buildLockedView('view_team_attendance');

    final presentCount = 20 + helper.teamAttendanceLogs.length;
    const absentCount = 2;
    const lateCount = 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stat grid
          Row(
            children: [
              Expanded(child: _buildKPI('Present', '$presentCount', AppColors.success)),
              const SizedBox(width: 8),
              Expanded(child: _buildKPI('Absent', '$absentCount', AppColors.error)),
              const SizedBox(width: 8),
              Expanded(child: _buildKPI('Late check', '$lateCount', AppColors.warning)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Live Logs & Corrections', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: helper.teamAttendanceLogs.length,
            itemBuilder: (context, index) {
              final tc = helper.teamAttendanceLogs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tc.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                          Text(tc.date, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Punch Adjusted: ${tc.punchIn} to ${tc.punchOut}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('Reason: ${tc.reason}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textLight)),
                      const Divider(height: 16),
                      Text('Corrected By: ${tc.correctedBy} on ${tc.timestamp}', style: const TextStyle(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
