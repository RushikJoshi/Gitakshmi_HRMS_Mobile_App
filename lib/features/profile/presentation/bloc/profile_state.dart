import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final EmployeeProfileModel profile;
  final String? designation;

  const ProfileLoaded({
    required this.profile,
    required this.designation,
  });
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}

class FaceRegisterLoading extends ProfileState {
  final EmployeeProfileModel profile;
  final String? designation;
  const FaceRegisterLoading({required this.profile, this.designation});
}

class FaceRegisterSuccess extends ProfileState {
  final EmployeeProfileModel profile;
  final String? designation;
  final String message;
  const FaceRegisterSuccess({required this.profile, this.designation, required this.message});
}

class FaceRegisterError extends ProfileState {
  final EmployeeProfileModel profile;
  final String? designation;
  final String message;
  const FaceRegisterError({required this.profile, this.designation, required this.message});
}
