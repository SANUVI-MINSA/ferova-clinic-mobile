import 'package:ferova_clinic_flutter/feature/medical_record/domain/repository/medical_record_repository.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/hemoglobin_control_state.dart';
import 'package:flutter/material.dart';

class HemoglobinControlViewModel extends ChangeNotifier {
  final MedicalRecordRepository repository;
  HemoglobinControlState state = const HemoglobinControlState();

  HemoglobinControlViewModel({required this.repository});

  Future<bool> createHemoglobinLevel(
    String patientId,
    double hemoglobinLevel,
  ) async {
    state = state.copyWith(isCreatingLevel: true, createErrorMessage: null);
    notifyListeners();

    try {
      await repository.createHemoglobinLevel(patientId, hemoglobinLevel);
      state = state.copyWith(isCreatingLevel: false, createErrorMessage: null);
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(
        isCreatingLevel: false,
        createErrorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }
}
