import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/theme/app_theme.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:gitakshmi_hrms_app/core/navigation/navigation_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<CompanyConfig>(
          valueListenable: SaaSBrandingHelper.instance.configNotifier,
          builder: (context, config, child) {
            final baseTheme = AppTheme.light;
            final dynamicTheme = baseTheme.copyWith(
              primaryColor: config.primaryColor,
              colorScheme: baseTheme.colorScheme.copyWith(
                primary: config.primaryColor,
                secondary: config.secondaryColor,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 24.w,
                  ),
                ),
              ),
            );

            return MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              title: config.appName,
              theme: dynamicTheme,
              home: const SplashPage(),
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return ResponsiveBreakpoints.builder(
                  breakpoints: const [
                    Breakpoint(start: 0, end: 600, name: MOBILE),
                    Breakpoint(start: 601, end: 1024, name: TABLET),
                    Breakpoint(
                      start: 1025,
                      end: double.infinity,
                      name: DESKTOP,
                    ),
                  ],
                  useShortestSide: true,
                  child: child ?? const SizedBox.shrink(),
                );
              },
            );
          },
        );
      },
    );
  }
}
