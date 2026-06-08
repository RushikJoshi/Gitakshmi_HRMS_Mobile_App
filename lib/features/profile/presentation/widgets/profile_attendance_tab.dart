import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileAttendanceTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final Color primaryColor;

  const ProfileAttendanceTab({
    super.key,
    required this.profile,
    required this.primaryColor,
  });

  Widget _buildStatCircle(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCircle('Present', '${profile.attendanceSummary.presentDays}d', Colors.green),
            _buildStatCircle('Late', '${profile.attendanceSummary.lateDays}d', Colors.amber),
            _buildStatCircle('Leaves', '${profile.attendanceSummary.leaveDays}d', Colors.red),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),
        _buildInfoTile('Overtime Hours', '${profile.attendanceSummary.otHours} Hrs'),
        _buildInfoTile('Working Hours (Month)', '${profile.attendanceSummary.currentMonthHours} Hrs'),
      ],
    );
  }
}
