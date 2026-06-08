import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/features/timesheet/presentation/pages/timecard_page.dart';

class DashboardPunchCard extends StatelessWidget {
  final Function(int) onNavigateTab;

  const DashboardPunchCard({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '09:25 AM  12-05-2025',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // QR Scan icon from assets/icons/scan.png
                  Image.asset(
                    'assets/icons/scan.png',
                    width: 22,
                    height: 22,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Pie Chart Row + Buttons ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Full-circle pie chart with labels inside segments
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CustomPaint(
                      painter: PieChartPainter(
                        workingPercent: 50,
                        breakPercent: 50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Buttons
                  Expanded(
                    child: Column(
                      children: [
                        // Punch In button
                        _buildActionButton(
                          title: 'Punch In',
                          iconPath: 'assets/icons/clock-outline.png',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0FBE7C), Color(0xFF0AAD6F)],
                          ),
                          onTap: () => onNavigateTab(1),
                        ),
                        const SizedBox(height: 12),
                        // My Time-card button
                        _buildActionButton(
                          title: 'My Time-card',
                          iconPath: 'assets/icons/move-left.png',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3F81FF), Color(0xFF5C3FFF)],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TimecardScreen()),
                          ),
                          flipIcon: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Legend ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendDot(const Color(0xFF3CC5FD), 'Working time'),
                  const SizedBox(width: 16),
                  _buildLegendDot(const Color(0xFFF4817A), 'Break time'),
                ],
              ),

              const Divider(height: 30),

              // ── Bottom Timeline Row ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimelineMini(
                    iconPath: 'assets/icons/punch_in.png',
                    time: '09:08 AM',
                    label: 'Punch In',
                  ),
                  _buildTimelineMini(
                    iconPath: 'assets/icons/punch_out.png',
                    time: '06:05 PM',
                    label: 'Punch Out',
                  ),
                  _buildTimelineMini(
                    iconPath: 'assets/icons/total_hour.png',
                    time: '08:13',
                    label: 'Total Hours',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gradient button with image icon asset
  Widget _buildActionButton({
    required String title,
    required String iconPath,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool flipIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.baseWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Transform.scale(
              scaleX: flipIcon ? -1 : 1,
              child: Image.asset(
                iconPath,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                color: AppColors.baseWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineMini({
    required String iconPath,
    required String time,
    required String label,
  }) {
    return Column(
      children: [
        Image.asset(
          iconPath,
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Custom Painter: Full Pie Chart with Text Labels Inside ──────────────────
class PieChartPainter extends CustomPainter {
  final double workingPercent;
  final double breakPercent;

  PieChartPainter({
    required this.workingPercent,
    required this.breakPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final double total = workingPercent + breakPercent;
    if (total == 0) {
      final paint = Paint()
        ..color = AppColors.gray200
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    const teal = Color(0xFF3CC5FD);
    const salmon = Color(0xFFF4817A);

    final double startAngle = -pi / 2; // Top
    final double workingSweep = (workingPercent / total) * 2 * pi;
    final double breakSweep = (breakPercent / total) * 2 * pi;

    // Draw Working segment (right side — teal)
    final paintWorking = Paint()
      ..color = teal
      ..style = PaintingStyle.fill;
    canvas.drawArc(rect, startAngle, workingSweep, true, paintWorking);

    // Draw Break segment (left side — salmon)
    final paintBreak = Paint()
      ..color = salmon
      ..style = PaintingStyle.fill;
    canvas.drawArc(rect, startAngle + workingSweep, breakSweep, true, paintBreak);

    // ── Draw labels inside each segment ───────────────
    _drawSegmentLabel(
      canvas: canvas,
      center: center,
      radius: radius,
      startAngle: startAngle,
      sweepAngle: workingSweep,
      title: 'Working',
      value: '00:00 h',
      color: Colors.white,
    );

    _drawSegmentLabel(
      canvas: canvas,
      center: center,
      radius: radius,
      startAngle: startAngle + workingSweep,
      sweepAngle: breakSweep,
      title: 'Break',
      value: '00:00 h',
      color: Colors.white,
    );
  }

  void _drawSegmentLabel({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required String title,
    required String value,
    required Color color,
  }) {
    final double midAngle = startAngle + sweepAngle / 2;
    final double labelRadius = radius * 0.60;
    final Offset labelCenter = Offset(
      center.dx + labelRadius * cos(midAngle),
      center.dy + labelRadius * sin(midAngle),
    );

    // Draw title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Draw value
    final valuePainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double totalH = titlePainter.height + 3 + valuePainter.height;
    final double startY = labelCenter.dy - totalH / 2;

    titlePainter.paint(
      canvas,
      Offset(labelCenter.dx - titlePainter.width / 2, startY),
    );
    valuePainter.paint(
      canvas,
      Offset(labelCenter.dx - valuePainter.width / 2, startY + titlePainter.height + 3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
