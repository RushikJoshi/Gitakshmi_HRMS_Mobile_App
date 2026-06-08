import 'package:flutter/material.dart';

class LeaveSummaryHeader extends StatelessWidget {
  final double horizontalPadding;
  final String availableLeaves;
  final String usedLeaves;

  const LeaveSummaryHeader({
    super.key,
    required this.horizontalPadding,
    this.availableLeaves = "20",
    this.usedLeaves = "2",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _header(),
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: 0,
            child: _summaryCard(),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        return Container(
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff795FFC),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(46),
              bottomRight: Radius.circular(46),
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                top: 70,
                left: 28,
                child: Text(
                  "Leave Summary",
                  style: TextStyle(
                    color: Color(0xffFEFEFE),
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Positioned(
                top: 100,
                left: 28,
                child: Text(
                  "Submit Leave",
                  style: TextStyle(
                    color: Color(0xFFD9D6FE),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                top: 43,
                right: width < 360 ? -55 : -28,
                child: Image.asset(
                  "assets/images/bag.png",
                  width: width < 360 ? 145 : 176,
                  height: 97,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCard() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Leave",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            "Period 1 Jan 2024 - 30 Dec 2024",
            style: TextStyle(fontSize: 11, color: Color(0xFF7C8493)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _leaveBox(
                  dotColor: const Color(0xFF19B36E),
                  title: "Available",
                  value: availableLeaves,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _leaveBox(
                  dotColor: const Color(0xff7A5AF8),
                  title: "Leave Used",
                  value: usedLeaves,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leaveBox({
    required Color dotColor,
    required String title,
    required String value,
  }) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEBECEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: dotColor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
