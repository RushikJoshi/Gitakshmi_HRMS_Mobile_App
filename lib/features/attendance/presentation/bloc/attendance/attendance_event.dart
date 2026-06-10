abstract class AttendanceEvent {
  const AttendanceEvent();
}

class VerifyAttendanceEvent extends AttendanceEvent {
  final String base64Image;
  final double lat;
  final double lng;
  final double accuracy;
  final String actionType;

  const VerifyAttendanceEvent({
    required this.base64Image,
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.actionType,
  });
}
