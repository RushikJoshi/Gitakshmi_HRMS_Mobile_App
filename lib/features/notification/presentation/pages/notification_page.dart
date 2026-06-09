import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
import 'package:gitakshmi_hrms_app/features/notification/presentation/widgets/notification_list_tile.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        "title": "New Recruitment Request Pending",
        "body": "Akash Patel has raised recruitment approval request.",
        "time": "10 mins ago",
        "unread": true,
        "icon": Icons.assignment_late_rounded,
        "color": AppColors.warning,
      },
      {
        "title": "Salary Credited",
        "body": "Your payslip for May 2026 has been generated.",
        "time": "2 hours ago",
        "unread": true,
        "icon": Icons.payments_rounded,
        "color": AppColors.success,
      },
      {
        "title": "Out of Range Alert",
        "body": "Geofencing triggers detected employee outside Mumbai HQ.",
        "time": "1 day ago",
        "unread": false,
        "icon": Icons.location_off_rounded,
        "color": AppColors.error,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(
          "Alerts",
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCenteredView(
          maxWidth: 600,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              return NotificationListTile(alert: alerts[index]);
            },
          ),
        ),
      ),
    );
  }
}
