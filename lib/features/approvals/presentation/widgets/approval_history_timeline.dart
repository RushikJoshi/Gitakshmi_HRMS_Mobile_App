import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class ApprovalWorkflowTimeline extends StatelessWidget {
  final UnifiedApprovalRequest request;
  final bool canSeeAll;
  final String activeEmployeeId;

  const ApprovalWorkflowTimeline({
    super.key,
    required this.request,
    required this.canSeeAll,
    required this.activeEmployeeId,
  });

  Color _statusColor(String s) {
    switch (s) {
      case 'Approved': return Colors.green;
      case 'Rejected': return Colors.red;
      case 'Pending': return Colors.orange;
      case 'Waiting': return Colors.grey;
      case 'Sent Back': return Colors.deepOrange;
      case 'Info Requested': return Colors.blue;
      case 'Escalated': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxVisibleLevel = -1;
    if (canSeeAll) {
      maxVisibleLevel = request.totalLevels;
    } else {
      final myLevelIdx = request.workflowLevels.indexWhere((l) => l.approverEmpId == activeEmployeeId);
      if (myLevelIdx != -1) {
        maxVisibleLevel = myLevelIdx;
      } else {
        maxVisibleLevel = request.workflowLevels.indexWhere((l) => l.decision == 'Pending') - 1;
        if (maxVisibleLevel < 0) maxVisibleLevel = request.totalLevels;
      }
    }

    return Column(
      children: request.workflowLevels.asMap().entries.map((entry) {
        final i = entry.key;
        final level = entry.value;
        final isVisible = i <= maxVisibleLevel;
        final isLast = i == request.workflowLevels.length - 1;
        final levelColor = _statusColor(level.decision);

        if (!isVisible) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                    child: const Icon(Icons.lock_rounded, size: 16, color: Colors.grey),
                  ),
                  if (!isLast) Container(width: 2, height: 56, color: Colors.grey.shade200),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Level ${level.level} — ${level.roleTitle}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_rounded, size: 14, color: Colors.grey),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Confidential — Awaiting previous approval levels',
                                style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: levelColor, width: 2),
                  ),
                  child: Center(child: Text('${level.level}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: levelColor))),
                ),
                if (!isLast) Container(width: 2, height: level.comment.isEmpty ? 56 : 80, color: levelColor.withValues(alpha: 0.2)),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: levelColor.withValues(alpha: 0.25)),
                  ),
                  color: levelColor.withValues(alpha: 0.04),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Level ${level.level} — ${level.roleTitle}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
                                Text(level.approverName, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: levelColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                              child: Text(level.decision, style: TextStyle(color: levelColor, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        if (level.comment.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.format_quote_rounded, size: 14, color: AppColors.textLight),
                                const SizedBox(width: 6),
                                Flexible(child: Text(level.comment, style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary))),
                              ],
                            ),
                          ),
                        ],
                        if (level.decidedAt.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 11, color: AppColors.textLight),
                              const SizedBox(width: 4),
                              Text(level.decidedAt, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class ApprovalActivityHistory extends StatelessWidget {
  final UnifiedApprovalRequest request;

  const ApprovalActivityHistory({super.key, required this.request});

  IconData _historyIcon(String eventType) {
    switch (eventType) {
      case 'Created': return Icons.add_circle_rounded;
      case 'Attachment Added': return Icons.attach_file_rounded;
      case 'Approved': return Icons.check_circle_rounded;
      case 'Rejected': return Icons.cancel_rounded;
      case 'Sent Back': return Icons.undo_rounded;
      case 'Info Requested': return Icons.help_rounded;
      case 'Escalated': return Icons.trending_up_rounded;
      case 'Resubmitted': return Icons.refresh_rounded;
      default: return Icons.circle_outlined;
    }
  }

  Color _historyColor(String eventType) {
    switch (eventType) {
      case 'Approved': return Colors.green;
      case 'Rejected': return Colors.red;
      case 'Sent Back': return Colors.deepOrange;
      case 'Info Requested': return Colors.blue;
      case 'Escalated': return Colors.purple;
      case 'Attachment Added': return Colors.teal;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: request.history.asMap().entries.map((entry) {
        final i = entry.key;
        final event = entry.value;
        final color = _historyColor(event.eventType);
        final isLast = i == request.history.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(_historyIcon(event.eventType), color: color, size: 16),
                ),
                if (!isLast) Container(width: 2, height: 52, color: Colors.grey.shade200),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(event.eventType, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
                        Text(event.timestamp, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                      ],
                    ),
                    Text('by ${event.actor}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    if (event.note.isNotEmpty)
                      Text(event.note, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
