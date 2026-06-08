import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class RolesCatalogTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Function(RoleModel) onEditRole;
  final Function(RoleModel) onCloneRole;
  final Function(RoleModel) onDeleteRole;

  const RolesCatalogTab({
    super.key,
    required this.helper,
    required this.onEditRole,
    required this.onCloneRole,
    required this.onDeleteRole,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: helper.roles.length,
      itemBuilder: (context, index) {
        final role = helper.roles[index];
        final isDefault = role.isSystemDefault;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            role.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              isDefault ? 'Default' : 'Custom',
                              style: TextStyle(color: isDefault ? AppColors.primary : AppColors.warning, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: (isDefault ? AppColors.primary : AppColors.warning).withValues(alpha: 0.08),
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEditRole(role);
                        } else if (value == 'clone') {
                          onCloneRole(role);
                        } else if (value == 'delete') {
                          onDeleteRole(role);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit Permissions')),
                        const PopupMenuItem(value: 'clone', child: Text('Clone Role')),
                        if (!isDefault)
                          const PopupMenuItem(value: 'delete', child: Text('Delete Role', style: TextStyle(color: AppColors.error))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(role.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_outline_rounded, size: 16, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${role.usersCount} Active Users',
                          style: const TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.security_rounded, size: 16, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${role.permissions.length} Permissions',
                          style: const TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Status: ', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        Chip(
                          label: Text(
                            role.status,
                            style: TextStyle(color: role.status == 'Active' ? AppColors.success : AppColors.error, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: (role.status == 'Active' ? AppColors.success : AppColors.error).withValues(alpha: 0.08),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
