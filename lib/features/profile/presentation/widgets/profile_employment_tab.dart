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
    final helper = RolePermissionHelper.instance;
    final apiData = helper.apiResponses[profile.employeeId] ?? {};

    final code = apiData['employee_code'] ?? apiData['employeeCode'] ?? apiData['code'] ?? apiData['employeeId'] ?? '-';
    final designation = apiData['designation'] ?? apiData['position'] ?? apiData['role'] ?? '-';
    final department = apiData['department'] ?? apiData['dept'] ?? '-';
    final empCategory = apiData['employment_category'] ?? apiData['employment_type'] ?? apiData['type'] ?? apiData['employeeType'] ?? '-';
    final joiningDate = apiData['joiningDate'] ?? apiData['joining_date'] ?? apiData['date_of_joining'] ?? apiData['joining'] ?? '-';
    final workMode = apiData['workMode'] ?? apiData['work_mode'] ?? '-';
    
    final shiftTiming = apiData['shift'] ?? apiData['shift_timing'] ?? apiData['timings'] ?? '-';
    final weekOff = apiData['week_off'] ?? apiData['week_off_day'] ?? apiData['weekoff'] ?? '-';

    final basicSalary = apiData['salary'] ?? apiData['monthly_salary'] ?? apiData['basic_salary'] ?? '-';
    final ctc = apiData['ctc'] ?? apiData['annual_ctc'] ?? '-';
    final taxDetails = apiData['tax_details'] ?? apiData['tax'] ?? '-';

    return Column(
      children: [
        _buildSectionCard(
          title: 'Employment Details',
          icon: Icons.business_center_rounded,
          children: [
            _buildInfoTile('Employee Code', code.toString()),
            _buildInfoTile('Designated Role', designation.toString()),
            _buildInfoTile('Department', department.toString()),
            _buildInfoTile('Employment Category', empCategory.toString()),
            _buildInfoTile('Work Mode', workMode.toString()),
            _buildInfoTile('Date of Joining', joiningDate.toString()),
          ],
        ),
        _buildSectionCard(
          title: 'Shift Details',
          icon: Icons.schedule_rounded,
          children: [
            _buildInfoTile('Standard Shift timing', shiftTiming.toString()),
            _buildInfoTile('Designated Week Off', weekOff.toString()),
          ],
        ),
        if (canViewPayroll)
          _buildSectionCard(
            title: 'Compensation Details',
            icon: Icons.payments_rounded,
            children: [
              _buildInfoTile('Basic Monthly Salary', basicSalary.toString()),
              _buildInfoTile('Calculated Annual CTC', ctc.toString()),
              _buildInfoTile('Income Tax Summary', taxDetails.toString()),
            ],
          ),
      ],
    );
  }
}
