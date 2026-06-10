abstract class AttendanceState {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;
  const AttendanceSuccess(this.message);
}

class AttendanceFailure extends AttendanceState {
  final String message;
  const AttendanceFailure(this.message);
}
