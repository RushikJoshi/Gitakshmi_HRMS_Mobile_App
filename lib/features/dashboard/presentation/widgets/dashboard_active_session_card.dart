import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class DashboardActiveSessionCard extends StatelessWidget {
  const DashboardActiveSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        color: AppColors.surface,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Active Session',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  // Circular Progress Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120.w,
                        height: 120.w,
                        child: CustomPaint(
                          painter: ActiveSessionProgressPainter(progress: 0.65),
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '0:48:00',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                  // Text descriptions & Badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'working\n9 Hours',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textLight,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        const Text(
                          'Minimum working\n8 Hours',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textLight,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          child: const Text(
                            'On Break',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Active Session Progress Ring
class ActiveSessionProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  ActiveSessionProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintTrack = Paint()
      ..color = AppColors.purple100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.w
      ..strokeCap = StrokeCap.round;

    final paintProgress = Paint()
      ..color = AppColors.purple600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.w
      ..strokeCap = StrokeCap.round;

    // 3/4 Circular ring with opening at the bottom
    double startAngle = 3.141592653589793 * 0.75;
    double sweepAngle = 3.141592653589793 * 1.5;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paintTrack);
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * progress,
      false,
      paintProgress,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
