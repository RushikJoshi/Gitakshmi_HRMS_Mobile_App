import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/widgets/team_directory_tab.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/widgets/team_org_chart_tab.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/widgets/team_performance_tab.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/widgets/team_documents_tab.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/widgets/team_tracking_tab.dart';
import 'package:gitakshmi_hrms_app/features/team/presentation/widgets/team_leaves_tab.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;

    return AnimatedBuilder(
      animation: helper,
      builder: (context, _) {
        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primaryColor = config.primaryColor;
        final permissions = helper.getFinalPermissions(helper.activeEmployeeId);

        // Verification of Team Permissions
        final canViewRoster = permissions.contains('view_team');
        final canViewLiveAttendance = permissions.contains('view_team_attendance');
        final canViewLeave = permissions.contains('view_team_leave');
        final canViewTracking = permissions.contains('view_team_tracking');
        final canViewTimesheet = permissions.contains('view_team_timesheet');
        final canManageDocs = permissions.contains('manage_team_documents');

        if (!canViewRoster) {
          return Scaffold(
            appBar: AppBar(title: const Text('Team Board')),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded, size: 64, color: AppColors.error),
                    SizedBox(height: 16),
                    Text(
                      'Access Denied',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You do not possess the view_team permission required to access the Team Management dashboard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    )
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Team Dashboard'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                const Tab(icon: Icon(Icons.groups_rounded), text: 'Roster & Actions'),
                Tab(icon: const Icon(Icons.fingerprint_rounded), text: 'Live Punch (${canViewLiveAttendance ? "Active" : "Locked"})'),
                Tab(icon: const Icon(Icons.calendar_month_rounded), text: 'Timesheets (${canViewTimesheet ? "Active" : "Locked"})'),
                Tab(icon: const Icon(Icons.map_rounded), text: 'Tracking & Visits (${canViewTracking ? "Active" : "Locked"})'),
                Tab(icon: const Icon(Icons.beach_access_rounded), text: 'Team Leave (${canViewLeave ? "Active" : "Locked"})'),
                Tab(icon: const Icon(Icons.folder_shared_rounded), text: 'Team Docs (${canManageDocs ? "Active" : "Locked"})'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              TeamDirectoryTab(
                helper: helper,
                primaryColor: primaryColor,
                permissions: permissions,
                showLeaveOnBehalfDialog: (ctx, h, emp) => _showLeaveOnBehalfDialog(ctx, h, primaryColor, emp),
                showManualPunchDialog: (ctx, h, emp) => _showManualPunchDialog(ctx, h, primaryColor, emp),
                showCorrectionDialog: (ctx, h, emp) => _showCorrectionDialog(ctx, h, primaryColor, emp),
                showAssignVisitDialogForUser: (ctx, h, emp) => _showAssignVisitDialogForUser(ctx, h, primaryColor, emp),
                showUploadDocDialog: (ctx, h, emp) => _showUploadDocDialog(ctx, h, primaryColor, emp),
                showWfhRequestDialog: (ctx, h, emp) => _showWfhRequestDialog(ctx, h, primaryColor, emp),
                showExpenseDialog: (ctx, h, emp) => _showExpenseDialog(ctx, h, primaryColor, emp),
                showSeparationDialog: (ctx, h, emp) => _showSeparationDialog(ctx, h, primaryColor, emp),
              ),
              TeamOrgChartTab(
                helper: helper,
                primaryColor: primaryColor,
                active: canViewLiveAttendance,
              ),
              TeamPerformanceTab(
                helper: helper,
                primaryColor: primaryColor,
                active: canViewTimesheet,
              ),
              TeamTrackingTab(
                helper: helper,
                primaryColor: primaryColor,
                active: canViewTracking,
                permissions: permissions,
                showAssignVisitDialog: _showAssignVisitDialog,
              ),
              TeamLeavesTab(
                helper: helper,
                primaryColor: primaryColor,
                active: canViewLeave,
                permissions: permissions,
                showLeaveOnBehalfDialog: _showLeaveOnBehalfDialog,
              ),
              TeamDocumentsTab(
                helper: helper,
                primaryColor: primaryColor,
                active: canManageDocs,
                permissions: permissions,
                showUploadDocDialog: _showUploadDocDialog,
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // OPERATIONAL ACTION DIALOG FORMS
  // ==========================================

  // 1. Leave on behalf of Dialog
  void _showLeaveOnBehalfDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel? targetEmp) {
    String? selectedEmp = targetEmp?.name;
    final List<String> employeeNames = helper.employees.where((e) => e.id != helper.activeEmployeeId).map((e) => e.name).toList();
    
    final typeController = TextEditingController(text: 'Casual Leave');
    final rangeController = TextEditingController(text: '12-Jun-2026 to 13-Jun-2026');
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Apply Leave On Behalf Of'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (targetEmp == null)
              AppDropdownField<String>(
                labelText: 'Select Team Member',
                value: selectedEmp,
                items: employeeNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                onChanged: (val) => selectedEmp = val,
              )
            else
              Text('Applying for: ${targetEmp.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AppTextField(
              controller: typeController,
              labelText: 'Leave Type (Casual, Sick, etc.)',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: rangeController,
              labelText: 'Date Range',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: reasonController,
              labelText: 'Reason for leave',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (selectedEmp != null && reasonController.text.isNotEmpty) {
                helper.applyLeaveOnBehalf(selectedEmp!, typeController.text, rangeController.text, reasonController.text);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Apply Leave'),
          ),
        ],
      ),
    );
  }

  // 2. Manual Punch Dialog
  void _showManualPunchDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel emp) {
    final dateController = TextEditingController(text: '05-Jun-2026');
    final inController = TextEditingController(text: '09:00 AM');
    final outController = TextEditingController(text: '06:00 PM');
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Manual Attendance: ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: dateController,
              labelText: 'Select Date',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: inController,
              labelText: 'Punch In Time',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: outController,
              labelText: 'Punch Out Time',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: reasonController,
              labelText: 'Regularization Reason',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                helper.markManualAttendanceOnBehalf(emp.name, dateController.text, inController.text, outController.text, reasonController.text);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Submit Punch'),
          ),
        ],
      ),
    );
  }

  // 3. Correction Dialog
  void _showCorrectionDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel emp) {
    final dateController = TextEditingController(text: '04-Jun-2026');
    final inController = TextEditingController(text: '09:15 AM');
    final outController = TextEditingController(text: '06:30 PM');
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Attendance Correction: ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: dateController,
              labelText: 'Target Date',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: inController,
              labelText: 'Adjusted Punch In',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: outController,
              labelText: 'Adjusted Punch Out',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: reasonController,
              labelText: 'Adjustment Remarks',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                helper.correctAttendanceOnBehalf(emp.name, dateController.text, inController.text, outController.text, reasonController.text);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Apply Adjustments'),
          ),
        ],
      ),
    );
  }

  // 4. Assign Visit Dialog
  void _showAssignVisitDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor) {
    String? selectedEmp;
    final List<String> employeeNames = helper.employees.where((e) => e.id != helper.activeEmployeeId).map((e) => e.name).toList();
    final clientController = TextEditingController();
    final locationController = TextEditingController();
    final timeController = TextEditingController(text: '11:30 AM');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Assign Visit On Behalf Of'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDropdownField<String>(
              labelText: 'Select Representative',
              value: selectedEmp,
              items: employeeNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
              onChanged: (val) => selectedEmp = val,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: clientController,
              labelText: 'Client Name',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: locationController,
              labelText: 'Location / Client Address',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: timeController,
              labelText: 'Reporting Time',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (selectedEmp != null && clientController.text.isNotEmpty) {
                helper.assignClientVisitOnBehalf(selectedEmp!, clientController.text, locationController.text, timeController.text);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Assign Visit'),
          ),
        ],
      ),
    );
  }

  void _showAssignVisitDialogForUser(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel emp) {
    final clientController = TextEditingController();
    final locationController = TextEditingController();
    final timeController = TextEditingController(text: '11:30 AM');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Assign Client Visit: ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assigning to: ${emp.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AppTextField(
              controller: clientController,
              labelText: 'Client Name',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: locationController,
              labelText: 'Location / Client Address',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: timeController,
              labelText: 'Reporting Time',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (clientController.text.isNotEmpty) {
                helper.assignClientVisitOnBehalf(emp.name, clientController.text, locationController.text, timeController.text);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Assign Visit'),
          ),
        ],
      ),
    );
  }

  // 5. Upload Document Dialog
  void _showUploadDocDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel? targetEmp) {
    String? selectedEmp = targetEmp?.name;
    final List<String> employeeNames = helper.employees.where((e) => e.id != helper.activeEmployeeId).map((e) => e.name).toList();
    
    String docType = 'Salary Revision';
    final List<String> docTypes = ['Offer Letter', 'Appointment Letter', 'Salary Revision', 'Warning Letter'];
    final nameController = TextEditingController(text: 'Increment_Letter_2026.pdf');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Upload Document On Behalf Of'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (targetEmp == null)
                    AppDropdownField<String>(
                      labelText: 'Select Employee',
                      value: selectedEmp,
                      items: employeeNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                      onChanged: (val) => selectedEmp = val,
                    )
                  else
                    Text('Uploading for: ${targetEmp.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  AppDropdownField<String>(
                    labelText: 'Document Type',
                    value: docType,
                    items: docTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          docType = val;
                          if (val == 'Warning Letter') nameController.text = 'Warning_Attendance_Violation.pdf';
                          if (val == 'Offer Letter') nameController.text = 'Offer_Candidate_HR.pdf';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: nameController,
                    labelText: 'File Name Description',
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (selectedEmp != null && nameController.text.isNotEmpty) {
                      helper.uploadDocumentOnBehalf(selectedEmp!, docType, nameController.text);
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Upload Document'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 6. WFH Request Dialog
  void _showWfhRequestDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel emp) {
    final dateController = TextEditingController(text: '08-Jun-2026');
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('WFH Request on behalf of ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: dateController,
              labelText: 'Target Date',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: reasonController,
              labelText: 'Reason for WFH',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                helper.applyWfhOnBehalf(emp.name, dateController.text, reasonController.text);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Submit WFH'),
          ),
        ],
      ),
    );
  }

  // 7. Expense Dialog
  void _showExpenseDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel emp) {
    final amountController = TextEditingController();
    String category = 'Travel Reimbursement';
    final List<String> categories = ['Travel Reimbursement', 'Client Entertainment', 'Office Supplies', 'Internet/Mobile Allowance'];
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Expense Claim: ${emp.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    labelText: 'Amount (Rs)',
                  ),
                  const SizedBox(height: 12),
                  AppDropdownField<String>(
                    labelText: 'Category',
                    value: category,
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => category = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: descController,
                    labelText: 'Claim Description',
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isNotEmpty && descController.text.isNotEmpty) {
                      helper.claimExpenseOnBehalf(emp.name, amountController.text, category, descController.text);
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Claim Expense'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 8. Resignation / Separation Dialog
  void _showSeparationDialog(BuildContext context, RolePermissionHelper helper, Color primaryColor, EmployeeModel emp) {
    final reasonController = TextEditingController();
    final noticeController = TextEditingController(text: '30');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Initiate Exit: ${emp.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: reasonController, decoration: const InputDecoration(labelText: 'Exit/Resignation Reason', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: noticeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Notice Period (Days)', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty && noticeController.text.isNotEmpty) {
                helper.initiateSeparationOnBehalf(emp.name, reasonController.text, noticeController.text);
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Confirm exit triggers', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
