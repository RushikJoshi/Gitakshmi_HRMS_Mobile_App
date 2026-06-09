import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';
import 'package:gitakshmi_hrms_app/features/approvals/presentation/pages/approval_review_page.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  // Mock requests data matching the mockup exactly
  final List<Map<String, dynamic>> _pendingRequests = [
    {
      "id": 101,
      "name": "Mr. Sharma",
      "dept": "Software Developer",
      "type": "Mr. Sharma's Offer letter...",
      "details": "Senior Software Developer offer letter approval request. CTC: Proposed INR 12,00,000 LPA.",
      "priority": "High",
      "date": "06 Jun 2026",
      "category": "HR & Leaves",
      "steps": ["HR Approved", "Director Pending"],
      "attachments": ["Offer_Letter_Sharma.pdf"]
    },
    {
      "id": 102,
      "name": "Mr. Dave",
      "dept": "Digital Marketing",
      "type": "Mr. Dave's Appointment letter...",
      "details": "Digital Marketing Specialist appointment letter approval request. CTC: Proposed INR 8,00,000 LPA.",
      "priority": "Medium",
      "date": "05 Jun 2026",
      "category": "HR & Leaves",
      "steps": ["Manager Approved", "HR Pending"],
      "attachments": ["Appointment_Letter_Dave.pdf"]
    }
  ];

  void _navigateToReview(Map<String, dynamic> req) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalReviewPage(request: req),
      ),
    );
    if (!mounted) return;
    if (result != null && result is Map) {
      final action = result['action'];
      final id = result['id'];
      if (action == 'approved' || action == 'rejected') {
        setState(() {
          _pendingRequests.removeWhere((item) => item["id"] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(action == 'approved' ? 'Request approved.' : 'Request rejected.'),
            backgroundColor: action == 'approved' ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPurple = Color(0xff7A5AF8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Approval Notification",
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Purple Header Card
                Container(
                  width: double.infinity,
                  height: 138,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A5AF8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Text Column
                      Positioned(
                        top: 28,
                        left: 20,
                        right: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Approval Notification",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "You have following approval notification",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD9D6FE),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Illustration Image
                      Positioned(
                        top: 10,
                        right: 14,
                        bottom: 10,
                        child: Image.asset(
                          'assets/images/approval_illustration.png',
                          width: 108,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.assignment_turned_in_rounded,
                              size: 58,
                              color: Color(0xFFD9D6FE),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 2. Notification Receive Row
                Row(
                  children: [
                    const Text(
                      "Notification Receive",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F1FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${_pendingRequests.length}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: brandPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your attention is require on following",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Pending Approvals List
                if (_pendingRequests.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "No pending approval requests!",
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  ..._pendingRequests.map((req) => _buildApprovalCard(req)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> req) {
    const Color brandPurple = Color(0xff7A5AF8);

    // Calculate progress ratio
    final List<String> steps = List<String>.from(req["steps"] ?? []);
    final int approvedCount = steps.where((s) => s.contains("Approved")).length;
    final double progressRatio = steps.isEmpty ? 0.0 : approvedCount / steps.length;

    // Get priority colors
    Color priorityBgColor;
    Color priorityTextColor;
    final String priority = req["priority"] ?? "Low";
    switch (priority.toLowerCase()) {
      case 'high':
        priorityBgColor = const Color(0xFFFEE4E2);
        priorityTextColor = const Color(0xFFD92D20);
        break;
      case 'medium':
        priorityBgColor = const Color(0xFFFEF0C7);
        priorityTextColor = const Color(0xFFB54708);
        break;
      default:
        priorityBgColor = const Color(0xFFE0F2FE);
        priorityTextColor = const Color(0xFF0369A1);
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEAECF0)),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () => _navigateToReview(req),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row (Purple Circular Icon + Title/Subtitle)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF4F1FF),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.description_rounded,
                      color: brandPurple,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          req["type"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF101828),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          req["dept"],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF667085),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Badge Row (Priority badge + Status badge)
              Row(
                children: [
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: priorityBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          color: priorityTextColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$priority Priority',
                          style: TextStyle(
                            color: priorityTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.folder_rounded,
                          color: Color(0xFF475467),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          req["category"] ?? "General",
                          style: const TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressRatio,
                      backgroundColor: const Color(0xFFF2F4F7),
                      valueColor: const AlwaysStoppedAnimation<Color>(brandPurple),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Bottom Row (Timeline steps avatars + Date + Review Button)
              Row(
                children: [
                  // Timeline steps avatars
                  if (steps.isNotEmpty)
                    SizedBox(
                      width: 28.0 + (steps.length - 1) * 16.0,
                      height: 28,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List.generate(steps.length, (index) {
                          final step = steps[index];
                          final initials = step.split(' ').first;
                          final displayInitials = initials.length > 2 ? initials.substring(0, 2) : initials;
                          final isApproved = step.contains("Approved");
                          return Positioned(
                            left: index * 16.0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isApproved ? const Color(0xFFD1FADF) : const Color(0xFFFEE4E2),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                displayInitials,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: isApproved ? const Color(0xFF039855) : const Color(0xFFD92D20),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  const Spacer(),
                  // Date Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEAECF0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: Color(0xFF667085),
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          req["date"],
                          style: const TextStyle(
                            color: Color(0xFF475467),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Review Action Button
                  ElevatedButton(
                    onPressed: () => _navigateToReview(req),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                    ),
                    child: const Text(
                      "Review",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
