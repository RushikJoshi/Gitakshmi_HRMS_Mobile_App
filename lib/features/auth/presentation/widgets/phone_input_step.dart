import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class PhoneInputStep extends StatelessWidget {
  final TextEditingController phoneController;
  final VoidCallback onSendOtp;

  const PhoneInputStep({
    super.key,
    required this.phoneController,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your phone number to sign into the HRMS portal.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
                AppTextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          labelText: 'Phone Number',
          prefixIcon: Icons.phone_iphone_rounded,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSendOtp,
          child: const Text('Send OTP'),
        ),
      ],
    );
  }
}
