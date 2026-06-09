import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/phone_sign_in_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/signup_page.dart';
import 'package:gitakshmi_hrms_app/features/dashboard/presentation/pages/dashboard_page.dart';

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
      }

      if (passwordController.text.trim().isEmpty) {
        passwordError = "Password is required";
      } else if (passwordController.text.trim().length < 6) {
        passwordError = "Password must be at least 6 characters";
      }
    });

    if (emailError == null && passwordError == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
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
          child: ResponsiveCenteredView(
            maxWidth: 500,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.r),
                  topRight: Radius.circular(22.r),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(26.w, 30.h, 26.w, 30.h),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 92.h,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      "Sign in to my account",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475467),
                      ),
                    ),

                    SizedBox(height: 28.h),

                    _label("Email"),
                    SizedBox(height: 8.h),
                    _inputField(
                      controller: emailController,
                      hint: "My Email",
                      icon: Icons.mail_outline_rounded,
                      errorText: emailError,
                    ),

                    SizedBox(height: 18.h),

                    _label("Password"),
                    SizedBox(height: 8.h),
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

                    SizedBox(height: 10.h),

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
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Remember Me",
                          style: TextStyle(
                            fontSize: 12.sp,
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
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: AppColors.border,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    _gradientButton("Sign In"),

                    SizedBox(height: 34.h),

                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFE4E7EC))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: const Color(0xFFB0B7C3),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFE4E7EC))),
                      ],
                    ),

                    SizedBox(height: 34.h),

                    _outlineButton(
                      text: "Sign in With Employee ID",
                      icon: Icons.badge_rounded,
                    ),

                    SizedBox(height: 14.h),

                    _outlineButton(
                      text: "Sign in With Phone",
                      icon: Icons.phone_rounded,
                    ),

                    SizedBox(height: 34.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: TextStyle(
                            fontSize: 11.sp,
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
                          child: Text(
                            "Sign Up Here",
                            style: TextStyle(
                              fontSize: 11.sp,
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
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF667085),
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
            borderRadius: BorderRadius.circular(7.r),
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
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
              hintStyle: TextStyle(
                color: const Color(0xFF98A2B3),
                fontSize: 13.sp,
              ),
              prefixIcon: Icon(
                icon,
                color: hasError ? Colors.red : AppColors.border,
                size: 20.sp,
              ),
              suffixIcon: hasError && hint.toLowerCase().contains("email")
                  ? Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20.sp,
                    )
                  : suffixIcon != null
                      ? GestureDetector(
                          onTap: onSuffixTap,
                          child: Icon(
                            suffixIcon,
                            color: hasError ? Colors.red : AppColors.border,
                            size: 20.sp,
                          ),
                        )
                      : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.r),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xFF98A2B3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.r),
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
    return Container(
      height: 54.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
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
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
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
      height: 50.h,
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
          size: 22.sp,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: AppColors.border,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.border,
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
      ),
    );
  }
}
