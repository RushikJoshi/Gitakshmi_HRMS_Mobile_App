import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class LogsAnalyticsTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const LogsAnalyticsTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final totalRoles = helper.roles.length;
    final customRoles = helper.roles.where((r) => !r.isSystemDefault).length;
    final unusedRoles = helper.roles.where((r) => r.usersCount == 0).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Analytics cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              _buildAnalyticsCard('Total Roles', '$totalRoles', primaryColor),
              _buildAnalyticsCard('Custom Roles', '$customRoles', AppColors.warning),
              _buildAnalyticsCard('Unused Roles', '$unusedRoles', AppColors.error),
            ],
          ),
          const SizedBox(height: 20),

          // Audit trail
          const Text('Security Audit trail Log', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: helper.auditLogs.length,
            itemBuilder: (context, index) {
              final log = helper.auditLogs[index];
              Color actionColor = AppColors.primary;
              if (log.actionType.contains('Created')) actionColor = AppColors.success;
              if (log.actionType.contains('Override')) actionColor = AppColors.warning;
              if (log.actionType.contains('Deleted') || log.actionType.contains('Removed')) actionColor = AppColors.error;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade100)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: actionColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
                            child: Text(log.actionType, style: TextStyle(color: actionColor, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                          Text(log.timestamp, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(log.description, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('By: ${log.actorName}', style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String label, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
