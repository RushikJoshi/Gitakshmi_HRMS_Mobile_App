import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_selection_bottom_sheet.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_date_picker.dart';

class ProfilePersonalTab extends StatefulWidget {
  final EmployeeProfileModel profile;
  final bool isEditing;
  final bool isHR;
  final Color primaryColor;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController mobileController;
  final TextEditingController personalEmailController;
  final TextEditingController positionController;
  final TextEditingController dobController;
  final TextEditingController currentLine1Controller;
  final TextEditingController currentCityController;
  final TextEditingController currentPincodeController;
  final TextEditingController countryController;
  final TextEditingController stateController;

  const ProfilePersonalTab({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.isHR,
    required this.primaryColor,
    required this.firstNameController,
    required this.lastNameController,
    required this.mobileController,
    required this.personalEmailController,
    required this.positionController,
    required this.dobController,
    required this.currentLine1Controller,
    required this.currentCityController,
    required this.currentPincodeController,
    required this.countryController,
    required this.stateController,
  });

  @override
  State<ProfilePersonalTab> createState() => _ProfilePersonalTabState();
}

class _ProfilePersonalTabState extends State<ProfilePersonalTab> {
  // Mock country, state, city structures for interactive bottom sheets
  final Map<String, List<String>> countryStates = {
    'Indonesia': ['DKI Jakarta', 'West Java', 'Bali', 'East Java'],
    'India': ['Gujarat', 'Maharashtra', 'Delhi', 'Karnataka'],
    'United States': ['California', 'New York', 'Texas', 'Florida'],
    'Singapore': ['Central Region', 'East Region', 'North Region'],
  };

  final Map<String, List<String>> stateCities = {
    // Indonesia
    'DKI Jakarta': ['Jakarta Selatan', 'Jakarta Pusat', 'Jakarta Barat', 'Jakarta Utara'],
    'West Java': ['Bandung', 'Bogor', 'Bekasi', 'Depok'],
    'Bali': ['Denpasar', 'Badung', 'Gianyar', 'Ubud'],
    'East Java': ['Surabaya', 'Malang', 'Sidoarjo'],
    // India
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Thane'],
    'Delhi': ['New Delhi', 'North Delhi', 'South Delhi'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubballi'],
    // United States
    'California': ['Los Angeles', 'San Francisco', 'San Diego', 'San Jose'],
    'New York': ['New York City', 'Buffalo', 'Rochester'],
    'Texas': ['Houston', 'Austin', 'Dallas', 'San Antonio'],
    'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville'],
  };

  final List<String> positionList = const [
    'Junior Full Stack Developer',
    'Senior Flutter Developer',
    'Lead Product Designer',
    'UX Writer',
    'Jr Product Manager',
    'UI Designer',
    'HR Manager',
  ];

  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.trim().split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final monthName = parts[1];
        final year = int.parse(parts[2]);
        final month = monthNames.indexOf(monthName) + 1;
        if (month > 0) {
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}
    return null;
  }

  void _showSelectionBottomSheet({
    required String title,
    required String subtitle,
    required List<String> options,
    required TextEditingController controller,
    VoidCallback? onSelected,
  }) async {
    final selected = await AppSelectionBottomSheet.show(
      context: context,
      title: title,
      subtitle: subtitle,
      options: options,
      initialSelected: controller.text,
    );
    if (selected != null) {
      controller.text = selected;
      if (onSelected != null) {
        onSelected();
      }
    }
  }

  Widget _buildEditField({
    required String label,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF7A5AF8), size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF7A5AF8), width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData prefixIcon,
    required String value,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE4E7EC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(prefixIcon, color: const Color(0xFF7A5AF8), size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF98A2B3), size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildMultiLineField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF7A5AF8), width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card 1: My Personal Data
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F3F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'My Personal Data',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Details about my personal data',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                
                // Photo upload section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7D3FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/boy_avatar.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFF7544FC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sync_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Upload Photo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Format should be in .jpeg .png atleast\n800x800px and less than 5MB',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.grey, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildEditField(
                  label: 'First Name',
                  prefixIcon: Icons.person_outline_rounded,
                  controller: widget.firstNameController,
                  enabled: widget.isHR,
                ),
                _buildEditField(
                  label: 'Last Name',
                  prefixIcon: Icons.person_outline_rounded,
                  controller: widget.lastNameController,
                  enabled: widget.isHR,
                ),
                _buildDropdownField(
                  label: 'Date of Birth',
                  prefixIcon: Icons.calendar_today_rounded,
                  value: widget.dobController.text,
                  onTap: () async {
                    final initialDate = _parseDate(widget.dobController.text) ?? DateTime(1997, 12, 10);
                    final selected = await AppDatePicker.showSingle(
                      context: context,
                      title: 'Select Date of Birth',
                      subtitle: 'Choose your birth date',
                      initialDate: initialDate,
                      firstDate: DateTime(DateTime.now().year - 80),
                      lastDate: DateTime.now(),
                    );
                    if (selected != null) {
                      setState(() {
                        widget.dobController.text = _formatDate(selected);
                      });
                    }
                  },
                ),
                _buildEditField(
                  label: 'Mobile Number',
                  prefixIcon: Icons.phone_iphone_rounded,
                  controller: widget.mobileController,
                ),
                _buildEditField(
                  label: 'Personal Email',
                  prefixIcon: Icons.mail_outline_rounded,
                  controller: widget.personalEmailController,
                ),
                _buildDropdownField(
                  label: 'Position',
                  prefixIcon: Icons.badge_outlined,
                  value: widget.positionController.text,
                  onTap: () {
                    _showSelectionBottomSheet(
                      title: 'Select Position',
                      subtitle: 'Choose your professional title',
                      options: positionList,
                      controller: widget.positionController,
                      onSelected: () {
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Card 2: Address
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F3F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your current domicile',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                
                _buildDropdownField(
                  label: 'Country',
                  prefixIcon: Icons.public_rounded,
                  value: widget.countryController.text,
                  onTap: () {
                    _showSelectionBottomSheet(
                      title: 'Select Country',
                      subtitle: 'Choose your current residence country',
                      options: countryStates.keys.toList(),
                      controller: widget.countryController,
                      onSelected: () {
                        setState(() {
                          final states = countryStates[widget.countryController.text] ?? [];
                          if (states.isNotEmpty) {
                            widget.stateController.text = states.first;
                            final cities = stateCities[widget.stateController.text] ?? [];
                            if (cities.isNotEmpty) {
                              widget.currentCityController.text = cities.first;
                            } else {
                              widget.currentCityController.text = '';
                            }
                          } else {
                            widget.stateController.text = '';
                            widget.currentCityController.text = '';
                          }
                        });
                      },
                    );
                  },
                ),
                _buildDropdownField(
                  label: 'State',
                  prefixIcon: Icons.map_rounded,
                  value: widget.stateController.text,
                  onTap: () {
                    final states = countryStates[widget.countryController.text] ?? [];
                    _showSelectionBottomSheet(
                      title: 'Select State',
                      subtitle: 'Choose your state/province',
                      options: states.isNotEmpty ? states : ['DKI Jakarta'],
                      controller: widget.stateController,
                      onSelected: () {
                        setState(() {
                          final cities = stateCities[widget.stateController.text] ?? [];
                          if (cities.isNotEmpty) {
                            widget.currentCityController.text = cities.first;
                          } else {
                            widget.currentCityController.text = '';
                          }
                        });
                      },
                    );
                  },
                ),
                _buildDropdownField(
                  label: 'City',
                  prefixIcon: Icons.location_city_rounded,
                  value: widget.currentCityController.text,
                  onTap: () {
                    final cities = stateCities[widget.stateController.text] ?? [];
                    _showSelectionBottomSheet(
                      title: 'Select City',
                      subtitle: 'Choose your local city domicile',
                      options: cities.isNotEmpty ? cities : ['Jakarta Selatan'],
                      controller: widget.currentCityController,
                    );
                  },
                ),
                _buildMultiLineField(
                  label: 'Full Address',
                  controller: widget.currentLine1Controller,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildInfoTile('Full Name', '${widget.profile.firstName} ${widget.profile.middleName} ${widget.profile.lastName}'),
        _buildInfoTile('Gender', widget.profile.gender),
        _buildInfoTile('Date of Birth', widget.profile.dob),
        _buildInfoTile('Blood Group', widget.profile.bloodGroup),
        _buildInfoTile('Marital Status', widget.profile.maritalStatus),
        _buildInfoTile('Nationality', widget.profile.nationality),
        _buildInfoTile('Official Email', widget.profile.officialEmail),
        _buildInfoTile('Personal Email', widget.profile.personalEmail),
        _buildInfoTile('Mobile Number', widget.profile.mobileNumber),
        _buildInfoTile('Identity Aadhar No.', widget.profile.aadharNumber),
        _buildInfoTile('Identity PAN Card', widget.profile.panNumber),
        _buildInfoTile('Passport Number', widget.profile.passportNumber),
        _buildInfoTile('Driving License No.', widget.profile.drivingLicenseNumber),
        _buildInfoTile('Face Scanner Status', widget.profile.faceRegistrationStatus),
        _buildInfoTile('Biometric ID Register', widget.profile.biometricId),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Current Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ),
        _buildInfoTile('Address Line', '${widget.profile.addressDetails.currentLine1}, ${widget.profile.addressDetails.currentLine2}'),
        _buildInfoTile('City / Pincode', '${widget.profile.addressDetails.currentCity} - ${widget.profile.addressDetails.currentPincode}'),
        _buildInfoTile('State / Country', '${widget.profile.addressDetails.currentState}, ${widget.profile.addressDetails.currentCountry}'),
      ],
    );
  }
}
