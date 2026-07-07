
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/pending_patients/pending_patients_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../patient_management/presentation/mother_search/mother_search_page.dart';
import '../start_treatment/start_treatment_page.dart';

class PendingPatientsViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  PendingPatientsState state = const PendingPatientsState();
  VoidCallback? onGoToPatients;

  PendingPatientsViewModel({required this.repository}) {
    loadPendingPatients();
  }

  Future<void> loadPendingPatients() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final response = await repository.getPendingPatients();
      state = state.copyWith(
        isLoading: false,
        response: response,
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

  void selectPatient(BuildContext context, String patientId, String patientName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartTreatmentPage(
          patientId: patientId,
          patientName: patientName,
        ),
      ),
    );
  }


  void assignPatients(BuildContext context) {
    // Usar el callback para ir a la pestaña de pacientes
    if (onGoToPatients != null) {
      onGoToPatients!();
      Navigator.pop(context);
    }
  }
}