import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';

class MedicalRecordState {
  final bool isLoading;
  final bool isCheckingRecords;
  final bool isSavingRecord;
  final bool isLoadingRecord;
  final bool isUpdatingRecord;
  final String? errorMessage;
  final String? saveErrorMessage;
  final String? recordErrorMessage;
  final String? updateErrorMessage;
  final List<Patient> patients;
  final Map<String, bool> patientHasRecord;
  final MedicalRecord? medicalRecord;

  const MedicalRecordState({
    this.isLoading = false,
    this.isCheckingRecords = false,
    this.isSavingRecord = false,
    this.isLoadingRecord = false,
    this.isUpdatingRecord = false,
    this.errorMessage,
    this.saveErrorMessage,
    this.recordErrorMessage,
    this.updateErrorMessage,
    this.patients = const [],
    this.patientHasRecord = const {},
    this.medicalRecord,
  });

  MedicalRecordState copyWith({
    bool? isLoading,
    bool? isCheckingRecords,
    bool? isSavingRecord,
    bool? isLoadingRecord,
    bool? isUpdatingRecord,
    String? errorMessage,
    String? saveErrorMessage,
    String? recordErrorMessage,
    String? updateErrorMessage,
    List<Patient>? patients,
    Map<String, bool>? patientHasRecord,
    MedicalRecord? medicalRecord,
  }) {
    return MedicalRecordState(
      isLoading: isLoading ?? this.isLoading,
      isCheckingRecords: isCheckingRecords ?? this.isCheckingRecords,
      isSavingRecord: isSavingRecord ?? this.isSavingRecord,
      isLoadingRecord: isLoadingRecord ?? this.isLoadingRecord,
      isUpdatingRecord: isUpdatingRecord ?? this.isUpdatingRecord,
      errorMessage: errorMessage,
      saveErrorMessage: saveErrorMessage,
      recordErrorMessage: recordErrorMessage,
      updateErrorMessage: updateErrorMessage,
      patients: patients ?? this.patients,
      patientHasRecord: patientHasRecord ?? this.patientHasRecord,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}
