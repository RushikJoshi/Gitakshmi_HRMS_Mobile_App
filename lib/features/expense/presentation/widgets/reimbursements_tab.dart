import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_status_chip.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class ReimbursementsTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final bool canFinance;
  final Color primaryColor;

  const ReimbursementsTab({
    super.key,
    required this.helper,
    required this.canFinance,
    required this.primaryColor,
  });

  @override
  State<ReimbursementsTab> createState() => _ReimbursementsTabState();
}

class _ReimbursementsTabState extends State<ReimbursementsTab> {
  final _payRefCtrl = TextEditingController();

  @override
  void dispose() {
    _payRefCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final approved = widget.helper.expenseClaims
        .where((c) => c.status == 'Approved' || c.status == 'Partially Approved')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.canFinance && approved.isNotEmpty) ...[
            const Text('Process Reimbursements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            ...approved.map(
              (c) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(c.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          Text('₹${c.approvedAmount.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: widget.primaryColor)),
                        ],
                      ),
                      Text(c.title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _payRefCtrl,
                        decoration: const InputDecoration(labelText: 'Payment Reference No. (NEFT/UPI)', border: OutlineInputBorder(), isDense: true),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        icon: const Icon(Icons.payments_rounded, color: Colors.white, size: 16),
                        label: const Text('Mark as Paid', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (_payRefCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter payment reference number.')));
                            return;
                          }
                          widget.helper.processReimbursement(c.id, _payRefCtrl.text.trim());
                          _payRefCtrl.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reimbursement processed!'), backgroundColor: Colors.purple),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 24),
          ],

          const Text('Reimbursement History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          if (widget.helper.reimbursements.isEmpty)
            const Text('No reimbursements recorded yet.', style: TextStyle(color: AppColors.textSecondary))
          else
            ...widget.helper.reimbursements.map(
              (r) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (r.status == 'Paid' ? Colors.green : Colors.indigo).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          r.status == 'Paid' ? Icons.verified_rounded : Icons.sync_rounded,
                          color: r.status == 'Paid' ? Colors.green : Colors.indigo,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(r.claimTitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            if (r.paymentReferenceNo.isNotEmpty)
                              Text(
                                'Ref: ${r.paymentReferenceNo}',
                                style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            Text(r.processedDate, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('₹${r.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          ExpenseStatusChip(label: r.status, status: r.status),
                          const SizedBox(height: 4),
                          Text(r.bankAccount, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
