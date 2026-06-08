import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_claim_list_tile.dart';

class ExpenseDashboardTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final Function(ExpenseClaimModel) onTapClaim;

  const ExpenseDashboardTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.onTapClaim,
  });

  @override
  Widget build(BuildContext context) {
    final myId = helper.activeEmployeeId;
    final myClaims = helper.expenseClaims.where((c) => c.employeeId == myId).toList();
    final totalClaimed = myClaims.fold<double>(0, (s, c) => s + c.totalClaimed);
    final totalApproved =
        myClaims
            .where((c) => c.status == 'Approved' || c.status == 'Reimbursed')
            .fold<double>(0, (s, c) => s + c.approvedAmount);
    final totalPending =
        myClaims.where((c) => c.status == 'Pending').fold<double>(0, (s, c) => s + c.totalClaimed);
    final totalRejected =
        myClaims.where((c) => c.status == 'Rejected').fold<double>(0, (s, c) => s + c.totalClaimed);
    final totalReimbursed =
        myClaims.where((c) => c.status == 'Reimbursed').fold<double>(0, (s, c) => s + c.approvedAmount);

    // Policy violation banners
    final violations = myClaims.expand((c) => c.policyViolations).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary Row 1
          Row(
            children: [
              _summaryCard('Total Claimed', '₹${totalClaimed.toStringAsFixed(0)}', primaryColor, Icons.receipt_long_rounded),
              _summaryCard('Approved', '₹${totalApproved.toStringAsFixed(0)}', Colors.green, Icons.check_circle_rounded),
            ],
          ),
          Row(
            children: [
              _summaryCard('Pending', '₹${totalPending.toStringAsFixed(0)}', Colors.orange, Icons.hourglass_top_rounded),
              _summaryCard('Reimbursed', '₹${totalReimbursed.toStringAsFixed(0)}', Colors.purple, Icons.paid_rounded),
            ],
          ),
          Row(
            children: [
              _summaryCard('Rejected', '₹${totalRejected.toStringAsFixed(0)}', Colors.red, Icons.cancel_rounded),
              _summaryCard(
                'Advances',
                '${helper.advanceRequests.where((a) => a.employeeId == myId).length} active',
                Colors.teal,
                Icons.account_balance_wallet_rounded,
              ),
            ],
          ),

          // Policy alerts
          if (violations.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${violations.length} Policy Violation(s) Detected',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...violations.map(
                    (v) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${v.category}: ₹${v.amount.toStringAsFixed(0)} claimed (limit ₹${v.policyLimit.toStringAsFixed(0)})',
                        style: const TextStyle(fontSize: 11, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Text(
            'Recent Claims',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          ...myClaims.take(3).map(
            (c) => ExpenseClaimListTile(
              claim: c,
              primaryColor: primaryColor,
              onTap: () => onTapClaim(c),
            ),
          ),
          if (myClaims.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No expense claims found. Create your first claim!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
