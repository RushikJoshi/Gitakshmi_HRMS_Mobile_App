import 'package:flutter/material.dart';
import '../widgets/timesheet_dialogs.dart';
import 'timecard_page.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
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
        child: Column(
          children: [
            // Month Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildArrowBtn(Icons.chevron_left),
                  Row(
                    children: const [
                      Text(
                        "May, 2025",
                        style: TextStyle(
                          fontSize: 16,
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
    
    // Mock days logic for UI purposes
    // 1st of May 2025 is Thursday. So Mon, Tue, Wed are empty.
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
    
    // Empty spots for 1st row (Mon, Tue, Wed)
    for (int i = 0; i < 3; i++) {
      gridItems.add(const SizedBox());
    }
    
    // Days 1 to 31
    for (int i = 1; i <= 31; i++) {
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
            if (bgColor == punchinMissingColor || bgColor == punchoutMissingColor) {
              showRaiseRequestOptionsDialog(context);
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimecardScreen()),
          );
        },
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
            const Divider(height: 1, thickness: 3,color: Color(0xFFEAECF0)),
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
      )
    );
  }

  Widget _buildBottomFields() {
    final fields = [
      {"icon": Icons.exit_to_app, "title": "Working Days", "count": "25"},
      {"icon": Icons.hourglass_empty, "title": "Present Days", "count": "20"},
      {"icon": Icons.cancel_outlined, "title": "Extra Days", "count": "02"},
      {"icon": Icons.arrow_circle_right_outlined, "title": "Holiday", "count": "01"},
      {"icon": Icons.error_outline, "title": "Salaried Day", "count": "01"},
      {"icon": Icons.event_busy, "title": "Week-off", "count": "01"},
      {"icon": Icons.event_available, "title": "Paid Leave", "count": "01"},
      {"icon": Icons.event_busy, "title": "Unpaid Leave", "count": "01"},
      {"icon": Icons.edit_calendar, "title": "Short Leave", "count": "01"},
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
}
