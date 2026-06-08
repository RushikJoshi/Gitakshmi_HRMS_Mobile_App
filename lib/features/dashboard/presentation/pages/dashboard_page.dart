import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:gitakshmi_hrms_app/features/approvals/presentation/pages/approvals_page.dart';
import 'package:gitakshmi_hrms_app/features/notification/presentation/pages/notification_page.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/pages/profile_page.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_header_card.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_stat_grid.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_punch_card.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_active_session_card.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_work_hours_card.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_daily_tasks_card.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/widgets/dashboard_log_timeline_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _bottomIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildHomeView(CompanyConfig config, RolePermissionHelper helper, List<String> permissions) {
    final activeEmp = helper.activeEmployee;
    final role = helper.roles.firstWhere(
      (r) => r.id == activeEmp.roleId,
      orElse: () => helper.roles.first,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Stack: Blue header + overlapping Stat Grid card ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Layer 1: Blue gradient header
              DashboardHeaderCard(
                userName: activeEmp.name,
                designation: role.name,
              ),
              // Layer 2: Stat grid overlapping the bottom of the header
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: const DashboardStatGrid(),
              ),
            ],
          ),
          // Compensation space so next widget starts below the stat grid
          // (statGrid starts at 110 + ~220 height = 330; Stack = 160; delta = 170 + 20 gap)
          const SizedBox(height: 110),

          // Punch In/Out Card
          DashboardPunchCard(
            onNavigateTab: (index) {
              setState(() {
                _bottomIndex = index;
              });
            },
          ),

          const SizedBox(height: 20),

          // Active Session Card
          const DashboardActiveSessionCard(),

          const SizedBox(height: 20),

          // Work Hours Bar Chart Card
          const DashboardWorkHoursCard(),

          const SizedBox(height: 20),

          // Daily Tasks Card
          const DashboardDailyTasksCard(),

          const SizedBox(height: 20),

          // Log Timeline Card
          const DashboardLogTimelineCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

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
              _buildHomeView(config, helper, permissions),
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
