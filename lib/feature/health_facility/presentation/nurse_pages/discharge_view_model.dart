import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/discharge_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/discharge_state.dart';
import 'package:flutter/material.dart';

class DischargeViewModel extends ChangeNotifier {
  final DischargeRepository repository;
  DischargeState state = const DischargeState();

  DischargeViewModel({required this.repository}) {
    getPatients();
  }

  Future<void> getPatients({String? searchTerm, bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoading: true);
      notifyListeners();
    }
    try {
      final patients = await repository.getDischargePatients(searchTerm: searchTerm);
      state = state.copyWith(patients: patients, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '$e');
    }
    notifyListeners();
  }

  Future<void> dischargePatient(String patientId) async {
    state = state.copyWith(isDischarging: true);
    notifyListeners();
    try {
      await repository.dischargePatient(patientId);
      // Refrescar lista tras alta exitosa
      await getPatients(silent: true);
      state = state.copyWith(isDischarging: false);
    } catch (e) {
      state = state.copyWith(isDischarging: false, errorMessage: '$e');
    }
    notifyListeners();
  }
}
