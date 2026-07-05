import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/discharge_patient.dart';

class DischargeState {
  final bool isLoading;
  final bool isDischarging;
  final String? errorMessage;
  final List<DischargePatient> patients;

  const DischargeState({
    this.isLoading = false,
    this.isDischarging = false,
    this.errorMessage,
    this.patients = const [],
  });

  DischargeState copyWith({
    bool? isLoading,
    bool? isDischarging,
    String? errorMessage,
    List<DischargePatient>? patients,
  }) {
    return DischargeState(
      isLoading: isLoading ?? this.isLoading,
      isDischarging: isDischarging ?? this.isDischarging,
      errorMessage: errorMessage,
      patients: patients ?? this.patients,
    );
  }
}
