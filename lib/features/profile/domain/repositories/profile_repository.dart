abstract class ProfileRepository {
  Future<dynamic> getProfile(String token);
  Future<dynamic> registerFace(
    String token,
    String base64Image, {
    required String employeeName,
    required String employeeId,
  });
}
