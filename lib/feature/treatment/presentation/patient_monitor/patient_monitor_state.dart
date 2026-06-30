
import '../../domain/model/patient_monitor.dart';

class PatientMonitorState {
  final bool isLoading;
  final String? errorMessage;
  final PatientMonitor? patient;

  const PatientMonitorState({
    this.isLoading = false,
    this.errorMessage,
    this.patient,
  });

  PatientMonitorState copyWith({
    bool? isLoading,
    String? errorMessage,
    PatientMonitor? patient,
  }) {
    return PatientMonitorState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      patient: patient ?? this.patient,
    );
  }
}