import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/pending_patients_response_dto.dart';

class PendingPatientsState {
  final bool isLoading;
  final String? errorMessage;
  final PendingPatientsResponseDto? response;

  const PendingPatientsState({
    this.isLoading = false,
    this.errorMessage,
    this.response,
  });

  PendingPatientsState copyWith({
    bool? isLoading,
    String? errorMessage,
    PendingPatientsResponseDto? response,
  }) {
    return PendingPatientsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      response: response ?? this.response,
    );
  }
}