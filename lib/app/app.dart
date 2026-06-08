import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/theme/app_theme.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/features/splash/presentation/pages/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
          ),
        );

        return MaterialApp(
          title: config.appName,
          theme: dynamicTheme,
          home: const SplashPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
