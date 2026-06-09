import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class DashboardHeaderCard extends StatelessWidget {
  final String userName;
  final String designation;
  final VoidCallback? onMenuPressed;

  const DashboardHeaderCard({
    super.key,
    required this.userName,
    required this.designation,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Curved blue header background with rich gradient
        Container(
          height: 250.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.blue500,
                AppColors.blue600,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
        ),
        // Safe area content overlay
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [

                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            color: AppColors.baseWhite,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Image.asset(
                            'assets/images/g.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        // Username and Designation
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.baseWhite,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              designation,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.baseWhite.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Flying clock illustration
                    SizedBox(
                      width: 90.w,
                      height: 90.w,
                      child: Image.asset(
                        'assets/images/clock.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
