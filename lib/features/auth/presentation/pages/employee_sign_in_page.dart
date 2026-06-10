import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/phone_sign_in_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/signup_page.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/pages/dashboard_page.dart';

class EmployeeSignInPage extends StatefulWidget {
  const EmployeeSignInPage({super.key});

  @override
  State<EmployeeSignInPage> createState() => _EmployeeSignInPageState();
}

class _EmployeeSignInPageState extends State<EmployeeSignInPage> {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmployeeIdHide = false;
  bool isPasswordHide = true;
  bool rememberMe = false;

  String? employeeIdError;
  String? passwordError;

  void validateLogin() {
    setState(() {
      employeeIdError = null;
      passwordError = null;

      if (employeeIdController.text.trim().isEmpty) {
        employeeIdError = "Employee ID is required";
      }

      if (passwordController.text.trim().isEmpty) {
        passwordError = "Password is required";
      } else if (passwordController.text.trim().length < 6) {
        passwordError = "Password must be at least 6 characters";
      }
    });

    if (employeeIdError == null && passwordError == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  double _responsiveGap(double size) {
    final height = ResponsiveHelper.screenHeight(context);
    if (height < 680) {
      return size * 0.6;
    } else if (height < 800) {
      return size * 0.8;
    }
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveCenteredView(
          maxWidth: 460,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _responsiveGap(22)),
                Image.asset(
                  "assets/images/logo.png",
                  height: 82,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: _responsiveGap(12)),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: _responsiveGap(6)),
                const Text(
                  "Sign in to my account",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray500,
                  ),
                ),
                SizedBox(height: _responsiveGap(28)),
                _label("Employee ID"),
                SizedBox(height: _responsiveGap(8)),
                _inputField(
                  controller: employeeIdController,
                  hint: "My Employee ID",
                  icon: Icons.account_circle_outlined,
                  errorText: employeeIdError,
                  obscureText: isEmployeeIdHide,
                  suffixIcon: isEmployeeIdHide
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () {
                    setState(() {
                      isEmployeeIdHide = !isEmployeeIdHide;
                    });
                  },
                ),
                SizedBox(height: _responsiveGap(20)),
                _label("Password"),
                SizedBox(height: _responsiveGap(8)),
                _inputField(
                  controller: passwordController,
                  hint: "My Password",
                  icon: Icons.center_focus_weak_rounded,
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
                SizedBox(height: _responsiveGap(12)),
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
                        color: rememberMe ? AppColors.primaryPurple : AppColors.borderLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Remember Me",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDarkGray,
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
                          color: AppColors.primaryPurple,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _responsiveGap(24)),
                _gradientButton("Sign In"),
                SizedBox(height: _responsiveGap(32)),
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.dividerLight, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: AppColors.gray400,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.dividerLight, thickness: 1)),
                  ],
                ),
                SizedBox(height: _responsiveGap(32)),
                _outlineButton(
                  text: "Sign in With Email",
                  icon: Icons.mail_outline_rounded,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                // SizedBox(height: _responsiveGap(14)),
                // _outlineButton(
                //   text: "Sign in With Phone",
                //   icon: Icons.phone_rounded,
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const PhoneSignInScreen(),
                //       ),
                //     );
                //   },
                // ),
                // SizedBox(height: _responsiveGap(34)),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Don’t have an account? ",
                //       style: TextStyle(
                //         fontSize: 14,
                //         fontWeight: FontWeight.w500,
                //         color: AppColors.textSecondary,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const SignUpScreen(),
                //           ),
                //         );
                //       },
                //       child: const Text(
                //         "Sign Up Here",
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //           color: AppColors.primaryPurple,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: _responsiveGap(16)),
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
          fontSize: 14,
          color: AppColors.textDarkGray,
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
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: hasError
                    ? Colors.red.withOpacity(0.10)
                    : const Color(0x0A101828),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            onChanged: (value) {
              if (hasError) {
                setState(() {
                  if (hint.toLowerCase().contains("employee")) {
                    employeeIdError = null;
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
                color: AppColors.gray400,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: hasError ? Colors.red : AppColors.primaryPurple,
                size: 20,
              ),
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                        suffixIcon,
                        color: hasError ? Colors.red : AppColors.primaryPurple,
                        size: 20,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.borderLight,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.primaryPurple,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 2.w),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _gradientButton(String text) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: validateLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _outlineButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.primaryPurple,
          size: 20,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.primaryPurple,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
