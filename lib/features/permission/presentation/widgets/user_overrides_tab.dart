import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class UserOverridesTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final Function(EmployeeModel) onConfigureUser;

  const UserOverridesTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.onConfigureUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: helper.employees.length,
      itemBuilder: (context, index) {
        final emp = helper.employees[index];
        final role = helper.roles.firstWhere((r) => r.id == emp.roleId, orElse: () => helper.roles.first);
        final finalPermCount = helper.getFinalPermissions(emp.id).length;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  radius: 22,
                  child: Text(
                    emp.name.split(' ').map((n) => n[0]).join(),
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('Default Role: ${role.name}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (emp.extraPermissions.isNotEmpty)
                            Chip(
                              label: Text('+${emp.extraPermissions.length} Extra', style: const TextStyle(color: AppColors.success, fontSize: 9, fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.success.withValues(alpha: 0.08),
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                            ),
                          if (emp.restrictedPermissions.isNotEmpty)
                            Chip(
                              label: Text('-${emp.restrictedPermissions.length} Restricted', style: const TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.error.withValues(alpha: 0.08),
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                            ),
                          Chip(
                            label: Text('$finalPermCount Active Auth', style: const TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => onConfigureUser(emp),
                  icon: const Icon(Icons.settings_suggest_rounded),
                  color: primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
