import 'package:ferova_clinic_flutter/feature/treatment/presentation/patient_monitor/patient_monitor_state.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/repositories/treatment_repository.dart';

class PatientMonitorViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  PatientMonitorState state = const PatientMonitorState();
  final String patientId;

  PatientMonitorViewModel({
    required this.repository,
    required this.patientId,
  }) {
    loadPatientMonitor();
  }

  Future<void> loadPatientMonitor() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final response = await repository.getPatientMonitor(patientId);
      state = state.copyWith(
        isLoading: false,
        patient: response.patient,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }
}
