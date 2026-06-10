import 'package:gitakshmi_hrms_app/features/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:gitakshmi_hrms_app/features/attendance/domain/repository/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<dynamic> verifyAttendance({
    required String token,
    required String base64Image,
    required double lat,
    required double lng,
    required double accuracy,
    required String actionType,
  }) async {
    return await remoteDataSource.verifyAttendance(
      token: token,
      base64Image: base64Image,
      lat: lat,
      lng: lng,
      accuracy: accuracy,
      actionType: actionType,
    );
  }
}
