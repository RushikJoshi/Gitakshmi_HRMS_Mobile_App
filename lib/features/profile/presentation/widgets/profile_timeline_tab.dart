import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileTimelineTab extends StatelessWidget {
  final EmployeeProfileModel profile;

  const ProfileTimelineTab({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    final changes = helper.auditLogs.where((l) => l.targetName == '${profile.firstName} ${profile.lastName}').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Milestones Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        ...profile.timelineActivities.map((act) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                  Container(width: 2, height: 40, color: Colors.grey.shade300),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(act.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(act.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(act.timestamp, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    const SizedBox(height: 12),
                  ],
                ),
              )
            ],
          );
        }),
        const Divider(height: 30),
        const Text('Security Audit Trails', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        if (changes.isEmpty)
          const Text('No recent profile changes audited.', style: TextStyle(fontSize: 11, color: Colors.grey))
        else
          ...changes.map((log) {
            return Card(
              color: Colors.grey.shade50,
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(log.actionType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(log.timestamp, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(log.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('Changed By: ${log.actorName}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
