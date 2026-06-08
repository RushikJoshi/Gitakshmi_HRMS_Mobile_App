import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/widgets/phone_input_step.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/widgets/otp_input_step.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/widgets/permission_loading_step.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  int _step = 0; // 0 = Phone Input, 1 = OTP Input, 2 = Permissions Fetch
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  void _sendOtp() {
    if (_phoneController.text.length >= 10) {
      setState(() {
        _step = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
    }
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      setState(() {
        _step = 2;
      });
      // Simulate permission fetching step
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit OTP.')),
      );
    }
  }

  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP Resent.')),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Brand logo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              if (_step == 0) ...[
                PhoneInputStep(
                  phoneController: _phoneController,
                  onSendOtp: _sendOtp,
                ),
              ] else if (_step == 1) ...[
                OtpInputStep(
                  phoneNumber: _phoneController.text,
                  otpControllers: _otpControllers,
                  otpFocusNodes: _otpFocusNodes,
                  onVerifyOtp: _verifyOtp,
                  onResendOtp: _resendOtp,
                ),
              ] else ...[
                const Expanded(
                  child: PermissionLoadingStep(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
