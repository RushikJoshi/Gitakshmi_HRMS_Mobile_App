import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class AwsOfflineSyncCard extends StatelessWidget {
  final int syncQueueCount;
  final VoidCallback onForceSync;
  final VoidCallback onShowSQLiteLogs;

  const AwsOfflineSyncCard({
    super.key,
    required this.syncQueueCount,
    required this.onForceSync,
    required this.onShowSQLiteLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'AWS Offline Sync Engine',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    syncQueueCount > 0 ? '$syncQueueCount Pending' : 'Synced',
                    style: TextStyle(
                      color: syncQueueCount > 0 ? AppColors.warning : AppColors.success,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor:
                      (syncQueueCount > 0 ? AppColors.warning : AppColors.success).withValues(
                        alpha: 0.1,
                      ),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              syncQueueCount > 0
                  ? 'You have offline attendance logs stored locally in encrypted SQLite DB. They will auto-sync to DynamoDB when online.'
                  : 'All biometric templates and check-in history are fully synchronized with AWS cloud datalake.',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onForceSync,
                    icon: const Icon(Icons.sync_rounded, size: 14),
                    label: const Text('Force AWS Sync Now', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShowSQLiteLogs,
                    icon: const Icon(Icons.storage_rounded, size: 14),
                    label: const Text('SQLite Audit Logs', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
