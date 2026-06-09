import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/features/leave/data/models/leave_model.dart';

class LeaveSubmittedCard extends StatelessWidget {
  final int selectedTab;
  final List<LeaveEntry> reviewLeaves;

  const LeaveSubmittedCard({
    key,
    required this.selectedTab,
    required this.reviewLeaves,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedTab == 0) {
      if (reviewLeaves.isEmpty) {
        return _noLeaveSubmittedCard();
      }
      return Column(
        children: reviewLeaves
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _leaveReviewCard(entry),
                ))
            .toList(),
      );
    } else if (selectedTab == 1) {
      return _leaveStatusCard(
        statusText: "Approved at 19 Sept 2024",
        statusColor: const Color(0xFF12B76A),
        statusIcon: Icons.check_circle,
      );
    } else {
      return _leaveStatusCard(
        statusText: "Rejected at 19 Sept 2024",
        statusColor: const Color(0xFFF04438),
        statusIcon: Icons.cancel,
      );
    }
  }

  Widget _leaveReviewCard(LeaveEntry entry) {
    final List<String> monthsFull = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    final String submittedDateStr =
        "${entry.submittedDate.day} ${monthsFull[entry.submittedDate.month - 1]} ${entry.submittedDate.year}";

    String totalLeave = '-';
    String leaveDate = entry.duration.isEmpty ? '-' : entry.duration;
    if (entry.startDate != null && entry.endDate != null) {
      final int days = (entry.endDate! - entry.startDate!).abs() + 1;
      totalLeave = '$days Day${days > 1 ? 's' : ''}';
    } else if (entry.startDate != null) {
      totalLeave = '1 Day';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.star_border_rounded,
                color: Color(0xff7A5AF8),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Review Submitted",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _leaveInfoText(
                    title: "Leave Date",
                    value: leaveDate,
                  ),
                ),
                Expanded(
                  child: _leaveInfoText(
                    title: "Total Leave",
                    value: totalLeave,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Submitted on: $submittedDateStr",
            style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }

  Widget _noLeaveSubmittedCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 312),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Leave Submitted",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "Leave information",
            style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 45),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/bag_2.png',
                  height: 118,
                  width: 64,
                ),
                const SizedBox(height: 12),
                const Text(
                  "No Leave Submitted!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF161B23),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Ready to catch some fresh air?\nClick \"+\" and take that well-deserved break!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF777F8C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveStatusCard({
    required String statusText,
    required Color statusColor,
    required IconData statusIcon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/calender.png',
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "18 September 2024",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _leaveInfoText(
                    title: "Leave Date",
                    value: "20 Sept - 22 Sept",
                  ),
                ),
                Expanded(
                  child: _leaveInfoText(
                    title: "Total Leave",
                    value: "2 Days",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  statusText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Text(
                "By",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF101828),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFFFFE0E0),
                child: Icon(
                  Icons.person,
                  size: 13,
                  color: Color(0xFFF97066),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "Elaine",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF101828),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leaveInfoText({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF344054),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
