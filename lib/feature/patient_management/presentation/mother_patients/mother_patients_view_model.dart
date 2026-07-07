import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/assignable_patient.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/domain/repository/patient_management_repository.dart';
import 'package:flutter/material.dart';

import '../../domain/execptions/nurse_not_assigned_exception.dart';

enum AssignNurseResult { success, noFacilityAssigned, error }

class MotherPatientsState {
  final bool isLoading;
  final String? errorMessage;
  final List<AssignablePatient> patients;
  final bool isAssigning;
  final String? assigningPatientId;
  final String? assignErrorMessage;

  const MotherPatientsState({
    this.isLoading = false,
    this.errorMessage,
    this.patients = const [],
    this.isAssigning = false,
    this.assigningPatientId,
    this.assignErrorMessage,
  });

  MotherPatientsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<AssignablePatient>? patients,
    bool? isAssigning,
    String? assigningPatientId,
    String? assignErrorMessage,
  }) {
    return MotherPatientsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      patients: patients ?? this.patients,
      isAssigning: isAssigning ?? this.isAssigning,
      assigningPatientId: assigningPatientId,
      assignErrorMessage: assignErrorMessage,
    );
  }
}

class MotherPatientsViewModel extends ChangeNotifier {
  final PatientManagementRepository repository;
  MotherPatientsState state = const MotherPatientsState();

  MotherPatientsViewModel({required this.repository});

  Future<void> getMotherPatients(String motherId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final patients = await repository.getMotherPatients(motherId);
      state = state.copyWith(
        isLoading: false,
        patients: patients,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
    notifyListeners();
  }

  Future<AssignNurseResult> assignNurseToPatient(String patientId) async {
    state = state.copyWith(
      isAssigning: true,
      assigningPatientId: patientId,
      assignErrorMessage: null,
    );
    notifyListeners();

    try {
      await repository.assignNurseToPatient(patientId);
      final updatedPatients = state.patients
          .map(
            (patient) => patient.patientId == patientId
                ? patient.copyWith(statusAssignment: AssignmentStatus.assigned)
                : patient,
          )
          .toList();
      state = state.copyWith(
        isAssigning: false,
        assigningPatientId: null,
        patients: updatedPatients,
        assignErrorMessage: null,
      );
      notifyListeners();
      return AssignNurseResult.success;
    } on NurseNotAssignedException catch (e) {
      state = state.copyWith(
        isAssigning: false,
        assigningPatientId: null,
        assignErrorMessage: e.toString(),
      );
      notifyListeners();
      return AssignNurseResult.noFacilityAssigned;
    } catch (e) {
      state = state.copyWith(
        isAssigning: false,
        assigningPatientId: null,
        assignErrorMessage: e.toString(),
      );
      notifyListeners();
      return AssignNurseResult.error;
    }
  }
}
