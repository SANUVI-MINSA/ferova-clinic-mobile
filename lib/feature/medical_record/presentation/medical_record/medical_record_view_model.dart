import 'package:ferova_clinic_flutter/feature/medical_record/domain/repository/medical_record_repository.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_state.dart';
import 'package:flutter/material.dart';

class MedicalRecordViewModel extends ChangeNotifier {
  final MedicalRecordRepository repository;
  MedicalRecordState state = const MedicalRecordState();

  MedicalRecordViewModel({required this.repository}) {}

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
}
