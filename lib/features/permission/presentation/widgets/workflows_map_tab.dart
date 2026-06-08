import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class WorkflowsMapTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const WorkflowsMapTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: helper.workflows.length,
      itemBuilder: (context, index) {
        final wf = helper.workflows[index];
        final approvers = helper.getAuthorizedApprovers(wf.requiredPermission);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(wf.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        'Key: ${wf.requiredPermission}',
                        style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(wf.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const Divider(height: 24),
                const Text('Dynamic Authorized Approvers List:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                const SizedBox(height: 8),
                if (approvers.isEmpty)
                  const Text('🚨 No users have permission to approve this flow!', style: TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold))
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: approvers.map((appr) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(appr.name.split(' ').map((n) => n[0]).join(), style: TextStyle(fontSize: 8, color: primaryColor, fontWeight: FontWeight.bold)),
                        ),
                        label: Text(appr.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide(color: Colors.grey.shade200),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
