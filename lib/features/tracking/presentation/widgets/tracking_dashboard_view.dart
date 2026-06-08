import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class TrackingDashboardView extends StatelessWidget {
  final bool isManagerMode;
  final bool isTracking;
  final bool fakeGpsWarning;
  final bool offlineMode;
  final int totalVisitsCount;
  final int completedCount;
  final ValueChanged<bool> onTrackingChanged;
  final List<Map<String, dynamic>> managerTeam;

  const TrackingDashboardView({
    super.key,
    required this.isManagerMode,
    required this.isTracking,
    required this.fakeGpsWarning,
    required this.offlineMode,
    required this.totalVisitsCount,
    required this.completedCount,
    required this.onTrackingChanged,
    required this.managerTeam,
  });

  Widget _buildStatBox(String label, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Warning Alerts Banners
        if (fakeGpsWarning)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.gpp_bad_rounded, color: AppColors.error),
                SizedBox(width: 12),
                Expanded(
                  child: Text('SECURITY ALERT: Mock GPS app coordinates detected! Live tracking restriction applied.',
                      style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),

        if (offlineMode)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.wifi_off_rounded, color: AppColors.warning),
                SizedBox(width: 12),
                Expanded(
                  child: Text('OFFLINE STATUS: Internet disconnected. Visit records and GPS locations are stored locally and will sync later.',
                      style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),

        if (!isManagerMode) ...[
          // Stats Summary
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildStatBox('Today\'s Visits', '$totalVisitsCount', AppColors.primary),
              _buildStatBox('Completed', '$completedCount', AppColors.success),
              _buildStatBox('Distance covered', '14.2 KM', AppColors.info),
              // Premium Productivity score card
              Card(
                color: AppColors.success.withValues(alpha: 0.08),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.success, width: 1)),
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PRODUCTIVITY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success)),
                      SizedBox(height: 2),
                      Text('89%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.success)),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Tracking toggle Card
          Card(
            color: isTracking ? AppColors.success.withValues(alpha: 0.05) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Icon(isTracking ? Icons.my_location_rounded : Icons.location_disabled_rounded, color: isTracking ? AppColors.success : AppColors.textLight, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isTracking ? 'Live Route Streaming Active' : 'Sales Visits Tracker Stopped', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(isTracking ? 'Interval: 15s • Streaming coordinates' : 'Punch In / Start travel to launch live GPS logs', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Switch(
                    value: isTracking,
                    onChanged: onTrackingChanged,
                    activeColor: AppColors.success,
                  )
                ],
              ),
            ),
          ),
        ] else ...[
          // MANAGER VIEWPORT
          const Text('Team Status Tracker Logs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: managerTeam.length,
            itemBuilder: (context, index) {
              final team = managerTeam[index];
              final statusColor = team["color"] as Color;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    child: Text(
                      team["name"]!.split(' ').map((n) => n[0]).join(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                  title: Text(team["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Status: ${team["status"]} • Speed: ${team["speed"]}\nVisits: ${team["visits"]} • Idle Alerts: ${team["idle"]}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: statusColor),
                ),
              );
            },
          )
        ],
      ],
    );
  }
}
