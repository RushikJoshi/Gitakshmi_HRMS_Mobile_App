import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class TrackingLiveMap extends StatelessWidget {
  final bool isTracking;
  final bool isManagerMode;

  const TrackingLiveMap({
    super.key,
    required this.isTracking,
    required this.isManagerMode,
  });

  @override
  Widget build(BuildContext context) {
    if (isManagerMode) {
      // MANAGER LIVE MAP
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                  ),
                ),
              ),
            ),
            // Employee Pin A
            const Positioned(
              top: 40,
              left: 60,
              child: Tooltip(
                message: 'Mayur S. (Active)',
                child: Icon(Icons.person_pin_circle_rounded, color: AppColors.success, size: 36),
              ),
            ),
            // Employee Pin B
            const Positioned(
              bottom: 40,
              right: 120,
              child: Tooltip(
                message: 'Amit S. (Stopped/Idle)',
                child: Icon(Icons.person_pin_circle_rounded, color: AppColors.warning, size: 36),
              ),
            ),
            // Employee Pin C
            const Positioned(
              top: 90,
              right: 50,
              child: Tooltip(
                message: 'Akash P. (Lunch Break)',
                child: Icon(Icons.person_pin_circle_rounded, color: AppColors.info, size: 36),
              ),
            ),
          ],
        ),
      );
    }

    // EMPLOYEE LIVE MAP
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(double.infinity, 160),
            painter: MapRoutePainter(isTracking: isTracking),
          ),
          const Positioned(
            top: 30,
            left: 50,
            child: Icon(Icons.home_work_rounded, color: AppColors.primary, size: 24),
          ),
          Positioned(
            bottom: 25,
            right: 80,
            child: Icon(Icons.pin_drop_rounded, color: isTracking ? AppColors.success : AppColors.error, size: 26),
          )
        ],
      ),
    );
  }
}

class MapRoutePainter extends CustomPainter {
  final bool isTracking;

  MapRoutePainter({required this.isTracking});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isTracking ? AppColors.success.withValues(alpha: 0.8) : Colors.grey.withValues(alpha: 0.4)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.25)
      ..lineTo(size.width * 0.4, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.6, size.height * 0.45)
      ..lineTo(size.width * 0.8, size.height * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
