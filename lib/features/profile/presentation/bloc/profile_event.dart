abstract class ProfileEvent {
  const ProfileEvent();
}

class FetchProfileEvent extends ProfileEvent {
  final String? employeeId;
  const FetchProfileEvent({this.employeeId});
}

class RegisterFaceEvent extends ProfileEvent {
  final String base64Image;
  const RegisterFaceEvent({required this.base64Image});
}
