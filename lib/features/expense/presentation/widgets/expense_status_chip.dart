import 'package:flutter/material.dart';

class ExpenseStatusChip extends StatelessWidget {
  final String label;
  final String status;

  const ExpenseStatusChip({super.key, required this.label, required this.status});

  static Color statusColor(String s) {
    switch (s) {
      case 'Approved': return Colors.green;
      case 'Pending': return Colors.orange;
      case 'Partially Approved': return Colors.blue;
      case 'Rejected': return Colors.red;
      case 'Reimbursed': return Colors.purple;
      case 'Settled': return Colors.teal;
      case 'Processing': return Colors.indigo;
      case 'Paid': return Colors.green;
      default: return Colors.grey;
    }
  }

  static IconData statusIcon(String s) {
    switch (s) {
      case 'Approved': return Icons.check_circle_rounded;
      case 'Pending': return Icons.hourglass_top_rounded;
      case 'Partially Approved': return Icons.check_circle_outline_rounded;
      case 'Rejected': return Icons.cancel_rounded;
      case 'Reimbursed': return Icons.paid_rounded;
      case 'Settled': return Icons.done_all_rounded;
      case 'Paid': return Icons.verified_rounded;
      default: return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon(status), size: 10, color: c),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
