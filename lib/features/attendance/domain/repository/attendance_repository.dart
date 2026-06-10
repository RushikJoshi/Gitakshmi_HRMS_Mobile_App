abstract class AttendanceRepository {
  Future<dynamic> verifyAttendance({
    required String token,
    required String base64Image,
    required double lat,
    required double lng,
    required double accuracy,
    required String actionType,
  });
}
