import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class TrackingGeofenceSetup extends StatelessWidget {
  final bool fakeGpsWarning;
  final bool offlineMode;
  final ValueChanged<bool?> onFakeGpsChanged;
  final ValueChanged<bool?> onOfflineModeChanged;

  const TrackingGeofenceSetup({
    super.key,
    required this.fakeGpsWarning,
    required this.offlineMode,
    required this.onFakeGpsChanged,
    required this.onOfflineModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.04),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text('Fake GPS Warning', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Checkbox(
                  value: fakeGpsWarning,
                  onChanged: onFakeGpsChanged,
                )
              ],
            ),
            Container(width: 1, height: 20, color: Colors.grey.shade300),
            Row(
              children: [
                const Text('Offline Store Mode', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Checkbox(
                  value: offlineMode,
                  onChanged: onOfflineModeChanged,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
