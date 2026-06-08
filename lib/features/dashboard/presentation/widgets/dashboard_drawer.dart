import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/timesheet/presentation/pages/timesheet_page.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/pages/leave_page.dart';
import 'package:gitakshmi_hrms_app/features/payroll/presentation/pages/payslip_page.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/pages/team_page.dart';
import 'package:gitakshmi_hrms_app/features/tracking/presentation/pages/tracking_page.dart';
import 'package:gitakshmi_hrms_app/features/reports/presentation/pages/reports_page.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/pages/holiday_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/pages/asset_management_page.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/pages/expense_management_page.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/pages/recruitment_management_page.dart';
import 'package:gitakshmi_hrms_app/features/permission/presentation/pages/permission_page.dart';
import 'package:gitakshmi_hrms_app/features/settings/presentation/pages/settings_page.dart';

class DashboardDrawer extends StatelessWidget {
  final CompanyConfig config;
  final RolePermissionHelper helper;
  final EmployeeModel activeEmp;
  final List<String> permissions;

  const DashboardDrawer({
    super.key,
    required this.config,
    required this.helper,
    required this.activeEmp,
    required this.permissions,
  });

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(title, style: TextStyle(color: color ?? AppColors.textPrimary, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = config.primaryColor;
    final canTrack = permissions.contains('view_tracking');
    final canViewPayroll = permissions.contains('view_payroll');
    final canViewTeam = permissions.contains('view_team');
    final canManageAccess = permissions.contains('manage_team') || permissions.contains('edit_employee') || activeEmp.id == 'emp_mayur';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                config.logoIcon,
                size: 30,
                color: primaryColor,
              ),
            ),
            accountName: Text(activeEmp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text('${helper.roles.firstWhere((r) => r.id == activeEmp.roleId, orElse: () => helper.roles.first).name} • ${helper.currentCompany}'),
          ),
          if (permissions.contains('view_attendance'))
            _buildDrawerItem(Icons.calendar_month_rounded, 'Timesheet', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TimeSheetScreen()));
            }),
          if (permissions.contains('view_leave'))
            _buildDrawerItem(Icons.beach_access_rounded, 'Leave Management', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveSummaryScreen()));
            }),
          if (canViewPayroll)
            _buildDrawerItem(Icons.payments_rounded, 'Payroll', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PayslipScreen()));
            }),
          if (canViewTeam)
            _buildDrawerItem(Icons.groups_rounded, 'Team Management', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamPage()));
            }),
          if (canTrack)
            _buildDrawerItem(Icons.map_rounded, 'Sales Tracking', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingPage()));
            }),
          if (permissions.contains('view_reports'))
            _buildDrawerItem(Icons.bar_chart_rounded, 'Reports & Analytics', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsPage()));
            }),
          _buildDrawerItem(Icons.celebration_rounded, 'Holiday List', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HolidayScreen()));
          }),
          _buildDrawerItem(Icons.devices_other_rounded, 'Asset Management', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetManagementPage()));
          }),
          _buildDrawerItem(Icons.assignment_ind_rounded, 'Recruitment ATS', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RecruitmentManagementPage()));
          }),
          _buildDrawerItem(Icons.receipt_long_rounded, 'Expense & Reimbursement', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseManagementPage()));
          }),
          if (canManageAccess)
            _buildDrawerItem(Icons.admin_panel_settings_rounded, 'Role & Permissions Control', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PermissionPage()));
            }),
          _buildDrawerItem(Icons.settings_rounded, 'Settings', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          }),
          const Divider(),
          _buildDrawerItem(Icons.logout_rounded, 'Log Out', () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }, color: AppColors.error),
        ],
      ),
    );
  }
}
