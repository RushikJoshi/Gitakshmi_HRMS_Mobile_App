import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_selection_bottom_sheet.dart';
import 'package:gitakshmi_hrms_app/core/widgets/buttons/app_button.dart';
import '../../data/models/holiday_model.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  static const Color headerPurple = Color(0xff7A5AF8);
  static const Color bgColor = Color(0xFFF4F6F9);
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF667085);
  static const Color borderColor = Color(0xFFD0D5DD);
  static const Color appliedPurple = Color(0xFFB5A4F4);

  String _currentMonth = "May, 2025";

  final List<String> _monthsList = [
    "January, 2025", "February, 2025", "March, 2025", "April, 2025",
    "May, 2025", "June, 2025", "July, 2025", "August, 2025",
    "September, 2025", "October, 2025", "November, 2025", "December, 2025"
  ];

  final List<HolidayEntry> holidays = [
    HolidayEntry(
      date: "27 Jun 2025",
      name: "Rathyatra",
      dayName: "Friday",
      imageAsset: "assets/images/rathyatra.png",
    ),
    HolidayEntry(
      date: "09 Aug 2025",
      name: "Raksha Bandhan",
      dayName: "Saturday",
      imageAsset: "assets/images/raxabandhan.png",
      isApplied: true,
    ),
    HolidayEntry(
      date: "15 Aug 2025",
      name: "Independence Day",
      dayName: "Friday",
      imageAsset: "assets/images/Independence_day.png",
    ),
    HolidayEntry(
      date: "16 Aug 2025",
      name: "Janmashtami",
      dayName: "Saturday",
      imageAsset: "assets/images/Janmashtami.png",
    ),
  ];

  void _changeMonth(bool next) {
    final index = _monthsList.indexOf(_currentMonth);
    if (index == -1) return;
    if (next) {
      if (index < _monthsList.length - 1) {
        setState(() {
          _currentMonth = _monthsList[index + 1];
        });
      }
    } else {
      if (index > 0) {
        setState(() {
          _currentMonth = _monthsList[index - 1];
        });
      }
    }
  }

  Future<void> _selectMonth() async {
    final result = await AppSelectionBottomSheet.show(
      context: context,
      title: "Select Month",
      subtitle: "Choose month to view holidays",
      options: _monthsList,
      initialSelected: _currentMonth,
    );
    if (result != null && mounted) {
      setState(() {
        _currentMonth = result;
      });
    }
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
          "Holidays",
          style: TextStyle(
            color: darkText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: bgColor,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Color(0xFF344054)),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMonthArrow(Icons.chevron_left, () => _changeMonth(false)),
                GestureDetector(
                  onTap: _selectMonth,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        _currentMonth,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: darkText, size: 20),
                    ],
                  ),
                ),
                _buildMonthArrow(Icons.chevron_right, () => _changeMonth(true)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildHolidayCard(holiday, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFD0D5DD).withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF475467), size: 20),
      ),
    );
  }

  Widget _buildHolidayCard(HolidayEntry holiday, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF98A2B3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section: Date and Delete button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Image.asset('assets/images/calender.png',color: Color(0xFF475467), ),
                const SizedBox(width: 8),
                Text(
                  holiday.date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475467),
                  ),
                ),
                if (holiday.isApplied) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        holidays[index].isApplied = false;
                      });
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.delete_outline, color: Color(0xFFF04438), size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF04438),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEAECF0)),
          // Bottom section: Info and Apply button
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image or Icon fallback
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      holiday.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.celebration, color: Color(0xFFFDB022)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        holiday.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        holiday.dayName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Apply / Applied Button
                AppButton(
                  text: holiday.isApplied ? "Applied" : "Apply",
                  height: 32,
                  borderRadius: 16,
                  backgroundColor: holiday.isApplied ? appliedPurple : headerPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    if (!holiday.isApplied) {
                      setState(() {
                        holidays[index].isApplied = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
