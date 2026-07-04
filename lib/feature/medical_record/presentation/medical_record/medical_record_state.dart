import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';

class MedicalRecordState {
  final bool isLoading;
  final bool isCheckingRecords;
  final bool isSavingRecord;
  final String? errorMessage;
  final String? saveErrorMessage;
  final List<Patient> patients;
  final Map<String, bool> patientHasRecord;

  const MedicalRecordState({
    this.isLoading = false,
    this.isCheckingRecords = false,
    this.isSavingRecord = false,
    this.errorMessage,
    this.saveErrorMessage,
    this.patients = const [],
    this.patientHasRecord = const {},
  });

  MedicalRecordState copyWith({
    bool? isLoading,
    bool? isCheckingRecords,
    bool? isSavingRecord,
    String? errorMessage,
    String? saveErrorMessage,
    List<Patient>? patients,
    Map<String, bool>? patientHasRecord,
  }) {
    return MedicalRecordState(
      isLoading: isLoading ?? this.isLoading,
      isCheckingRecords: isCheckingRecords ?? this.isCheckingRecords,
      isSavingRecord: isSavingRecord ?? this.isSavingRecord,
      errorMessage: errorMessage,
      saveErrorMessage: saveErrorMessage,
      patients: patients ?? this.patients,
      patientHasRecord: patientHasRecord ?? this.patientHasRecord,
    );
  }
}
