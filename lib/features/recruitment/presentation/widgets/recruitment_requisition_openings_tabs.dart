import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RecruitmentRequisitionTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final EmployeeModel activeEmp;
  final Color primaryColor;

  const RecruitmentRequisitionTab({
    super.key,
    required this.rHelper,
    required this.activeEmp,
    required this.primaryColor,
  });

  @override
  State<RecruitmentRequisitionTab> createState() => _RecruitmentRequisitionTabState();
}

class _RecruitmentRequisitionTabState extends State<RecruitmentRequisitionTab> {
  final _reqFormKey = GlobalKey<FormState>();

  String _reqDept = 'Mobile Development';
  String _reqDesignation = '';
  int _reqPositions = 1;
  String _reqEmpType = 'Permanent';
  String _reqBranch = 'Ahmedabad HQ';
  final String _reqPriority = 'Medium';
  final _reqBudgetController = TextEditingController(text: '12 LPA');
  String _reqReason = 'New Position';

  @override
  void dispose() {
    _reqBudgetController.dispose();
    super.dispose();
  }

  void _openRequisitionFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Raise Manpower Request', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _reqFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDropdownField<String>(
                  labelText: 'Department',
                  value: _reqDept,
                  items: ['Mobile Development', 'Product & Engineering', 'Product & Design', 'Sales', 'HR'].map((d) {
                          return DropdownMenuItem(value: d, child: Text(d));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqDept = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Designation / Title'),
                        onChanged: (v) => _reqDesignation = v,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      AppDropdownField<int>(
                  labelText: 'No. Of Positions',
                  value: _reqPositions,
                  items: [1, 2, 3, 5, 10].map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.toString()));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqPositions = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Employment Type',
                  value: _reqEmpType,
                  items: ['Permanent', 'Contract', 'Intern', 'Part Time', 'Consultant'].map((t) {
                          return DropdownMenuItem(value: t, child: Text(t));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqEmpType = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Branch Location',
                  value: _reqBranch,
                  items: ['Ahmedabad HQ', 'Mumbai Branch', 'Remote'].map((b) {
                          return DropdownMenuItem(value: b, child: Text(b));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqBranch = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppTextField(
                  controller: _reqBudgetController,
                  labelText: 'Salary Budget (e.g. 12 LPA)',
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Reason For Hiring',
                  value: _reqReason,
                  items: ['New Position', 'Replacement', 'Project Requirement', 'Expansion', 'Urgent Requirement'].map((r) {
                          return DropdownMenuItem(value: r, child: Text(r));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _reqReason = val);
                        },
                ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (_reqFormKey.currentState?.validate() ?? false) {
                      widget.rHelper.createRequisition(
                        department: _reqDept,
                        designation: _reqDesignation,
                        positions: _reqPositions,
                        employmentType: _reqEmpType,
                        branch: _reqBranch,
                        expectedDate: '25-Jun-2026',
                        priority: _reqPriority,
                        budget: _reqBudgetController.text,
                        reason: _reqReason,
                        files: ['JD_${_reqDesignation.replaceAll(" ", "_")}.pdf'],
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit Requisition'),
                ),
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
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
            label: const Text('Create Requisition Request', style: TextStyle(color: Colors.white)),
            onPressed: _openRequisitionFormDialog,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.rHelper.requisitions.length,
            itemBuilder: (context, index) {
              final req = widget.rHelper.requisitions[index];
              final isPending = req.status == 'Pending';
              final currentApprover = req.approvalFlow[req.currentApprovalStep < req.approvalFlow.length ? req.currentApprovalStep : req.approvalFlow.length - 1];

              bool canApprove = false;
              if (isPending) {
                if (req.currentApprovalStep == 0 && widget.activeEmp.roleId == 'r_tl') canApprove = true;
                if (req.currentApprovalStep == 1 && widget.activeEmp.roleId == 'r_manager' && widget.activeEmp.dept == req.department) canApprove = true;
                if (req.currentApprovalStep == 2 && widget.activeEmp.roleId == 'r_hr') canApprove = true;
                if (req.currentApprovalStep == 3 && widget.activeEmp.roleId == 'r_admin') canApprove = true;
                if (widget.activeEmp.roleId == 'r_admin') canApprove = true;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(req.designation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(req.status, style: TextStyle(color: req.status == 'Approved' ? Colors.green : Colors.amber.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Department: ${req.department} • Vacancies: ${req.positionsCount} • Budget: ${req.budget}'),
                      Text('Attachments: ${req.attachments.join(", ")}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(req.approvalFlow.length, (idx) {
                          final step = req.approvalFlow[idx];
                          final isDone = idx < req.currentApprovalStep;
                          final isCurr = idx == req.currentApprovalStep && isPending;
                          return Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: isDone ? Colors.green : isCurr ? Colors.amber : Colors.grey.shade200,
                                  child: isDone ? const Icon(Icons.check, size: 8, color: Colors.white) : Text((idx + 1).toString(), style: const TextStyle(fontSize: 8)),
                                ),
                                Text(step, style: const TextStyle(fontSize: 7), textAlign: TextAlign.center),
                              ],
                            ),
                          );
                        }),
                      ),
                      if (canApprove) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error), foregroundColor: AppColors.error),
                              onPressed: () => widget.rHelper.rejectRequisition(req.id, widget.activeEmp.name),
                              child: const Text('Reject'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                              onPressed: () => widget.rHelper.approveRequisition(req.id, currentApprover),
                              child: const Text('Approve Requisition'),
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecruitmentOpeningsTab extends StatelessWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentOpeningsTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rHelper.openings.length,
      itemBuilder: (context, index) {
        final job = rHelper.openings[index];
        final isOpen = job.status == 'Open';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(job.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Switch(
                      value: isOpen,
                      activeColor: primaryColor,
                      onChanged: (val) {
                        rHelper.updateJobStatus(job.id, val ? 'Open' : 'On Hold');
                      },
                    ),
                  ],
                ),
                Text('Department: ${job.department} • Exp: ${job.experience}'),
                Text('Location: ${job.location} • Budget: ${job.salaryRange}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: job.skills.map((s) => Chip(
                    label: Text(s, style: const TextStyle(fontSize: 10)),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.grey.shade50,
                  )).toList(),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type: ${job.employmentType}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Row(
                      children: job.publishChannels.map((c) => Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
                        child: Text(c, style: TextStyle(fontSize: 9, color: primaryColor, fontWeight: FontWeight.bold)),
                      )).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
