import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
import '../widgets/timesheet_dialogs.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  DateTime _selectedMonth = DateTime(2025, 5, 1);

  final List<String> _months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const Color headerPurple = Color(0xff7A5AF8);
  static const Color bgColor = Color(0xFFFEFEFE);
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF667085);
  
  // Calendar Colors
  static const Color presentColor = Color(0xFF12B76A); // Green
  static const Color absentColor = Color(0xFFF04438); // Red
  static const Color leaveColor = Color(0xff7A5AF8); // Purple
  static const Color onLeaveColor = Color(0xFFB5A4F4); // Light Purple
  static const Color punchinMissingColor = Color(0xFFFDB022); // Yellow
  static const Color punchoutMissingColor = Color(0xFFF79009); // Orange
  static const Color defaultDayColor = Colors.transparent;
  
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
          "Time Sheet",
          style: TextStyle(
            color: darkText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenteredView(
          maxWidth: 600,
          child: Column(
            children: [
              // Month Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
                        });
                      },
                      child: _buildArrowBtn(Icons.chevron_left),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showMonthYearPicker(context),
                      child: Row(
                        children: [
                          Text(
                            '${_months[_selectedMonth.month - 1]}, ${_selectedMonth.year}',
                            style: const TextStyle(
                              fontSize: 16,
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
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
                        });
                      },
                      child: _buildArrowBtn(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              
              // Calendar grid
              _buildCalendarGrid(),
              
              // Legends
              _buildLegends(),
              
              const SizedBox(height: 32),
              
              // Working hours
              _buildWorkingHoursCard(context),
              
              const SizedBox(height: 24),
              
              // Bottom Fields Grid
              _buildBottomFields(),
              
              const SizedBox(height: 60), // extra spacing
            ],
          ),
        ),
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

  Widget _buildCalendarGrid() {
    // Days of week
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    // Calculate days in the selected month dynamically
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    
    // Calculate starting weekday (Monday is 0, Sunday is 6)
    final startingWeekday = (DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday - 1) % 7;
    
    List<Widget> gridItems = [];
    
    for (String d in daysOfWeek) {
      gridItems.add(
        Center(
          child: Text(
            d,
            style: const TextStyle(fontSize: 12, color: greyText, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    
    // Empty spots for 1st row
    for (int i = 0; i < startingWeekday; i++) {
      gridItems.add(const SizedBox());
    }
    
    // Days 1 to daysInMonth
    for (int i = 1; i <= daysInMonth; i++) {
      Color bgColor = defaultDayColor;
      Color textColor = darkText;
      
      // Assigning colors as per user request
      if (i == 1 || i == 2 || i == 3) {
        bgColor = presentColor;
        textColor = Colors.white;
      } else if (i == 7 || i == 8) {
        bgColor = absentColor;
        textColor = Colors.white;
      } else if (i == 23) {
        bgColor = leaveColor;
        textColor = Colors.white;
      } else if (i == 9) {
        bgColor = onLeaveColor;
        textColor = Colors.white;
      } else if (i == 16) {
        bgColor = punchinMissingColor;
        textColor = Colors.white;
      } else if (i == 17) {
        bgColor = punchoutMissingColor;
        textColor = Colors.white;
      }
      
      gridItems.add(
        GestureDetector(
          onTap: () {
            if (bgColor == punchinMissingColor) {
              showRaiseRequestOptionsDialog(context, isPunchIn: true);
            } else if (bgColor == punchoutMissingColor) {
              showRaiseRequestOptionsDialog(context, isPunchIn: false);
            }
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: bgColor == defaultDayColor ? const Color(0xFFD0D5DD) : bgColor,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$i',
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: gridItems,
        ),
      ),
    );
  }

  Widget _buildLegends() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _legendItem(presentColor, "Present"),
          _legendItem(absentColor, "Absent"),
          _legendItem(leaveColor, "Leave"),
          _legendItem(onLeaveColor, "On Leave"),
          _legendItem(punchinMissingColor, "Punching Missing"),
          _legendItem(punchoutMissingColor, "Punchout Missing"),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: greyText, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEAECF0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Working Hours",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475467),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 3, color: Color(0xFFEAECF0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD0D5DD)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "250 Hours",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E63B4),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Total Hours",
                            style: TextStyle(fontSize: 11, color: greyText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD0D5DD)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "27 Hours 10 Minutes",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E63B4),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Monthly Hours Spent",
                            style: TextStyle(fontSize: 11, color: greyText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomFields() {
    final fields = [
      {"icon": Icons.exit_to_app, "title": "Working Days", "count": "25"},
      {"icon": Icons.hourglass_empty, "title": "Present Days", "count": "20"},
      {"icon": Icons.cancel_outlined, "title": "Absent Days", "count": "05"},
      {"icon": Icons.arrow_circle_right_outlined, "title": "Holiday", "count": "01"},
      {"icon": Icons.event_busy, "title": "Week-off", "count": "04"},
      {"icon": Icons.event_available, "title": "On Leave", "count": "01"},
      {"icon": Icons.alarm, "title": "Late In", "count": "02"},
      {"icon": Icons.logout, "title": "Early Out", "count": "01"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.8,
        ),
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final field = fields[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: headerPurple.withOpacity(0.6), width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  field["icon"] as IconData,
                  color: headerPurple,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field["count"] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: headerPurple,
                        ),
                      ),
                      Text(
                        field["title"] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: headerPurple,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    int selectedMonthIndex = _selectedMonth.month; // 1-indexed
    int selectedYear = _selectedMonth.year;
    
    final shortMonths = const [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Select Month & Year',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: darkText,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year Selector Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setDialogState(() {
                            selectedYear--;
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: headerPurple,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '$selectedYear',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          setDialogState(() {
                            selectedYear++;
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: headerPurple,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Months Grid
                  SizedBox(
                    width: 280,
                    height: 180,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 12,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final monthNum = index + 1;
                        final isSelected = selectedMonthIndex == monthNum;
                        
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedMonthIndex = monthNum;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? headerPurple : const Color(0xFFF4F1FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? headerPurple : const Color(0xFFE4E7EC),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              shortMonths[index],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF475467),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            SizedBox(
              width: 110,
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: headerPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: headerPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 110,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(selectedYear, selectedMonthIndex, 1);
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: headerPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
