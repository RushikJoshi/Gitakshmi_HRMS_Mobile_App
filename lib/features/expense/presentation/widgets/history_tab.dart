import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_claim_list_tile.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';

class HistoryTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final Function(ExpenseClaimModel) onTapClaim;

  const HistoryTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.onTapClaim,
  });

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  String _filterStatus = 'All';
  String _filterCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final allClaims = widget.helper.expenseClaims;
    final statuses = ['All', 'Pending', 'Approved', 'Partially Approved', 'Rejected', 'Reimbursed'];
    final categories = [
      'All',
      'Travel',
      'Fuel',
      'Food',
      'Hotel',
      'Client Meeting',
      'Entertainment',
      'Office Supplies',
      'Internet',
      'Mobile Recharge',
      'Training',
      'Medical',
      'Other',
    ];

    var filtered =
        allClaims.where((c) {
          final statusOk = _filterStatus == 'All' || c.status == _filterStatus;
          final categoryOk = _filterCategory == 'All' || c.lineItems.any((l) => l.category == _filterCategory);
          return statusOk && categoryOk;
        }).toList();

    return Column(
      children: [
        // Filters
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterStatus,
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder(), isDense: true),
                  items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _filterStatus = v ?? 'All'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterCategory,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(), isDense: true),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _filterCategory = v ?? 'All'),
                ),
              ),
            ],
          ),
        ),
        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Text('${filtered.length} claims found', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Expanded(
          child:
              filtered.isEmpty
                  ? const Center(child: Text('No claims match the current filters.', style: TextStyle(color: AppColors.textSecondary)))
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => ExpenseClaimListTile(
                      claim: filtered[i],
                      primaryColor: widget.primaryColor,
                      onTap: () => widget.onTapClaim(filtered[i]),
                    ),
                  ),
        ),
      ],
    );
  }
}
