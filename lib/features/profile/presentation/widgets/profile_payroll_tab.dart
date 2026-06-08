import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfilePayrollTab extends StatelessWidget {
  final EmployeeProfileModel profile;

  const ProfilePayrollTab({
    super.key,
    required this.profile,
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
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Compensation Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
        ),
        const SizedBox(height: 8),
        _buildInfoTile('Basic Monthly Salary', profile.payrollSummary.currentSalary),
        _buildInfoTile('Calculated Annual CTC', profile.payrollSummary.ctc),
        _buildInfoTile('Income Tax Summary', profile.payrollSummary.taxDetails),
      ],
    );
  }
}
