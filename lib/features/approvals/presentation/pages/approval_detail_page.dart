import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';

import 'package:gitakshmi_hrms_app/features/approvals/presentation/widgets/approval_document_preview.dart';
import 'package:gitakshmi_hrms_app/features/approvals/presentation/widgets/approval_history_timeline.dart';
import 'package:gitakshmi_hrms_app/features/approvals/presentation/widgets/approval_action_panel.dart';

class ApprovalDetailPage extends StatefulWidget {
  final UnifiedApprovalRequest request;
  const ApprovalDetailPage({super.key, required this.request});

  @override
  State<ApprovalDetailPage> createState() => _ApprovalDetailPageState();
}

class _ApprovalDetailPageState extends State<ApprovalDetailPage> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Color _statusColor(String s) {
    switch (s) {
      case 'Approved': return Colors.green;
      case 'Rejected': return Colors.red;
      case 'Pending': return Colors.orange;
      case 'Waiting': return Colors.grey;
      case 'Sent Back': return Colors.deepOrange;
      case 'Info Requested': return Colors.blue;
      case 'Escalated': return Colors.purple;
      default: return Colors.grey;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      default: return Colors.blue;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Leave': return Icons.beach_access_rounded;
      case 'Expense': return Icons.receipt_long_rounded;
      case 'Asset Request': return Icons.devices_other_rounded;
      case 'Recruitment': return Icons.people_alt_rounded;
      case 'Travel': return Icons.flight_rounded;
      case 'Budget': return Icons.account_balance_rounded;
      case 'Attendance Correction': return Icons.edit_calendar_rounded;
      case 'Offer Letter': return Icons.description_rounded;
      case 'Resignation': return Icons.logout_rounded;
      default: return Icons.assignment_rounded;
    }
  }

  Widget _sectionHeader(String title, IconData icon, Color primary) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Row(children: [
      Icon(icon, size: 18, color: primary),
      const SizedBox(width: 8),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primary)),
      const SizedBox(width: 12),
      Expanded(child: Divider(color: primary.withValues(alpha: 0.2))),
    ]),
  );

  // ─── Action dialog helper ────────────────────────────────────────────────
  void _showActionDialog({
    required String title,
    required String hint,
    required Color color,
    required IconData icon,
    bool required = false,
    required void Function(String comment) onConfirm,
  }) {
    _commentCtrl.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (required)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Comment is required to proceed.', style: TextStyle(fontSize: 11, color: color)),
            ),
          TextField(
            controller: _commentCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            icon: Icon(icon, color: Colors.white, size: 16),
            label: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (required && _commentCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a $title reason.'), backgroundColor: Colors.red));
                return;
              }
              Navigator.pop(ctx);
              onConfirm(_commentCtrl.text.trim());
            },
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    return AnimatedBuilder(
      animation: helper,
      builder: (context, _) {
        // Always get fresh copy of request from state
        final req = helper.approvalRequests.firstWhere((r) => r.id == widget.request.id, orElse: () => widget.request);
        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primary = config.primaryColor;
        final perms = helper.getFinalPermissions(helper.activeEmployeeId);
        final canApprove = perms.contains('approve_request');
        final canFullWorkflow = perms.contains('view_full_workflow');
        final myEmpId = helper.activeEmployeeId;

        // Determine if the active user is the current pending approver
        final pendingLevel = req.workflowLevels.where((l) => l.decision == 'Pending').isEmpty
            ? null
            : req.workflowLevels.firstWhere((l) => l.decision == 'Pending');
        final isMyTurn = canApprove && pendingLevel != null && pendingLevel.approverEmpId == myEmpId;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(req.requestNo, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary)),
              Text(req.type, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
            actions: [
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                tooltip: 'Copy Request No.',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: req.requestNo));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request number copied!'), duration: Duration(seconds: 1)));
                },
              ),
            ],
          ),
          body: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  // ── HEADER CARD ──────────────────────────────────────────
                  _buildHeaderCard(req, primary),
                  // ── WORKFLOW SUMMARY ─────────────────────────────────────
                  _buildWorkflowSummary(req, primary),
                  // ── REQUEST DETAILS ──────────────────────────────────────
                  _sectionHeader('Request Details', _typeIcon(req.type), primary),
                  _buildRequestDetails(req, primary),
                  // ── ATTACHMENTS ──────────────────────────────────────────
                  if (req.attachments.isNotEmpty) ...[
                    _sectionHeader('Attachments (${req.attachments.length})', Icons.attach_file_rounded, primary),
                    ApprovalDocumentPreview(request: req, primaryColor: primary),
                  ],
                  // ── WORKFLOW TIMELINE ────────────────────────────────────
                  _sectionHeader('Approval Workflow Timeline', Icons.account_tree_rounded, primary),
                  ApprovalWorkflowTimeline(request: req, canSeeAll: canFullWorkflow, activeEmployeeId: myEmpId),
                  // ── ACTIVITY HISTORY ─────────────────────────────────────
                  _sectionHeader('Activity History', Icons.history_rounded, primary),
                  ApprovalActivityHistory(request: req),
                  const SizedBox(height: 100), // bottom padding for action bar
                ]),
              ),
            ),
            // ── STICKY ACTION BAR ─────────────────────────────────────────
            if (isMyTurn && req.status == 'Pending')
              ApprovalActionPanel(
                request: req,
                helper: helper,
                primaryColor: primary,
                showActionDialog: (title, hint, color, icon, reqFlag, onConfirm) {
                  _showActionDialog(title: title, hint: hint, color: color, icon: icon, required: reqFlag, onConfirm: onConfirm);
                },
              ),
          ]),
        );
      },
    );
  }

  // ── HEADER CARD ─────────────────────────────────────────────────────────
  Widget _buildHeaderCard(UnifiedApprovalRequest req, Color primary) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon(req.type), color: primary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(req.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text('${req.employeeName} • ${req.department}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                _chip(req.status, _statusColor(req.status)),
                const SizedBox(width: 8),
                _chip(req.priority, _priorityColor(req.priority)),
              ]),
            ])),
          ]),
          const Divider(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _infoBox('Request No.', req.requestNo, Icons.tag_rounded),
            _infoBox('Date', req.requestDate, Icons.calendar_today_rounded),
            _infoBox('Attachments', '${req.attachments.length}', Icons.attach_file_rounded),
          ]),
        ]),
      ),
    );
  }

  Widget _infoBox(String label, String value, IconData icon) => Column(children: [
    Icon(icon, size: 14, color: AppColors.textSecondary),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
    Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
  ]);

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
  );

  // ── WORKFLOW SUMMARY ─────────────────────────────────────────────────────
  Widget _buildWorkflowSummary(UnifiedApprovalRequest req, Color primary) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary.withValues(alpha: 0.08), primary.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: 0.15)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _summaryItem('Step', '${req.completedLevels + (req.status == 'Pending' ? 1 : 0)} of ${req.totalLevels}', Icons.stairs_rounded, primary),
        Container(width: 1, height: 36, color: primary.withValues(alpha: 0.2)),
        _summaryItem('Pending With', req.status == 'Pending' ? req.pendingWithName.split(' ').first : '—', Icons.person_rounded, primary),
        Container(width: 1, height: 36, color: primary.withValues(alpha: 0.2)),
        _summaryItem('Role', req.status == 'Pending' ? req.pendingWithRole : req.status, Icons.badge_rounded, primary),
      ]),
    );
  }

  Widget _summaryItem(String label, String value, IconData icon, Color primary) => Column(children: [
    Icon(icon, size: 16, color: primary),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primary), overflow: TextOverflow.ellipsis),
    Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
  ]);

  // ── REQUEST DETAILS ──────────────────────────────────────────────────────
  Widget _buildRequestDetails(UnifiedApprovalRequest req, Color primary) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(children: [
          ...req.typeSpecificData.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 110, child: Text(entry.key, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
              const Text(' : ', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
              Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
            ]),
          )),
        ]),
      ),
    );
  }
}
