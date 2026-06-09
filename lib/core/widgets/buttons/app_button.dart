import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

enum AppButtonType { primary, secondary, outlined, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
  }) : type = AppButtonType.secondary;

  const AppButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
  }) : type = AppButtonType.outlined;

  const AppButton.text({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.textColor,
    this.width,
    this.height = 40,
    this.borderRadius = 8,
  })  : type = AppButtonType.text,
        backgroundColor = null;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    final Color effectiveBgColor = backgroundColor ??
        (type == AppButtonType.primary
            ? AppColors.primary
            : type == AppButtonType.secondary
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent);

    final Color effectiveTextColor = textColor ??
        (type == AppButtonType.primary
            ? Colors.white
            : type == AppButtonType.outlined || type == AppButtonType.text
                ? AppColors.primary
                : AppColors.primary);

    Widget content = isLoading
        ? SizedBox(
            height: 20.w,
            width: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: effectiveTextColor),
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: effectiveTextColor,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: type == AppButtonType.outlined
          ? OutlinedButton(
              onPressed: isDisabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDisabled
                      ? AppColors.textLight.withValues(alpha: 0.5)
                      : effectiveTextColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
              ),
              child: content,
            )
          : type == AppButtonType.text
              ? TextButton(
                  onPressed: isDisabled ? null : onPressed,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius.r),
                    ),
                  ),
                  child: content,
                )
              : ElevatedButton(
                  onPressed: isDisabled ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDisabled
                        ? AppColors.textLight.withValues(alpha: 0.3)
                        : effectiveBgColor,
                    elevation: type == AppButtonType.primary && !isDisabled ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius.r),
                    ),
                  ),
                  child: content,
                ),
    );
  }
}
