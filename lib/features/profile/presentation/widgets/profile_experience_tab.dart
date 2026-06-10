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

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF7544FC), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F4F7)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (profile.experienceRecords.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: const Column(
              children: [
                Icon(Icons.history_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('No work experience records found.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          )
        else
          ...profile.experienceRecords.map((exp) {
            final String title = exp.companyName.isNotEmpty ? exp.companyName : 'Previous Company Details';
            return _buildSectionCard(
              title: title,
              icon: Icons.history_rounded,
              children: [
                _buildInfoTile('Company Name', exp.companyName),
                _buildInfoTile('Designation', exp.designation),
                _buildInfoTile('Department', exp.department),
                _buildInfoTile('Industry', exp.industry),
                _buildInfoTile('Joining Date', exp.joiningDate),
                _buildInfoTile('Relieving Date', exp.relievingDate),
                _buildInfoTile('Total Experience', exp.totalExperience),
                _buildInfoTile('Last Drawn Salary', exp.currentSalary),
                _buildInfoTile('Reason for Leaving', exp.reasonForLeaving),
                if (exp.attachedDoc.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        onPressed: () => openMockDocViewer(context, exp.attachedDoc, 'Experience Verification Docs'),
                        icon: Icon(Icons.attach_file_rounded, size: 16, color: primaryColor),
                        label: Text(exp.attachedDoc, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            );
          }),
        if (isHR)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mock UI: Clicked Add Prior Job Record')),
                );
              },
              icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor),
              label: Text('Add Prior Experience', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          )
      ],
    );
  }
}
