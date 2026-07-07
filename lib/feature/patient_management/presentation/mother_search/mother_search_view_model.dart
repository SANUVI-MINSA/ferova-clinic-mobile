import 'package:ferova_clinic_flutter/feature/patient_management/domain/repository/patient_management_repository.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_search/mother_search_state.dart';
import 'package:flutter/material.dart';

class MotherSearchViewModel extends ChangeNotifier {
  final PatientManagementRepository repository;
  MotherSearchState state = const MotherSearchState();

  MotherSearchViewModel({required this.repository});

  Future<bool> searchMotherByDni(String search) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final mother = await repository.searchMotherByDni(search);
      state = state.copyWith(
        isLoading: false,
        mother: mother,
        errorMessage: null,
      );
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      notifyListeners();
      return false;
    }
  }
}
