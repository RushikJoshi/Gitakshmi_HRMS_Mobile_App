import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
import 'package:gitakshmi_hrms_app/features/leave/data/models/leave_model.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String? leaveCategory;
  String? leaveDuration;
  String? taskDelegation;

  int? startDate;
  int? endDate;

  final TextEditingController phoneController =
  TextEditingController(text: 'enter number');
  final TextEditingController descriptionController = TextEditingController();

  static const Map<String, String> countryPrefixes = {
    'IND': '+91',
    'INA': '+62',
    'USA': '+1',
    'UK': '+44',
    'SGP': '+65',
    'UAE': '+971',
  };

  late String selectedCountry;
  late TextEditingController subscriberPhoneController;

  static const Color bgColor = Color(0xFFF1F1FF);
  static const Color purple = Color(0xFF6938EF);
  static const Color selectedPurple = Color(0xFF7A5AF8);
  static const Color darkPurple = Color(0xFF6938EF);
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF667085);
  static const Color borderColor = Color(0xFFB7C0D0);

  final List<String> leaveCategories = const [
    "Sick Leave",
    "Annual Leave/Vacation Leave",
    "Maternity/Paternity Leave",
    "Bereavement Leave",
    "Personal Leave",
    "Jury Duty Leave",
    "Compassionate Leave",
  ];

  final List<String> taskDelegationList = const [
    "Jeane - UX Writer",
    "Alpheas - UI Designer",
    "John - UX Designer",
    "Alicia - Jr Product Manager",
    "Claudia - UI Designer",
    "Option 4",
    "Option 4",
  ];

  @override
  void initState() {
    super.initState();
    String initialText = phoneController.text.trim();
    String detectedCountry = 'INA';
    String subscriberNumber = initialText;

    for (var entry in countryPrefixes.entries) {
      if (initialText.startsWith(entry.value)) {
        detectedCountry = entry.key;
        subscriberNumber = initialText.substring(entry.value.length).trim();
        break;
      }
    }

    selectedCountry = detectedCountry;
    subscriberPhoneController = TextEditingController(text: subscriberNumber);
    subscriberPhoneController.addListener(_updatePhoneController);
  }

  void _updatePhoneController() {
    final prefix = countryPrefixes[selectedCountry] ?? '';
    phoneController.text = '$prefix ${subscriberPhoneController.text}'.trim();
  }

  @override
  void dispose() {
    subscriberPhoneController.removeListener(_updatePhoneController);
    subscriberPhoneController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget _submitNowButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFA787FF),
            Color(0xFF4F1ED8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6938EF).withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _openSubmitLeavePopup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff4F1ED8),
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          "Submit Now",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _openSubmitLeavePopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 580),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [

              // Main Popup
              Container(
                margin: const EdgeInsets.only(top: 45),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Submit Leave",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF101828),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Double-check your leave details to ensure\neverything is correct. Do you want to proceed?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF344054),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Yes Submit Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFA787FF),
                            Color(0xFF4F1ED8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6938EF).withOpacity(0.30),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _openLeaveSubmittedPopup();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Yes, Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF6938EF),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "No, Let me check",
                          style: TextStyle(
                            color: Color(0xFF6938EF),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Image Box
              Positioned(
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Image.asset(
                    'assets/images/submit_icon.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openLeaveSubmittedPopup() {
    final outerContext = context; // capture screen context before modal
    showModalBottomSheet(
      context: outerContext,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 580),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Main Popup
              Container(
                margin: const EdgeInsets.only(top: 45),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Leave Submitted!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your leave request has been sent for review!\nWait for HR to review your request.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // View Expense History Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFA787FF),
                            Color(0xFF4F1ED8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6938EF).withOpacity(0.30),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final entry = LeaveEntry(
                            category: leaveCategory ?? '',
                            duration: leaveDuration ?? '',
                            taskDelegation: taskDelegation,
                            phone: phoneController.text,
                            description: descriptionController.text,
                            submittedDate: DateTime.now(),
                            startDate: startDate,
                            endDate: endDate,
                          );
                          Navigator.pop(context);           // close bottom sheet
                          Navigator.pop(outerContext, entry); // return to LeaveSummaryScreen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "View Expense History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Floating Purple Icon Box
              Positioned(
                top: 0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF9B6FF5),
                        Color(0xFF5B21B6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6938EF).withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: 
                    Image.asset('assets/images/submit_icon.png',height: 100,width: 100,)
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openTaskDelegationPopup() {
    String? tempSelected = taskDelegation;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 580),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: ResponsiveHelper.screenHeight(context) * 0.70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Task Delegation",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff101828),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Select Leave category",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff667085),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView.separated(
                              itemCount: taskDelegationList.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                final item = taskDelegationList[index];
                                final isSelected = tempSelected == item;

                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      tempSelected = item;
                                    });
                                  },
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFF4F1FF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                        color: isSelected
                                            ? selectedPurple
                                            : borderColor,
                                        width: isSelected ? 1.3 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF344054),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_off,
                                          color: isSelected
                                              ? selectedPurple
                                              : const Color(0xFF98A2B3),
                                          size: 21,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: darkPurple),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: darkPurple,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  taskDelegation = tempSelected;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkPurple,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                "Select",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
          },
        );
      },
    );
  }

  Widget _dayBox(String day) {
    return Expanded(
      child: Container(
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFEAECF0),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          day,
          style: const TextStyle(fontSize: 14, color: Color(0xff101828)),
        ),
      ),
    );
  }

  void _openLeaveDurationPopup() {
    int? tempStart = startDate;
    int? tempEnd = endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 580),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: ResponsiveHelper.screenHeight(context) * 0.70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Leave Duration",
                      style: TextStyle(
                        fontSize: 20,
                        color: darkText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Select Leave Duration",
                      style: TextStyle(fontSize: 14, color: greyText),
                    ),
                    const SizedBox(height: 21),
                    Row(
                      children: const [
                        Icon(
                          Icons.chevron_left_rounded,
                          color: selectedPurple,
                          size: 26,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "November 2024",
                              style: TextStyle(
                                fontSize: 16,
                                color: darkText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: selectedPurple,
                          size: 26,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _dayBox("Sun"),
                        _dayBox("Mon"),
                        _dayBox("Tue"),
                        _dayBox("Wed"),
                        _dayBox("Thu"),
                        _dayBox("Fri"),
                        _dayBox("Sat"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 6,
                        children: [
                          ...["25", "26", "27", "28", "29", "30"]
                              .map((e) => _dateText(e, disabled: true)),
                          ...List.generate(30, (index) {
                            final day = index + 1;
                            final bool selected =
                                day == tempStart || day == tempEnd;

                            final bool between = tempStart != null &&
                                tempEnd != null &&
                                day > tempStart! &&
                                day < tempEnd!;

                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (tempStart == null ||
                                      tempEnd != null ||
                                      day < tempStart!) {
                                    tempStart = day;
                                    tempEnd = null;
                                  } else {
                                    tempEnd = day;
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? selectedPurple
                                      : between
                                      ? const Color(0xFFE7DCFF)
                                      : Colors.transparent,
                                  shape: selected
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                ),
                                child: Text(
                                  "$day",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selected ? Colors.white : darkText,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          }),
                          ...["1", "2", "3", "4", "5"]
                              .map((e) => _dateText(e, disabled: true)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkPurple,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            startDate = tempStart;
                            endDate = tempEnd;

                            if (startDate != null && endDate != null) {
                              leaveDuration = "$startDate Nov - $endDate Nov";
                            } else if (startDate != null) {
                              leaveDuration = "$startDate Nov";
                            }
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Submit Date",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: darkPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Close Message",
                          style: TextStyle(
                            color: darkPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dateText(String text, {bool disabled = false}) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: disabled ? const Color(0xFF98A2B3) : darkText,
        ),
      ),
    );
  }

  void _openLeaveCategoryPopup() {
    String? tempSelected = leaveCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 580),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: ResponsiveHelper.screenHeight(context) * 0.72,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Leave Category",
                            style: TextStyle(
                              fontSize: 16,
                              color: darkText,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Select Leave category",
                            style: TextStyle(fontSize: 12, color: greyText),
                          ),
                          const SizedBox(height: 18),
                          Expanded(
                            child: ListView.separated(
                              itemCount: leaveCategories.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                final item = leaveCategories[index];
                                final isSelected = tempSelected == item;

                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      tempSelected = item;
                                    });
                                  },
                                  child: Container(
                                    height: 46,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFF4F1FF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                        color: isSelected
                                            ? selectedPurple
                                            : borderColor,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF344054),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: isSelected
                                              ? selectedPurple
                                              : const Color(0xFF98A2B3),
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: darkPurple),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                "Close Message",
                                style: TextStyle(
                                  color: darkPurple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  leaveCategory = tempSelected;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkPurple,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                "Submit Date",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required dynamic icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon is String
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                icon,
                width: 19,
                height: 19,
                fit: BoxFit.contain,
              ),
            )
          : Icon(icon as IconData, color: purple, size: 19),
      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: purple),
      hintStyle: const TextStyle(fontSize: 13, color: darkText),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: purple, width: 1.2),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF475467),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _selectField({
    required String label,
    required String hint,
    required dynamic icon,
    required String? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextFormField(
          readOnly: true,
          onTap: onTap,
          style: const TextStyle(fontSize: 13, color: darkText),
          decoration: _inputDecoration(hint: value ?? hint, icon: icon),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Emergency Contact During Leave Period"),
        TextFormField(
          controller: subscriberPhoneController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 13, color: darkText),
          decoration: InputDecoration(
            prefixIcon: SizedBox(
              width: 80,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCountry,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.keyboard_arrow_down_rounded, color: purple, size: 18),
                  ),
                  alignment: Alignment.center,
                  selectedItemBuilder: (BuildContext context) {
                    return countryPrefixes.keys.map<Widget>((String key) {
                      return Center(
                        child: Text(
                          key,
                          style: const TextStyle(
                            fontSize: 13,
                            color: darkText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  items: countryPrefixes.keys.map<DropdownMenuItem<String>>((String key) {
                    final prefix = countryPrefixes[key];
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(
                        "$key ($prefix)",
                        style: const TextStyle(
                          fontSize: 13,
                          color: darkText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCountry = newValue;
                        _updatePhoneController();
                      });
                    }
                  },
                ),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: purple, width: 1.2),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Leave Description"),
        TextFormField(
          controller: descriptionController,
          maxLines: 5,
          style: const TextStyle(fontSize: 13, color: darkText),
          decoration: InputDecoration(
            hintText: "Enter Leave Description",
            hintStyle:
            const TextStyle(fontSize: 13, color: Color(0xFF98A2B3)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: purple, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 22, 14, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fill Leave Information",
            style: TextStyle(
              fontSize: 14,
              color: darkText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Information about leave details",
            style: TextStyle(fontSize: 12, color: greyText),
          ),
          const SizedBox(height: 18),
          _selectField(
            label: "Leave Category",
            hint: "Select Category",
            icon: Icons.work_rounded,
            value: leaveCategory,
            onTap: _openLeaveCategoryPopup,
          ),
          _selectField(
            label: "Leave Duration",
            hint: "Select Duration",
            icon: 'assets/icons/calender.png',
            value: leaveDuration,
            onTap: _openLeaveDurationPopup,
          ),
          _selectField(
            label: "Task Delegation",
            hint: "Select Category",
            icon: Icons.person_rounded,
            value: taskDelegation,
            onTap: _openTaskDelegationPopup,
          ),
          _phoneField(),
          _descriptionField(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: purple,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Submit Leave",
          style: TextStyle(
            fontSize: 16,
            color: darkText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ResponsiveCenteredView(
          maxWidth: 580,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(11, 16, 11, 16),
                  child: _formCard(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                child: _submitNowButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}