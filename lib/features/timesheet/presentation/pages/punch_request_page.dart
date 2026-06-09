import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_date_picker.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';

class PunchRequestScreen extends StatefulWidget {
  final bool isPunchIn;
  
  const PunchRequestScreen({super.key, required this.isPunchIn});

  @override
  State<PunchRequestScreen> createState() => _PunchRequestScreenState();
}

class _PunchRequestScreenState extends State<PunchRequestScreen> {
  static const Color headerPurple = Color(0xff7A5AF8);
  static const Color darkText = Color(0xFF111827);
  static const Color labelBlue = Color(0xFF2E63B4);

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> _pickDate() async {
    final picked = await AppDatePicker.showSingle(
      context: context,
      title: "Select Date",
      subtitle: "Choose the request date",
      initialDate: _selectedDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
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
        title: Text(
          widget.isPunchIn ? "Punch In Request" : "Punch Out Request",
          style: const TextStyle(
            color: darkText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenteredView(
          maxWidth: 560,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Date",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: labelBlue,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: _buildDropdownField(
                  Icons.calendar_month_outlined,
                  _selectedDate != null ? _formatDate(_selectedDate!) : "Select Date",
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                "Time",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: labelBlue,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickTime,
                child: _buildDropdownField(
                  Icons.access_time,
                  _selectedTime != null ? _formatTime(_selectedTime!) : "Select Time",
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                "Reason",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: labelBlue,
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
                      padding: EdgeInsets.only(bottom: 70),
                      child: Icon(Icons.edit_note, color: Color(0xFF667085), size: 20),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: headerPurple,
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
                    side: const BorderSide(color: headerPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Cancel Request",
                    style: TextStyle(
                      color: headerPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  Widget _buildDropdownField(IconData icon, String hint) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D5DD)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF475467), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hint,
              style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF475467), size: 20),
        ],
      ),
    );
  }
}
