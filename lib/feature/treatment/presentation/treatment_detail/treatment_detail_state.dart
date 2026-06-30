import '../../domain/model/treatment_detail.dart';

class TreatmentDetailState {
  final bool isLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final TreatmentDetail? treatment;

  const TreatmentDetailState({
    this.isLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.treatment,
  });

  TreatmentDetailState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    String? errorMessage,
    TreatmentDetail? treatment,
  }) {
    return TreatmentDetailState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: errorMessage,
      treatment: treatment ?? this.treatment,
    );
  }
}