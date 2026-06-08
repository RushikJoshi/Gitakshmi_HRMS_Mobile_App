import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class NotificationListTile extends StatelessWidget {
  final Map<String, dynamic> alert;

  const NotificationListTile({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final bool unread = alert["unread"] ?? false;
    final Color alertColor = alert["color"] as Color;
    final IconData iconData = alert["icon"] as IconData;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: unread ? AppColors.primary.withOpacity(0.02) : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: alertColor.withOpacity(0.1),
          child: Icon(iconData, color: alertColor),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                alert["title"] ?? '',
                style: TextStyle(
                  fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            if (unread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(alert["body"] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(alert["time"] ?? '', style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}
