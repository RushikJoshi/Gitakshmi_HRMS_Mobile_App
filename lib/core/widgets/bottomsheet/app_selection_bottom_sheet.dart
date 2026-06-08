import 'package:flutter/material.dart';

class AppSelectionBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final String? initialSelected;

  const AppSelectionBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    this.initialSelected,
  });

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> options,
    String? initialSelected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppSelectionBottomSheet(
        title: title,
        subtitle: subtitle,
        options: options,
        initialSelected: initialSelected,
      ),
    );
  }

  @override
  State<AppSelectionBottomSheet> createState() => _AppSelectionBottomSheetState();
}

class _AppSelectionBottomSheetState extends State<AppSelectionBottomSheet> {
  String? _tempSelected;

  @override
  void initState() {
    super.initState();
    // Only set initial if it's actually in the options list
    if (widget.initialSelected != null &&
        widget.initialSelected!.isNotEmpty &&
        widget.options.contains(widget.initialSelected)) {
      _tempSelected = widget.initialSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelectionValid = _tempSelected != null && _tempSelected!.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag handle
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E7EC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF101828),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.options.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = widget.options[index];
                          final isSelected = _tempSelected == item;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _tempSelected = item;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF5F4FF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF7544FC)
                                      : const Color(0xFFE4E7EC),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSelected
                                            ? const Color(0xFF7544FC)
                                            : const Color(0xFF344054),
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? const Color(0xFF7544FC)
                                          : Colors.white,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF7544FC)
                                            : const Color(0xFFD0D5DD),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 13,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF7544FC),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF7544FC),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isSelectionValid
                            ? () => Navigator.pop(context, _tempSelected)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7544FC),
                          disabledBackgroundColor:
                              const Color(0xFF7544FC).withValues(alpha: 0.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Select",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
