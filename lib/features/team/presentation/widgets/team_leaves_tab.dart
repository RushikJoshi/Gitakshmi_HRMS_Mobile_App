import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class TeamLeavesTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final bool active;
  final List<String> permissions;
  final Function(BuildContext, RolePermissionHelper, Color, EmployeeModel?) showLeaveOnBehalfDialog;

  const TeamLeavesTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.active,
    required this.permissions,
    required this.showLeaveOnBehalfDialog,
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

  @override
  Widget build(BuildContext context) {
    if (!active) return _buildLockedView('view_team_leave');

    final canCancel = permissions.contains('cancel_leave_for_team');
    final canApply = permissions.contains('apply_leave_for_team');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Team Leave Records', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              if (canApply)
                OutlinedButton.icon(
                  onPressed: () => showLeaveOnBehalfDialog(context, helper, primaryColor, null),
                  icon: const Icon(Icons.post_add_rounded, size: 14),
                  label: const Text('Apply On Behalf', style: TextStyle(fontSize: 11)),
                )
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: helper.teamLeaves.length,
            itemBuilder: (context, index) {
              final tl = helper.teamLeaves[index];
              final isCancelled = tl.status.contains('Cancelled');

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
                          Text(tl.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                          Chip(
                            label: Text(tl.status, style: TextStyle(color: isCancelled ? AppColors.error : AppColors.success, fontSize: 8, fontWeight: FontWeight.bold)),
                            backgroundColor: (isCancelled ? AppColors.error : AppColors.success).withValues(alpha: 0.08),
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Leave: ${tl.leaveType} (${tl.dateRange})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('Reason: ${tl.reason}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Submitted by ${tl.appliedBy} on ${tl.timestamp}', style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                          if (canCancel && !isCancelled)
                            TextButton.icon(
                              onPressed: () => helper.cancelLeaveOnBehalf(tl.id),
                              icon: const Icon(Icons.cancel_presentation_rounded, size: 12, color: AppColors.error),
                              label: const Text('Cancel Request', style: TextStyle(color: AppColors.error, fontSize: 10)),
                              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            )
                        ],
                      )
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
