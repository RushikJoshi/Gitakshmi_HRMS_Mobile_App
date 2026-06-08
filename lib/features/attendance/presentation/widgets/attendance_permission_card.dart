import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class AttendancePermissionCard extends StatelessWidget {
  final bool isLocationStep; // true for Location, false for Camera
  final bool isPermanentlyDenied;
  final VoidCallback onCancel;
  final VoidCallback onOpenSettings;
  final VoidCallback onAllowAccess;

  const AttendancePermissionCard({
    super.key,
    required this.isLocationStep,
    required this.isPermanentlyDenied,
    required this.onCancel,
    required this.onOpenSettings,
    required this.onAllowAccess,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon =
        isLocationStep
            ? (isPermanentlyDenied ? Icons.location_off_rounded : Icons.my_location_rounded)
            : (isPermanentlyDenied ? Icons.camera_indoor_outlined : Icons.camera_alt_rounded);

    final String title =
        isLocationStep
            ? (isPermanentlyDenied
                ? 'Location Permission Disabled'
                : 'Allow "Gitakshmi HRMS" to access device location?')
            : (isPermanentlyDenied
                ? 'Camera Permission Disabled'
                : 'Allow "Gitakshmi HRMS" to access your camera?');

    final String description =
        isLocationStep
            ? (isPermanentlyDenied
                ? 'Location permission is permanently denied in system settings. To verify you are inside the office radius, please enable Location permission in app settings.'
                : 'Location permission is mandatory to verify you are inside the office radius before check-in.')
            : (isPermanentlyDenied
                ? 'Camera permission is permanently denied in system settings. To verify your identity and check liveness, please enable Camera permission in app settings.'
                : 'Camera permission is required to verify your face and perform spoof check checks.');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, color: isPermanentlyDenied ? AppColors.error : AppColors.primary, size: 48),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: onCancel, child: const Text('Cancel')),
                if (isPermanentlyDenied)
                  ElevatedButton.icon(
                    onPressed: onOpenSettings,
                    icon: const Icon(Icons.settings_rounded, size: 16),
                    label: const Text('Open App Settings'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  )
                else
                  ElevatedButton(onPressed: onAllowAccess, child: const Text('Allow Access')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
