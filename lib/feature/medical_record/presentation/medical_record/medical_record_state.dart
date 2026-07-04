import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';

class MedicalRecordState {
  final bool isLoading;
  final bool isCheckingRecords;
  final String? errorMessage;
  final List<Patient> patients;
  final Map<String, bool> patientHasRecord;

  const MedicalRecordState({
    this.isLoading = false,
    this.isCheckingRecords = false,
    this.errorMessage,
    this.patients = const [],
    this.patientHasRecord = const {},
  });

  MedicalRecordState copyWith({
    bool? isLoading,
    bool? isCheckingRecords,
    String? errorMessage,
    List<Patient>? patients,
    Map<String, bool>? patientHasRecord,
  }) {
    return MedicalRecordState(
      isLoading: isLoading ?? this.isLoading,
      isCheckingRecords: isCheckingRecords ?? this.isCheckingRecords,
      errorMessage: errorMessage,
      patients: patients ?? this.patients,
      patientHasRecord: patientHasRecord ?? this.patientHasRecord,
    );
  }
}
