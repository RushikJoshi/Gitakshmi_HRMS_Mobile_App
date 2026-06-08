import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class SupervisorAttendanceList extends StatelessWidget {
  final List<Map<String, dynamic>> teamAttendance;

  const SupervisorAttendanceList({super.key, required this.teamAttendance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Team Attendance Roster',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),

        // Filter Chips
        Row(
          children: [
            ChoiceChip(
              label: const Text('All Shifts'),
              selected: true,
              selectedColor: AppColors.primary,
              labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
            ),
            const SizedBox(width: 8),
            ChoiceChip(label: const Text('Night Shift'), selected: false, labelStyle: const TextStyle(fontSize: 11)),
            const SizedBox(width: 8),
            ChoiceChip(label: const Text('Rotational'), selected: false, labelStyle: const TextStyle(fontSize: 11)),
          ],
        ),
        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teamAttendance.length,
          itemBuilder: (context, index) {
            final team = teamAttendance[index];
            final statusColor = team["color"] as Color;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  child: Text(
                    team["name"]!.split(' ').map((n) => n[0]).join(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 13),
                  ),
                ),
                title: Text(team["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${team["role"]} • ${team["time"]}', style: const TextStyle(fontSize: 11)),
                trailing: Chip(
                  label: Text(
                    team["status"]!,
                    style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: statusColor.withValues(alpha: 0.08),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
