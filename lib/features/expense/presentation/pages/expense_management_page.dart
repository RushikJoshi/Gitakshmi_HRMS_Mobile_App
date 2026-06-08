import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';

import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_status_chip.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_dashboard_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/my_expenses_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/new_claim_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/advance_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/history_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_approvals_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/reimbursements_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_policies_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_reports_tab.dart';

class ExpenseManagementPage extends StatefulWidget {
  const ExpenseManagementPage({super.key});

  @override
  State<ExpenseManagementPage> createState() => _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends State<ExpenseManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openClaimDetailSheet(ExpenseClaimModel claim, Color primary, RolePermissionHelper helper) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.88,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExpenseStatusChip(label: claim.status, status: claim.status),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
              Text(claim.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('Submitted: ${claim.submittedDate}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              if (claim.approvedBy.isNotEmpty)
                Text('Approved by: ${claim.approvedBy} on ${claim.approvedDate}', style: const TextStyle(fontSize: 11, color: Colors.green)),
              const SizedBox(height: 16),

              // Amounts
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _amountBox('Claimed', '₹${claim.totalClaimed.toStringAsFixed(0)}', primary),
                    if (claim.approvedAmount > 0)
                      _amountBox('Approved', '₹${claim.approvedAmount.toStringAsFixed(0)}', Colors.green),
                    if (claim.approvedAmount < claim.totalClaimed && claim.approvedAmount > 0)
                      _amountBox('Variance', '₹${(claim.totalClaimed - claim.approvedAmount).toStringAsFixed(0)}', Colors.orange),
                  ],
                ),
              ),

              // Rejection reason
              if (claim.rejectionReason.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(claim.rejectionReason, style: const TextStyle(fontSize: 11, color: Colors.red))),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Text('Expense Line Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              ...claim.lineItems.map((item) => _lineItemCard(item, primary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountBox(String label, String value, Color color) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
    ],
  );

  Widget _lineItemCard(ExpenseLineItem item, Color primary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: item.exceedsPolicy ? Colors.red.shade200 : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10),
        color: item.exceedsPolicy ? Colors.red.shade50 : Colors.white,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (item.exceedsPolicy ? Colors.red : primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_categoryIcon(item.category), color: item.exceedsPolicy ? Colors.red : primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: item.exceedsPolicy ? Colors.red : AppColors.textPrimary),
                ),
                Text(item.description, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                if (item.billAttached.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.attach_file_rounded, size: 10, color: Colors.green),
                      Text(item.billAttached, style: const TextStyle(fontSize: 9, color: Colors.green)),
                    ],
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${item.amount.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: item.exceedsPolicy ? Colors.red : AppColors.textPrimary)),
              if (item.exceedsPolicy)
                Text('Limit: ₹${item.policyLimit.toStringAsFixed(0)}', style: const TextStyle(fontSize: 9, color: Colors.red)),
              Text(item.date, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
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
    final helper = RolePermissionHelper.instance;
    return AnimatedBuilder(
      animation: helper,
      builder: (context, _) {
        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primary = config.primaryColor;
        final perms = helper.getFinalPermissions(helper.activeEmployeeId);
        final canApprove = perms.contains('approve_expense');
        final canViewPayroll = perms.contains('generate_payroll') || perms.contains('view_payroll');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense & Reimbursement'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primary,
              labelColor: primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                const Tab(icon: Icon(Icons.dashboard_rounded), text: 'Dashboard'),
                const Tab(icon: Icon(Icons.receipt_long_rounded), text: 'My Expenses'),
                const Tab(icon: Icon(Icons.add_card_rounded), text: 'New Claim'),
                const Tab(icon: Icon(Icons.account_balance_wallet_rounded), text: 'Advance'),
                const Tab(icon: Icon(Icons.history_rounded), text: 'History'),
                Tab(icon: const Icon(Icons.approval_rounded), text: 'Approvals${canApprove ? "" : " 🔒"}'),
                const Tab(icon: Icon(Icons.payments_rounded), text: 'Reimbursements'),
                const Tab(icon: Icon(Icons.policy_rounded), text: 'Policies'),
                const Tab(icon: Icon(Icons.bar_chart_rounded), text: 'Reports'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ExpenseDashboardTab(
                helper: helper,
                primaryColor: primary,
                onTapClaim: (claim) => _openClaimDetailSheet(claim, primary, helper),
              ),
              MyExpensesTab(
                helper: helper,
                primaryColor: primary,
                onTapClaim: (claim) => _openClaimDetailSheet(claim, primary, helper),
              ),
              NewClaimTab(
                helper: helper,
                primaryColor: primary,
                onSubmitClaimSuccess: () => _tabController.animateTo(1),
              ),
              AdvanceTab(
                helper: helper,
                primaryColor: primary,
              ),
              HistoryTab(
                helper: helper,
                primaryColor: primary,
                onTapClaim: (claim) => _openClaimDetailSheet(claim, primary, helper),
              ),
              ExpenseApprovalsTab(
                helper: helper,
                canApprove: canApprove,
                canFinance: canViewPayroll,
                primaryColor: primary,
              ),
              ReimbursementsTab(
                helper: helper,
                canFinance: canViewPayroll,
                primaryColor: primary,
              ),
              ExpensePoliciesTab(
                helper: helper,
                primaryColor: primary,
              ),
              ExpenseReportsTab(
                helper: helper,
                primaryColor: primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
