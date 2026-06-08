import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/signup_page.dart';

// Mapping the user's screen names to the project's page classes
typedef SignInScreen = LoginPage;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<OnboardModel> pages = [
    OnboardModel(
      topImage: "assets/images/onbording1_top.png",
      bottomImage: "assets/images/onbording1_bottom.png",
      title: "Welcome to HRMS!",
      subtitle: "Make Smart Decisions! Set clear timelines for\nprojects and celebrate your achievements!",
      buttonText: "Next",
      secondButtonText: "Skip",
      top: ImagePos(top: 86, left: 9, width: 283),
      bottom: ImagePos(top: 200, left: 79, width: 280),
    ),
    OnboardModel(
      topImage: "assets/images/onboarding2_top.png",
      bottomImage: "assets/images/onboarding2_bottom.png",
      title: "Manage Stress Effectively",
      subtitle: "Stay Balanced! Track your workload and maintain a\nhealthy stress level with ease.",
      buttonText: "Next",
      secondButtonText: "Skip",
      top: ImagePos(top: 60, left: 30, width: 266),
      bottom: ImagePos(top: 164, left: 40, width: 296),
    ),
    OnboardModel(
      topImage: "assets/images/onboarding3_top.png",
      bottomImage: "assets/images/onboarding3_bottom.png",
      title: "Plan for Success",
      subtitle: "Your Journey Starts Here! Earn achievement badges\nas you conquer your tasks. Let's get started!",
      buttonText: "Next",
      secondButtonText: "Skip",
      top: ImagePos(top: 65, left: 49, width: 301),
      bottom: ImagePos(top: 211, left: 49, width: 301),
    ),
    OnboardModel(
      topImage: "assets/images/onboarding_final_top.png",
      bottomImage: "assets/images/onboarding_final_bottom.png",
      title: "Navigate Your Work Journey\nEfficient & Easy",
      subtitle: "Increase your work management & career\ndevelopment radically",
      buttonText: "Sign In",
      secondButtonText: "Sign Up",
      top: ImagePos(top: 50, left: 38, width: 287),
      bottom: ImagePos(top: 161, left: 60, width: 299),
    ),
  ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body:
      PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => currentIndex = index),
        itemBuilder: (context, index) => _buildPage(pages[index]),
      ),
    );
  }

  Widget _buildPage(OnboardModel page) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .58,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.on_gradient1,
                AppColors.on_gradient2,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: page.top.top,
                left: page.top.left,
                right: page.top.right,
                bottom: page.top.bottom,
                child: Image.asset(
                  page.topImage,
                  width: page.top.width,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_outlined,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.3),
                    );
                  },
                ),
              ),
              Positioned(
                top: page.bottom.top,
                left: page.bottom.left,
                right: page.bottom.right,
                bottom: page.bottom.bottom,
                child: Image.asset(
                  page.bottomImage,
                  width: page.bottom.width,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),

    ///page title=====================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF101828),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF344054),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                _indicator(),
                const Spacer(),
                _gradientButton(page.buttonText),
                const SizedBox(height: 14),
                _outlineButton(page.secondButtonText),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: currentIndex == index ? 22 : 18,
          height: 4,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? const Color(0xFF7A5AF8)
                : const Color(0xFFE4E7EC),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _gradientButton(String text) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            AppColors.button_grad_1,
            AppColors.button_grad_2,
            AppColors.button_grad_3,
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _outlineButton(String text) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          if (text == "Skip") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.border,
            width: 1.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF7A5AF8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class OnboardModel {
  final String topImage;
  final String bottomImage;
  final String title;
  final String subtitle;
  final String buttonText;
  final String secondButtonText;
  final ImagePos top;
  final ImagePos bottom;

  OnboardModel({
    required this.topImage,
    required this.bottomImage,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.secondButtonText,
    required this.top,
    required this.bottom,
  });
}

class ImagePos {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double width;

  ImagePos({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.width,
  });
}
