import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_dashboard_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/my_expenses_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/new_claim_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/reimbursements_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/advance_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_reports_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_policies_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_approvals_tab.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/history_tab.dart';
import 'add_expense_page.dart';

class ExpenseManagementPage extends StatefulWidget {
  const ExpenseManagementPage({super.key});

  @override
  State<ExpenseManagementPage> createState() => _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends State<ExpenseManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showClaimDetailsDialog(BuildContext context, ExpenseClaimModel claim) {
    final primaryColor = SaaSBrandingHelper.instance.configNotifier.value.primaryColor;
    final emp = RolePermissionHelper.instance.employees.firstWhere(
      (e) => e.id == claim.employeeId,
      orElse: () => RolePermissionHelper.instance.employees.first,
    );
    final department = emp.dept;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  claim.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (claim.status == 'Approved' || claim.status == 'Paid' ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  claim.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: claim.status == 'Approved' || claim.status == 'Paid' ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Employee', claim.employeeName),
                  _detailRow('Department', department),
                  _detailRow('Submitted Date', claim.submittedDate),
                  _detailRow('Total Claimed', '₹${claim.totalClaimed.toStringAsFixed(0)}'),
                  if (claim.approvedAmount > 0)
                    _detailRow('Approved Amount', '₹${claim.approvedAmount.toStringAsFixed(0)}', isHighlight: true),
                  const Divider(height: 24),
                  const Text('Line Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  ...claim.lineItems.map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryColor)),
                              Text('₹${item.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          if (item.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(item.description, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          ],
                          const SizedBox(height: 4),
                          Text(item.date, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;

    return AnimatedBuilder(
      animation: helper,
      builder: (context, _) {
        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primaryColor = config.primaryColor;

        // Dynamic Role permissions
        final activeEmpId = helper.activeEmployeeId;
        final canApprove = helper.activeEmployee.roleId == 'r_admin' ||
            helper.activeEmployee.roleId == 'r_finance' ||
            helper.activeEmployee.roleId == 'r_manager' ||
            helper.hasPermission(activeEmpId, 'approve_expense');
        final canFinance = helper.activeEmployee.roleId == 'r_admin' ||
            helper.activeEmployee.roleId == 'r_finance';

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FC),
          appBar: AppBar(
            title: const Text('Expense Management'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard_rounded), text: 'Summary'),
                Tab(icon: Icon(Icons.receipt_long_rounded), text: 'My Expenses'),
                Tab(icon: Icon(Icons.add_circle_outline_rounded), text: 'New Claim'),
                Tab(icon: Icon(Icons.payments_rounded), text: 'Reimbursements'),
                Tab(icon: Icon(Icons.account_balance_wallet_rounded), text: 'Advances'),
                Tab(icon: Icon(Icons.fact_check_rounded), text: 'Approvals'),
                Tab(icon: Icon(Icons.analytics_rounded), text: 'Reports'),
                Tab(icon: Icon(Icons.policy_rounded), text: 'Policies'),
                Tab(icon: Icon(Icons.history_rounded), text: 'History'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ExpenseDashboardTab(
                helper: helper,
                primaryColor: primaryColor,
                onTapClaim: (claim) => _showClaimDetailsDialog(context, claim),
              ),
              MyExpensesTab(
                helper: helper,
                primaryColor: primaryColor,
                onTapClaim: (claim) => _showClaimDetailsDialog(context, claim),
              ),
              NewClaimTab(
                helper: helper,
                primaryColor: primaryColor,
                onSubmitClaimSuccess: () {
                  _tabController.animateTo(1); // Switch to My Expenses
                },
              ),
              ReimbursementsTab(
                helper: helper,
                canFinance: canFinance,
                primaryColor: primaryColor,
              ),
              AdvanceTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
              ExpenseApprovalsTab(
                helper: helper,
                canApprove: canApprove,
                canFinance: canFinance,
                primaryColor: primaryColor,
              ),
              ExpenseReportsTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
              ExpensePoliciesTab(
                helper: helper,
                primaryColor: primaryColor,
              ),
              HistoryTab(
                helper: helper,
                primaryColor: primaryColor,
                onTapClaim: (claim) => _showClaimDetailsDialog(context, claim),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------
// MODELS & ENUMS
// ----------------------------------------------------
enum ExpenseStatus { review, approved, rejected }

class ExpenseSummaryItem {
  final String date;
  final String type;
  final double amount;
  final ExpenseStatus status;
  final String? approvedDate;
  final String? approvedBy;

  ExpenseSummaryItem({
    required this.date,
    required this.type,
    required this.amount,
    required this.status,
    this.approvedDate,
    this.approvedBy,
  });
}

// ----------------------------------------------------
// SEPARATE WIDGETS
// ----------------------------------------------------

/// 1. Header Card widget with flying card image (with rounded bottom corners)
class ExpenseHeaderCard extends StatelessWidget {
  const ExpenseHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8C5CF8),
            Color(0xFF6A36EF),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Expense Summary",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Claim your expenses here.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Floating credit card with rainbow trail
            Positioned(
              right: 16,
              top: 18,
              child: Image.asset(
                "assets/images/credit_card.png",
                height: 110,
                width: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. Stats Card overlapping the header
class ExpenseStatsCard extends StatelessWidget {
  const ExpenseStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Expense",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "Period 1 Jan 2024 - 30 Dec 2024",
            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF667085),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildStatBox(
                label: "Total",
                value: "₹1010",
                iconWidget: const Icon(
                  Icons.credit_card_rounded,
                  size: 11,
                  color: Color(0xFF7A5AF8),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                label: "Review",
                value: "₹455",
                iconWidget: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                label: "Approved",
                value: "₹555",
                iconWidget: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required Widget iconWidget,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                iconWidget,
                const SizedBox(width: 5),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF101828),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. Horizontal Tab Selector with rounded active pills and counts
class ExpenseTabSelector extends StatelessWidget {
  final int activeIndex;
  final int reviewCount;
  final int approvedCount;
  final int rejectedCount;
  final ValueChanged<int> onTabSelected;

  const ExpenseTabSelector({
    super.key,
    required this.activeIndex,
    required this.reviewCount,
    required this.approvedCount,
    required this.rejectedCount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTabPill("Review", reviewCount, 0),
        _buildTabPill("Approved", approvedCount, 1),
        _buildTabPill("Rejected", rejectedCount, 2),
      ],
    );
  }

  Widget _buildTabPill(String label, int count, int index) {
    final bool isActive = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF7A5AF8) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? const Color(0xFF7A5AF8) : const Color(0xFFD0D5DD),
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isActive ? Colors.white : const Color(0xFF475467),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.orange : const Color(0xFFEAECF0),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.white : const Color(0xFF475467),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. Scrollable List of Expense Items
class ExpenseCardList extends StatelessWidget {
  final List<ExpenseSummaryItem> expenses;
  final int activeTabIndex;

  const ExpenseCardList({
    super.key,
    required this.expenses,
    required this.activeTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            "No expenses in this category.",
            style: TextStyle(color: Color(0xFF667085)),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final item = expenses[index];
        return _buildExpenseItem(item);
      },
    );
  }

  Widget _buildExpenseItem(ExpenseSummaryItem item) {
    final bool isApproved = activeTabIndex == 1;
    final bool isRejected = activeTabIndex == 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAECF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header inside the card
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xFF7A5AF8),
              ),
              const SizedBox(width: 6),
              Text(
                item.date,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Inner Grey Box containing details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Type",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total Expense",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${item.amount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Approved Status Footer
          if (isApproved && item.approvedDate != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF2F4F7), height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Approved at ${item.approvedDate}",
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "By ",
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFEAD5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 10, color: Colors.orange),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.approvedBy ?? "Elaine",
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

          // Rejected Status Footer
          if (isRejected && item.approvedDate != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF2F4F7), height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Rejected at ${item.approvedDate}",
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "By ",
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFEAD5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 10, color: Colors.orange),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.approvedBy ?? "Elaine",
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
