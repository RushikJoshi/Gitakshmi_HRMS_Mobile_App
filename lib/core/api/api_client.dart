import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:gitakshmi_hrms_app/core/api/api_endpoints.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(ApiEndpoints.login)
  @Headers(<String, dynamic>{
    "Origin": "https://hrms.gitakshmi.com",
  })
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoints.payslips)
  Future<dynamic> getPayslips(@Header('Authorization') String token);

  @GET(ApiEndpoints.profile)
  @Headers(<String, dynamic>{
    "Origin": "https://hrms.gitakshmi.com",
  })
  Future<dynamic> getProfile(@Header('Authorization') String token);

  @POST(ApiEndpoints.registerFace)
  @Headers(<String, dynamic>{
    "Origin": "https://hrms.gitakshmi.com",
    "Content-Type": "application/json",
  })
  Future<dynamic> registerFace(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.verifyAttendance)
  @Headers(<String, dynamic>{
    "Origin": "https://hrms.gitakshmi.com",
    "Content-Type": "application/json",
  })
  Future<dynamic> verifyAttendance(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> body,
  );
}

