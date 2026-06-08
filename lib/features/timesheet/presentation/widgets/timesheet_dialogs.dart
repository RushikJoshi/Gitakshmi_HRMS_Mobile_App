import 'package:flutter/material.dart';

// ─── Shared styling constants ─────────────────────────────────────────────────
const Color _purple    = Color(0xff7A5AF8);
const Color _darkText  = Color(0xFF101828);
const Color _greyText  = Color(0xFF667085);
const Color _blueLabel = Color(0xFF2E63B4);

// ═════════════════════════════════════════════════════════════════════════════
// STEP 1 — "Raise a Request" options popup
// ═════════════════════════════════════════════════════════════════════════════
void showRaiseRequestOptionsDialog(BuildContext rootContext) {
  showDialog(
    context: rootContext,
    barrierDismissible: true,
    builder: (_) => _RaiseRequestOptionsDialog(rootContext: rootContext),
  );
}

class _RaiseRequestOptionsDialog extends StatefulWidget {
  final BuildContext rootContext;
  const _RaiseRequestOptionsDialog({required this.rootContext});

  @override
  State<_RaiseRequestOptionsDialog> createState() =>
      _RaiseRequestOptionsDialogState();
}

class _RaiseRequestOptionsDialogState
    extends State<_RaiseRequestOptionsDialog> {
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Raise a Request",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 20),

                // Illustration
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/images/request_image.png',
                    height: 171,
                    width: 158,
                    errorBuilder: (_, __, ___) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.campaign, color: Colors.indigo, size: 48),
                        SizedBox(width: 12),
                        Icon(Icons.back_hand, color: Colors.brown, size: 44),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Option 1 — Punch Out Missing Request → direct tap
                _OptionRow(
                  icon: Icons.timer_off_outlined,
                  label: "Punch Out Missing Request",
                  onTap: () {
                    Navigator.pop(context);
                    showPunchOutRequestDialog(widget.rootContext);
                  },
                ),
                const SizedBox(height: 12),

                // Option 2 — Send Reminder for Attendance (expandable)
                _ExpandableOptionRow(
                  icon: Icons.shield_outlined,
                  label: "Send Reminder for Attendance",
                  isExpanded: _expanded == 1,
                  onHeaderTap: () =>
                      setState(() => _expanded = _expanded == 1 ? null : 1),
                  onActionTap: () {
                    Navigator.pop(context);
                    showReminderConfirmDialog(widget.rootContext);
                  },
                  actionLabel: "Send Reminder Now →",
                ),
                const SizedBox(height: 28),

                // Close → back to last screen
                _CloseButton(onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          Positioned(top: 0, child: _FloatingClockIcon()),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 2 — "Punch Out Request" form popup
// ═════════════════════════════════════════════════════════════════════════════
void showPunchOutRequestDialog(BuildContext rootContext) {
  showDialog(
    context: rootContext,
    barrierDismissible: true,
    builder: (_) => _PunchOutRequestDialog(rootContext: rootContext),
  );
}

class _PunchOutRequestDialog extends StatelessWidget {
  final BuildContext rootContext;
  const _PunchOutRequestDialog({required this.rootContext});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Center(
                  child: Text(
                    "Punch Out Request",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _darkText,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Date
                const Text("Date",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _blueLabel)),
                const SizedBox(height: 8),
                const _DropdownField(
                    icon: Icons.calendar_month_outlined,
                    hint: "Select Date"),
                const SizedBox(height: 16),

                // Time
                const Text("Time",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _blueLabel)),
                const SizedBox(height: 8),
                const _DropdownField(
                    icon: Icons.access_time, hint: "Select Time"),
                const SizedBox(height: 16),

                // Reason
                const Text("Reason",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _blueLabel)),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD0D5DD)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type Here",
                      hintStyle: TextStyle(
                          fontSize: 13, color: Color(0xFF98A2B3)),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 55),
                        child: Icon(Icons.edit_note,
                            color: Color(0xFF667085), size: 20),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit → opens Reminder popup
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showReminderConfirmDialog(rootContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: const Text("Submit Request",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel → shows Leave popup
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showLeaveDialog(rootContext);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _purple),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text("Cancel Request",
                        style: TextStyle(
                            color: _purple,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(top: 0, child: _FloatingClockIcon()),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 3 — "Raise a Request – Send Reminder" confirmation popup
// ═════════════════════════════════════════════════════════════════════════════
void showReminderConfirmDialog(BuildContext rootContext) {
  showDialog(
    context: rootContext,
    barrierDismissible: true,
    builder: (_) => _ReminderConfirmDialog(rootContext: rootContext),
  );
}

class _ReminderConfirmDialog extends StatelessWidget {
  final BuildContext rootContext;
  const _ReminderConfirmDialog({required this.rootContext});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Raise a Request",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 24),

                // Illustration — red clipboard with clock
                Image.asset(
                  'assets/images/reminder_image.png',
                  height: 100,
                  errorBuilder: (_, __, ___) => Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Icon(Icons.assignment_late,
                          color: Colors.red.shade700, size: 80),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child:
                            Icon(Icons.alarm, color: Colors.grey, size: 32),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Are you sure want to\nsend Reminder ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _blueLabel,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // Close → opens Leave popup
                _CloseButton(
                  onTap: () {
                    Navigator.pop(context);
                    showLeaveDialog(rootContext);
                  },
                ),
              ],
            ),
          ),
          Positioned(top: 0, child: _FloatingClockIcon()),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 4 — "You are on leave" popup
// ═════════════════════════════════════════════════════════════════════════════
void showLeaveDialog(BuildContext rootContext) {
  showDialog(
    context: rootContext,
    barrierDismissible: true,
    builder: (_) => const _LeaveDialog(),
  );
}

class _LeaveDialog extends StatelessWidget {
  const _LeaveDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Raise a Request",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 24),

                // Illustration — person on leave
                Image.asset(
                  'assets/images/on_leave_image.png',
                  height: 120,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.beach_access,
                      color: Colors.teal,
                      size: 80),
                ),

                const SizedBox(height: 20),

                const Text(
                  "You are on leave",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _blueLabel,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "(10 May 2025)",
                  style: TextStyle(fontSize: 13, color: _greyText),
                ),
                const SizedBox(height: 28),

                // Close → pop dialog and return to last screen
                _CloseButton(onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          Positioned(top: 0, child: _FloatingClockIcon()),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Shared reusable widgets
// ═════════════════════════════════════════════════════════════════════════════

class _FloatingClockIcon extends StatelessWidget {
  const _FloatingClockIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: _purple,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.access_time, color: _purple, size: 20),
        ),
      ),
    );
  }
}

/// Simple option row (direct tap, no expand)
class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OptionRow(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD0D5DD)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _greyText, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _darkText,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: _greyText, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Expandable dropdown row with animated arrow
class _ExpandableOptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isExpanded;
  final VoidCallback onHeaderTap;
  final VoidCallback onActionTap;
  final String actionLabel;

  const _ExpandableOptionRow({
    required this.icon,
    required this.label,
    required this.isExpanded,
    required this.onHeaderTap,
    required this.onActionTap,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpanded ? _purple : const Color(0xFFD0D5DD),
          width: isExpanded ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onHeaderTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(icon,
                      color: isExpanded ? _purple : _greyText, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isExpanded ? _purple : _darkText,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: isExpanded ? _purple : _greyText, size: 20),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFEEEEEE), height: 1),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: onActionTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F1FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          color: _purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Dropdown-style input field
class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String hint;
  const _DropdownField({required this.icon, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D5DD)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF475467), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(hint,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF98A2B3))),
          ),
          const Icon(Icons.keyboard_arrow_down,
              color: Color(0xFF475467), size: 20),
        ],
      ),
    );
  }
}

/// Rounded purple "Close" button
class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: const Text(
          "Close",
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
