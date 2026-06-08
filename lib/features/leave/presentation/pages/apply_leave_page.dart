import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/features/leave/data/models/leave_model.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_selection_bottom_sheet.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_date_picker.dart';

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
  TextEditingController(text: '+62 82150005000');
  final TextEditingController descriptionController = TextEditingController();

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
  void dispose() {
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

  void _openTaskDelegationPopup() async {
    final selected = await AppSelectionBottomSheet.show(
      context: context,
      title: "Select Task Delegation",
      subtitle: "Select Leave category",
      options: taskDelegationList,
      initialSelected: taskDelegation,
    );
    if (selected != null) {
      setState(() {
        taskDelegation = selected;
      });
    }
  }

  void _openLeaveDurationPopup() async {
    final initialStart = startDate != null ? DateTime(2024, 11, startDate!) : null;
    final initialEnd = endDate != null ? DateTime(2024, 11, endDate!) : null;
    final initialRange = (initialStart != null)
        ? DateTimeRange(start: initialStart, end: initialEnd ?? initialStart)
        : null;

    final selectedRange = await AppDatePicker.showRange(
      context: context,
      title: "Leave Duration",
      subtitle: "Select Leave Duration",
      initialRange: initialRange,
      firstDate: DateTime(2024, 11, 1),
      lastDate: DateTime(2024, 11, 30),
    );

    if (selectedRange != null) {
      setState(() {
        startDate = selectedRange.start.day;
        endDate = selectedRange.end.day;
        
        final startStr = "${selectedRange.start.day} Nov";
        final endStr = "${selectedRange.end.day} Nov";
        if (selectedRange.start.day == selectedRange.end.day) {
          leaveDuration = startStr;
        } else {
          leaveDuration = "$startStr - $endStr";
        }
      });
    }
  }

  void _openLeaveCategoryPopup() async {
    final selected = await AppSelectionBottomSheet.show(
      context: context,
      title: "Leave Category",
      subtitle: "Select Leave category",
      options: leaveCategories,
      initialSelected: leaveCategory,
    );
    if (selected != null) {
      setState(() {
        leaveCategory = selected;
      });
    }
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: purple, size: 19),
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
    required IconData icon,
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
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 13, color: darkText),
          decoration: InputDecoration(
            prefixIcon: SizedBox(
              width: 68,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "INA",
                    style: TextStyle(
                      fontSize: 13,
                      color: darkText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      color: purple, size: 18),
                ],
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
            icon: Icons.calendar_month_rounded,
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

  Widget _topBar() {
    return Container(
      height: 56,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: purple,
                size: 16,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Submit Leave",
                style: TextStyle(
                  fontSize: 16,
                  color: darkText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
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
    );
  }
}