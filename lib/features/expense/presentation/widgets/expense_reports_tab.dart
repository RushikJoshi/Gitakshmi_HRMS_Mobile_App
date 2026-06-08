import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ExpenseReportsTab extends StatelessWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const ExpenseReportsTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

  Color _statusColor(String s) {
    switch (s) {
      case 'Approved': return Colors.green;
      case 'Pending': return Colors.orange;
      case 'Partially Approved': return Colors.blue;
      case 'Rejected': return Colors.red;
      case 'Reimbursed': return Colors.purple;
      case 'Settled': return Colors.teal;
      case 'Processing': return Colors.indigo;
      case 'Paid': return Colors.green;
      default: return Colors.grey;
    }
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

  @override
  Widget build(BuildContext context) {
    final allClaims = helper.expenseClaims;

    // Category totals
    final Map<String, double> categoryTotals = {};
    for (final claim in allClaims) {
      for (final item in claim.lineItems) {
        categoryTotals[item.category] = (categoryTotals[item.category] ?? 0) + item.amount;
      }
    }
    final sortedCategories = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxCategoryAmt = sortedCategories.isEmpty ? 1.0 : sortedCategories.first.value;

    // Employee totals
    final Map<String, double> empTotals = {};
    for (final claim in allClaims) {
      empTotals[claim.employeeName] = (empTotals[claim.employeeName] ?? 0) + claim.totalClaimed;
    }
    final sortedEmp = empTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Status counts
    final statusCount = <String, int>{};
    for (final c in allClaims) {
      statusCount[c.status] = (statusCount[c.status] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Expense Reports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 16),

          // Status summary
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Claims by Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: statusCount.entries.map((e) => Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _statusColor(e.key).withValues(alpha: 0.15)),
                          child: Center(
                            child: Text(
                              '${e.value}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _statusColor(e.key)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(e.key.split(' ').first, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                      ],
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category bar chart
          const Text('Category-wise Spend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  ...sortedCategories.take(8).map((entry) {
                    final pct = entry.value / maxCategoryAmt;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(_categoryIcon(entry.key), size: 14, color: primaryColor),
                          const SizedBox(width: 6),
                          SizedBox(width: 80, child: Text(entry.key, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade100,
                                valueColor: AlwaysStoppedAnimation<Color>(primaryColor.withValues(alpha: 0.7 + 0.3 * pct)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('₹${entry.value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),
                  if (sortedCategories.isEmpty)
                    const Text('No data to display.', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Employee totals
          const Text('Employee-wise Claims', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  ...sortedEmp.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: Text(
                            e.key[0],
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.key, style: const TextStyle(fontSize: 12))),
                        Text('₹${e.value.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  )),
                  if (sortedEmp.isEmpty)
                    const Text('No data to display.', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Grand total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, primaryColor.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Company Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  '₹${allClaims.fold<double>(0, (s, c) => s + c.totalClaimed).toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
