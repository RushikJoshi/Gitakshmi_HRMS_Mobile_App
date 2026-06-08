import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/my_assets_tab.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/request_desk_tab.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/ticket_desk_tab.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/qr_audit_tab.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/handover_tab.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/policies_tab.dart';
import 'package:gitakshmi_hrms_app/features/asset/presentation/widgets/admin_desk_tab.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class AssetManagementPage extends StatefulWidget {
  const AssetManagementPage({super.key});

  @override
  State<AssetManagementPage> createState() => _AssetManagementPageState();
}

class _AssetManagementPageState extends State<AssetManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Returns request form dialog
  void _showReturnRequestDialog(CompanyAssetModel asset) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Return request: ${asset.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide the exit reason or handback context:', style: TextStyle(fontSize: 11)),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason (e.g. Resignation, Upgrade replacement)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                if (reasonController.text.trim().isNotEmpty) {
                  RolePermissionHelper.instance.requestAssetReturn(asset.id, reasonController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Asset return request submitted to HR team.'), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text('Submit Return', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;

    return AnimatedBuilder(
      animation: helper,
      builder: (context, _) {
        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primaryColor = config.primaryColor;
        final activeEmpId = helper.activeEmployeeId;

        // User role checks (HR/Admin/IT Team Context)
        final isHRorAdmin = helper.activeEmployee.roleId == 'r_admin' ||
            helper.activeEmployee.roleId == 'r_hr' ||
            activeEmpId == 'emp_mayur';
        final isITTeam = isHRorAdmin || helper.activeEmployee.dept == 'Engineering';

        // Filter assets assigned to active employee
        final myAssets = helper.companyAssets.where((a) => a.assignedToEmployeeId == activeEmpId).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Asset Lifecycle Management'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                const Tab(icon: Icon(Icons.devices_rounded), text: 'My Assets'),
                const Tab(icon: Icon(Icons.note_add_rounded), text: 'Request Desk'),
                const Tab(icon: Icon(Icons.support_agent_rounded), text: 'Ticket Desk'),
                const Tab(icon: Icon(Icons.qr_code_scanner_rounded), text: 'QR Audit'),
                const Tab(icon: Icon(Icons.move_up_rounded), text: 'Handover'),
                const Tab(icon: Icon(Icons.policy_rounded), text: 'Policies & Docs'),
                Tab(
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                  text: 'Admin Desk (${isITTeam ? "Active" : "Locked"})',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              MyAssetsTab(
                assets: myAssets,
                primaryColor: primaryColor,
                onReturnInitiated: _showReturnRequestDialog,
              ),
              RequestDeskTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
              TicketDeskTab(
                helper: helper,
                myAssets: myAssets,
                primaryColor: primaryColor,
              ),
              QrAuditTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
              HandoverTab(
                helper: helper,
                myAssets: myAssets,
                primaryColor: primaryColor,
              ),
              PoliciesTab(
                primaryColor: primaryColor,
              ),
              AdminDeskTab(
                helper: helper,
                isITTeam: isITTeam,
                primaryColor: primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
