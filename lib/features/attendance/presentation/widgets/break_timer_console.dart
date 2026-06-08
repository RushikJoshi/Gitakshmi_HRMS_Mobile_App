import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class BreakTimerConsole extends StatelessWidget {
  final int activeActivity;
  final bool livenessSuccess;
  final bool simulateOverBreakLimit;
  final ValueChanged<bool?> onSimulateOverBreakLimitChanged;
  final Color timerColor;
  final String timerStatusText;
  final String timerValue;
  final String timerLimitText;
  final List<Map<String, String>> breaksHistory;
  final Function(int) onBreakButtonPressed;
  final VoidCallback onPunchOut;

  const BreakTimerConsole({
    super.key,
    required this.activeActivity,
    required this.livenessSuccess,
    required this.simulateOverBreakLimit,
    required this.onSimulateOverBreakLimitChanged,
    required this.timerColor,
    required this.timerStatusText,
    required this.timerValue,
    required this.timerLimitText,
    required this.breaksHistory,
    required this.onBreakButtonPressed,
    required this.onPunchOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  timerStatusText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: timerColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Face Verification: ${livenessSuccess ? "SDK CLEARED ✅" : "BYPASSED ⚠️"}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // Over Break Limits simulation toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Simulate Over-limit Break Limit',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                      value: simulateOverBreakLimit,
                      onChanged: onSimulateOverBreakLimitChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Circular Progress Timer
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: CircularProgressIndicator(
                        value:
                            activeActivity == 3 || activeActivity == 4
                                ? (simulateOverBreakLimit ? 1.0 : 0.85)
                                : 0.65,
                        color: timerColor,
                        backgroundColor: Colors.grey.shade100,
                        strokeWidth: 15,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timerValue,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(timerLimitText, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Late Check-in Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.alarm_on_rounded, color: AppColors.warning, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Late Check-In alert: +18 Mins',
                        style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBreakButton(Icons.local_cafe_rounded, 'Tea Break', 4),
                    _buildBreakButton(Icons.restaurant_rounded, 'Lunch', 3),
                    _buildBreakButton(Icons.more_time_rounded, 'OT Active', 5),
                  ],
                ),
                const Divider(height: 40),

                OutlinedButton.icon(
                  onPressed: onPunchOut,
                  icon: const Icon(Icons.exit_to_app_rounded, color: AppColors.error),
                  label: const Text('Biometric Punch Out', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Break logs history
        const Text(
          'Today\'s Break Summary Logs',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: breaksHistory.length,
            itemBuilder: (context, index) {
              final item = breaksHistory[index];
              return ListTile(
                leading: const Icon(Icons.coffee_rounded, color: AppColors.primary),
                title: Text(item["type"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text(
                  'Start: ${item["time"]} • Duration: ${item["duration"]}',
                  style: const TextStyle(fontSize: 11),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBreakButton(IconData icon, String label, int activityCode) {
    final isActive = activeActivity == activityCode;
    final buttonColor =
        activityCode == 3
            ? AppColors.timerLunch
            : (activityCode == 4 ? AppColors.timerShortBreak : AppColors.timerOvertime);

    return ElevatedButton.icon(
      onPressed: () => onBreakButtonPressed(activityCode),
      icon: Icon(isActive ? Icons.play_arrow_rounded : icon, size: 14),
      label: Text(isActive ? 'Resume' : label, style: const TextStyle(fontSize: 10)),
      style: ElevatedButton.styleFrom(backgroundColor: buttonColor, padding: const EdgeInsets.symmetric(horizontal: 8)),
    );
  }
}
