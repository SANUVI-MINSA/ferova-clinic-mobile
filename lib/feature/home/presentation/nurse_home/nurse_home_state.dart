import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';

class NurseHomeState {
  final bool isLoadingPatients;
  final bool isLoadingAppointments;
  final String? errorMessage;
  final int activePatients;
  final int highRiskCount;
  final int mediumRiskCount;
  final int lowRiskCount;
  final List<Appointment> todayAppointments;
  final String facilityName;

  const NurseHomeState({
    this.isLoadingPatients = false,
    this.isLoadingAppointments = false,
    this.errorMessage,
    this.activePatients = 0,
    this.highRiskCount = 0,
    this.mediumRiskCount = 0,
    this.lowRiskCount = 0,
    this.todayAppointments = const [],
    this.facilityName = 'Sin posta asignada',
  });

  NurseHomeState copyWith({
    bool? isLoadingPatients,
    bool? isLoadingAppointments,
    String? errorMessage,
    int? activePatients,
    int? highRiskCount,
    int? mediumRiskCount,
    int? lowRiskCount,
    List<Appointment>? todayAppointments,
    String? facilityName,
  }) {
    return NurseHomeState(
      isLoadingPatients: isLoadingPatients ?? this.isLoadingPatients,
      isLoadingAppointments: isLoadingAppointments ?? this.isLoadingAppointments,
      errorMessage: errorMessage,
      activePatients: activePatients ?? this.activePatients,
      highRiskCount: highRiskCount ?? this.highRiskCount,
      mediumRiskCount: mediumRiskCount ?? this.mediumRiskCount,
      lowRiskCount: lowRiskCount ?? this.lowRiskCount,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      facilityName: facilityName ?? this.facilityName,
    );
  }
}
