import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ApprovalDocumentPreview extends StatelessWidget {
  final UnifiedApprovalRequest request;
  final Color primaryColor;

  const ApprovalDocumentPreview({
    super.key,
    required this.request,
    required this.primaryColor,
  });

  static IconData fileIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return Icons.picture_as_pdf_rounded;
      case 'JPG':
      case 'PNG': return Icons.image_rounded;
      case 'DOC':
      case 'DOCX': return Icons.article_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  static Color fileColor(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return Colors.red;
      case 'JPG':
      case 'PNG': return Colors.green;
      case 'DOC':
      case 'DOCX': return Colors.blue;
      default: return Colors.grey;
    }
  }

  void openAttachmentViewer(BuildContext context, ApprovalAttachment att) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: fileColor(att.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(fileIcon(att.type), color: fileColor(att.type), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(att.filename, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('${att.type} • ${att.sizeDisplay}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${att.filename}...'), backgroundColor: Colors.teal));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_rounded, color: AppColors.textSecondary),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sharing ${att.filename}...'), backgroundColor: Colors.blue));
                          },
                        ),
                        IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Preview area
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: fileColor(att.type).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: fileColor(att.type).withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            children: [
                              Icon(fileIcon(att.type), size: 80, color: fileColor(att.type).withValues(alpha: 0.7)),
                              const SizedBox(height: 16),
                              Text(att.filename, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text('${att.type} File', style: TextStyle(fontSize: 13, color: fileColor(att.type))),
                              Text(att.sizeDisplay, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 20),
                              const Text(
                                'Preview not available in this environment.\nUse Download or Share to access the file.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, color: AppColors.textLight),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                              icon: const Icon(Icons.download_rounded, color: Colors.white),
                              label: const Text('Download', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${att.filename}...'), backgroundColor: Colors.teal));
                              },
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                              icon: const Icon(Icons.share_rounded, color: Colors.white),
                              label: const Text('Share', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sharing ${att.filename}...'), backgroundColor: Colors.blue));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: request.attachments.map((att) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: fileColor(att.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(fileIcon(att.type), color: fileColor(att.type), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(att.filename, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: fileColor(att.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(att.type, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: fileColor(att.type))),
                        ),
                        const SizedBox(width: 8),
                        Text(att.sizeDisplay, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                children: [
                  _attBtn(Icons.visibility_rounded, 'View', Colors.blue, () => openAttachmentViewer(context, att)),
                  _attBtn(
                    Icons.download_rounded,
                    'Download',
                    Colors.teal,
                    () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${att.filename}...'), backgroundColor: Colors.teal)),
                  ),
                  _attBtn(
                    Icons.share_rounded,
                    'Share',
                    Colors.purple,
                    () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sharing ${att.filename}...'), backgroundColor: Colors.purple)),
                  ),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _attBtn(IconData icon, String tooltip, Color color, VoidCallback onTap) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 18),
      ),
    ),
  );
}
