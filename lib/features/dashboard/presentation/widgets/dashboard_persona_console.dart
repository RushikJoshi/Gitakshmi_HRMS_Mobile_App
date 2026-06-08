import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';

class DashboardPersonaConsole extends StatefulWidget {
  final CompanyConfig config;
  final RolePermissionHelper helper;
  final List<String> permissions;
  final VoidCallback onPersonaChanged;

  const DashboardPersonaConsole({
    super.key,
    required this.config,
    required this.helper,
    required this.permissions,
    required this.onPersonaChanged,
  });

  @override
  State<DashboardPersonaConsole> createState() => _DashboardPersonaConsoleState();
}

class _DashboardPersonaConsoleState extends State<DashboardPersonaConsole> {
  bool _isConsoleExpanded = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.config.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 0,
        color: primaryColor.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _isConsoleExpanded = !_isConsoleExpanded;
                });
              },
              leading: Icon(Icons.supervised_user_circle_rounded, color: primaryColor),
              title: const Text(
                'Logged User Persona Context',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: Icon(
                _isConsoleExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: primaryColor,
              ),
            ),
            if (_isConsoleExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppDropdownField<String>(
                      labelText: 'Simulate User Account',
                      value: widget.helper.activeEmployeeId,
                      items: widget.helper.employees.map((e) {
                        final role = widget.helper.roles.firstWhere(
                          (r) => r.id == e.roleId,
                          orElse: () => widget.helper.roles.first,
                        );
                        return DropdownMenuItem(
                          value: e.id,
                          child: Text('${e.name} (${role.name})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          widget.helper.setActiveEmployee(val);
                          widget.onPersonaChanged();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Formula: Final Access = Role (${widget.helper.roles.firstWhere((r) => r.id == widget.helper.activeEmployee.roleId, orElse: () => widget.helper.roles.first).name}) '
                      '+ ${widget.helper.activeEmployee.extraPermissions.length} Extra - ${widget.helper.activeEmployee.restrictedPermissions.length} Restricted.',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Active Permissions: ${widget.permissions.join(", ")}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textLight,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
