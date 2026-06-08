import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/pages/profile_page.dart';

class TeamDirectoryTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final List<String> permissions;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showLeaveOnBehalfDialog;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showManualPunchDialog;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showCorrectionDialog;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showAssignVisitDialogForUser;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showUploadDocDialog;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showWfhRequestDialog;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showExpenseDialog;
  final Function(BuildContext, RolePermissionHelper, EmployeeModel) showSeparationDialog;

  const TeamDirectoryTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.permissions,
    required this.showLeaveOnBehalfDialog,
    required this.showManualPunchDialog,
    required this.showCorrectionDialog,
    required this.showAssignVisitDialogForUser,
    required this.showUploadDocDialog,
    required this.showWfhRequestDialog,
    required this.showExpenseDialog,
    required this.showSeparationDialog,
  });

  @override
  State<TeamDirectoryTab> createState() => _TeamDirectoryTabState();
}

class _TeamDirectoryTabState extends State<TeamDirectoryTab> {
  String _selectedDept = 'All';
  final List<String> _departments = ['All', 'Marketing', 'Engineering', 'Sales', 'Finance'];

  Widget _buildProfileActionButton(IconData icon, String title, bool enabled, VoidCallback onTap, {Color? color}) {
    final activeColor = color ?? AppColors.primary;
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 105,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: enabled ? activeColor.withValues(alpha: 0.2) : Colors.grey.shade200),
            color: enabled ? activeColor.withValues(alpha: 0.04) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: enabled ? activeColor : Colors.grey, size: 22),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: enabled ? AppColors.textPrimary : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeAuditLogsList(RolePermissionHelper helper, String name) {
    final filteredLogs = helper.auditLogs.where((l) => l.targetName == name).toList();

    if (filteredLogs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
        child: const Text(
          'No delegated actions have been recorded on behalf of this employee yet.',
          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final log = filteredLogs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade100)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(log.actionType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                    Text(log.timestamp, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(log.description, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('Triggered By: ${log.actorName}', style: const TextStyle(fontSize: 9, color: AppColors.textLight, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openEmployeeProfileSheet(
    BuildContext context,
    RolePermissionHelper helper,
    EmployeeModel emp,
    Color primaryColor,
    List<String> permissions,
  ) {
    final role = helper.roles.firstWhere((r) => r.id == emp.roleId, orElse: () => helper.roles.first);

    // Context Permission checks for executing on behalf actions
    final canApplyLeave = permissions.contains('apply_leave_for_team');
    final canPunchAttendance = permissions.contains('mark_attendance_for_team');
    final canCorrectAttendance = permissions.contains('correct_attendance_for_team');
    final canAssignVisit = permissions.contains('create_visit_for_team');
    final canManageDocs = permissions.contains('manage_team_documents');
    final isHRorAdmin = helper.activeEmployee.roleId == 'r_admin' || helper.activeEmployee.roleId == 'r_hr';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 16),
                  
                  // Employee Profile Details Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryColor.withValues(alpha: 0.1),
                        radius: 28,
                        child: Text(
                          emp.name.split(' ').map((n) => n[0]).join(),
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(emp.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text('Department: ${emp.dept}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text('Assigned Role: ${role.name}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 32),

                  // Delegated Actions Grid Title
                  const Text('On Behalf Of Operations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textLight)),
                  const SizedBox(height: 12),

                  // Action Buttons List
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildProfileActionButton(
                        Icons.contact_page_rounded,
                        'View Profile',
                        true,
                        () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(employeeId: emp.id),
                            ),
                          );
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.beach_access_rounded,
                        'Apply Leave',
                        canApplyLeave,
                        () {
                          Navigator.pop(context);
                          widget.showLeaveOnBehalfDialog(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.fingerprint_rounded,
                        'Manual Punch',
                        canPunchAttendance,
                        () {
                          Navigator.pop(context);
                          widget.showManualPunchDialog(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.alarm_add_rounded,
                        'Punch Correct',
                        canCorrectAttendance,
                        () {
                          Navigator.pop(context);
                          widget.showCorrectionDialog(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.add_location_alt_rounded,
                        'Assign Visit',
                        canAssignVisit,
                        () {
                          Navigator.pop(context);
                          widget.showAssignVisitDialogForUser(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.cloud_upload_rounded,
                        'Upload Document',
                        canManageDocs,
                        () {
                          Navigator.pop(context);
                          widget.showUploadDocDialog(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.home_work_rounded,
                        'WFH Request',
                        canApplyLeave,
                        () {
                          Navigator.pop(context);
                          widget.showWfhRequestDialog(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.receipt_long_rounded,
                        'Expense Claim',
                        canApplyLeave || isHRorAdmin,
                        () {
                          Navigator.pop(context);
                          widget.showExpenseDialog(context, helper, emp);
                        },
                      ),
                      _buildProfileActionButton(
                        Icons.directions_run_rounded,
                        'Initiate Separation',
                        isHRorAdmin,
                        () {
                          Navigator.pop(context);
                          widget.showSeparationDialog(context, helper, emp);
                        },
                        color: AppColors.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Employee Specific logs / history
                  const Text('Direct Audit Activity Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textLight)),
                  const SizedBox(height: 10),

                  _buildEmployeeAuditLogsList(helper, emp.name),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.helper.employees.where((e) {
      if (e.id == widget.helper.activeEmployeeId) return false; // Hide self from team roster
      if (_selectedDept == 'All') return true;
      return e.dept == _selectedDept;
    }).toList();

    return Column(
      children: [
        // Department Filter
        Container(
          height: 60,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _departments.length,
            itemBuilder: (context, index) {
              final dept = _departments[index];
              final isSelected = dept == _selectedDept;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(dept),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDept = dept;
                      });
                    }
                  },
                  selectedColor: widget.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final emp = filtered[index];
              final role = widget.helper.roles.firstWhere((r) => r.id == emp.roleId, orElse: () => widget.helper.roles.first);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: widget.primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      emp.name.split(' ').map((n) => n[0]).join(),
                      style: TextStyle(color: widget.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  subtitle: Text('${emp.dept} • Role: ${role.name}', style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                  onTap: () => _openEmployeeProfileSheet(context, widget.helper, emp, widget.primaryColor, widget.permissions),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
