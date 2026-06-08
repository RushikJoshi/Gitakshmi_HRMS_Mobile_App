class HolidayEntry {
  final String date;
  final String name;
  final String dayName;
  final String imageAsset;
  bool isApplied;

  HolidayEntry({
    required this.date,
    required this.name,
    required this.dayName,
    required this.imageAsset,
    this.isApplied = false,
  });
}
