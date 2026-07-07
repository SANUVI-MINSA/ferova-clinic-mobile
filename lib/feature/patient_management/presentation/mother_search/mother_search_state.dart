import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/mother.dart';

class MotherSearchState {
  final bool isLoading;
  final String? errorMessage;
  final Mother? mother;

  const MotherSearchState({
    this.isLoading = false,
    this.errorMessage,
    this.mother,
  });

  MotherSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    Mother? mother,
  }) {
    return MotherSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      mother: mother ?? this.mother,
    );
  }
}
