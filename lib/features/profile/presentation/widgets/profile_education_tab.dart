import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileEducationTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final bool isHR;
  final Color primaryColor;
  final StateSetter setModalState;
  final Function(BuildContext, String, String) openMockDocViewer;

  const ProfileEducationTab({
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
        ...profile.educationRecords.map((edu) {
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
                        edu.qualification,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                      ),
                      Icon(Icons.school_rounded, color: primaryColor, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Course: ${edu.course} (${edu.specialization})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Institute: ${edu.institute}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('University: ${edu.university} (${edu.passingYear})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Percentage / CGPA: ${edu.percentage}', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => openMockDocViewer(context, edu.attachedDoc, 'Marksheet & Certificates'),
                    icon: Icon(Icons.attach_file_rounded, size: 16, color: primaryColor),
                    label: Text(edu.attachedDoc, style: TextStyle(color: primaryColor, fontSize: 12)),
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
                const SnackBar(content: Text('Mock UI: Clicked Add Education Record')),
              );
            },
            icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor),
            label: Text('Add Qualification', style: TextStyle(color: primaryColor)),
          )
      ],
    );
  }
}
