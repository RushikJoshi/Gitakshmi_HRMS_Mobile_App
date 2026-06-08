import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class ProfilePersonalTab extends StatelessWidget {
  final EmployeeProfileModel profile;
  final bool isEditing;
  final bool isHR;
  final Color primaryColor;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController mobileController;
  final TextEditingController personalEmailController;
  final TextEditingController currentLine1Controller;
  final TextEditingController currentCityController;
  final TextEditingController currentPincodeController;

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
    required this.currentLine1Controller,
    required this.currentCityController,
    required this.currentPincodeController,
  });

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
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
    if (isEditing) {
      return Column(
        children: [
          _buildTextField('First Name', firstNameController, enabled: isHR),
          _buildTextField('Last Name', lastNameController, enabled: isHR),
          _buildTextField('Mobile Number', mobileController),
          _buildTextField('Personal Email', personalEmailController),
          const SizedBox(height: 16),
          const Text('Address Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          _buildTextField('Current Address Line 1', currentLine1Controller),
          _buildTextField('City', currentCityController),
          _buildTextField('Pincode', currentPincodeController),
        ],
      );
    }

    return Column(
      children: [
        _buildInfoTile('Full Name', '${profile.firstName} ${profile.middleName} ${profile.lastName}'),
        _buildInfoTile('Gender', profile.gender),
        _buildInfoTile('Date of Birth', profile.dob),
        _buildInfoTile('Blood Group', profile.bloodGroup),
        _buildInfoTile('Marital Status', profile.maritalStatus),
        _buildInfoTile('Nationality', profile.nationality),
        _buildInfoTile('Official Email', profile.officialEmail),
        _buildInfoTile('Personal Email', profile.personalEmail),
        _buildInfoTile('Mobile Number', profile.mobileNumber),
        _buildInfoTile('Identity Aadhar No.', profile.aadharNumber),
        _buildInfoTile('Identity PAN Card', profile.panNumber),
        _buildInfoTile('Passport Number', profile.passportNumber),
        _buildInfoTile('Driving License No.', profile.drivingLicenseNumber),
        _buildInfoTile('Face Scanner Status', profile.faceRegistrationStatus),
        _buildInfoTile('Biometric ID Register', profile.biometricId),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Current Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ),
        _buildInfoTile('Address Line', '${profile.addressDetails.currentLine1}, ${profile.addressDetails.currentLine2}'),
        _buildInfoTile('City / Pincode', '${profile.addressDetails.currentCity} - ${profile.addressDetails.currentPincode}'),
        _buildInfoTile('State / Country', '${profile.addressDetails.currentState}, ${profile.addressDetails.currentCountry}'),
      ],
    );
  }
}
