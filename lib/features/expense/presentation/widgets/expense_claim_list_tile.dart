import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_status_chip.dart';

class ExpenseClaimListTile extends StatelessWidget {
  final ExpenseClaimModel claim;
  final Color primaryColor;
  final VoidCallback onTap;

  const ExpenseClaimListTile({
    super.key,
    required this.claim,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      claim.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ExpenseStatusChip(label: claim.status, status: claim.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${claim.totalClaimed.toStringAsFixed(0)} claimed',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryColor),
                  ),
                  if (claim.approvedAmount > 0 && claim.approvedAmount != claim.totalClaimed)
                    Text(
                      '₹${claim.approvedAmount.toStringAsFixed(0)} approved',
                      style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${claim.lineItems.length} item(s)', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  Text(claim.submittedDate, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                ],
              ),
              if (claim.policyViolations.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${claim.policyViolations.length} policy violation(s)',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
