import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:gitakshmi_hrms_app/features/approvals/presentation/pages/approvals_page.dart';
import 'package:gitakshmi_hrms_app/features/notification/presentation/pages/notification_page.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/pages/profile_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_home_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _bottomIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;

    return ValueListenableBuilder<CompanyConfig>(
      valueListenable: SaaSBrandingHelper.instance.configNotifier,
      builder: (context, config, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            SaaSBrandingHelper.instance.configNotifier,
            helper,
          ]),
          builder: (context, _) {
            final primaryColor = config.primaryColor;
            final activeEmp = helper.activeEmployee;
            final permissions = helper.getFinalPermissions(activeEmp.id);

            // Dynamic Permissions verification based on computed set
            final canApprove = permissions.contains('approve_leave') || permissions.contains('approve_request');

            // Dynamically build bottom nav tabs
            final List<Widget> pages = [
              DashboardHomeView(
                config: config,
                helper: helper,
                permissions: permissions,
                onNavigateTab: (index) {
                  setState(() {
                    _bottomIndex = index;
                  });
                },
              ),
              const AttendancePage(),
              if (canApprove) const ApprovalsPage(),
              const NotificationPage(),
              const ProfilePage(),
            ];

            final List<BottomNavigationBarItem> navItems = [
              const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.fingerprint_rounded), label: 'Attendance'),
              if (canApprove) const BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_rounded), label: 'Approvals'),
              const BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
              const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ];

            // Safeguard bottom index bounds when permissions change dynamically
            if (_bottomIndex >= pages.length) {
              _bottomIndex = 0;
            }

            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                title: Text(
                  _bottomIndex == 0
                      ? config.appName
                      : _bottomIndex == 1
                          ? 'Smart Attendance'
                          : _bottomIndex == 2 && canApprove
                              ? 'Workflow Approvals'
                              : _bottomIndex == (canApprove ? 3 : 2)
                                  ? 'Notifications'
                                  : 'Profile',
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.power_settings_new_rounded, color: AppColors.error),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
              drawer: DashboardDrawer(
                config: config,
                helper: helper,
                activeEmp: activeEmp,
                permissions: permissions,
              ),
              body: pages[_bottomIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _bottomIndex,
                onTap: (index) {
                  setState(() {
                    _bottomIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: primaryColor,
                unselectedItemColor: Colors.grey.shade400,
                showUnselectedLabels: true,
                items: navItems,
              ),
            );
          },
        );
      },
    );
  }
}
