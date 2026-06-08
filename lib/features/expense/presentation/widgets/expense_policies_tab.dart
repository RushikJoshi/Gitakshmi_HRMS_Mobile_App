import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ExpensePoliciesTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const ExpensePoliciesTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Company Expense Policies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Expense claims are automatically validated against these limits.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: helper.expensePolicies.map((p) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(_categoryIcon(p.category), size: 16, color: primaryColor),
                      const SizedBox(width: 6),
                      Flexible(child: Text(p.category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: primaryColor), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.category == 'Fuel' ? '₹${p.limitPerClaim.toStringAsFixed(0)}/km' : '₹${p.limitPerClaim.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  Text(p.unit, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Policy Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...helper.expensePolicies.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_categoryIcon(p.category), size: 14, color: primaryColor),
                const SizedBox(width: 8),
                Expanded(child: RichText(text: TextSpan(
                  style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                  children: [
                    TextSpan(text: '${p.category}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: p.notes, style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
