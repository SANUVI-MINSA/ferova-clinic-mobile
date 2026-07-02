import 'package:ferova_clinic_flutter/feature/treatment/presentation/risk_patients/risk_patients_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/treatment_repository.dart';
import '../patient_monitor/patient_monitor_page.dart';

class RiskPatientsViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  RiskPatientsState state;

  RiskPatientsViewModel({
    required this.repository,
    required String riskLevel,
  }) : state = RiskPatientsState(riskLevel: riskLevel) {
    loadPatients();
  }

  Future<void> loadPatients() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final response = await repository.getPatientsByRiskLevel(state.riskLevel);
      state = state.copyWith(
        isLoading: false,
        patients: response.patients,
        total: response.total,
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

  void viewPatientDetail(BuildContext context, String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientMonitorPage(
          patientId: patientId,
        ),
      ),
    );
  }
}