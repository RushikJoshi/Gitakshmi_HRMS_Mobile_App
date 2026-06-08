import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RequestDeskTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const RequestDeskTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

  @override
  State<RequestDeskTab> createState() => _RequestDeskTabState();
}

class _RequestDeskTabState extends State<RequestDeskTab> {
  final _requestFormKey = GlobalKey<FormState>();

  String _reqCategory = 'IT';
  String _reqType = 'New';
  String _reqPriority = 'Medium';
  final _reqReasonController = TextEditingController();
  final _reqAttachmentController = TextEditingController(text: 'Specification_Doc.pdf');

  @override
  void dispose() {
    _reqReasonController.dispose();
    _reqAttachmentController.dispose();
    super.dispose();
  }

  void _openRequestFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Asset Request Form', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _requestFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDropdownField<String>(
                  labelText: 'Asset Category',
                  value: _reqCategory,
                  items: ['IT', 'Office', 'Field'].map((c) {
                          return DropdownMenuItem(value: c, child: Text(c));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqCategory = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Request Type',
                  value: _reqType,
                  items: ['New', 'Upgrade', 'Replacement', 'Lost Asset'].map((t) {
                          return DropdownMenuItem(value: t, child: Text(t));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqType = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Priority Level',
                  value: _reqPriority,
                  items: ['Low', 'Medium', 'High', 'Critical'].map((p) {
                          return DropdownMenuItem(value: p, child: Text(p));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqPriority = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _reqReasonController,
                        decoration: const InputDecoration(labelText: 'Reason & Context details'),
                        maxLines: 3,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Reason details is required';
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
                    if (_requestFormKey.currentState?.validate() ?? false) {
                      widget.helper.createAssetRequest(
                        category: _reqCategory,
                        type: _reqType,
                        priority: _reqPriority,
                        reason: _reqReasonController.text,
                        attachment: _reqAttachmentController.text,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Asset request submitted to manager approval successfully!')),
                      );
                      _reqReasonController.clear();
                    }
                  },
                  child: const Text('Submit Request', style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _openUpgradeFormDialog() {
    setState(() {
      _reqType = 'Upgrade';
    });
    _openRequestFormDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
                  icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
                  label: const Text('Request Asset', style: TextStyle(color: Colors.white)),
                  onPressed: _openRequestFormDialog,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(side: BorderSide(color: widget.primaryColor)),
                  icon: Icon(Icons.autorenew_rounded, color: widget.primaryColor),
                  label: Text('Request Upgrade', style: TextStyle(color: widget.primaryColor)),
                  onPressed: _openUpgradeFormDialog,
                ),
              )
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: widget.helper.assetRequests.isEmpty
              ? const Center(child: Text('No requests history logged.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.helper.assetRequests.length,
                  itemBuilder: (context, index) {
                    final req = widget.helper.assetRequests[index];
                    final isPending = req.status == 'Pending';
                    final isApproved = req.status == 'Approved';

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
                                  '${req.category} Asset Request (${req.type})',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isPending
                                        ? Colors.amber.shade50
                                        : isApproved
                                            ? Colors.green.shade50
                                            : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    req.status,
                                    style: TextStyle(
                                      color: isPending
                                          ? Colors.amber
                                          : isApproved
                                              ? Colors.green
                                              : Colors.red,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Reason: ${req.reason}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Priority: ${req.priority}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                Text('Date: ${req.date}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
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
