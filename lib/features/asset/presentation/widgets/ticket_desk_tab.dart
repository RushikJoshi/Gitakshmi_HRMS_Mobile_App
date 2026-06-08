import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class TicketDeskTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final List<CompanyAssetModel> myAssets;
  final Color primaryColor;

  const TicketDeskTab({
    super.key,
    required this.helper,
    required this.myAssets,
    required this.primaryColor,
  });

  @override
  State<TicketDeskTab> createState() => _TicketDeskTabState();
}

class _TicketDeskTabState extends State<TicketDeskTab> {
  final _ticketFormKey = GlobalKey<FormState>();

  String? _tktAssetId;
  String _tktIssueType = 'Hardware Malfunction';
  String _tktPriority = 'High';
  final _tktDescController = TextEditingController();

  @override
  void dispose() {
    _tktDescController.dispose();
    super.dispose();
  }

  void _openTicketFormDialog() {
    _tktAssetId = widget.myAssets.first.id;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Log Asset Support Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _ticketFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDropdownField<String>(
                  labelText: 'Affected Asset',
                  value: _tktAssetId,
                  items: widget.myAssets.map((a) {
                          return DropdownMenuItem(value: a.id, child: Text(a.name, style: const TextStyle(fontSize: 12)));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _tktAssetId = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Issue Category',
                  value: _tktIssueType,
                  items: ['Broken Screen', 'Battery Issue', 'Keyboard Issue', 'Hardware Malfunction', 'Lost Asset', 'Damaged SIM Card', 'Other'].map((i) {
                          return DropdownMenuItem(value: i, child: Text(i));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _tktIssueType = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Severity level',
                  value: _tktPriority,
                  items: ['Low', 'Medium', 'High', 'Critical'].map((p) {
                          return DropdownMenuItem(value: p, child: Text(p));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _tktPriority = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _tktDescController,
                        decoration: const InputDecoration(labelText: 'Provide diagnostic failure notes'),
                        maxLines: 3,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Description is required';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
                  onPressed: () {
                    if (_ticketFormKey.currentState?.validate() ?? false) {
                      final asset = widget.myAssets.firstWhere((a) => a.id == _tktAssetId);
                      widget.helper.reportAssetIssue(
                        assetId: asset.id,
                        assetName: asset.name,
                        issueType: _tktIssueType,
                        description: _tktDescController.text,
                        priority: _tktPriority,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Support ticket logged to IT successfully!')),
                      );
                      _tktDescController.clear();
                    }
                  },
                  child: const Text('Log Ticket', style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.report_problem_rounded, color: Colors.white),
            label: const Text('Report Asset Issue / Raise Ticket', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (widget.myAssets.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You must have assigned assets to report an issue ticket.')),
                );
                return;
              }
              _openTicketFormDialog();
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: widget.helper.assetTickets.isEmpty
              ? const Center(child: Text('No support tickets reported.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.helper.assetTickets.length,
                  itemBuilder: (context, index) {
                    final tkt = widget.helper.assetTickets[index];
                    final isOpen = tkt.status == 'Open';
                    final isResolved = tkt.status == 'Resolved';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Issue: ${tkt.issueType}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isOpen
                                        ? Colors.blue.shade50
                                        : isResolved
                                            ? Colors.green.shade50
                                            : Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tkt.status,
                                    style: TextStyle(
                                      color: isOpen
                                          ? Colors.blue
                                          : isResolved
                                              ? Colors.green
                                              : Colors.amber,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Asset: ${tkt.assetName}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            Text(tkt.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            if (isResolved && tkt.resolutionRemarks.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.green.shade50,
                                child: Text(
                                  'IT Remarks: ${tkt.resolutionRemarks}',
                                  style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Priority: ${tkt.priority}', style: TextStyle(fontSize: 10, color: tkt.priority == 'Critical' ? Colors.red : Colors.black, fontWeight: FontWeight.bold)),
                                Text('Date: ${tkt.date}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }
}
