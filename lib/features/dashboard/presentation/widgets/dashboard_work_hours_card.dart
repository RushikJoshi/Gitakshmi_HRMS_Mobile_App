import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_selection_bottom_sheet.dart';

class DashboardWorkHoursCard extends StatefulWidget {
  const DashboardWorkHoursCard({super.key});

  @override
  State<DashboardWorkHoursCard> createState() => _DashboardWorkHoursCardState();
}

class _DashboardWorkHoursCardState extends State<DashboardWorkHoursCard> {
  String _selectedFilter = 'This Week';

  Future<void> _selectFilter() async {
    final result = await AppSelectionBottomSheet.show(
      context: context,
      title: 'Select Filter',
      subtitle: 'Choose weekly range filter',
      options: ['This Week', 'Last Week'],
      initialSelected: _selectedFilter,
    );
    if (result != null && mounted) {
      setState(() {
        _selectedFilter = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Work Hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      _buildLegendDot(AppColors.purple600, 'Hours'),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: _selectFilter,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedFilter,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Custom painted weekly bar chart representation
              SizedBox(
                height: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildWeeklyBar('Mon', _selectedFilter == 'This Week' ? 0.6 : 0.4),
                    _buildWeeklyBar('Tue', _selectedFilter == 'This Week' ? 0.4 : 0.8),
                    _buildWeeklyBar('Wed', _selectedFilter == 'This Week' ? 0.6 : 0.5),
                    _buildWeeklyBar('Thu', _selectedFilter == 'This Week' ? 0.7 : 0.6),
                    _buildWeeklyBar('Fri', _selectedFilter == 'This Week' ? 0.9 : 0.7),
                    _buildWeeklyBar('Sat', _selectedFilter == 'This Week' ? 0.8 : 0.2),
                    _buildWeeklyBar('Sun', _selectedFilter == 'This Week' ? 0.5 : 0.1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyBar(String day, double percent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: 90 * percent,
          decoration: BoxDecoration(
            color: AppColors.purple600,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
