import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ApprovalActionPanel extends StatelessWidget {
  final UnifiedApprovalRequest request;
  final RolePermissionHelper helper;
  final Color primaryColor;
  final Function(String title, String hint, Color color, IconData icon, bool required, void Function(String comment) onConfirm) showActionDialog;

  const ApprovalActionPanel({
    super.key,
    required this.request,
    required this.helper,
    required this.primaryColor,
    required this.showActionDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Your Action Required', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          // Primary actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 12)),
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  label: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => showActionDialog(
                    'Approve',
                    'Add approval comment (e.g. "Approved for business requirement.")',
                    Colors.green,
                    Icons.check_circle_rounded,
                    true,
                    (comment) {
                      helper.approveUnifiedRequest(request.id, comment);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request approved!'), backgroundColor: Colors.green));
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 12)),
                  icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 18),
                  label: const Text('Reject', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => showActionDialog(
                    'Reject',
                    'Reason for rejection (required)...',
                    Colors.red,
                    Icons.cancel_rounded,
                    true,
                    (reason) {
                      helper.rejectUnifiedRequest(request.id, reason);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected.'), backgroundColor: Colors.red));
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Secondary actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.deepOrange),
                    foregroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.undo_rounded, size: 15),
                  label: const Text('Send Back', style: TextStyle(fontSize: 12)),
                  onPressed: () => showActionDialog(
                    'Send Back',
                    'Reason for sending back (e.g. "Missing attachment")...',
                    Colors.deepOrange,
                    Icons.undo_rounded,
                    true,
                    (note) {
                      helper.sendBackRequest(request.id, note);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request sent back to applicant.'), backgroundColor: Colors.deepOrange),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.help_rounded, size: 15),
                  label: const Text('Request Info', style: TextStyle(fontSize: 12)),
                  onPressed: () => showActionDialog(
                    'Request Info',
                    'What additional info do you need?',
                    Colors.blue,
                    Icons.help_rounded,
                    true,
                    (question) {
                      helper.requestMoreInfoOnRequest(request.id, question);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Info request sent to applicant.'), backgroundColor: Colors.blue),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purple),
                    foregroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.trending_up_rounded, size: 15),
                  label: const Text('Escalate', style: TextStyle(fontSize: 12)),
                  onPressed: () => showActionDialog(
                    'Escalate',
                    'Reason for escalation...',
                    Colors.purple,
                    Icons.trending_up_rounded,
                    true,
                    (note) {
                      helper.escalateRequest(request.id, note);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request escalated.'), backgroundColor: Colors.purple),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
