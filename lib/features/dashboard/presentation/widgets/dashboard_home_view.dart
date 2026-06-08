import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/pages/leave_page.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/pages/team_page.dart';
import 'package:gitakshmi_hrms_app/features/tracking/presentation/pages/tracking_page.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/pages/asset_management_page.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/pages/expense_management_page.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/pages/recruitment_management_page.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';

class DashboardHomeView extends StatelessWidget {
  final CompanyConfig config;
  final RolePermissionHelper helper;
  final List<String> permissions;
  final Function(int) onNavigateTab;

  const DashboardHomeView({
    super.key,
    required this.config,
    required this.helper,
    required this.permissions,
    required this.onNavigateTab,
  });

  Widget _buildActionCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                  child: const Icon(Icons.assignment_late_rounded, color: AppColors.warning),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Casual Leave Request', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text('Submitted by Akash Patel (Marketing)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Approve'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = config.primaryColor;
    final canApprove = permissions.contains('approve_leave') || permissions.contains('approve_request');
    final canTrack = permissions.contains('view_tracking');
    final canViewTeam = permissions.contains('view_team');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic Persona Switching Console Card
          Card(
            color: primaryColor.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: primaryColor.withValues(alpha: 0.15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.supervised_user_circle_rounded, color: primaryColor, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Logged User Persona Context',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: helper.activeEmployeeId,
                    decoration: const InputDecoration(
                      labelText: 'Simulate User Account',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: helper.employees.map((e) {
                      final role = helper.roles.firstWhere((r) => r.id == e.roleId, orElse: () => helper.roles.first);
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text('${e.name} (${role.name})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        helper.setActiveEmployee(val);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Formula: Final Access = Role (${helper.roles.firstWhere((r) => r.id == helper.activeEmployee.roleId, orElse: () => helper.roles.first).name}) '
                    '+ ${helper.activeEmployee.extraPermissions.length} Extra - ${helper.activeEmployee.restrictedPermissions.length} Restricted.',
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Active Permissions: ${permissions.join(", ")}',
                    style: const TextStyle(fontSize: 9, color: AppColors.textLight, fontFamily: 'monospace'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Shift timing card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.access_time_filled_rounded, color: primaryColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Day Shift', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(height: 4),
                        Text('09:00 AM - 06:00 PM', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Chip(
                    label: Text('Shift Active', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.success,
                    side: BorderSide.none,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              if (permissions.contains('create_attendance'))
                _buildActionCard(Icons.fingerprint_rounded, 'Punch In', primaryColor, () => onNavigateTab(1)),
              if (permissions.contains('create_attendance'))
                _buildActionCard(Icons.local_cafe_rounded, 'Start Break', primaryColor, () => onNavigateTab(1)),
              if (permissions.contains('apply_leave'))
                _buildActionCard(Icons.beach_access_rounded, 'Apply Leave', primaryColor, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveSummaryScreen()))),
              if (canApprove)
                _buildActionCard(Icons.help_center_rounded, 'Raise Request', primaryColor, () => onNavigateTab(2)),
              if (canViewTeam)
                _buildActionCard(Icons.groups_rounded, 'Team View', primaryColor, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamPage()))),
              if (canTrack)
                _buildActionCard(Icons.my_location_rounded, 'Tracking', primaryColor, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingPage()))),
              _buildActionCard(
                Icons.devices_other_rounded,
                'Asset Hub',
                primaryColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetManagementPage())),
              ),
              _buildActionCard(
                Icons.receipt_long_rounded,
                'Expenses',
                primaryColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseManagementPage())),
              ),
              _buildActionCard(
                Icons.assignment_ind_rounded,
                'Recruitment',
                primaryColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecruitmentManagementPage())),
              ),
            ],
          ),
          
          if (canApprove) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pending Approvals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                TextButton(
                  onPressed: () => onNavigateTab(2),
                  child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildApprovalSummaryCard(),
          ],
        ],
      ),
    );
  }
}
