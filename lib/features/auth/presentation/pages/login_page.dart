import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/phone_sign_in_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/signup_page.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/pages/leave_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHide = true;
  bool rememberMe = false;

  String? emailError;
  String? passwordError;

  void validateLogin() {
    setState(() {
      emailError = null;
      passwordError = null;

      if (emailController.text.trim().isEmpty) {
        emailError = "Email is required";
      } else if (!emailController.text.contains("@")) {
        emailError = "Enter valid email address";
      } else if (emailController.text.trim() != "tanvi@gmail.com") {
        emailError = "Email doesn't registered to any account";
      }

      if (passwordController.text.trim().isEmpty) {
        passwordError = "Password is required";
      } else if (passwordController.text != "123456") {
        passwordError = "Invalid password";
      }
    });

    if (emailError == null && passwordError == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LeaveSummaryScreen()),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17172B),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 30, 26, 30),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 92,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Sign in to my account",
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
                    hint: "My Email",
                    icon: Icons.mail_outline_rounded,
                    errorText: emailError,
                  ),

                  const SizedBox(height: 18),

                  _label("Password"),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: passwordController,
                    hint: "My Password",
                    icon: Icons.lock_outline_rounded,
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

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberMe = !rememberMe;
                          });
                        },
                        child: Icon(
                          rememberMe
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: AppColors.border,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Remember Me",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: AppColors.border,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _gradientButton("Sign In"),

                  const SizedBox(height: 34),

                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFE4E7EC))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Color(0xFFB0B7C3),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFE4E7EC))),
                    ],
                  ),

                  const SizedBox(height: 34),

                  _outlineButton(
                    text: "Sign in With Employee ID",
                    icon: Icons.badge_rounded,
                  ),

                  const SizedBox(height: 14),

                  _outlineButton(
                    text: "Sign in With Phone",
                    icon: Icons.phone_rounded,
                  ),

                  const SizedBox(height: 34),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up Here",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
    required IconData icon,
    String? errorText,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
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
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            onChanged: (value) {
              if (hasError) {
                setState(() {
                  if (hint.toLowerCase().contains("email")) {
                    emailError = null;
                  } else {
                    passwordError = null;
                  }
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
              prefixIcon: Icon(
                icon,
                color: hasError ? Colors.red : AppColors.border,
                size: 20,
              ),
              suffixIcon: hasError && hint.toLowerCase().contains("email")
                  ? const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 20,
              )
                  : suffixIcon != null
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
        onPressed: validateLogin,
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

  Widget _outlineButton({
    required String text,
    required IconData icon,
  }) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhoneSignInScreen(),
            ),
          );
        },
        icon: Icon(
          icon,
          color: AppColors.border,
          size: 22,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: AppColors.border,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.border,
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
