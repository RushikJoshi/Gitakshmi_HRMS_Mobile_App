import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';

class ProfileSettingsTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final Color primaryColor;
  final StateSetter setModalState;

  const ProfileSettingsTab({
    super.key,
    required this.profile,
    required this.primaryColor,
    required this.setModalState,
  });

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    final config = SaaSBrandingHelper.instance.configNotifier.value;
    
    final Map<String, String> permissionLabels = {
      'approve_leave': 'Leave & Request Approvals',
      'view_tracking': 'Sales Live GPS Tracking',
      'payroll_view': 'Payroll Ledger & Payslips',
      'view_team': 'Team Attendance & Logs',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          value: profile.settings.enableBiometric,
          onChanged: (val) {
            setModalState(() {
              profile.settings.enableBiometric = val;
            });
          },
          title: const Text('Enable Fingerprint Biometrics', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          activeThumbColor: primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: profile.settings.enableFaceLogin,
          onChanged: (val) {
            setModalState(() {
              profile.settings.enableFaceLogin = val;
            });
          },
          title: const Text('Enable Anti-Spoof Face Login', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          activeThumbColor: primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: profile.settings.attendanceNotifications,
          onChanged: (val) {
            setModalState(() {
              profile.settings.attendanceNotifications = val;
            });
          },
          title: const Text('Shift & Punch Reminders', style: TextStyle(fontSize: 12)),
          activeThumbColor: primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          value: profile.settings.approvalNotifications,
          onChanged: (val) {
            setModalState(() {
              profile.settings.approvalNotifications = val;
            });
          },
          title: const Text('Approvals Pending Alerts', style: TextStyle(fontSize: 12)),
          activeThumbColor: primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
        
        const Divider(height: 30),
        
        // Tenant Swapper (Preserving existing logic)
        const Text('White-Label SaaS Branding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: config.companyName,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Tenant Context Switcher',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: ['ABC Pvt Ltd', 'XYZ Tech', 'SalesPro'].map((company) {
            return DropdownMenuItem(value: company, child: Text(company, style: const TextStyle(fontSize: 12)));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              SaaSBrandingHelper.instance.changeCompany(val);
              helper.switchCompany(val);
              Navigator.pop(context); // close sheet to update main page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched SaaS tenant context to $val successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
        ),
        
        const SizedBox(height: 20),
        
        // Permissions Swapper (Preserving existing logic)
        const Text('Dynamic Permission Override Console', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        ...permissionLabels.entries.map((entry) {
          final permKey = entry.key;
          final permLabel = entry.value;
          final hasPerm = config.permissions.contains(permKey);

          return SwitchListTile(
            value: hasPerm,
            onChanged: (enable) {
              setModalState(() {
                SaaSBrandingHelper.instance.togglePermission(permKey, enable);
              });
            },
            title: Text(permLabel, style: const TextStyle(fontSize: 11)),
            activeThumbColor: primaryColor,
            contentPadding: EdgeInsets.zero,
          );
        }),
      ],
    );
  }
}
