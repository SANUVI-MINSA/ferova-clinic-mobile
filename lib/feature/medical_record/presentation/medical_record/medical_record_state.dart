import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';

class MedicalRecordState {
  final bool isLoading;
  final bool isCheckingRecords;
  final bool isSavingRecord;
  final bool isLoadingRecord;
  final String? errorMessage;
  final String? saveErrorMessage;
  final String? recordErrorMessage;
  final List<Patient> patients;
  final Map<String, bool> patientHasRecord;
  final MedicalRecord? medicalRecord;

  const MedicalRecordState({
    this.isLoading = false,
    this.isCheckingRecords = false,
    this.isSavingRecord = false,
    this.isLoadingRecord = false,
    this.errorMessage,
    this.saveErrorMessage,
    this.recordErrorMessage,
    this.patients = const [],
    this.patientHasRecord = const {},
    this.medicalRecord,
  });

  MedicalRecordState copyWith({
    bool? isLoading,
    bool? isCheckingRecords,
    bool? isSavingRecord,
    bool? isLoadingRecord,
    String? errorMessage,
    String? saveErrorMessage,
    String? recordErrorMessage,
    List<Patient>? patients,
    Map<String, bool>? patientHasRecord,
    MedicalRecord? medicalRecord,
  }) {
    return MedicalRecordState(
      isLoading: isLoading ?? this.isLoading,
      isCheckingRecords: isCheckingRecords ?? this.isCheckingRecords,
      isSavingRecord: isSavingRecord ?? this.isSavingRecord,
      isLoadingRecord: isLoadingRecord ?? this.isLoadingRecord,
      errorMessage: errorMessage,
      saveErrorMessage: saveErrorMessage,
      recordErrorMessage: recordErrorMessage,
      patients: patients ?? this.patients,
      patientHasRecord: patientHasRecord ?? this.patientHasRecord,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}
