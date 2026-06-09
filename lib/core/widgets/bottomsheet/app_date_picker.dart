import 'package:flutter/material.dart';

enum AppDatePickerMode {
  single,
  range,
}

class AppDatePicker extends StatefulWidget {
  final String title;
  final String subtitle;
  final AppDatePickerMode mode;
  final DateTime? initialSingleDate;
  final DateTimeRange? initialDateRange;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDatePicker({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mode,
    this.initialSingleDate,
    this.initialDateRange,
    this.firstDate,
    this.lastDate,
  });

  static Future<DateTime?> showSingle({
    required BuildContext context,
    required String title,
    required String subtitle,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppDatePicker(
        title: title,
        subtitle: subtitle,
        mode: AppDatePickerMode.single,
        initialSingleDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  static Future<DateTimeRange?> showRange({
    required BuildContext context,
    required String title,
    required String subtitle,
    DateTimeRange? initialRange,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppDatePicker(
        title: title,
        subtitle: subtitle,
        mode: AppDatePickerMode.range,
        initialDateRange: initialRange,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime _currentMonth;
  DateTime? _selectedSingleDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late final DateTime _firstDateLimit;
  late final DateTime _lastDateLimit;

  final List<String> _weekdays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  final List<String> _months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    
    // Set date limits
    _firstDateLimit = widget.firstDate ?? DateTime(DateTime.now().year - 100);
    _lastDateLimit = widget.lastDate ?? DateTime(DateTime.now().year + 50);

    // Set initial display month & selections
    if (widget.mode == AppDatePickerMode.single) {
      _selectedSingleDate = widget.initialSingleDate;
      _currentMonth = DateTime((_selectedSingleDate ?? DateTime.now()).year, (_selectedSingleDate ?? DateTime.now()).month);
    } else {
      _rangeStart = widget.initialDateRange?.start;
      _rangeEnd = widget.initialDateRange?.end;
      final refDate = _rangeStart ?? DateTime.now();
      _currentMonth = DateTime(refDate.year, refDate.month);
    }
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _getStartingWeekday(int year, int month) {
    return DateTime(year, month, 1).weekday % 7;
  }

  void _previousMonth() {
    setState(() {
      int newMonth = _currentMonth.month - 1;
      int newYear = _currentMonth.year;
      if (newMonth == 0) {
        newMonth = 12;
        newYear -= 1;
      }
      final newMonthDateTime = DateTime(newYear, newMonth);
      if (newMonthDateTime.isAfter(_firstDateLimit) || 
          (newMonthDateTime.year == _firstDateLimit.year && newMonthDateTime.month == _firstDateLimit.month)) {
        _currentMonth = newMonthDateTime;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      int newMonth = _currentMonth.month + 1;
      int newYear = _currentMonth.year;
      if (newMonth == 13) {
        newMonth = 1;
        newYear += 1;
      }
      final newMonthDateTime = DateTime(newYear, newMonth);
      if (newMonthDateTime.isBefore(_lastDateLimit) || 
          (newMonthDateTime.year == _lastDateLimit.year && newMonthDateTime.month == _lastDateLimit.month)) {
        _currentMonth = newMonthDateTime;
      }
    });
  }

  void _showMonthYearPicker(BuildContext context) {
    int selectedMonthIndex = _currentMonth.month; // 1-indexed
    int selectedYear = _currentMonth.year;
    
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
              color: Color(0xFF101828),
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
                          if (selectedYear > _firstDateLimit.year) {
                            setDialogState(() {
                              selectedYear--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Color(0xFF7544FC),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '$selectedYear',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          if (selectedYear < _lastDateLimit.year) {
                            setDialogState(() {
                              selectedYear++;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF7544FC),
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
                              color: isSelected ? const Color(0xFF7544FC) : const Color(0xFFF4F1FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF7544FC) : const Color(0xFFE4E7EC),
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
                  side: const BorderSide(color: Color(0xFF7544FC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF7544FC),
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
                  final targetMonth = DateTime(selectedYear, selectedMonthIndex);
                  if (targetMonth.isAfter(_firstDateLimit) && targetMonth.isBefore(_lastDateLimit) ||
                      (targetMonth.year == _firstDateLimit.year && targetMonth.month == _firstDateLimit.month) ||
                      (targetMonth.year == _lastDateLimit.year && targetMonth.month == _lastDateLimit.month)) {
                    setState(() {
                      _currentMonth = targetMonth;
                      if (widget.mode == AppDatePickerMode.single) {
                        final prevDay = _selectedSingleDate?.day ?? 1;
                        final lastDayOfNewMonth = DateTime(selectedYear, selectedMonthIndex + 1, 0).day;
                        final newDay = prevDay > lastDayOfNewMonth ? lastDayOfNewMonth : prevDay;
                        _selectedSingleDate = DateTime(selectedYear, selectedMonthIndex, newDay);
                      }
                    });
                  }
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7544FC),
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

  void _handleDayTap(DateTime day) {
    if (day.isBefore(_firstDateLimit) || day.isAfter(_lastDateLimit)) return;

    setState(() {
      if (widget.mode == AppDatePickerMode.single) {
        _selectedSingleDate = day;
      } else {
        if (_rangeStart == null || _rangeEnd != null) {
          _rangeStart = day;
          _rangeEnd = null;
        } else if (day.isBefore(_rangeStart!)) {
          _rangeStart = day;
          _rangeEnd = null;
        } else {
          _rangeEnd = day;
        }
      }
    });
  }

  bool _isDaySelected(DateTime day) {
    if (widget.mode == AppDatePickerMode.single) {
      return _selectedSingleDate != null && 
             _selectedSingleDate!.year == day.year && 
             _selectedSingleDate!.month == day.month && 
             _selectedSingleDate!.day == day.day;
    } else {
      final isStart = _rangeStart != null && 
                      _rangeStart!.year == day.year && 
                      _rangeStart!.month == day.month && 
                      _rangeStart!.day == day.day;
      final isEnd = _rangeEnd != null && 
                    _rangeEnd!.year == day.year && 
                    _rangeEnd!.month == day.month && 
                    _rangeEnd!.day == day.day;
      return isStart || isEnd;
    }
  }

  bool _isDayBetween(DateTime day) {
    if (widget.mode == AppDatePickerMode.range && _rangeStart != null && _rangeEnd != null) {
      return day.isAfter(_rangeStart!) && day.isBefore(_rangeEnd!);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final startingWeekday = _getStartingWeekday(_currentMonth.year, _currentMonth.month);

    final totalGridItems = daysInMonth + startingWeekday;

    final isSubmitEnabled = widget.mode == AppDatePickerMode.single 
        ? _selectedSingleDate != null 
        : (_rangeStart != null); // Allow range start only, or require both? Range start only is fine (shows "X Date")

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag Handle
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E7EC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Header Info
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF101828),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Month Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFF7544FC),
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () => _showMonthYearPicker(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF101828),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Color(0xFF7544FC),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF7544FC),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Weekdays Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _weekdays.map((day) {
                  return Expanded(
                    child: Container(
                      height: 28,
                      alignment: Alignment.center,
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Calendar Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: totalGridItems,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (index < startingWeekday) {
                      return const SizedBox.shrink();
                    }

                    final dayNumber = index - startingWeekday + 1;
                    final dayDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                    
                    final isSelected = _isDaySelected(dayDate);
                    final isBetween = _isDayBetween(dayDate);
                    final isOutOfLimit = dayDate.isBefore(_firstDateLimit) || dayDate.isAfter(_lastDateLimit);

                    // Border style for range selection start/end
                    final isStart = widget.mode == AppDatePickerMode.range &&
                                    _rangeStart != null &&
                                    _rangeStart!.year == dayDate.year &&
                                    _rangeStart!.month == dayDate.month &&
                                    _rangeStart!.day == dayDate.day;

                    final isEnd = widget.mode == AppDatePickerMode.range &&
                                  _rangeEnd != null &&
                                  _rangeEnd!.year == dayDate.year &&
                                  _rangeEnd!.month == dayDate.month &&
                                  _rangeEnd!.day == dayDate.day;

                    Color dayBgColor = Colors.transparent;
                    Color dayTextColor = const Color(0xFF1D2939);
                    ShapeBorder dayShape = const CircleBorder();

                    if (isSelected) {
                      dayBgColor = const Color(0xFF7544FC);
                      dayTextColor = Colors.white;
                    } else if (isBetween) {
                      dayBgColor = const Color(0xFFF5F4FF);
                      dayTextColor = const Color(0xFF7544FC);
                      dayShape = RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: isStart ? const Radius.circular(20) : Radius.zero,
                          right: isEnd ? const Radius.circular(20) : Radius.zero,
                        ),
                      );
                    } else if (isOutOfLimit) {
                      dayTextColor = const Color(0xFFD0D5DD);
                    }

                    return Material(
                      color: dayBgColor,
                      shape: dayShape,
                      child: InkWell(
                        onTap: isOutOfLimit ? null : () => _handleDayTap(dayDate),
                        customBorder: dayShape,
                        child: Center(
                          child: Text(
                            '$dayNumber',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: dayTextColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF7544FC),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF7544FC),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isSubmitEnabled
                            ? () {
                                if (widget.mode == AppDatePickerMode.single) {
                                  Navigator.pop(context, _selectedSingleDate);
                                } else {
                                  Navigator.pop(
                                    context,
                                    DateTimeRange(
                                      start: _rangeStart!,
                                      end: _rangeEnd ?? _rangeStart!,
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7544FC),
                          disabledBackgroundColor:
                              const Color(0xFF7544FC).withValues(alpha: 0.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Select",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
