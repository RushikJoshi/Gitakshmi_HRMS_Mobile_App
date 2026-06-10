import 'package:gitakshmi_hrms_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:gitakshmi_hrms_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<dynamic> getProfile(String token) async {
    return await remoteDataSource.getProfile(token);
  }

  @override
  Future<dynamic> registerFace(
    String token,
    String base64Image, {
    required String employeeName,
    required String employeeId,
  }) async {
    return await remoteDataSource.registerFace(
      token,
      base64Image,
      employeeName: employeeName,
      employeeId: employeeId,
    );
  }
}
