import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
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
      child: ResponsiveCenteredView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                DashboardHeaderCard(
                  userName: activeEmp.name,
                  designation: role.name,
                ),
                Positioned(
                  top: 140.h,
                  left: 0,
                  right: 0,
                  child: const DashboardStatGrid(),
                ),
              ],
            ),
            SizedBox(height: 130.h),
            DashboardPunchCard(
              onNavigateTab: (index) => setState(() => _bottomIndex = index),
            ),
            SizedBox(height: 20.h),
            const DashboardActiveSessionCard(),
            SizedBox(height: 20.h),
            const DashboardWorkHoursCard(),
            SizedBox(height: 20.h),
            const DashboardDailyTasksCard(),
            SizedBox(height: 20.h),
            const DashboardLogTimelineCard(),
            SizedBox(height: 30.h),
          ],
        ),
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
        width: 72.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? activeColor : Colors.grey.shade400,
              size: 24.sp,
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
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

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? result) async {
                if (didPop) return;
                
                if (_bottomIndex != 0) {
                  setState(() {
                    _bottomIndex = 0;
                  });
                  return;
                }
                
                final bool? shouldExit = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    title: const Row(
                      children: [
                        Icon(Icons.exit_to_app_rounded, color: AppColors.blue600),
                        SizedBox(width: 10),
                        Text(
                          'Exit App',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    content: const Text(
                      'Are you sure you want to exit the app?',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldExit == true) {
                  await SystemNavigator.pop();
                }
              },
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: AppColors.scaffoldBg,
                drawer: DashboardDrawer(
                  config: config,
                  helper: helper,
                  activeEmp: activeEmp,
                  permissions: permissions,
                ),
                body: pages[_bottomIndex],

                // ── Center FAB (notched circular button) ──────────────────
                floatingActionButton: Container(
                  width: 58.w,
                  height: 58.w,
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
                  notchMargin: 8.r,
                  color: Colors.white,
                  elevation: 12,
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 60.h,
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
                        SizedBox(width: 58.w),
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
              ),
            );
          },
        );
      },
    );
  }
}
