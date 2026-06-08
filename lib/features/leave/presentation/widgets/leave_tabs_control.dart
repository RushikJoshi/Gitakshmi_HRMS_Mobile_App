import 'package:flutter/material.dart';

class LeaveTabsControl extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final int badgeCount;

  const LeaveTabsControl({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _tabItem("Review", 0),
          _tabItem("Approved", 1),
          _tabItem("Rejected", 2),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final bool isSelected = selectedTab == index;
    final int displayBadge = (index == 0) ? badgeCount : 0;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff7A5AF8) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF344054),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (displayBadge > 0) ...[
                const SizedBox(width: 5),
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF04438),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$displayBadge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
