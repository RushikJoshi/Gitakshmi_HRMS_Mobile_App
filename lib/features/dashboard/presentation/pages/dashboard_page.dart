import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/pages/attendance_page.dart';
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

  // ── Pages ────────────────────────────────────────────────────────────────
  Widget _buildHomeView(
      CompanyConfig config, RolePermissionHelper helper, List<String> permissions) {
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
              DashboardHeaderCard(
                userName: activeEmp.name,
                designation: role.name,
              ),
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: const DashboardStatGrid(),
              ),
            ],
          ),
          const SizedBox(height: 110),

          DashboardPunchCard(
            onNavigateTab: (index) => setState(() => _bottomIndex = index),
          ),
          const SizedBox(height: 20),
          const DashboardActiveSessionCard(),
          const SizedBox(height: 20),
          const DashboardWorkHoursCard(),
          const SizedBox(height: 20),
          const DashboardDailyTasksCard(),
          const SizedBox(height: 20),
          const DashboardLogTimelineCard(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Custom Nav Item ──────────────────────────────────────────────────────
  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required Color activeColor,
  }) {
    final bool isActive = _bottomIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _bottomIndex = index),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? activeColor : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? activeColor : Colors.grey.shade400,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────
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

            // 4 pages: Home | Attendance | Notifications | Profile
            final List<Widget> pages = [
              _buildHomeView(config, helper, permissions),
              const AttendancePage(),
              const NotificationPage(),
              const ProfilePage(),
            ];

            if (_bottomIndex >= pages.length) _bottomIndex = 0;

            // Nav bar dark navy color (matching screenshot)
            const navActiveColor = AppColors.blue600;

            return Scaffold(
              key: _scaffoldKey,
              drawer: DashboardDrawer(
                config: config,
                helper: helper,
                activeEmp: activeEmp,
                permissions: permissions,
              ),
              body: pages[_bottomIndex],

              // ── Center FAB (notched circular button) ──────────────────
              floatingActionButton: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue600,

                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,

              // ── Custom Notched Bottom Nav Bar ─────────────────────────
              bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 8,
                color: Colors.white,
                elevation: 12,
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Left side
                      _buildNavItem(
                        index: 0,
                        activeIcon: Icons.home_rounded,
                        inactiveIcon: Icons.home_outlined,
                        label: 'Home',
                        activeColor: navActiveColor,
                      ),
                      _buildNavItem(
                        index: 1,
                        activeIcon: Icons.fingerprint_rounded,
                        inactiveIcon: Icons.fingerprint_rounded,
                        label: 'Attendance',
                        activeColor: navActiveColor,
                      ),
                      // Space for FAB
                      const SizedBox(width: 58),
                      // Right side
                      _buildNavItem(
                        index: 2,
                        activeIcon: Icons.notifications_rounded,
                        inactiveIcon: Icons.notifications_outlined,
                        label: 'Alerts',
                        activeColor: navActiveColor,
                      ),
                      _buildNavItem(
                        index: 3,
                        activeIcon: Icons.person_rounded,
                        inactiveIcon: Icons.person_outlined,
                        label: 'Profile',
                        activeColor: navActiveColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
