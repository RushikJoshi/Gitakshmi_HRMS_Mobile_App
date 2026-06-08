import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class TeamDocumentsTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final bool active;
  final List<String> permissions;
  final Function(BuildContext, RolePermissionHelper, Color, EmployeeModel?) showUploadDocDialog;

  const TeamDocumentsTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.active,
    required this.permissions,
    required this.showUploadDocDialog,
  });

  Widget _buildLockedView(String permissionRequired) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.textLight),
            const SizedBox(height: 16),
            const Text('Feature Restricted', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              'Requires "$permissionRequired" permissions in active context.',
              style: const TextStyle(fontSize: 11, color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!active) return _buildLockedView('manage_team_documents');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Uploaded Documents Folder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              OutlinedButton.icon(
                onPressed: () => showUploadDocDialog(context, helper, primaryColor, null),
                icon: const Icon(Icons.upload_file_rounded, size: 14),
                label: const Text('Upload File', style: TextStyle(fontSize: 11)),
              )
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: helper.teamDocuments.length,
            itemBuilder: (context, index) {
              final doc = helper.teamDocuments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
                  ),
                  title: Text(doc.docName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  subtitle: Text('Type: ${doc.docType} • Employee: ${doc.employeeName}\nBy ${doc.uploadedBy} on ${doc.timestamp}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${doc.docName}...')));
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
