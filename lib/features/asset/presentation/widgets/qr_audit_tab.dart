import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';

class QrAuditTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const QrAuditTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

  @override
  State<QrAuditTab> createState() => _QrAuditTabState();
}

class _QrAuditTabState extends State<QrAuditTab> {
  String? _selectedAssetCode;
  String _selectedCondition = 'Excellent';

  @override
  void initState() {
    super.initState();
    final myOwned = widget.helper.companyAssets.toList();
    if (myOwned.isNotEmpty) {
      _selectedAssetCode = myOwned.first.assetCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myOwned = widget.helper.companyAssets.toList();
    if (myOwned.isEmpty) {
      return const Center(child: Text('No assets available to audit.'));
    }

    if (_selectedAssetCode == null || !myOwned.any((a) => a.assetCode == _selectedAssetCode)) {
      _selectedAssetCode = myOwned.first.assetCode;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Asset Auditing & Scanner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text(
            'Physical asset verification scan check. Select asset and verify condition to audit and recalibrate health index score.',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Simulated camera scanner view
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 120),
                  ),
                ),
                // Camera target box
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: widget.primaryColor, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  child: Text(
                    'Align QR Code in alignment box',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scanner Form
          AppDropdownField<String>(
                  labelText: 'Simulate Scanned QR / Asset Code',
                  value: _selectedAssetCode,
                  items: myOwned.map((a) {
              return DropdownMenuItem(value: a.assetCode, child: Text('${a.name} (${a.assetCode})', style: const TextStyle(fontSize: 12)));
            }).toList(),
                  onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedAssetCode = val;
                });
              }
            },
                ),
          const SizedBox(height: 12),
          AppDropdownField<String>(
                  labelText: 'Audited Condition',
                  value: _selectedCondition,
                  items: ['Excellent', 'Good', 'Fair', 'Poor'].map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
                  onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedCondition = val;
                });
              }
            },
                ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, padding: const EdgeInsets.symmetric(vertical: 14)),
            icon: const Icon(Icons.qr_code_rounded, color: Colors.white),
            label: const Text('Perform Verification Audit', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_selectedAssetCode == null) return;
              widget.helper.auditVerifyAsset(_selectedAssetCode!, widget.helper.activeEmployee.name, _selectedCondition);
              showDialog(
                context: context,
                builder: (context) {
                  final asset = myOwned.firstWhere((a) => a.assetCode == _selectedAssetCode);
                  final isOwner = asset.assignedToEmployeeId == widget.helper.activeEmployeeId;

                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          isOwner ? Icons.check_circle_rounded : Icons.warning_rounded,
                          color: isOwner ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(isOwner ? 'Audit Confirmed' : 'Ownership Mismatch'),
                      ],
                    ),
                    content: Text(
                      isOwner
                          ? 'Audit verified successfully! Ownership confirmed for Ravi. Condition logged: $_selectedCondition.'
                          : 'Warning: This asset is assigned to ${asset.assignedToEmployeeName}. Scanning has logged an ownership warning.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),
          const Text('Scan History Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          if (widget.helper.assetAudits.isEmpty)
            const Text('No recent scans reported.', style: TextStyle(fontSize: 11, color: Colors.grey))
          else
            ...widget.helper.assetAudits.map((aud) {
              final verified = aud.result == 'Verified Ownership';
              return ListTile(
                dense: true,
                leading: Icon(
                  verified ? Icons.check_circle_outline_rounded : Icons.report_problem_outlined,
                  color: verified ? Colors.green : Colors.red,
                ),
                title: Text(aud.assetName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                subtitle: Text('Audit: ${aud.scannedCondition} • Checked: ${aud.date}', style: const TextStyle(fontSize: 10)),
                trailing: Text(aud.result, style: TextStyle(color: verified ? Colors.green : Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
              );
            })
        ],
      ),
    );
  }
}
