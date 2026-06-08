import 'package:flutter/material.dart';

class SalaryBreakupScreen extends StatefulWidget {
  const SalaryBreakupScreen({super.key});

  @override
  State<SalaryBreakupScreen> createState() => _SalaryBreakupScreenState();
}

class _SalaryBreakupScreenState extends State<SalaryBreakupScreen> {
  static const Color headerPurple = Color(0xff7A5AF8);
  static const Color bgColor = Color(0xFFF4F6F9);
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF667085);
  static const Color borderColor = Color(0xFFEAECF0);
  static const Color redText = Color(0xFFF04438);

  bool isMonthly = true;
  bool isJun2025Expanded = true;
  bool isDeductionsExpanded = true;
  bool isNetPayExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F1FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: headerPurple,
                size: 16,
              ),
            ),
          ),
        ),
        title: const Text(
          "Salary Break Up",
          style: TextStyle(
            color: darkText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: headerPurple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Download",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Year Selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildArrowBtn(Icons.chevron_left),
                Row(
                  children: const [
                    Text(
                      "2025 - 2026",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, color: darkText, size: 20),
                  ],
                ),
                _buildArrowBtn(Icons.chevron_right),
              ],
            ),
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabBtn("Monthly", isMonthly)),
                  Expanded(child: _buildTabBtn("Annually", !isMonthly)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildMainSalaryCard(),
                const SizedBox(height: 16),
                _buildDeductionsCard(),
                const SizedBox(height: 16),
                _buildNetPayCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        _showRaiseIssuePopup(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: headerPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Raise An Issue",
                        style: TextStyle(
                          color: headerPurple,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA787FF), Color(0xFF4F1ED8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6938EF).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Download Payslips",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFD0D5DD).withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF475467), size: 20),
    );
  }

  Widget _buildTabBtn(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMonthly = title == "Monthly";
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? headerPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF475467),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMainSalaryCard() {
    return _buildExpandableCard(
      isExpanded: isJun2025Expanded,
      onToggle: () => setState(() => isJun2025Expanded = !isJun2025Expanded),
      header: Row(
        children: const [
          Icon(Icons.calendar_month_outlined, color: Color(0xFF667085), size: 18),
          SizedBox(width: 8),
          Text(
            "Jun 2025",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF344054),
            ),
          ),
        ],
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Salary Break-up", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: darkText)),
            Text("Amount (₹)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: darkText)),
          ],
        ),
        const SizedBox(height: 10),
        _dashedLine(),
        const SizedBox(height: 10),
        _buildTwoColRow("Basic", "₹21,000.00"),
        _buildTwoColRow("HRA", "₹8,000.00"),
        _buildTwoColRow("Conveyance", "₹1,000.00"),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                text: "Gross Salary ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText),
                children: [
                  TextSpan(text: "(Per Month)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: greyText)),
                ],
              ),
            ),
            const Text("₹30,000.00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                text: "Salary CTC ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText),
                children: [
                  TextSpan(text: "(Per Month)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: greyText)),
                ],
              ),
            ),
            const Text("₹30,000.00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText)),
          ],
        ),
      ],
    );
  }

  Widget _buildDeductionsCard() {
    return _buildExpandableCard(
      isExpanded: isDeductionsExpanded,
      onToggle: () => setState(() => isDeductionsExpanded = !isDeductionsExpanded),
      header: const Text(
        "Deductions",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF344054)),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Professional Tax", style: TextStyle(fontSize: 13, color: Color(0xFF475467))),
            Text("₹200.00", style: TextStyle(fontSize: 13, color: Color(0xFF475467))),
          ],
        ),
        const SizedBox(height: 12),
        _dashedLine(),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Total Deduction", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: redText)),
            Text("₹200.00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: redText)),
          ],
        ),
      ],
    );
  }

  Widget _buildNetPayCard() {
    return _buildExpandableCard(
      isExpanded: isNetPayExpanded,
      onToggle: () => setState(() => isNetPayExpanded = !isNetPayExpanded),
      header: const Text(
        "Net Pay",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF344054)),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Salary in Hand (Per Month)", style: TextStyle(fontSize: 13, color: Color(0xFF475467))),
            Text("₹29,800.00", style: TextStyle(fontSize: 13, color: Color(0xFF475467))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Salary (CTC) / Per Year", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText)),
            Text("₹3,60,000.00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText)),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableCard({
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget header,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(child: header),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF667085),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: borderColor),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTwoColRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: const TextStyle(fontSize: 12, color: Color(0xFF475467))),
          Row(
            children: [
              const Text("|", style: TextStyle(fontSize: 12, color: Color(0xFFD0D5DD))),
              const SizedBox(width: 32),
              SizedBox(
                width: 80,
               // alignment: Alignment.centerRight,
                child: Text(right, style: const TextStyle(fontSize: 12, color: Color(0xFF475467))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFD0D5DD))),
            );
          }),
        );
      },
    );
  }

  void _showRaiseIssuePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Raise An Issue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Reason",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F648E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD0D5DD)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Type Here",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF98A2B3),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 70), // Align icon to top
                            child: Icon(Icons.edit_note, color: Color(0xFF667085), size: 20),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7A5AF8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Submit Request",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xff7A5AF8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Cancel Request",
                          style: TextStyle(
                            color: Color(0xff7A5AF8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xff7A5AF8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff7A5AF8).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.access_time, color: Color(0xff7A5AF8), size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
