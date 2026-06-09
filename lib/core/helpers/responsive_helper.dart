import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double maxContentWidth = 1200;

  static double screenWidth(BuildContext context) {
    return ResponsiveBreakpoints.of(context).screenWidth;
  }

  static double screenHeight(BuildContext context) {
    return ResponsiveBreakpoints.of(context).screenHeight;
  }

  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }

  static bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }

  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }

  static T adaptiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final breakpoint = ResponsiveBreakpoints.of(context);
    if (breakpoint.isDesktop && desktop != null) {
      return desktop;
    }
    if (breakpoint.isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    double horizontal = 16,
    double vertical = 16,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      left: (left ?? horizontal).w,
      right: (right ?? horizontal).w,
      top: (top ?? vertical).h,
      bottom: (bottom ?? vertical).h,
    );
  }

  static double responsiveSpacing(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return adaptiveValue<double>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  static int responsiveGridCount(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    final breakpoint = ResponsiveBreakpoints.of(context);
    if (breakpoint.isDesktop) {
      return desktop;
    }
    if (breakpoint.isTablet) {
      return tablet;
    }
    return mobile;
  }
}

class ResponsiveCenteredView extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenteredView({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveHelper.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > maxWidth
            ? maxWidth
            : constraints.maxWidth;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ),
        );
      },
    );
  }
}
