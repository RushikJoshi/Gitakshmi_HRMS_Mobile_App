import 'package:flutter/material.dart';

class ExpenseManagementPage extends StatefulWidget {
  const ExpenseManagementPage({super.key});

  @override
  State<ExpenseManagementPage> createState() => _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends State<ExpenseManagementPage> {
  // Current active tab index: 0 = Review, 1 = Approved, 2 = Rejected
  int _activeTabIndex = 0;

  // Mock list of expenses matching the screenshot
  final List<ExpenseSummaryItem> _expenses = [
    // Review Items
    ExpenseSummaryItem(
      date: "27 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.review,
    ),
    ExpenseSummaryItem(
      date: "24 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.review,
    ),
    ExpenseSummaryItem(
      date: "21 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.review,
    ),
    // Approved Items
    ExpenseSummaryItem(
      date: "18 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.approved,
      approvedDate: "19 Sept 2024",
      approvedBy: "Elaine",
    ),
    ExpenseSummaryItem(
      date: "14 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.approved,
      approvedDate: "19 Sept 2024",
      approvedBy: "Elaine",
    ),
    // Rejected Items
    ExpenseSummaryItem(
      date: "10 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.rejected,
      approvedDate: "11 Sept 2024",
      approvedBy: "Elaine",
    ),
    ExpenseSummaryItem(
      date: "05 September 2024",
      type: "E-Learning",
      amount: 55,
      status: ExpenseStatus.rejected,
      approvedDate: "06 Sept 2024",
      approvedBy: "Elaine",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter list dynamically based on the active tab
    final filteredExpenses = _expenses.where((expense) {
      if (_activeTabIndex == 0) return expense.status == ExpenseStatus.review;
      if (_activeTabIndex == 1) return expense.status == ExpenseStatus.approved;
      return expense.status == ExpenseStatus.rejected;
    }).toList();

    // Counts for badges
    final reviewCount = _expenses.where((e) => e.status == ExpenseStatus.review).length;
    final approvedCount = _expenses.where((e) => e.status == ExpenseStatus.approved).length;
    final rejectedCount = _expenses.where((e) => e.status == ExpenseStatus.rejected).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved Purple Header Card
            const ExpenseHeaderCard(),

            // Overlapping Stats Card
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ExpenseStatsCard(),
            ),
            const SizedBox(height: 20),

            // Horizontal Tab Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ExpenseTabSelector(
                activeIndex: _activeTabIndex,
                reviewCount: reviewCount,
                approvedCount: approvedCount,
                rejectedCount: rejectedCount,
                onTabSelected: (index) {
                  setState(() {
                    _activeTabIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Expense Items List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ExpenseCardList(
                expenses: filteredExpenses,
                activeTabIndex: _activeTabIndex,
              ),
            ),
            const SizedBox(height: 30), // bottom spacing
          ],
        ),
      ),
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

/// 1. Custom Wave Clipper for Purple Header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 48);

    // Smooth bezier curve to match wave shape in mockup
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height,
      size.width * 0.7,
      size.height - 35,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height - 50,
      size.width,
      size.height - 25,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// 2. Header Card widget with flying card image
class ExpenseHeaderCard extends StatelessWidget {
  const ExpenseHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 220,
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
                        fontSize: 12.5,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Floating credit card with rainbow trail
              Positioned(
                right: 8,
                top: 24,
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
      ),
    );
  }
}

/// 3. Stats Card overlapping the header
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

/// 4. Horizontal Tab Selector with rounded active pills and counts
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

/// 5. Scrollable List of Expense Items
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Color(0xFF7A5AF8),
              ),
              const SizedBox(width: 6),
              Text(
                item.date,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        ),
        // Item Details Box
        Container(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Type",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
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
                          fontSize: 12,
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "₹${item.amount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF344054),
                        ),
                      ),
                    ],
                  ),
                ],
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
        ),
      ],
    );
  }
}
