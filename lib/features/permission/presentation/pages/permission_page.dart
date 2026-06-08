import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';

import 'package:gitakshmi_hrms_app/features/permission/presentation/widgets/roles_catalog_tab.dart';
import 'package:gitakshmi_hrms_app/features/permission/presentation/widgets/user_overrides_tab.dart';
import 'package:gitakshmi_hrms_app/features/permission/presentation/widgets/workflows_map_tab.dart';
import 'package:gitakshmi_hrms_app/features/permission/presentation/widgets/logs_analytics_tab.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
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

        return Scaffold(
          appBar: AppBar(
            title: const Text('Access Control & Roles'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(icon: Icon(Icons.shield_rounded), text: 'Roles Catalog'),
                Tab(icon: Icon(Icons.people_rounded), text: 'User Overrides'),
                Tab(icon: Icon(Icons.route_rounded), text: 'Workflows Map'),
                Tab(icon: Icon(Icons.analytics_rounded), text: 'Logs & Analytics'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              RolesCatalogTab(
                helper: helper,
                onEditRole: (role) => _showRoleDialog(context, helper, role, primaryColor),
                onCloneRole: (role) => _showCloneDialog(context, helper, role),
                onDeleteRole: (role) => _showDeleteConfirm(context, helper, role),
              ),
              UserOverridesTab(
                helper: helper,
                primaryColor: primaryColor,
                onConfigureUser: (emp) => _showUserOverridesDialog(context, helper, emp, primaryColor),
              ),
              WorkflowsMapTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
              LogsAnalyticsTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
            ],
          ),
          floatingActionButton: _tabController.index == 0
              ? FloatingActionButton.extended(
                  onPressed: () => _showRoleDialog(context, helper, null, primaryColor),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: const Text('Create Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: primaryColor,
                )
              : null,
        );
      },
    );
  }

  // ==========================================
  // DIALOGS & FORMS
  // ==========================================
  
  // Create / Edit Role Dialog
  void _showRoleDialog(BuildContext context, RolePermissionHelper helper, RoleModel? editRole, Color primaryColor) {
    final nameController = TextEditingController(text: editRole?.name ?? '');
    final descController = TextEditingController(text: editRole?.description ?? '');
    final List<String> selectedPermissions = List<String>.from(editRole?.permissions ?? []);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editRole == null ? 'Create Custom Role' : 'Edit Permissions for ${editRole.name}'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (editRole == null) ...[
                      AppTextField(
                  controller: nameController,
                  labelText: 'Role Name',
                ),
                      const SizedBox(height: 12),
                      AppTextField(
                  controller: descController,
                        maxLines: 2,
                  labelText: 'Description',
                ),
                      const SizedBox(height: 16),
                    ],
                    const Text('Permissions Checklist:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    ...helper.permissionCategories.entries.map((entry) {
                      final category = entry.key;
                      final perms = entry.value;

                      return ExpansionTile(
                        title: Text(category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${perms.where((p) => selectedPermissions.contains(p['key'])).length} of ${perms.length} selected',
                          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                        ),
                        dense: true,
                        children: perms.map((p) {
                          final pKey = p['key']!;
                          final isSelected = selectedPermissions.contains(pKey);

                          return CheckboxListTile(
                            title: Text(pKey, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            subtitle: Text(p['desc']!, style: const TextStyle(fontSize: 10)),
                            value: isSelected,
                            onChanged: (val) {
                              setDialogState(() {
                                if (val == true) {
                                  selectedPermissions.add(pKey);
                                } else {
                                  selectedPermissions.remove(pKey);
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          );
                        }).toList(),
                      );
                    })
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    if (editRole == null) {
                      helper.createRole(nameController.text.trim(), descController.text.trim(), selectedPermissions);
                    } else {
                      helper.updateRole(editRole.id, nameController.text.trim(), descController.text.trim(), selectedPermissions);
                    }
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Clone Role Dialog
  void _showCloneDialog(BuildContext context, RolePermissionHelper helper, RoleModel role) {
    final nameController = TextEditingController(text: '${role.name} Copy');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Clone Role: ${role.name}'),
        content: AppTextField(
                  controller: nameController,
                  labelText: 'New Role Name',
                ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                helper.cloneRole(role.id, nameController.text.trim());
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Clone'),
          )
        ],
      ),
    );
  }

  // Delete Confirm Dialog
  void _showDeleteConfirm(BuildContext context, RolePermissionHelper helper, RoleModel role) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Role'),
        content: Text('Are you sure you want to permanently delete the custom role "${role.name}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              helper.deleteRole(role.id);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // Edit User Overrides Dialog (Role assignment, Extra and Restricted list overrides)
  void _showUserOverridesDialog(BuildContext context, RolePermissionHelper helper, EmployeeModel emp, Color primaryColor) {
    String selectedRoleId = emp.roleId;
    final List<String> extraPerms = List<String>.from(emp.extraPermissions);
    final List<String> restrictedPerms = List<String>.from(emp.restrictedPermissions);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final activeRole = helper.roles.firstWhere((r) => r.id == selectedRoleId, orElse: () => helper.roles.first);

            return AlertDialog(
              title: Text('Configure Security: ${emp.name}'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Role Selector
                    AppDropdownField<String>(
                  labelText: 'Default Assigned Role',
                  value: selectedRoleId,
                  items: helper.roles.map((r) {
                        return DropdownMenuItem(value: r.id, child: Text(r.name));
                      }).toList(),
                  onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedRoleId = val;
                            // Clean conflicts: a permission cannot be in extra if it belongs to default role
                            final newRole = helper.roles.firstWhere((r) => r.id == val);
                            extraPerms.removeWhere((p) => newRole.permissions.contains(p));
                            restrictedPerms.removeWhere((p) => !newRole.permissions.contains(p));
                          });
                        }
                      },
                ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Tabs Selector for overrides
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Extra (+ Add)'),
                              Tab(text: 'Restricted (- Block)'),
                            ],
                            labelColor: AppColors.textPrimary,
                            indicatorColor: AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 350,
                            child: TabBarView(
                              children: [
                                // Tab 1: Extra permissions check list
                                _buildOverrideList(
                                  helper,
                                  availablePermissions: helper.getAllPermissionKeys().where((p) => !activeRole.permissions.contains(p)).toList(),
                                  selectedList: extraPerms,
                                  onChanged: (pKey, isSelected) {
                                    setDialogState(() {
                                      if (isSelected) {
                                        extraPerms.add(pKey);
                                        restrictedPerms.remove(pKey);
                                      } else {
                                        extraPerms.remove(pKey);
                                      }
                                    });
                                  },
                                ),

                                // Tab 2: Restricted permissions checklist
                                _buildOverrideList(
                                  helper,
                                  availablePermissions: activeRole.permissions,
                                  selectedList: restrictedPerms,
                                  onChanged: (pKey, isSelected) {
                                    setDialogState(() {
                                      if (isSelected) {
                                        restrictedPerms.add(pKey);
                                        extraPerms.remove(pKey);
                                      } else {
                                        restrictedPerms.remove(pKey);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    helper.updateEmployeeOverrides(
                      emp.id,
                      roleId: selectedRoleId,
                      extra: extraPerms,
                      restricted: restrictedPerms,
                    );
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text('Apply Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOverrideList(
    RolePermissionHelper helper, {
    required List<String> availablePermissions,
    required List<String> selectedList,
    required Function(String key, bool val) onChanged,
  }) {
    if (availablePermissions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No applicable permissions for this criteria in the selected role.',
            style: TextStyle(fontSize: 12, color: AppColors.textLight, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: availablePermissions.length,
      itemBuilder: (context, index) {
        final pKey = availablePermissions[index];
        final isSelected = selectedList.contains(pKey);

        // Find description
        String desc = '';
        for (var list in helper.permissionCategories.values) {
          final item = list.firstWhere((p) => p['key'] == pKey, orElse: () => {});
          if (item.isNotEmpty) {
            desc = item['desc']!;
            break;
          }
        }

        return CheckboxListTile(
          title: Text(pKey, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          subtitle: Text(desc, style: const TextStyle(fontSize: 10)),
          value: isSelected,
          onChanged: (val) {
            if (val != null) {
              onChanged(pKey, val);
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
        );
      },
    );
  }
}
