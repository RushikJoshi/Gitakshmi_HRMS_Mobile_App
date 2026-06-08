import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class TrackingLocationLogs extends StatelessWidget {
  final List<Map<String, dynamic>> visits;
  final List<Map<String, String>> stoppages;
  final List<Map<String, String>> timeline;
  final Function(Map<String, dynamic>) onVisitTap;

  const TrackingLocationLogs({
    super.key,
    required this.visits,
    required this.stoppages,
    required this.timeline,
    required this.onVisitTap,
  });

  Widget _buildVisitsListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        final isCompleted = visit["status"] == 'Completed';
        final isInProgress = visit["status"] == 'In Progress';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            onTap: () => onVisitTap(visit),
            leading: Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : (isInProgress ? Icons.directions_run_rounded : Icons.pending_actions_rounded),
              color: isCompleted ? AppColors.success : (isInProgress ? AppColors.info : AppColors.warning),
            ),
            title: Text(visit["client"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Est: ${visit["estDistance"]} (${visit["estTime"]}) • ${visit["time"]}', style: const TextStyle(fontSize: 11)),
            trailing: Chip(
              label: Text(visit["status"]!, style: TextStyle(color: isCompleted ? AppColors.success : (isInProgress ? AppColors.info : AppColors.warning), fontSize: 9, fontWeight: FontWeight.bold)),
              backgroundColor: (isCompleted ? AppColors.success : (isInProgress ? AppColors.info : AppColors.warning)).withValues(alpha: 0.08),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoppagesListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: stoppages.length,
      itemBuilder: (context, index) {
        final stop = stoppages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: const Icon(Icons.pause_circle_filled_rounded, color: AppColors.error),
            title: Text('${stop["location"]} (${stop["duration"]})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Reason: ${stop["reason"]} • ${stop["time"]}', style: const TextStyle(fontSize: 11)),
          ),
        );
      },
    );
  }

  Widget _buildTimelineListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: timeline.length,
      itemBuilder: (context, index) {
        final log = timeline[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log["time"]!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(log["event"]!, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Client Visits'),
              Tab(text: 'Stoppages'),
              Tab(text: 'Timeline'),
            ],
          ),
          SizedBox(
            height: 260,
            child: TabBarView(
              children: [
                _buildVisitsListView(),
                _buildStoppagesListView(),
                _buildTimelineListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
