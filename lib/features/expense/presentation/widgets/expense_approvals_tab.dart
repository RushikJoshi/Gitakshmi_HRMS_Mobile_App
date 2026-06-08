import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_status_chip.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class ExpenseApprovalsTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final bool canApprove;
  final bool canFinance;
  final Color primaryColor;

  const ExpenseApprovalsTab({
    super.key,
    required this.helper,
    required this.canApprove,
    required this.canFinance,
    required this.primaryColor,
  });

  @override
  State<ExpenseApprovalsTab> createState() => _ExpenseApprovalsTabState();
}

class _ExpenseApprovalsTabState extends State<ExpenseApprovalsTab> {
  final _partialAmountCtrl = TextEditingController();
  final _partialRemarkCtrl = TextEditingController();
  final _rejectReasonCtrl = TextEditingController();

  @override
  void dispose() {
    _partialAmountCtrl.dispose();
    _partialRemarkCtrl.dispose();
    _rejectReasonCtrl.dispose();
    super.dispose();
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Travel': return Icons.flight_rounded;
      case 'Fuel': return Icons.local_gas_station_rounded;
      case 'Food': return Icons.restaurant_rounded;
      case 'Hotel': return Icons.hotel_rounded;
      case 'Client Meeting': return Icons.handshake_rounded;
      case 'Entertainment': return Icons.theater_comedy_rounded;
      case 'Office Supplies': return Icons.inventory_2_rounded;
      case 'Internet': return Icons.wifi_rounded;
      case 'Mobile Recharge': return Icons.smartphone_rounded;
      case 'Training': return Icons.school_rounded;
      case 'Medical': return Icons.local_hospital_rounded;
      default: return Icons.category_rounded;
    }
  }

  void _showRejectDialog(String claimId) {
    _rejectReasonCtrl.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reject Claim', style: TextStyle(fontWeight: FontWeight.bold)),
        content: AppTextField(
          controller: _rejectReasonCtrl,
          labelText: 'Rejection Reason (required)',
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (_rejectReasonCtrl.text.trim().isEmpty) return;
              widget.helper.rejectExpenseClaim(claimId, _rejectReasonCtrl.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Claim rejected.'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Confirm Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPartialApproveDialog(ExpenseClaimModel claim) {
    _partialAmountCtrl.text = claim.totalClaimed.toStringAsFixed(0);
    _partialRemarkCtrl.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Partial Approval', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Claimed: ₹${claim.totalClaimed.toStringAsFixed(0)}', style: TextStyle(color: widget.primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AppTextField(
              controller: _partialAmountCtrl,
              keyboardType: TextInputType.number,
              labelText: 'Approved Amount (₹)',
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: _partialRemarkCtrl,
              labelText: 'Remarks (reason for partial)',
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              final amt = double.tryParse(_partialAmountCtrl.text.trim());
              if (amt == null || amt <= 0) return;
              widget.helper.partiallyApproveExpenseClaim(claim.id, amt, _partialRemarkCtrl.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Partial approval saved.'), backgroundColor: Colors.orange),
              );
            },
            child: const Text('Partially Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canApprove && !widget.canFinance) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lock_rounded, size: 64, color: AppColors.error),
              SizedBox(height: 16),
              Text('Approvals Restricted', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 8),
              Text(
                'You need "approve_expense" or payroll permissions to access this panel.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final pendingClaims = widget.helper.expenseClaims.where((c) => c.status == 'Pending').toList();
    final pendingAdvances = widget.helper.advanceRequests.where((a) => a.status == 'Pending').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorColor: widget.primaryColor,
            labelColor: widget.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Claims (${pendingClaims.length})'),
              Tab(text: 'Advances (${pendingAdvances.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Claims
            pendingClaims.isEmpty
                ? const Center(child: Text('No pending expense claims.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingClaims.length,
                  itemBuilder: (context, i) {
                    final claim = pendingClaims[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(claim.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(claim.title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₹${claim.totalClaimed.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: widget.primaryColor)),
                                Text('${claim.lineItems.length} items • ${claim.submittedDate}', style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                              ],
                            ),
                            if (claim.policyViolations.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '⚠ ${claim.policyViolations.length} policy violation(s)',
                                  style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold),
                                ),
                              ),
                            const Divider(height: 16),
                            // Item summary
                            ...claim.lineItems.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(_categoryIcon(item.category), size: 12, color: widget.primaryColor),
                                        const SizedBox(width: 6),
                                        Text(item.category, style: const TextStyle(fontSize: 11)),
                                      ],
                                    ),
                                    Text('₹${item.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), foregroundColor: Colors.red),
                                    onPressed: () => _showRejectDialog(claim.id),
                                    child: const Text('Reject'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.orange), foregroundColor: Colors.orange),
                                    onPressed: () => _showPartialApproveDialog(claim),
                                    child: const Text('Partial'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () {
                                      widget.helper.approveExpenseClaim(claim.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Claim approved!'), backgroundColor: Colors.green),
                                      );
                                    },
                                    child: const Text('Approve', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

            // Pending Advances
            pendingAdvances.isEmpty
                ? const Center(child: Text('No pending advance requests.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingAdvances.length,
                  itemBuilder: (context, i) {
                    final adv = pendingAdvances[i];
                    return Card(
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
                                Text(adv.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ExpenseStatusChip(label: adv.status, status: adv.status),
                              ],
                            ),
                            Text('${adv.type}: ${adv.purpose}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            Text('₹${adv.requestedAmount.toStringAsFixed(0)} • By ${adv.expectedDate}', style: TextStyle(fontWeight: FontWeight.bold, color: widget.primaryColor)),
                            const Divider(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), foregroundColor: Colors.red),
                                    onPressed: () {
                                      widget.helper.rejectAdvance(adv.id, 'Rejected by manager');
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Advance rejected.')));
                                    },
                                    child: const Text('Reject'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () {
                                      widget.helper.approveAdvance(adv.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Advance approved!'), backgroundColor: Colors.green),
                                      );
                                    },
                                    child: const Text('Approve', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
