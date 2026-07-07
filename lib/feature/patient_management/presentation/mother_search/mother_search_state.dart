import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/mother.dart';

class MotherSearchState {
  final bool isLoading;
  final String? errorMessage;
  final List<Mother> mothers;  // ✅ Cambiado a List
  final Mother? selectedMother;

  const MotherSearchState({
    this.isLoading = false,
    this.errorMessage,
    this.mothers = const [],
    this.selectedMother,
  });

  MotherSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Mother>? mothers,
    Mother? selectedMother,
  }) {
    return MotherSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      mothers: mothers ?? this.mothers,
      selectedMother: selectedMother ?? this.selectedMother,
    );
  }
}