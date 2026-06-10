import 'package:gitakshmi_hrms_app/core/api/api_client.dart';
import 'package:gitakshmi_hrms_app/core/api/dio_provider.dart';
import 'package:gitakshmi_hrms_app/features/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:gitakshmi_hrms_app/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:gitakshmi_hrms_app/features/attendance/domain/repository/attendance_repository.dart';

final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
  AttendanceRemoteDataSourceImpl(ApiClient(DioProvider.instance)),
);

void configureAttendanceInjection() {}
