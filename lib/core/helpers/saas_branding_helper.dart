import 'package:flutter/material.dart';

class CompanyConfig {
  final String companyName;
  final String appName;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData logoIcon;
  final List<String> permissions;

  CompanyConfig({
    required this.companyName,
    required this.appName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.logoIcon,
    required this.permissions,
  });

  CompanyConfig copyWith({
    String? companyName,
    String? appName,
    Color? primaryColor,
    Color? secondaryColor,
    IconData? logoIcon,
    List<String>? permissions,
  }) {
    return CompanyConfig(
      companyName: companyName ?? this.companyName,
      appName: appName ?? this.appName,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      logoIcon: logoIcon ?? this.logoIcon,
      permissions: permissions ?? this.permissions,
    );
  }
}

class SaaSBrandingHelper {
  SaaSBrandingHelper._internal();
  static final SaaSBrandingHelper instance = SaaSBrandingHelper._internal();

  final ValueNotifier<CompanyConfig> configNotifier = ValueNotifier<CompanyConfig>(
    CompanyConfig(
      companyName: 'ABC Pvt Ltd',
      appName: 'ABC HRMS',
      primaryColor: const Color(0xFF6366F1), // Indigo
      secondaryColor: const Color(0xFF4F46E5),
      logoIcon: Icons.rocket_launch_rounded,
      permissions: [
        'view_attendance',
        'mark_attendance',
        'approve_leave',
        'view_team',
        'live_tracking',
        'payroll_view',
      ],
    ),
  );

  CompanyConfig get currentConfig => configNotifier.value;

  void changeCompany(String companyName) {
    if (companyName == 'ABC Pvt Ltd') {
      configNotifier.value = configNotifier.value.copyWith(
        companyName: 'ABC Pvt Ltd',
        appName: 'ABC HRMS',
        primaryColor: const Color(0xFF6366F1),
        secondaryColor: const Color(0xFF4F46E5),
        logoIcon: Icons.rocket_launch_rounded,
      );
    } else if (companyName == 'XYZ Tech') {
      configNotifier.value = configNotifier.value.copyWith(
        companyName: 'XYZ Tech',
        appName: 'XYZ Workforce',
        primaryColor: const Color(0xFFEF4444), // Crimson Red
        secondaryColor: const Color(0xFFDC2626),
        logoIcon: Icons.fingerprint_rounded,
      );
    } else if (companyName == 'SalesPro') {
      configNotifier.value = configNotifier.value.copyWith(
        companyName: 'SalesPro',
        appName: 'SalesPro Portal',
        primaryColor: const Color(0xFF10B981), // Emerald Green
        secondaryColor: const Color(0xFF059669),
        logoIcon: Icons.add_business_rounded,
      );
    }
  }

  void togglePermission(String permission, bool enable) {
    final updatedList = List<String>.from(currentConfig.permissions);
    if (enable) {
      if (!updatedList.contains(permission)) {
        updatedList.add(permission);
      }
    } else {
      updatedList.remove(permission);
    }
    configNotifier.value = configNotifier.value.copyWith(permissions: updatedList);
  }

  bool hasPermission(String permission) {
    return currentConfig.permissions.contains(permission);
  }
}
