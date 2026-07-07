import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/value_objects/patient_history.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/repository/medical_record_repository.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_state.dart';
import 'package:flutter/material.dart';

class MedicalRecordViewModel extends ChangeNotifier {
  final MedicalRecordRepository repository;
  MedicalRecordState state = const MedicalRecordState();

  MedicalRecordViewModel({required this.repository}) {}

  // ✅ NUEVO MÉTODO: Forzar recarga
  Future<void> refresh() async {
    await getNursePatients();
  }

  Future<void> getNursePatients() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final patients = await repository.getNursePatients();
      state = state.copyWith(
        isLoading: false,
        patients: patients,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      notifyListeners();
      return;
    }
    notifyListeners();
    await checkPatientsMedicalRecord();
  }

  Future<void> checkPatientsMedicalRecord() async {
    state = state.copyWith(isCheckingRecords: true);
    notifyListeners();
    try {
      final results = await Future.wait(
        state.patients.map((patient) async {
          final hasRecord = await repository.checkMedicalRecord(patient.id);
          return MapEntry(patient.id, hasRecord);
        }),
      );
      state = state.copyWith(
        isCheckingRecords: false,
        patientHasRecord: Map.fromEntries(results),
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isCheckingRecords: false,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> postMedicalRecord({
    required String patientId,
    required double weight,
    required int height,
    required String consultationReason,
    required String observations,
    required List<PatientHistory> patientHistories,
    required List<String> symptoms,
  }) async {
    state = state.copyWith(isSavingRecord: true, saveErrorMessage: null);
    notifyListeners();

    try {
      await repository.postMedicalRecord(
        MedicalRecord(
          id: '',
          patientId: patientId,
          patientName: '',
          lastUpdated: '',
          gender: '',
          weight: weight,
          height: height,
          controls: const [],
          consultationReason: consultationReason,
          observations: observations,
          patientHistories: patientHistories,
          symptoms: symptoms,
        ),
      );
      state = state.copyWith(isSavingRecord: false, saveErrorMessage: null);
    } catch (e) {
      state = state.copyWith(
        isSavingRecord: false,
        saveErrorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> updateMedicalRecord({
    required String patientId,
    required double weight,
    required int height,
    required String consultationReason,
    required String observations,
    required List<PatientHistory> patientHistories,
    required List<String> symptoms,
  }) async {
    state = state.copyWith(isUpdatingRecord: true, updateErrorMessage: null);
    notifyListeners();

    try {
      await repository.updateMedicalRecord(
        MedicalRecord(
          id: '',
          patientId: patientId,
          patientName: '',
          lastUpdated: '',
          gender: '',
          weight: weight,
          height: height,
          controls: const [],
          consultationReason: consultationReason,
          observations: observations,
          patientHistories: patientHistories,
          symptoms: symptoms,
        ),
      );
      state = state.copyWith(isUpdatingRecord: false, updateErrorMessage: null);
    } catch (e) {
      state = state.copyWith(
        isUpdatingRecord: false,
        updateErrorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> getMedicalRecord(String patientId) async {
    state = state.copyWith(isLoadingRecord: true, recordErrorMessage: null);
    notifyListeners();

    try {
      final medicalRecord = await repository.getMedicalRecord(patientId);
      state = state.copyWith(
        isLoadingRecord: false,
        medicalRecord: medicalRecord,
        recordErrorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRecord: false,
        recordErrorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  void markPatientHasRecord(String patientId) {
    state = state.copyWith(
      patientHasRecord: {...state.patientHasRecord, patientId: true},
    );
    notifyListeners();
  }
}