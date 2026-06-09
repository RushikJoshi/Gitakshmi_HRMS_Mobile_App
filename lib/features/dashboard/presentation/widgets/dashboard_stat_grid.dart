import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';

class DashboardStatGrid extends StatelessWidget {
  const DashboardStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.baseWhite,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.baseBlack.withOpacity(0.04),
              blurRadius: 16.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        padding: EdgeInsets.all(15.w),
        child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveHelper.responsiveGridCount(
            context,
            mobile: 2,
            tablet: 2,
            desktop: 4,
          ),
          childAspectRatio: ResponsiveHelper.adaptiveValue<double>(
            context,
            mobile: 1.8,
            tablet: 1.8,
            desktop: 2.2,
          ),
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          children: [
            _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Total Runtime',
              value: '00:00 Hrs',
            ),
            _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Live Status',
              value: 'Off-duty',
            ),
            _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Leave Credit',
              value: '0 days',
            ),
            _buildStatCard(
              icon: Icons.close_rounded,
              title: 'Internal Roles',
              value: '0 application',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Off-white/gray50 background inside the main card
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.gray200, width: 1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.gray200, // Slightly darker grey for contrast
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: AppColors.gray500,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
