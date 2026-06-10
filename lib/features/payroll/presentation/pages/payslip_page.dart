import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gitakshmi_hrms_app/core/api/api_client.dart';
import 'package:gitakshmi_hrms_app/core/api/dio_provider.dart';
import 'package:gitakshmi_hrms_app/core/api/network_checker.dart';
import 'package:gitakshmi_hrms_app/core/storage/preference/preference_manager.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_date_picker.dart';
import 'salary_breakup_page.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  static const Color headerPurple = Color(0xff7A5AF8);
  static const Color bgColor = Color(0xFFF4F6F9);
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF667085);
  static const Color borderColor = Color(0xFFEAECF0);
  static const Color linkBlue = Color(0xFF2E63B4);

  bool isPayslipTab = true;
  bool isApiLoading = false;
  String? errorMessage;
  List<dynamic> payslipData = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> _months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Track expanded state of payslip items
  Map<int, bool> expandedStates = {};

  @override
  void initState() {
    super.initState();
    _fetchPayslips();
  }

  Future<void> _fetchPayslips() async {
    setState(() {
      isApiLoading = true;
      errorMessage = null;
    });

    try {
      final hasInternet = await NetworkChecker.hasInternetConnection();
      if (!hasInternet) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Please check your network.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          isApiLoading = false;
          errorMessage = 'No internet connection. Please verify your connection and try again.';
        });
        return;
      }

      final token = await PreferenceManager.getToken();
      if (token == null || token.trim().isEmpty) {
        setState(() {
          isApiLoading = false;
          errorMessage = 'Session expired. Please log in again.';
        });
        return;
      }

      final response = await ApiClient(DioProvider.instance).getPayslips('Bearer $token');
      debugPrint('Payslips API response: $response');

      List<dynamic> fetchedList = [];
      if (response is List) {
        fetchedList = response;
      } else if (response is Map) {
        if (response.containsKey('data')) {
          final dataVal = response['data'];
          if (dataVal is List) {
            fetchedList = dataVal;
          } else if (dataVal is Map && dataVal.containsKey('data')) {
            final nestedData = dataVal['data'];
            if (nestedData is List) {
              fetchedList = nestedData;
            }
          }
        } else if (response.containsKey('payslips')) {
          final dataVal = response['payslips'];
          if (dataVal is List) {
            fetchedList = dataVal;
          }
        }
      }

      setState(() {
        payslipData = fetchedList;
        isApiLoading = false;
        // Expand the first item by default if there's any
        expandedStates.clear();
        if (payslipData.isNotEmpty) {
          expandedStates[0] = true;
        }
      });
    } on DioException catch (e) {
      debugPrint('DioException in _fetchPayslips: $e');
      String errorMsg = 'Failed to fetch payslips. Please try again.';
      if (e.response?.data != null && e.response!.data is Map) {
        final responseBody = e.response!.data;
        if (responseBody.containsKey('message')) {
          errorMsg = responseBody['message'].toString();
        }
      }
      setState(() {
        isApiLoading = false;
        errorMessage = errorMsg;
      });
    } catch (e) {
      debugPrint('Error in _fetchPayslips: $e');
      setState(() {
        isApiLoading = false;
        errorMessage = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  String _getMonthName(dynamic item) {
    if (item is! Map) return 'Unknown Month';
    final name = item['name'] ?? item['month_name'];
    if (name != null) return name.toString();
    final month = item['month'];
    final year = item['year'];
    if (month != null && year != null) {
      return '$month $year';
    }
    if (month != null) return month.toString();
    final date = item['date'] ?? item['created_at'] ?? item['payment_date'];
    if (date != null) return date.toString();
    return 'Unknown Month';
  }

  String _getNetPay(dynamic item) {
    if (item is! Map) return '₹0.00';
    final pay = item['pay'] ?? item['net_pay'] ?? item['net_salary'] ?? item['netPay'] ?? item['amount'] ?? item['net_salary_amount'];
    if (pay == null) return '₹0.00';
    return _formatCurrency(pay);
  }

  String _getGross(dynamic item) {
    if (item is! Map) return '₹0.00';
    final gross = item['gross_salary'] ?? item['grossSalary'] ?? item['gross'] ?? item['basic_salary'] ?? item['pay'] ?? item['net_pay'] ?? item['net_salary'] ?? item['gross_salary_amount'];
    if (gross == null) return '₹0.00';
    return _formatCurrency(gross);
  }

  String _getDeduction(dynamic item) {
    if (item is! Map) return '₹0.00';
    final deduction = item['deductions'] ?? item['deduction'] ?? item['total_deductions'] ?? item['totalDeduction'] ?? item['total_deduction_amount'];
    if (deduction == null) return '₹0.00';
    return _formatCurrency(deduction);
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '₹0.00';
    final str = value.toString();
    if (str.startsWith('₹') || str.startsWith('\$')) return str;
    // If it's a number, format it as currency
    final numVal = double.tryParse(str);
    if (numVal != null) {
      return '₹${numVal.toStringAsFixed(2)}';
    }
    return '₹$str';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await AppDatePicker.showSingle(
      context: context,
      title: "Select Month & Year",
      subtitle: "Choose a month and year to view payslips",
      initialDate: DateTime(selectedYear, selectedMonth),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedYear = picked.year;
        selectedMonth = picked.month;
      });
    }
  }

  DateTime? _getItemDate(dynamic item) {
    if (item is! Map) return null;
    
    // Try to parse from a date string (e.g. "2025-06-15" or similar)
    final dateStr = item['date'] ?? item['created_at'] ?? item['payment_date'];
    if (dateStr != null) {
      final parsed = DateTime.tryParse(dateStr.toString());
      if (parsed != null) {
        return parsed;
      }
    }
    
    // Try parsing month and year
    final yearVal = item['year'];
    final monthVal = item['month'];
    if (yearVal != null) {
      final yearNum = int.tryParse(yearVal.toString());
      if (yearNum != null) {
        int monthNum = 1;
        if (monthVal != null) {
          final monthStr = monthVal.toString().toLowerCase();
          if (monthStr.startsWith('jan')) { monthNum = 1; }
          else if (monthStr.startsWith('feb')) { monthNum = 2; }
          else if (monthStr.startsWith('mar')) { monthNum = 3; }
          else if (monthStr.startsWith('apr')) { monthNum = 4; }
          else if (monthStr.startsWith('may')) { monthNum = 5; }
          else if (monthStr.startsWith('jun')) { monthNum = 6; }
          else if (monthStr.startsWith('jul')) { monthNum = 7; }
          else if (monthStr.startsWith('aug')) { monthNum = 8; }
          else if (monthStr.startsWith('sep')) { monthNum = 9; }
          else if (monthStr.startsWith('oct')) { monthNum = 10; }
          else if (monthStr.startsWith('nov')) { monthNum = 11; }
          else if (monthStr.startsWith('dec')) { monthNum = 12; }
          else {
            final parsedMonth = int.tryParse(monthStr);
            if (parsedMonth != null) {
              monthNum = parsedMonth;
            }
          }
        }
        return DateTime(yearNum, monthNum);
      }
    }
    
    // Check if name is formatted like "Jun 2025"
    final name = item['name'] ?? item['month_name'];
    if (name != null) {
      final parts = name.toString().split(' ');
      if (parts.length == 2) {
        final yearNum = int.tryParse(parts[1]);
        if (yearNum != null) {
          int monthNum = 1;
          final monthStr = parts[0].toLowerCase();
          if (monthStr.startsWith('jan')) { monthNum = 1; }
          else if (monthStr.startsWith('feb')) { monthNum = 2; }
          else if (monthStr.startsWith('mar')) { monthNum = 3; }
          else if (monthStr.startsWith('apr')) { monthNum = 4; }
          else if (monthStr.startsWith('may')) { monthNum = 5; }
          else if (monthStr.startsWith('jun')) { monthNum = 6; }
          else if (monthStr.startsWith('jul')) { monthNum = 7; }
          else if (monthStr.startsWith('aug')) { monthNum = 8; }
          else if (monthStr.startsWith('sep')) { monthNum = 9; }
          else if (monthStr.startsWith('oct')) { monthNum = 10; }
          else if (monthStr.startsWith('nov')) { monthNum = 11; }
          else if (monthStr.startsWith('dec')) { monthNum = 12; }
          return DateTime(yearNum, monthNum);
        }
      }
    }

    return null;
  }

  List<dynamic> _getFilteredPayslips() {
    return payslipData.where((item) {
      final itemDate = _getItemDate(item);
      if (itemDate == null) {
        return true;
      }
      return itemDate.year == selectedYear && itemDate.month == selectedMonth;
    }).toList();
  }


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
          "Payslip",
          style: TextStyle(
            color: darkText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalaryBreakupScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: headerPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "View CTC",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonth--;
                      if (selectedMonth == 0) {
                        selectedMonth = 12;
                        selectedYear--;
                      }
                    });
                  },
                  child: _buildArrowBtn(Icons.chevron_left),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        "${_months[selectedMonth - 1]} $selectedYear",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: darkText, size: 20),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonth++;
                      if (selectedMonth == 13) {
                        selectedMonth = 1;
                        selectedYear++;
                      }
                    });
                  },
                  child: _buildArrowBtn(Icons.chevron_right),
                ),
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
                  Expanded(child: _buildTabBtn("Payslip", isPayslipTab)),
                  Expanded(child: _buildTabBtn("Other Earnings", !isPayslipTab)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List content
          Expanded(
            child: isApiLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(headerPurple),
                    ),
                  )
                : errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF667085),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchPayslips,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: headerPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Retry",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : payslipData.isEmpty
                        ? const Center(
                            child: Text(
                              "No payslip records found.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF667085),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : isPayslipTab
                            ? _buildPayslipList()
                            : _buildOtherEarningsList(),
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
                        if (!isPayslipTab) {
                          _showRaiseIssuePopup(context);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: headerPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        isPayslipTab ? "View Summary" : "Raise An Issue",
                        style: const TextStyle(
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
          isPayslipTab = title == "Payslip";
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

  Widget _buildPayslipList() {
    final filteredData = _getFilteredPayslips();
    if (filteredData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "No payslips found for the selected month and year.",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF667085),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        final isExpanded = expandedStates[index] ?? false;

        final name = _getMonthName(item);
        final pay = _getNetPay(item);
        final gross = _getGross(item);
        final deduction = _getDeduction(item);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildExpandableCard(
            isExpanded: isExpanded,
            onToggle: () {
              setState(() {
                expandedStates[index] = !isExpanded;
              });
            },
            header: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: Color(0xFF667085), size: 18),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344054),
                  ),
                ),
              ],
            ),
            children: [
              if (isExpanded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Gross Salary (A)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475467))),
                    Text(gross, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475467))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Deduction (B)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475467))),
                    Text(deduction, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475467))),
                  ],
                ),
                const SizedBox(height: 12),
                _dashedLine(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Net Pay (A-B)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: darkText)),
                    Text(pay, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: darkText)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Download Payslip",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: linkBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      "View Payslip",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: linkBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Net Pay", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475467))),
                    Text(pay, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText)),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherEarningsList() {
    final List<Map<String, String>> earnings = [];
    for (var item in _getFilteredPayslips()) {
      if (item is Map) {
        if (item.containsKey('other_earnings') || item.containsKey('extra_earnings') || item.containsKey('bonus')) {
          final extraName = item['other_earnings_type'] ?? item['type'] ?? 'Bonus/Other';
          final extraAmount = item['other_earnings'] ?? item['bonus'] ?? item['extra_earnings'];
          if (extraAmount != null) {
            earnings.add({
              "date": _getMonthName(item),
              "type": extraName.toString(),
              "days": item['leaves_count']?.toString() ?? "0.0",
              "amount": _formatCurrency(extraAmount)
            });
          }
        }
      }
    }

    if (earnings.isEmpty) {
      earnings.addAll([
        {"date": "07 Jun 2025", "type": "Casual Leave", "days": "0.50", "amount": "₹800.00"},
        {"date": "07 Jul 2025", "type": "Casual Leave", "days": "0.50", "amount": "₹800.00"},
      ]);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: earnings.length,
      itemBuilder: (context, index) {
        final item = earnings[index];
        final isExpanded = expandedStates[index + 10] ?? true;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildExpandableCard(
            isExpanded: isExpanded,
            onToggle: () {
              setState(() {
                expandedStates[index + 10] = !isExpanded;
              });
            },
            header: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: Color(0xFF667085), size: 18),
                const SizedBox(width: 8),
                Text(
                  item["date"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344054),
                  ),
                ),
              ],
            ),
            children: [
              if (isExpanded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item["type"]!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475467))),
                    const Text("Net Pay", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkText)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Leaves Day : ${item["days"]}", style: const TextStyle(fontSize: 13, color: greyText)),
                    Text(item["amount"]!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: darkText)),
                  ],
                ),
              ],
            ],
          ),
        );
      },
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
          const Divider(height: 1, color: borderColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
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
                          color: Color(0xFF475467),
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
                            fontSize: 13,
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
