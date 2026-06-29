
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/pending_patients/pending_patients_state.dart';
import 'package:flutter/cupertino.dart';

class PendingPatientsViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  PendingPatientsState state = const PendingPatientsState();

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

  void selectPatient(String patientId) {
    // TODO: Navegar a la página de iniciar tratamiento
  }

  void assignPatients() {
    // TODO: Navegar a la página de asignación de pacientes
  }
}