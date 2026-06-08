import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileLeavesTab extends StatelessWidget {
  final EmployeeProfileModel profile;

  const ProfileLeavesTab({
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
          child: Text('Leave Balances', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 8),
        _buildInfoTile('Available Leave Balance', '${profile.leaveSummary.availableLeave} Days'),
        _buildInfoTile('Used Leaves Counter', '${profile.leaveSummary.usedLeave} Days'),
        _buildInfoTile('Pending Requests', '${profile.leaveSummary.pendingRequests} Apps'),
      ],
    );
  }
}
