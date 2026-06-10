import 'package:gitakshmi_hrms_app/core/api/api_client.dart';
import 'package:gitakshmi_hrms_app/core/api/dio_provider.dart';
import 'package:gitakshmi_hrms_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:gitakshmi_hrms_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:gitakshmi_hrms_app/features/profile/domain/repositories/profile_repository.dart';

final ProfileRepository profileRepository = ProfileRepositoryImpl(
  ProfileRemoteDataSourceImpl(ApiClient(DioProvider.instance)),
);

void configureProfileInjection() {}
