import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class HandoverTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final List<CompanyAssetModel> myAssets;
  final Color primaryColor;

  const HandoverTab({
    super.key,
    required this.helper,
    required this.myAssets,
    required this.primaryColor,
  });

  @override
  State<HandoverTab> createState() => _HandoverTabState();
}

class _HandoverTabState extends State<HandoverTab> {
  final _transferFormKey = GlobalKey<FormState>();

  String? _xferAssetId;
  String? _xferTargetEmpId;
  final _xferRemarksController = TextEditingController();

  @override
  void dispose() {
    _xferRemarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colleagues = widget.helper.employees.where((e) => e.id != widget.helper.activeEmployeeId).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _transferFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Employee Handover Transfer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            const Text(
              'Handover asset ownership immediately to a team colleague. Updates inventory logs and registers in the audit history database.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            if (widget.myAssets.isEmpty) ...[
              const Center(child: Text('No assets assigned to transfer.')),
            ] else ...[
              AppDropdownField<String>(
                  labelText: 'Select Handover Asset',
                  value: _xferAssetId ?? widget.myAssets.first.id,
                  items: widget.myAssets.map((a) {
                  return DropdownMenuItem(value: a.id, child: Text(a.name, style: const TextStyle(fontSize: 12)));
                }).toList(),
                  onChanged: (val) {
                  if (val != null) setState(() => _xferAssetId = val);
                },
                ),
              const SizedBox(height: 12),
              AppDropdownField<String>(
                  labelText: 'Transfer to Colleague',
                  value: _xferTargetEmpId ?? (colleagues.isNotEmpty ? colleagues.first.id : null),
                  items: colleagues.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text('${c.name} (${c.dept})', style: const TextStyle(fontSize: 12)));
                }).toList(),
                  onChanged: (val) {
                  if (val != null) setState(() => _xferTargetEmpId = val);
                },
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _xferRemarksController,
                decoration: const InputDecoration(labelText: 'Handover / Relieving Notes'),
                maxLines: 2,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Handover notes is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, padding: const EdgeInsets.symmetric(vertical: 14)),
                icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
                label: const Text('Execute Ownership Handover', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_transferFormKey.currentState?.validate() ?? false) {
                    final targetId = _xferTargetEmpId ?? (colleagues.isNotEmpty ? colleagues.first.id : '');
                    final assetId = _xferAssetId ?? widget.myAssets.first.id;
                    widget.helper.transferAsset(assetId, targetId, _xferRemarksController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Asset ownership transferred and logged successfully!'), backgroundColor: Colors.green),
                    );
                    _xferRemarksController.clear();
                    setState(() {
                      _xferAssetId = null;
                      _xferTargetEmpId = null;
                    });
                  }
                },
              ),
            ],

            const SizedBox(height: 24),
            const Text('Transfers Audit History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            if (widget.helper.assetTransfers.isEmpty)
              const Text('No recent transfers logged.', style: TextStyle(fontSize: 11, color: Colors.grey))
            else
              ...widget.helper.assetTransfers.map((xfer) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.transfer_within_a_station_rounded, color: Colors.orange),
                    title: Text(xfer.assetName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('From: ${xfer.fromEmployeeName} -> To: ${xfer.toEmployeeName} on ${xfer.date}', style: const TextStyle(fontSize: 10)),
                    trailing: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 16),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
