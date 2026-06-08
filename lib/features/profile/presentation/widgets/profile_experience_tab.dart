import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileExperienceTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final bool isHR;
  final Color primaryColor;
  final StateSetter setModalState;
  final Function(BuildContext, String, String) openMockDocViewer;

  const ProfileExperienceTab({
    super.key,
    required this.profile,
    required this.isHR,
    required this.primaryColor,
    required this.setModalState,
    required this.openMockDocViewer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...profile.experienceRecords.map((exp) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exp.companyName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                      ),
                      Icon(Icons.history_rounded, color: primaryColor, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Role: ${exp.designation} (${exp.department})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Duration: ${exp.joiningDate} to ${exp.relievingDate} (${exp.totalExperience})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Last Salary: ${exp.currentSalary} LPA', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Reason for Leaving: ${exp.reasonForLeaving}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => openMockDocViewer(context, exp.attachedDoc, 'Experience Verification Docs'),
                    icon: Icon(Icons.attach_file_rounded, size: 16, color: primaryColor),
                    label: Text(exp.attachedDoc, style: TextStyle(color: primaryColor, fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        }),
        if (isHR)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(side: BorderSide(color: primaryColor)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mock UI: Clicked Add Prior Job Record')),
              );
            },
            icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor),
            label: Text('Add Prior Experience', style: TextStyle(color: primaryColor)),
          )
      ],
    );
  }
}
