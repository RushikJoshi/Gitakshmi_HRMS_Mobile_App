import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/features/reports/presentation/widgets/late_check_in_card.dart';
import 'package:gitakshmi_hrms_app/features/reports/presentation/widgets/overtime_analytics_card.dart';
import 'package:gitakshmi_hrms_app/features/reports/presentation/widgets/travel_visit_analytics_card.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            // Late Check-in Analysis Card
            LateCheckInCard(),
            SizedBox(height: 16),

            // Overtime Analysis progress lists
            OvertimeAnalyticsCard(),
            SizedBox(height: 24),

            // Travel visits summary list
            TravelVisitAnalyticsCard(),
          ],
        ),
      ),
    );
  }
}

