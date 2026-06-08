import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/timesheet_dialogs.dart';

class TimecardScreen extends StatefulWidget {
  const TimecardScreen({super.key});

  @override
  State<TimecardScreen> createState() => _TimecardScreenState();
}

class _TimecardScreenState extends State<TimecardScreen> {
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF667085);
  static const Color headerPurple = Color(0xff7A5AF8);

  // chart segment colors — same as screenshot
  static const Color _yellow = Color(0xFFFDB022); // Days
  static const Color _blue = Color(0xFF1E4DB7); // Irregularities
  static const Color _teal = Color(0xFF0EB39E); // Hours

  int _selectedDayIndex = 1;

  final List<Map<String, dynamic>> _weekDays = [
    {'label': 'Mon', 'date': '13', 'dotColor': Color(0xFF12B76A)},
    {'label': 'Tue', 'date': '14', 'dotColor': Color(0xFFF04438)},
    {'label': 'Wed', 'date': '15', 'dotColor': Color(0xFFF04438)},
    {'label': 'Thu', 'date': '16', 'dotColor': Color(0xFF12B76A)},
    {'label': 'Fri', 'date': '17', 'dotColor': null},
    {'label': 'Sat', 'date': '18', 'dotColor': null},
    {'label': 'Sun', 'date': '19', 'dotColor': null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      // NO bottomNavigationBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
              Icons.chevron_left, color: Color(0xFF475467), size: 28),
        ),
        title: const Text(
          'Time Sheet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── White header block (month + week range + day circles) ──────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // Month row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('May, 2025',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: darkText)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 18,
                            color: darkText),
                      ],
                    ),
                  ),

                  // Week range row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _navArrow(Icons.chevron_left),
                      const SizedBox(width: 10),
                      const Text(
                        'May 13, 2025 - May 19, 2025',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: darkText),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                          Icons.keyboard_arrow_down, size: 16, color: darkText),
                      const SizedBox(width: 10),
                      _navArrow(Icons.chevron_right),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Day-of-week labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun'
                      ]
                          .map((d) =>
                          SizedBox(
                            width: 36,
                            child: Text(d,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: greyText,
                                    fontWeight: FontWeight.w500)),
                          ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Date circles
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_weekDays.length, (i) {
                        final day = _weekDays[i];
                        final Color? dot = day['dotColor'] as Color?;
                        final bool hasBg = dot != null;
                        final bool selected = _selectedDayIndex == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedDayIndex = i);
                            // Date 17 (Fri, index 4) → open Raise a Request
                            if (day['date'] == '17') {
                              showRaiseRequestOptionsDialog(context);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: hasBg ? dot : Colors.transparent,
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(color: headerPurple, width: 2)
                                  : hasBg
                                  ? null
                                  : Border.all(color: const Color(0xFFD0D5DD)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day['date'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: hasBg ? Colors.white : darkText,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),



            // ── Working Hours card ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEAECF0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text('Working Hours',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475467))),
                    ),
                    const Divider(
                        height: 1, thickness: 3, color: Color(0xFFEAECF0)),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _hoursBox('250 Hours', 'Total Hours'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _hoursBox(
                                '27 Hours 10 Minutes', 'Monthly Hours Spent'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // ── Timecard table ─────────────────────────────────────────────────

          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _navArrow(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D5DD)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 18, color: greyText),
    );
  }

  Widget _hoursBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E63B4))),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 11, color: greyText)),
        ],
      ),
    );
  }

}
