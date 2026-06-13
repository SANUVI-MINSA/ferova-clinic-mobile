import 'package:ferova_clinic_flutter/feature/health-facility/domain/model/appointment.dart';

class AppointmentState {
  final bool isLoading;
  final String? errorMessage;
  final List<Appointment> appointments;

  const AppointmentState({
    this.isLoading = false,
    this.errorMessage,
    this.appointments = const [],
  });

  AppointmentState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Appointment>? appointments,
  }) {
    return AppointmentState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      appointments: appointments ?? this.appointments,
    );
  }
}
