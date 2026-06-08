import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileAssetsTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final bool isHR;
  final Color primaryColor;
  final StateSetter setModalState;

  const ProfileAssetsTab({
    super.key,
    required this.profile,
    required this.isHR,
    required this.primaryColor,
    required this.setModalState,
  });

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    return Column(
      children: [
        ...profile.assignedAssets.map((asset) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(
                asset.assetName.contains('MacBook') || asset.assetName.contains('HP') || asset.assetName.contains('Dell')
                    ? Icons.laptop_chromebook_rounded
                    : Icons.credit_card_rounded,
                color: Colors.cyan,
              ),
              title: Text(asset.assetName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text('S/N: ${asset.serialNumber} • Issued: ${asset.issueDate}', style: const TextStyle(fontSize: 11)),
              trailing: Text(asset.returnDate, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          );
        }),
        if (isHR) ...[
          const Divider(),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(side: BorderSide(color: primaryColor)),
            onPressed: () {
              final newAsset = AssignedAsset(
                assetName: 'Apple iPad Air 11"',
                serialNumber: 'SN-IPAD-9821',
                issueDate: '06-Jun-2026',
                returnDate: '--',
              );
              setModalState(() {
                helper.assignAsset(profile.employeeId, newAsset);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New iPad assigned to employee!'), backgroundColor: Colors.green),
              );
            },
            icon: Icon(Icons.add_moderator_rounded, color: primaryColor),
            label: Text('Assign New Asset', style: TextStyle(color: primaryColor)),
          )
        ]
      ],
    );
  }
}
