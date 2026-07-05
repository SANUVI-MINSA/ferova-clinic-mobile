import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_controls.dart';

class HemoglobinControlState {
  final bool isCreatingLevel;
  final String? createErrorMessage;
  final bool isLoadingControls;
  final String? controlsErrorMessage;
  final HemoglobinControls? hemoglobinControls;

  const HemoglobinControlState({
    this.isCreatingLevel = false,
    this.createErrorMessage,
    this.isLoadingControls = false,
    this.controlsErrorMessage,
    this.hemoglobinControls,
  });

  HemoglobinControlState copyWith({
    bool? isCreatingLevel,
    String? createErrorMessage,
    bool? isLoadingControls,
    String? controlsErrorMessage,
    HemoglobinControls? hemoglobinControls,
  }) {
    return HemoglobinControlState(
      isCreatingLevel: isCreatingLevel ?? this.isCreatingLevel,
      createErrorMessage: createErrorMessage,
      isLoadingControls: isLoadingControls ?? this.isLoadingControls,
      controlsErrorMessage: controlsErrorMessage,
      hemoglobinControls: hemoglobinControls ?? this.hemoglobinControls,
    );
  }
}
