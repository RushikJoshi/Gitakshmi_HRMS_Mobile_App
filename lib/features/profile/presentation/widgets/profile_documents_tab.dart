import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ProfileDocumentsTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final bool isHR;
  final Color primaryColor;
  final StateSetter setModalState;
  final Function(BuildContext, String, String) openMockDocViewer;

  const ProfileDocumentsTab({
    super.key,
    required this.profile,
    required this.isHR,
    required this.primaryColor,
    required this.setModalState,
    required this.openMockDocViewer,
  });

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    return Column(
      children: [
        ...profile.documents.map((doc) {
          return ListTile(
            leading: Icon(
              doc.category == 'PAN' || doc.category == 'Aadhar' ? Icons.badge_rounded : Icons.description_rounded,
              color: primaryColor,
            ),
            title: Text(doc.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text('Category: ${doc.category} | Uploaded: ${doc.uploadedAt}', style: const TextStyle(fontSize: 11)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_rounded, size: 20),
                  onPressed: () => openMockDocViewer(context, doc.name, doc.category),
                ),
                if (isHR)
                  IconButton(
                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 20),
                    onPressed: () {
                      setModalState(() {
                        helper.deleteDocument(profile.employeeId, doc.id);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Document deleted successfully!')),
                      );
                    },
                  ),
              ],
            ),
          );
        }),
        if (isHR) ...[
          const Divider(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
            label: const Text('Upload Document', style: TextStyle(color: Colors.white)),
            onPressed: () {
              final newId = 'doc_${DateTime.now().millisecondsSinceEpoch}';
              final doc = ProfileDocument(
                id: newId,
                category: 'Resume',
                name: 'Revised_CV_June_2026.pdf',
                uploadedBy: helper.activeEmployee.name,
                uploadedAt: '06-Jun-2026 12:00 PM',
                filePath: 'mock/Revised_CV_June_2026.pdf',
              );
              setModalState(() {
                helper.uploadDocument(profile.employeeId, doc);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New document uploaded successfully!'), backgroundColor: Colors.green),
              );
            },
          )
        ]
      ],
    );
  }
}
