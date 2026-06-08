class LeaveEntry {
  final String category;
  final String duration;
  final String? taskDelegation;
  final String phone;
  final String description;
  final DateTime submittedDate;
  final int? startDate;
  final int? endDate;

  const LeaveEntry({
    required this.category,
    required this.duration,
    this.taskDelegation,
    required this.phone,
    required this.description,
    required this.submittedDate,
    this.startDate,
    this.endDate,
  });
}
