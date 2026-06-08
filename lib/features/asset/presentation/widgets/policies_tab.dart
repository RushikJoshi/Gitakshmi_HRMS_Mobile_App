import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class PoliciesTab extends StatelessWidget {
  final Color primaryColor;

  const PoliciesTab({
    super.key,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Asset Management Policy Guides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _buildPolicyCard(context, 'IT Hardware Usage Agreement.pdf', 'Covers developer laptops, monitors, physical locks care policies.'),
          _buildPolicyCard(context, 'Vehicle Mileage & Fuel Claims.pdf', 'Mileage claims policy for delivery and field client visit representatives.'),
          _buildPolicyCard(context, 'Mobile POS Hardware Policy.pdf', 'Merchant POS scanners security agreements.'),
          const SizedBox(height: 24),
          const Text('Maintenance Reminder Schedules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          _buildReminderTile('Vehicle Diagnostic Service', 'Honda Activa (VEH-00812) due in 12 days.', Colors.orange),
          _buildReminderTile('Office Printer Health Check', 'Marketing Printer calibration check scheduled for 15-Jun.', Colors.blue),
          _buildReminderTile('Laptop Battery Diagnostics check', 'HP EliteBook recall inspection checklist.', Colors.red),
        ],
      ),
    );
  }

  Widget _buildPolicyCard(BuildContext context, String name, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.gavel_rounded, color: primaryColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.download_rounded, color: primaryColor, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Downloading policy guide: $name')),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTile(String title, String details, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.event_note_rounded, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(details, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
