import 'package:gitakshmi_hrms_app/core/api/api_client.dart';

abstract class AttendanceRemoteDataSource {
  Future<dynamic> verifyAttendance({
    required String token,
    required String base64Image,
    required double lat,
    required double lng,
    required double accuracy,
    required String actionType,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final ApiClient apiClient;

  AttendanceRemoteDataSourceImpl(this.apiClient);

  @override
  Future<dynamic> verifyAttendance({
    required String token,
    required String base64Image,
    required double lat,
    required double lng,
    required double accuracy,
    required String actionType,
  }) async {
    return await apiClient.verifyAttendance(token, {
      "faceImageData": base64Image,
      "location": {
        "lat": lat,
        "lng": lng,
        "accuracy": accuracy,
      },
      "actionType": actionType,
    });
  }
}
