import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class TeamTrackingTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final bool active;
  final List<String> permissions;
  final Function(BuildContext, RolePermissionHelper, Color) showAssignVisitDialog;

  const TeamTrackingTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.active,
    required this.permissions,
    required this.showAssignVisitDialog,
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
    if (!active) return _buildLockedView('view_team_tracking');

    final canAssign = permissions.contains('create_visit_for_team');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Client Visits Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              if (canAssign)
                OutlinedButton.icon(
                  onPressed: () => showAssignVisitDialog(context, helper, primaryColor),
                  icon: const Icon(Icons.add_location_alt_rounded, size: 14),
                  label: const Text('Assign Visit', style: TextStyle(fontSize: 11)),
                )
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: helper.teamVisits.length,
            itemBuilder: (context, index) {
              final tv = helper.teamVisits[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (tv.status == 'Completed' ? AppColors.success : AppColors.primary).withValues(alpha: 0.1),
                    child: Icon(tv.status == 'Completed' ? Icons.check_circle_rounded : Icons.directions_car_rounded, color: tv.status == 'Completed' ? AppColors.success : AppColors.primary),
                  ),
                  title: Text(tv.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Location: ${tv.location} • Time: ${tv.time}\nRepresentative: ${tv.employeeName}'),
                  trailing: Chip(
                    label: Text(tv.status, style: TextStyle(color: tv.status == 'Completed' ? AppColors.success : AppColors.warning, fontSize: 8, fontWeight: FontWeight.bold)),
                    backgroundColor: (tv.status == 'Completed' ? AppColors.warning : AppColors.warning).withValues(alpha: 0.08),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
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
