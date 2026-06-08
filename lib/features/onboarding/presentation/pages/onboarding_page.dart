import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/features/auth/presentation/pages/login_page.dart';
import 'package:gitakshmi_hrms_app/features/onboarding/presentation/widgets/onboarding_slide_view.dart';
import 'package:gitakshmi_hrms_app/features/onboarding/presentation/widgets/onboarding_navigation_controls.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Enterprise SaaS HRMS",
      "description": "Multi-company isolated data hosting with premium white-label customization.",
      "icon": "corporate_fare",
    },
    {
      "title": "Smart Attendance & GPS",
      "description": "Geo-fenced radius verification coupled with ML-based anti-spoof face matching.",
      "icon": "fingerprint",
    },
    {
      "title": "Workflow Approval Engine",
      "description": "Dynamic, multi-level permission-based requests approval automation.",
      "icon": "assignment_turned_in",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToLogin,
                child: const Text('Skip', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return OnboardingSlideView(slide: _slides[index]);
                },
              ),
            ),
            OnboardingNavigationControls(
              slidesCount: _slides.length,
              currentIndex: _currentIndex,
              onNextPressed: () {
                if (_currentIndex < _slides.length - 1) {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                } else {
                  _navigateToLogin();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
