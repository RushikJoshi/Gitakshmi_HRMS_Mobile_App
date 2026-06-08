import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_personal_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_employment_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_documents_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_assets_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_leaves_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_payroll_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_attendance_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_settings_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_education_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_experience_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_timeline_tab.dart';

class ProfilePage extends StatefulWidget {
  final String? employeeId; // Optional: viewing a specific employee's profile
  const ProfilePage({super.key, this.employeeId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Local controllers for editing
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileController;
  late TextEditingController _personalEmailController;
  
  late TextEditingController _currentLine1Controller;
  late TextEditingController _currentCityController;
  late TextEditingController _currentPincodeController;
  
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _upiIdController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final helper = RolePermissionHelper.instance;
    final empId = widget.employeeId ?? helper.activeEmployeeId;
    final profile = helper.getProfile(empId);

    _firstNameController = TextEditingController(text: profile.firstName);
    _lastNameController = TextEditingController(text: profile.lastName);
    _mobileController = TextEditingController(text: profile.mobileNumber);
    _personalEmailController = TextEditingController(text: profile.personalEmail);
    
    _currentLine1Controller = TextEditingController(text: profile.addressDetails.currentLine1);
    _currentCityController = TextEditingController(text: profile.addressDetails.currentCity);
    _currentPincodeController = TextEditingController(text: profile.addressDetails.currentPincode);
    
    _bankNameController = TextEditingController(text: profile.bankDetails.bankName);
    _accountNumberController = TextEditingController(text: profile.bankDetails.accountNumber);
    _ifscCodeController = TextEditingController(text: profile.bankDetails.ifscCode);
    _upiIdController = TextEditingController(text: profile.bankDetails.upiId);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _personalEmailController.dispose();
    _currentLine1Controller.dispose();
    _currentCityController.dispose();
    _currentPincodeController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    return AnimatedBuilder(
      animation: helper,
      builder: (context, _) {
        final activeEmpId = helper.activeEmployeeId;
        final targetEmpId = widget.employeeId ?? activeEmpId;
        final isSelf = targetEmpId == activeEmpId;
        
        final profile = helper.getProfile(targetEmpId);
        final employee = helper.employees.firstWhere((e) => e.id == targetEmpId, orElse: () => helper.employees.first);
        final selfPermissions = helper.getFinalPermissions(activeEmpId);

        // Security controls
        final isHR = selfPermissions.contains('edit_employee') || activeEmpId == 'emp_mayur';
        final isFinance = selfPermissions.contains('view_payroll') || selfPermissions.contains('generate_payroll');
        final canViewPayroll = isHR || isFinance || isSelf;

        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primaryColor = config.primaryColor;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HR Approvals Console (Only visible to HR/Admin when viewing profiles and pending requests exist)
                if (isHR && isSelf && helper.profileChangeRequests.any((r) => r.status == 'Pending'))
                  _buildPendingApprovalsConsole(helper, primaryColor),

                // Profile Header Card
                _buildProfileHeader(context, profile, employee, primaryColor, isSelf, isHR),
                const SizedBox(height: 16),

                // 9-Card Console Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildConsoleCard(
                      id: 'card_personal',
                      icon: Icons.person_rounded,
                      title: 'Personal Info',
                      summary: '${profile.gender}, ${profile.dob}',
                      color: Colors.blue,
                      onTap: () => _openSectionDetail(context, 'Personal Details', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_professional',
                      icon: Icons.work_rounded,
                      title: 'Employment',
                      summary: '${employee.dept} • ${employee.roleId == "r_admin" ? "Admin" : employee.roleId == "r_hr" ? "HR" : "Staff"}',
                      color: Colors.orange,
                      onTap: () => _openSectionDetail(context, 'Professional Details', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_education',
                      icon: Icons.school_rounded,
                      title: 'Education',
                      summary: '${profile.educationRecords.length} Records Assigned',
                      color: Colors.purple,
                      onTap: () => _openSectionDetail(context, 'Education Details', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_experience',
                      icon: Icons.history_edu_rounded,
                      title: 'Experience',
                      summary: '${profile.experienceRecords.length} Prior Companies',
                      color: Colors.teal,
                      onTap: () => _openSectionDetail(context, 'Experience Details', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_documents',
                      icon: Icons.folder_shared_rounded,
                      title: 'Documents',
                      summary: '${profile.documents.length} Files Uploaded',
                      color: Colors.indigo,
                      onTap: () => _openSectionDetail(context, 'Document Vault', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_assets',
                      icon: Icons.devices_other_rounded,
                      title: 'Assets',
                      summary: '${profile.assignedAssets.length} Hardware Issued',
                      color: Colors.cyan,
                      onTap: () => _openSectionDetail(context, 'Asset Inventory', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_attendance_summary',
                      icon: Icons.bar_chart_rounded,
                      title: 'Attendance Stats',
                      summary: 'Present: ${profile.attendanceSummary.presentDays} Days',
                      color: Colors.green,
                      onTap: () => _openSectionDetail(context, 'Stats Summary', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_timeline',
                      icon: Icons.timeline_rounded,
                      title: 'Activity & Audit',
                      summary: '${profile.timelineActivities.length} Milestones Logged',
                      color: Colors.deepOrange,
                      onTap: () => _openSectionDetail(context, 'Activity Timeline & Audits', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                    _buildConsoleCard(
                      id: 'card_settings',
                      icon: Icons.settings_applications_rounded,
                      title: 'Settings & SaaS',
                      summary: 'Branding & Policy Configuration',
                      color: Colors.blueGrey,
                      onTap: () => _openSectionDetail(context, 'Settings & Configuration', profile, isSelf, isHR, canViewPayroll, primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
        padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.all(12),
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

  // Profile Header Card
  Widget _buildProfileHeader(
    BuildContext context,
    EmployeeProfileModel profile,
    EmployeeModel employee,
    Color primaryColor,
    bool isSelf,
    bool isHR,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with Full Screen View on Tap
                GestureDetector(
                  onTap: () => _openPhotoViewer(context, profile, isSelf, isHR),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundImage: NetworkImage(profile.photoUrl),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${profile.firstName} ${profile.lastName}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.roleId == 'r_admin' ? 'Engineering Director' : employee.roleId == 'r_hr' ? 'HR Manager' : employee.roleId == 'r_tl' ? 'Team Lead' : 'Staff Associate',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text('Employee ID: ${profile.employeeCode}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      Text('Branch: ${profile.addressDetails.currentCity} Office', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      Text('Joining Date: ${profile.dob}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Icon(Icons.visibility_rounded, color: primaryColor, size: 16),
                    label: Text('View Photo', style: TextStyle(color: primaryColor, fontSize: 12)),
                    onPressed: () => _openPhotoViewer(context, profile, isSelf, isHR),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 16),
                    label: const Text('PDF Resume', style: TextStyle(color: Colors.white, fontSize: 12)),
                    onPressed: () {
                      _showSimulationDialog(
                        context,
                        'Exporting Profile File',
                        'Creating encrypted PDF file: ${profile.employeeCode}_master_profile.pdf',
                        'Profile downloaded successfully!',
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Dashboard Card Builder
  Widget _buildConsoleCard({
    required String id,
    required IconData icon,
    required String title,
    required String summary,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                summary,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Photo Viewer Overlay Dialog
  void _openPhotoViewer(BuildContext context, EmployeeProfileModel profile, bool isSelf, bool isHR) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                child: Image.network(profile.photoUrl, fit: BoxFit.contain),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download_rounded, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Photo downloaded to local gallery successfully.')),
                          );
                        },
                      ),
                      if (isSelf || isHR) ...[
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.photo_camera_rounded, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mock Camera launched. Selected new profile picture.')),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mock Action: Remove Profile Photo')),
                            );
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Simulation Dialog helper
  void _showSimulationDialog(BuildContext context, String title, String taskMsg, String completionMsg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _SimulationProgressDialog(
          title: title,
          taskMsg: taskMsg,
          completionMsg: completionMsg,
        );
      },
    );
  }

  // Section Details Bottom Sheet
  void _openSectionDetail(
    BuildContext context,
    String category,
    EmployeeProfileModel profile,
    bool isSelf,
    bool isHR,
    bool canViewPayroll,
    Color primaryColor,
  ) {
    setState(() {
      _isEditing = false;
      _initControllers();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Modal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Row(
                        children: [
                          if (_canUserEdit(category, isSelf, isHR) && !_isEditing)
                            TextButton.icon(
                              icon: Icon(Icons.edit_rounded, color: primaryColor, size: 18),
                              label: Text('Edit Details', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                setModalState(() {
                                  _isEditing = true;
                                });
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(),
                  
                  // Scrollable Body
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCategoryBody(
                              category,
                              profile,
                              isSelf,
                              isHR,
                              canViewPayroll,
                              primaryColor,
                              setModalState,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Edit Action Buttons
                  if (_isEditing) ...[
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                _isEditing = false;
                                _initControllers();
                              });
                            },
                            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                            onPressed: () => _saveProfileChanges(context, category, profile, isSelf, isHR, setModalState),
                            child: const Text('Save Details', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Permission Logic checking what can be edited
  bool _canUserEdit(String category, bool isSelf, bool isHR) {
    if (isHR) return true; // HR can edit everything
    if (!isSelf) return false; // Managers cannot edit other employee profiles
    
    // Employee self-editing permissions
    if (category == 'Personal Details') return true;
    if (category == 'Bank Details') return true; // approval required
    return false;
  }

  // Render detail sheets based on category
  Widget _buildCategoryBody(
    String category,
    EmployeeProfileModel profile,
    bool isSelf,
    bool isHR,
    bool canViewPayroll,
    Color primaryColor,
    StateSetter setModalState,
  ) {
    switch (category) {
      case 'Personal Details':
        return ProfilePersonalTab(
          profile: profile,
          isEditing: _isEditing,
          isHR: isHR,
          primaryColor: primaryColor,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          mobileController: _mobileController,
          personalEmailController: _personalEmailController,
          currentLine1Controller: _currentLine1Controller,
          currentCityController: _currentCityController,
          currentPincodeController: _currentPincodeController,
        );
      case 'Professional Details':
        return ProfileEmploymentTab(
          profile: profile,
          isHR: isHR,
          canViewPayroll: canViewPayroll,
        );
      case 'Education Details':
        return ProfileEducationTab(
          profile: profile,
          isHR: isHR,
          primaryColor: primaryColor,
          setModalState: setModalState,
          openMockDocViewer: _openMockDocViewer,
        );
      case 'Experience Details':
        return ProfileExperienceTab(
          profile: profile,
          isHR: isHR,
          primaryColor: primaryColor,
          setModalState: setModalState,
          openMockDocViewer: _openMockDocViewer,
        );
      case 'Document Vault':
        return ProfileDocumentsTab(
          profile: profile,
          isHR: isHR,
          primaryColor: primaryColor,
          setModalState: setModalState,
          openMockDocViewer: _openMockDocViewer,
        );
      case 'Asset Inventory':
        return ProfileAssetsTab(
          profile: profile,
          isHR: isHR,
          primaryColor: primaryColor,
          setModalState: setModalState,
        );
      case 'Stats Summary':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileAttendanceTab(
              profile: profile,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 16),
            ProfileLeavesTab(
              profile: profile,
            ),
            const SizedBox(height: 16),
            ProfilePayrollTab(
              profile: profile,
            ),
          ],
        );
      case 'Activity Timeline & Audits':
        return ProfileTimelineTab(
          profile: profile,
        );
      case 'Settings & Configuration':
        return ProfileSettingsTab(
          profile: profile,
          primaryColor: primaryColor,
          setModalState: setModalState,
        );
      default:
        return const Center(child: Text('Section details loaded successfully.'));
    }
  }

  // Save changes and audit log
  void _saveProfileChanges(
    BuildContext context,
    String category,
    EmployeeProfileModel profile,
    bool isSelf,
    bool isHR,
    StateSetter setModalState,
  ) {
    if (_formKey.currentState?.validate() ?? false) {
      final helper = RolePermissionHelper.instance;
      
      // Update values
      if (category == 'Personal Details') {
        final newMobile = _mobileController.text;
        final newEmail = _personalEmailController.text;

        if (isHR) {
          // HR updates personal details directly
          final updated = profile.copyWith(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            mobileNumber: newMobile,
            personalEmail: newEmail,
            addressDetails: profile.addressDetails.copyWith(
              currentLine1: _currentLine1Controller.text,
              currentCity: _currentCityController.text,
              currentPincode: _currentPincodeController.text,
            )
          );
          helper.updateProfile(profile.employeeId, updated);
          
          helper.logAudit(
            helper.activeEmployee.name,
            profile.firstName + ' ' + profile.lastName,
            'Profile Details Updated',
            'HR updated personal profile details directly.',
          );
        } else {
          // Employee updates details directly
          final updated = profile.copyWith(
            mobileNumber: newMobile,
            personalEmail: newEmail,
            addressDetails: profile.addressDetails.copyWith(
              currentLine1: _currentLine1Controller.text,
              currentCity: _currentCityController.text,
              currentPincode: _currentPincodeController.text,
            )
          );
          helper.updateProfile(profile.employeeId, updated);
          
          helper.logAudit(
            helper.activeEmployee.name,
            profile.firstName + ' ' + profile.lastName,
            'Profile Details Updated',
            'Employee updated their contact numbers and address directly.',
          );
        }
      } else if (category == 'Bank Details') {
        // Employee edits bank details -> trigger approvals
        if (!isHR) {
          helper.requestProfileChange(
            employeeId: profile.employeeId,
            category: 'Bank Details',
            fieldName: 'Account Number',
            oldValue: profile.bankDetails.accountNumber,
            newValue: _accountNumberController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bank Details update submitted to HR for approval!'), backgroundColor: Colors.amber),
          );
        } else {
          // HR updates directly
          final updated = profile.copyWith(
            bankDetails: BankDetails(
              bankName: _bankNameController.text,
              accountHolderName: profile.bankDetails.accountHolderName,
              accountNumber: _accountNumberController.text,
              ifscCode: _ifscCodeController.text,
              branchName: profile.bankDetails.branchName,
              upiId: _upiIdController.text,
            )
          );
          helper.updateProfile(profile.employeeId, updated);
          
          helper.logAudit(
            helper.activeEmployee.name,
            profile.firstName + ' ' + profile.lastName,
            'Bank Details Swapped',
            'HR updated bank ledger coordinates directly.',
          );
        }
      }

      setModalState(() {
        _isEditing = false;
      });
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  // Document viewer modal mockup
  void _openMockDocViewer(BuildContext context, String docName, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Container(
                  height: 220,
                  color: Colors.grey.shade50,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, size: 50, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(docName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Size: 1.4 MB • Verified Mock Scan', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close Viewer'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      icon: const Icon(Icons.download_rounded, color: Colors.white, size: 16),
                      label: const Text('Download File', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloaded document: $docName')),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


}

// Simulated Progress Dialog widget
class _SimulationProgressDialog extends StatefulWidget {
  final String title;
  final String taskMsg;
  final String completionMsg;

  const _SimulationProgressDialog({
    required this.title,
    required this.taskMsg,
    required this.completionMsg,
  });

  @override
  State<_SimulationProgressDialog> createState() => _SimulationProgressDialogState();
}

class _SimulationProgressDialogState extends State<_SimulationProgressDialog> {
  double _progress = 0.0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _startTask();
  }

  void _startTask() async {
    for (int i = 0; i <= 10; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _progress = i / 10;
      });
    }
    setState(() {
      _finished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Divider(height: 20),
            const SizedBox(height: 10),
            if (!_finished) ...[
              Text(widget.taskMsg, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: _progress, color: Colors.blue, backgroundColor: Colors.grey.shade200),
            ] else ...[
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
                  const SizedBox(width: 10),
                  Text(widget.completionMsg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
