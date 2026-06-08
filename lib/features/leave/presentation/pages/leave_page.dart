import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/features/leave/data/models/leave_model.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/pages/apply_leave_page.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/widgets/leave_summary_header.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/widgets/leave_tabs_control.dart';
import 'package:gitakshmi_hrms_app/features/leave/presentation/widgets/leave_submitted_card.dart';

class LeaveSummaryScreen extends StatefulWidget {
  const LeaveSummaryScreen({super.key});

  @override
  State<LeaveSummaryScreen> createState() => _LeaveSummaryScreenState();
}

class _LeaveSummaryScreenState extends State<LeaveSummaryScreen> {
  int selectedTab = 0;
  final List<LeaveEntry> _reviewLeaves = [];

  static const Color bgColor = Color(0xFFEFEFFF);
  static const Color fabPurple = Color(0xff6938EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: fabPurple,
        onPressed: () async {
          final result = await Navigator.push<LeaveEntry>(
            context,
            MaterialPageRoute(builder: (_) => const ApplyLeaveScreen()),
          );
          if (result != null) {
            setState(() {
              _reviewLeaves.add(result);
              selectedTab = 0; // switch to Review tab
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final bool isTablet = screenWidth > 600;

            final double horizontalPadding = isTablet ? 32 : 12;
            final double maxContentWidth = isTablet ? 520 : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    LeaveSummaryHeader(horizontalPadding: horizontalPadding),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          LeaveTabsControl(
                            selectedTab: selectedTab,
                            onTabSelected: (index) {
                              setState(() {
                                selectedTab = index;
                              });
                            },
                            badgeCount: _reviewLeaves.length,
                          ),
                          const SizedBox(height: 14),
                          LeaveSubmittedCard(
                            selectedTab: selectedTab,
                            reviewLeaves: _reviewLeaves,
                          ),
                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
