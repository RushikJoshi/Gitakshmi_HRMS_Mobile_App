import 'package:gitakshmi_hrms_app/core/api/api_client.dart';

abstract class ProfileRemoteDataSource {
  Future<dynamic> getProfile(String token);
  Future<dynamic> registerFace(
    String token,
    String base64Image, {
    required String employeeName,
    required String employeeId,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<dynamic> getProfile(String token) async {
    return await apiClient.getProfile(token);
  }

  @override
  Future<dynamic> registerFace(
    String token,
    String base64Image, {
    required String employeeName,
    required String employeeId,
  }) async {
    return await apiClient.registerFace(token, {
      "employeeName": employeeName,
      "employeeId": employeeId,
      "faceEmbedding": null,
      "faceImageData": base64Image,
      "registrationNotes": "Self register: $employeeName ($employeeId)",
      "consentGiven": true,
    });
  }
}
