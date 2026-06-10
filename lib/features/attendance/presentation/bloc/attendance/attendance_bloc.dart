import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:gitakshmi_hrms_app/core/api/network_checker.dart';
import 'package:gitakshmi_hrms_app/core/storage/preference/preference_manager.dart';
import 'package:gitakshmi_hrms_app/features/attendance/domain/repository/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;

  AttendanceBloc({required this.repository}) : super(AttendanceInitial()) {
    on<VerifyAttendanceEvent>(_onVerifyAttendance);
  }

  Future<void> _onVerifyAttendance(
    VerifyAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    try {
      final hasInternet = await NetworkChecker.hasInternetConnection();
      if (!hasInternet) {
        emit(const AttendanceFailure('No internet connection. Please check your network.'));
        return;
      }

      final token = await PreferenceManager.getToken();
      if (token == null || token.trim().isEmpty) {
        emit(const AttendanceFailure('Session expired. Please log in again.'));
        return;
      }

      final response = await repository.verifyAttendance(
        token: 'Bearer $token',
        base64Image: event.base64Image,
        lat: event.lat,
        lng: event.lng,
        accuracy: event.accuracy,
        actionType: event.actionType,
      );

      String msg = 'Attendance marked successfully!';
      if (response is Map && response.containsKey('message')) {
        msg = response['message'].toString();
      }

      emit(AttendanceSuccess(msg));
    } on DioException catch (e) {
      String errorMsg = 'Failed to mark attendance. Please try again.';
      if (e.response?.data != null && e.response!.data is Map) {
        final responseBody = e.response!.data;
        if (responseBody.containsKey('message')) {
          errorMsg = responseBody['message'].toString();
        }
      }
      emit(AttendanceFailure(errorMsg));
    } catch (e) {
      emit(const AttendanceFailure('An unexpected error occurred. Please try again.'));
    }
  }
}
