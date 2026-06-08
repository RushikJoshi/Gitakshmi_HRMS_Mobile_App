import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_claim_list_tile.dart';

class MyExpensesTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final Function(ExpenseClaimModel) onTapClaim;

  const MyExpensesTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.onTapClaim,
  });

  @override
  Widget build(BuildContext context) {
    final myId = helper.activeEmployeeId;
    final myClaims = helper.expenseClaims.where((c) => c.employeeId == myId).toList();

    if (myClaims.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No expense claims yet', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Tap "New Claim" tab to submit your first expense.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myClaims.length,
      itemBuilder: (context, i) => ExpenseClaimListTile(
        claim: myClaims[i],
        primaryColor: primaryColor,
        onTap: () => onTapClaim(myClaims[i]),
      ),
    );
  }
}
