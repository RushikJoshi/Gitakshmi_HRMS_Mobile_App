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
    final double screenHeight = MediaQuery.of(context).size.height;

    // Dynamically calculate the top container height to adapt to different screen aspect ratios.
    double topHeight = screenHeight * 0.58;
    if (screenHeight < 650) {
      topHeight = screenHeight * 0.44;
    } else if (screenHeight < 750) {
      topHeight = screenHeight * 0.52;
    }

    final double paddingHorizontal = screenHeight < 700 ? 20 : 28;
    final double titleSize = screenHeight < 700 ? 18 : 20;
    final double subtitleSize = screenHeight < 700 ? 11 : 12;

    final double spacing1 = screenHeight < 700 ? 8 : 12;
    final double spacing2 = screenHeight < 700 ? 8 : 12;
    final double spacing3 = screenHeight < 700 ? 10 : 18;
    final double spacing4 = screenHeight < 700 ? 10 : 14;
    final double spacing5 = screenHeight < 700 ? 16 : 32;

    return Column(
      children: [
        Container(
          height: topHeight,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double containerWidth = constraints.maxWidth;
              final double containerHeight = constraints.maxHeight;

              // Reference design dimensions
              const double refWidth = 375.0;
              const double refHeight = 471.0;

              final double widthScale = containerWidth / refWidth;
              final double heightScale = containerHeight / refHeight;

              // Use the minimum scale factor to preserve image aspect ratios
              final double scale = widthScale < heightScale ? widthScale : heightScale;

              Positioned buildPositionedImage({
                required String imagePath,
                required ImagePos pos,
                required bool isTop,
              }) {
                final double? scaledTop = pos.top != null ? pos.top! * heightScale : null;
                final double? scaledLeft = pos.left != null ? pos.left! * widthScale : null;
                final double? scaledRight = pos.right != null ? pos.right! * widthScale : null;
                final double? scaledBottom = pos.bottom != null ? pos.bottom! * heightScale : null;
                final double scaledWidth = pos.width * scale;

                return Positioned(
                  top: scaledTop,
                  left: scaledLeft,
                  right: scaledRight,
                  bottom: scaledBottom,
                  child: Image.asset(
                    imagePath,
                    width: scaledWidth,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      if (isTop) {
                        return Icon(
                          Icons.image_outlined,
                          size: 80 * scale,
                          color: AppColors.primary.withOpacity(0.3),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              }

              return Stack(
                children: [
                  buildPositionedImage(imagePath: page.topImage, pos: page.top, isTop: true),
                  buildPositionedImage(imagePath: page.bottomImage, pos: page.bottom, isTop: false),
                ],
              );
            },
          ),
        ),

        ///page title and controls=====================
        Expanded(
          child: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: spacing1),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF101828),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: spacing2),
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: const Color(0xFF344054),
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: spacing3),
                          _indicator(),
                        ],
                      ),
                    ),
                  ),
                  _gradientButton(page.buttonText),
                  SizedBox(height: spacing4),
                  _outlineButton(page.secondButtonText),
                  SizedBox(height: spacing5),
                ],
              ),
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
