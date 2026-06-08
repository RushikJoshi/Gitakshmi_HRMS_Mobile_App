import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class OtpInputStep extends StatelessWidget {
  final String phoneNumber;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final VoidCallback onVerifyOtp;
  final VoidCallback onResendOtp;

  const OtpInputStep({
    super.key,
    required this.phoneNumber,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.onVerifyOtp,
    required this.onResendOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter Verification Code',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a 4-digit code to $phoneNumber',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return SizedBox(
              width: 60,
              child: TextField(
                controller: otpControllers[index],
                focusNode: otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (val) {
                  if (val.length == 1 && index < 3) {
                    FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                  } else if (val.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                  }
                  if (val.length == 1 && index == 3) {
                    onVerifyOtp();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onVerifyOtp,
          child: const Text('Verify & Login'),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Did not receive the code? '),
            TextButton(
              onPressed: onResendOtp,
              child: const Text('Resend', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}
