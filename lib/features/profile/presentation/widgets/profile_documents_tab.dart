import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF7544FC), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F4F7)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;

    final Map<String, List<ProfileDocument>> groupedDocs = {};
    for (var doc in profile.documents) {
      final cat = doc.category.isNotEmpty ? doc.category : 'General Documents';
      groupedDocs.putIfAbsent(cat, () => []).add(doc);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (profile.documents.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: const Column(
              children: [
                Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('No documents found in vault.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          )
        else
          ...groupedDocs.entries.map((entry) {
            final category = entry.key;
            final docsList = entry.value;
            return _buildSectionCard(
              title: category,
              icon: category.toUpperCase() == 'AADHAR' || category.toUpperCase() == 'PAN' || category.toUpperCase() == 'IDENTITY'
                  ? Icons.badge_rounded
                  : Icons.folder_shared_rounded,
              children: docsList.map((doc) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Uploaded At: ${doc.uploadedAt}${doc.uploadedBy.isNotEmpty ? " by ${doc.uploadedBy}" : ""}',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 20),
                        onPressed: () => openMockDocViewer(context, doc.name, doc.category),
                      ),
                      if (isHR) ...[
                        const SizedBox(width: 12),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        if (isHR) ...[
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
            label: const Text('Upload Document', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
