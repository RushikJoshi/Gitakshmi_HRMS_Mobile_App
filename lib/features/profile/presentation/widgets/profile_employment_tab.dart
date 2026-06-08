import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileEmploymentTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final bool isHR;
  final bool canViewPayroll;

  const ProfileEmploymentTab({
    super.key,
    required this.profile,
    required this.isHR,
    required this.canViewPayroll,
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
    final helper = RolePermissionHelper.instance;
    final emp = helper.employees.firstWhere((e) => e.id == profile.employeeId);

    return Column(
      children: [
        _buildInfoTile('Employee Code', profile.employeeCode),
        _buildInfoTile('Reporting Manager', 'Riya Sharma (TL)'),
        _buildInfoTile('Branch Assignment', 'Surat Regional HQs'),
        _buildInfoTile('Employment Category', 'Permanent Full-Time'),
        _buildInfoTile('Standard Shift timing', '09:00 AM to 06:00 PM'),
        _buildInfoTile('Designated Week Off', 'Sunday'),
        _buildInfoTile('Current System Role', emp.roleId == 'r_admin' ? 'Admin Superuser' : emp.roleId == 'r_hr' ? 'HR Specialist' : emp.roleId == 'r_tl' ? 'Team Lead' : 'Employee Staff'),
        if (canViewPayroll) ...[
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Compensation Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
          ),
          _buildInfoTile('Basic Monthly Salary', profile.payrollSummary.currentSalary),
          _buildInfoTile('Calculated Annual CTC', profile.payrollSummary.ctc),
          _buildInfoTile('Income Tax Summary', profile.payrollSummary.taxDetails),
        ]
      ],
    );
  }
}
