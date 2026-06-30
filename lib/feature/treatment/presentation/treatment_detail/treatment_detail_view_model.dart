import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatment_detail/treatment_detail_state.dart';
import 'package:flutter/cupertino.dart';
import '../../data/dtos/abandon_treatment_request_dto.dart';
import '../../data/dtos/complete_treatment_request_dto.dart';
import '../../domain/repositories/treatment_repository.dart';

class TreatmentDetailViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  TreatmentDetailState state = const TreatmentDetailState();
  final String treatmentId;

  TreatmentDetailViewModel({
    required this.repository,
    required this.treatmentId,
  }) {
    loadTreatmentDetail();
  }

  Future<void> loadTreatmentDetail() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final response = await repository.getTreatmentDetail(treatmentId);
      state = state.copyWith(
        isLoading: false,
        treatment: response.treatment,
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

  Future<void> completeTreatment(String observation) async {
    state = state.copyWith(isActionLoading: true);
    notifyListeners();

    try {
      final request = CompleteTreatmentRequestDto(
        treatmentId: treatmentId,
        observation: observation,
      );
      await repository.completeTreatment(request);

      // Recargar datos después de completar
      await loadTreatmentDetail();

      state = state.copyWith(isActionLoading: false);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString(),
      );
      notifyListeners();
      rethrow;
    }
  }

  Future<void> abandonTreatment(String observation) async {
    state = state.copyWith(isActionLoading: true);
    notifyListeners();

    try {
      final request = AbandonTreatmentRequestDto(
        treatmentId: treatmentId,
        observation: observation,
      );
      await repository.abandonTreatment(request);

      // Recargar datos después de abandonar
      await loadTreatmentDetail();

      state = state.copyWith(isActionLoading: false);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString(),
      );
      notifyListeners();
      rethrow;
    }
  }
}