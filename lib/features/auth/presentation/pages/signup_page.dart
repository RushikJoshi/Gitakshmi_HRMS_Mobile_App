import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/pages/dashboard_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordHide = true;
  bool isConfirmPasswordHide = true;
  bool agree = false;

  String? emailError;
  String? phoneError;
  String? companyIdError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    companyIdController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void openTermsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TermsPrivacyScreen(),
      ),
    );

    if (result == true) {
      setState(() => agree = true);
    }
  }

  void validateSignUp() {
    setState(() {
      emailError = null;
      phoneError = null;
      companyIdError = null;
      passwordError = null;
      confirmPasswordError = null;

      // Email Validation
      final emailVal = emailController.text.trim();
      if (emailVal.isEmpty) {
        emailError = "Email is required";
      } else if (!emailVal.contains("@")) {
        emailError = "Enter valid email address";
      }

      // Phone Validation
      final phoneVal = phoneController.text.trim();
      if (phoneVal.isEmpty) {
        phoneError = "Phone number is required";
      }

      // Company ID Validation
      final companyIdVal = companyIdController.text.trim();
      if (companyIdVal.isEmpty) {
        companyIdError = "Company ID is required";
      }

      // Password Validation
      final passVal = passwordController.text;
      if (passVal.isEmpty) {
        passwordError = "Password is required";
      } else if (passVal.length < 6) {
        passwordError = "Password must be at least 6 characters";
      }

      // Confirm Password Validation
      final confirmPassVal = confirmPasswordController.text;
      if (confirmPassVal.isEmpty) {
        confirmPasswordError = "Confirm password is required";
      } else if (confirmPassVal != passVal) {
        confirmPasswordError = "Passwords do not match";
      }
    });

    if (emailError == null &&
        phoneError == null &&
        companyIdError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      if (!agree) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please agree to the terms and privacy policy"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // If successful, show SnackBar and navigate back to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account registered successfully!"),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/logo.png",
                  height: 92,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Register Using Your Credentials",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(height: 28),

                _label("Email"),
                const SizedBox(height: 8),
                _inputField(
                  controller: emailController,
                  hint: "Tonald@wo",
                  icon: Icons.mail_outline_rounded,
                  errorText: emailError,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),

                _label("Phone Number"),
                const SizedBox(height: 8),
                _inputField(
                  controller: phoneController,
                  hint: "+62 82150005000",
                  errorText: phoneError,
                  keyboardType: TextInputType.phone,
                  isPhoneField: true,
                ),
                const SizedBox(height: 18),

                _label("Company ID"),
                const SizedBox(height: 8),
                _inputField(
                  controller: companyIdController,
                  hint: "1015015",
                  icon: Icons.mail_outline_rounded,
                  errorText: companyIdError,
                ),
                const SizedBox(height: 18),

                _label("Password"),
                const SizedBox(height: 8),
                _inputField(
                  controller: passwordController,
                  hint: "••••••••",
                  icon: Icons.fingerprint_rounded,
                  errorText: passwordError,
                  obscureText: isPasswordHide,
                  suffixIcon: isPasswordHide
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () {
                    setState(() {
                      isPasswordHide = !isPasswordHide;
                    });
                  },
                ),
                const SizedBox(height: 18),

                _label("Confirm Password"),
                const SizedBox(height: 8),
                _inputField(
                  controller: confirmPasswordController,
                  hint: "••••••••",
                  icon: Icons.fingerprint_rounded,
                  errorText: confirmPasswordError,
                  obscureText: isConfirmPasswordHide,
                  suffixIcon: isConfirmPasswordHide
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () {
                    setState(() {
                      isConfirmPasswordHide = !isConfirmPasswordHide;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Terms and Conditions checkbox row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => agree = !agree),
                      child: Icon(
                        agree
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: AppColors.border,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: GestureDetector(
                        onTap: openTermsScreen,
                        child: const Text.rich(
                          TextSpan(
                            text: "I agree with ",
                            style: TextStyle(
                              color: Color(0xFF101828),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "terms & conditions",
                                style: TextStyle(color: AppColors.border),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "privacy policy",
                                style: TextStyle(color: AppColors.border),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                _gradientButton("Sign Up"),
                const SizedBox(height: 34),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Sign in here",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF667085),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? errorText,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
    bool isPhoneField = false,
  }) {
    final bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: hasError
                    ? Colors.red.withOpacity(0.10)
                    : const Color(0x339747FF),
                blurRadius: hasError ? 4 : 0,
                spreadRadius: hasError ? 1 : 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            onChanged: (value) {
              if (hasError) {
                setState(() {
                  emailError = null;
                  phoneError = null;
                  companyIdError = null;
                  passwordError = null;
                  confirmPasswordError = null;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF98A2B3),
                fontSize: 13,
              ),
              prefixIcon: isPhoneField
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 14),
                        const Text(
                          "INA",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF98A2B3),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 20,
                          width: 1.2,
                          color: const Color(0xFFD0D5DD),
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  : icon != null
                      ? Icon(
                          icon,
                          color: hasError ? Colors.red : AppColors.border,
                          size: 20,
                        )
                      : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                        suffixIcon,
                        color: hasError ? Colors.red : AppColors.border,
                        size: 20,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xFF98A2B3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xFF9B8AFB),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 2),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _gradientButton(String text) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AppColors.button_grad_1,
            AppColors.button_grad_2,
            AppColors.button_grad_3,
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: validateSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Terms & Conditions and\nPrivacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 26),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFF8FAFC),
                    child: const SingleChildScrollView(
                      child: Text(
                        termsText,
                        style: TextStyle(
                          color: Color(0xFF101828),
                          fontSize: 11,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.button_grad_1,
                          AppColors.button_grad_2,
                          AppColors.button_grad_3,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "I Agree",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.border,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      "Decline",
                      style: TextStyle(
                        color: AppColors.border,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const String termsText = """
Terms and Conditions:
Acceptance: By using the Re-Dus app, you agree to comply with all applicable terms and conditions.

Usage: This app is for personal use only and may not be used for commercial purposes without permission.

Account: You are responsible for the security of your account and all activities that occur within it.

Content: You must not upload content that violates copyright, privacy, or applicable laws.

Changes: We reserve the right to change the terms and conditions at any time and will notify you of these changes through the app or via email.

Privacy Policy:
Data Collection: We collect personal data such as name, email, and location to process transactions and improve our services.

Data Usage: Your data is used for internal purposes such as account management, usage analysis, and service offerings.

Security: We protect your data with appropriate security measures to prevent unauthorized access.

Data Sharing: We do not share your personal data with third parties without your consent, except as required by law.

Your Rights: You can access, update, or delete your personal data through your account settings.
""";