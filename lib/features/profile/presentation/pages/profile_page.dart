import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/pages/profile_detail_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/core/storage/preference/preference_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitakshmi_hrms_app/features/profile/profile_injection.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:gitakshmi_hrms_app/core/widgets/shimmer/shimmer_widget.dart';

class ProfilePage extends StatelessWidget {
  final String? employeeId;
  const ProfilePage({super.key, this.employeeId});

  @override
  Widget build(BuildContext context) {
    if (employeeId != null) {
      return BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(repository: profileRepository)
          ..add(FetchProfileEvent(employeeId: employeeId)),
        child: _ProfilePageBody(key: key, employeeId: employeeId),
      );
    }

    try {
      final existingBloc = BlocProvider.of<ProfileBloc>(context);
      if (existingBloc.state is ProfileInitial) {
        existingBloc.add(const FetchProfileEvent());
      }
      return _ProfilePageBody(key: key, employeeId: employeeId);
    } catch (_) {
      return BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(repository: profileRepository)
          ..add(const FetchProfileEvent()),
        child: _ProfilePageBody(key: key, employeeId: employeeId),
      );
    }
  }
}

class _ProfilePageBody extends StatefulWidget {
  final String? employeeId;
  const _ProfilePageBody({super.key, this.employeeId});

  @override
  State<_ProfilePageBody> createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<_ProfilePageBody> {
  bool _isRegisteringFaceDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    final config = SaaSBrandingHelper.instance.configNotifier.value;
    final primaryColor = config.primaryColor;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is FaceRegisterLoading) {
          if (!_isRegisteringFaceDialogShowing) {
            _isRegisteringFaceDialogShowing = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const PopScope(
                canPop: false,
                child: AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Registering face, please wait...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          if (_isRegisteringFaceDialogShowing) {
            _isRegisteringFaceDialogShowing = false;
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is FaceRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is FaceRegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return _buildShimmerProfileLayout(context);
          }
          if (state is ProfileError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(FetchProfileEvent(employeeId: widget.employeeId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final EmployeeProfileModel profile;
          final String? designation;

          if (state is ProfileLoaded) {
            profile = state.profile;
            designation = state.designation;
          } else if (state is FaceRegisterLoading) {
            profile = state.profile;
            designation = state.designation;
          } else if (state is FaceRegisterSuccess) {
            profile = state.profile;
            designation = state.designation;
          } else if (state is FaceRegisterError) {
            profile = state.profile;
            designation = state.designation;
          } else {
            return const Scaffold(
              body: Center(child: Text('Unknown State')),
            );
          }

          return AnimatedBuilder(
            animation: helper,
            builder: (context, _) {
              final activeEmpId = helper.activeEmployeeId;
              final targetEmpId = widget.employeeId ?? activeEmpId;
              final isSelf = targetEmpId == activeEmpId;
              
              final employee = helper.employees.firstWhere((e) => e.id == targetEmpId, orElse: () => helper.employees.first);
              final selfPermissions = helper.getFinalPermissions(activeEmpId);

              final isHR = selfPermissions.contains('edit_employee') || activeEmpId == 'emp_mayur';
              final isFinance = selfPermissions.contains('view_payroll') || selfPermissions.contains('generate_payroll');
              final canViewPayroll = isHR || isFinance || isSelf;

              return Scaffold(
                backgroundColor: AppColors.scaffoldBg,
                body: SizedBox.expand(
                  child: Stack(
                    children: [
                      // Purple Header Background
                      Container(
                        height: 220,
                        width: double.infinity,
                        color: AppColors.purple600,
                        child: const SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'My Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Scrollable body
                      Positioned.fill(
                        top: 150,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Spacer/gap for overlapping avatar
                              const SizedBox(height: 70),

                              // HR Approvals Console
                              if (isHR && isSelf && helper.profileChangeRequests.any((r) => r.status == 'Pending')) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: _buildPendingApprovalsConsole(helper, primaryColor),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Name and title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${profile.firstName} ${profile.lastName}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified,
                                    color: Color(0xFF5B71F3),
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  (designation != null && designation.isNotEmpty)
                                      ? designation
                                      : (employee.roleId == 'r_admin'
                                          ? 'Engineering Director'
                                          : employee.roleId == 'r_hr'
                                              ? 'HR Manager'
                                              : employee.roleId == 'r_tl'
                                                  ? 'Team Lead'
                                                  : 'Junior Full Stack Developer'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.purple600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Grid scrolls, header stationary
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      GridView.count(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.92,
                                        children: [
                                          _buildProfileGridCard(
                                            icon: Icons.person_rounded,
                                            title: 'Personal Info',
                                            isActive: true,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Personal Details',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.workspace_premium_rounded,
                                            title: 'Professional Info',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Professional Details',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.school_rounded,
                                            title: 'Education Info',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Education Details',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.business_rounded,
                                            title: 'Experience Info',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Experience Details',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.insert_drive_file_rounded,
                                            title: 'Documents Details',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Document Vault',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.settings_rounded,
                                            title: 'Settings & SaaS',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Settings & Configuration',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.face_retouching_natural_rounded,
                                            title: 'Register Face',
                                            isActive: false,
                                            onTap: () async {
                                              final bloc = context.read<ProfileBloc>();
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (_) => FaceScannerPage(
                                                    onFaceScanned: (base64Image) {
                                                      bloc.add(RegisterFaceEvent(base64Image: base64Image));
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.bar_chart_rounded,
                                            title: 'Attendance Stats',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Stats Summary',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                          _buildProfileGridCard(
                                            icon: Icons.timeline_rounded,
                                            title: 'Activity Timeline',
                                            isActive: false,
                                            onTap: () => _navigateToDetail(
                                              context,
                                              category: 'Activity Timeline & Audits',
                                              profile: profile,
                                              isSelf: isSelf,
                                              isHR: isHR,
                                              canViewPayroll: canViewPayroll,
                                              primaryColor: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade600,
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(double.infinity, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Logout'),
                                              content: const Text('Are you sure you want to logout?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirmed == true) {
                                            await PreferenceManager.clearToken();
                                            if (!context.mounted) return;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => const LoginPage()),
                                              (route) => false,
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.logout_rounded),
                                        label: const Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Overlapping Avatar Card
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: AppColors.purple100,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                              child: Image.asset(
                                'assets/images/boy_avatar.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Pending Approvals Console for HR
  Widget _buildPendingApprovalsConsole(RolePermissionHelper helper, Color primaryColor) {
    final pending = helper.profileChangeRequests.where((r) => r.status == 'Pending').toList();
    return Card(
      color: Colors.red.shade50,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.gpp_maybe_rounded, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Pending Profile Change Approvals (${pending.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
                ),
              ],
            ),
            const Divider(height: 20),
            ...pending.map((req) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            req.employeeName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          Text(
                            req.date,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Category: ${req.category} | Field: ${req.fieldName}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Old: ${req.oldValue}',
                              style: TextStyle(fontSize: 11, color: Colors.red.shade700, decoration: TextDecoration.lineThrough),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_right_alt_rounded, size: 16, color: Colors.grey),
                          Expanded(
                            child: Text(
                              'New: ${req.newValue}',
                              style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              helper.rejectProfileRequest(req.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Change request rejected.'), backgroundColor: Colors.red),
                              );
                            },
                            child: const Text('Reject', style: TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              helper.approveProfileRequest(req.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Change request approved and updated!'), backgroundColor: Colors.green),
                              );
                            },
                            child: const Text('Approve', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(
    BuildContext context, {
    required String category,
    required EmployeeProfileModel profile,
    required bool isSelf,
    required bool isHR,
    required bool canViewPayroll,
    required Color primaryColor,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailPage(
          category: category,
          profile: profile,
          isSelf: isSelf,
          isHR: isHR,
          canViewPayroll: canViewPayroll,
          primaryColor: primaryColor,
          onSaved: () {
            context.read<ProfileBloc>().add(FetchProfileEvent(employeeId: widget.employeeId));
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildProfileGridCard({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.gray200, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 28,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerProfileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Header Shimmer
            Container(
              height: 220,
              width: double.infinity,
              color: AppColors.purple600,
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'My Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Body Container
            Positioned.fill(
              top: 150,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 70), // space for avatar
                      // Name Shimmer
                      const Center(
                        child: ShimmerWidget.rectangular(
                          height: 24,
                          width: 180,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Designation Shimmer
                      const Center(
                        child: ShimmerWidget.rectangular(
                          height: 16,
                          width: 120,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Grid Shimmer
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 9,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.92,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gray200),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShimmerWidget.circular(
                                    width: 28,
                                    height: 28,
                                  ),
                                  SizedBox(height: 12),
                                  ShimmerWidget.rectangular(
                                    height: 10,
                                    width: 50,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Avatar Circle Shimmer
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const ShimmerWidget.circular(
                    width: 104,
                    height: 104,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
