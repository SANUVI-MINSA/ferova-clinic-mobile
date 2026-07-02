import 'package:ferova_clinic_flutter/feature/treatment/domain/model/treatment_summary.dart';

class TreatmentsListState {

  final bool isLoading;
  final String? errorMessage;
  final List<TreatmentSummary> treatments;
  final String? selectedFilter; // 'TODOS', 'ACTIVE', 'COMPLETED', 'ABANDONED' o null
  final int activeCount;
  final int completedCount;
  final int abandonedCount;

  const TreatmentsListState({
    this.isLoading = false,
    this.errorMessage,
    this.treatments = const [],
    this.selectedFilter,
    this.activeCount = 0,
    this.completedCount = 0,
    this.abandonedCount = 0,
  });

  TreatmentsListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<TreatmentSummary>? treatments,
    String? selectedFilter,
    int? activeCount,
    int? completedCount,
    int? abandonedCount,
  }) {
    return TreatmentsListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      treatments: treatments ?? this.treatments,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      activeCount: activeCount ?? this.activeCount,
      completedCount: completedCount ?? this.completedCount,
      abandonedCount: abandonedCount ?? this.abandonedCount,
    );
  }

  List<TreatmentSummary> get filteredTreatments {
    // Si selectedFilter es null o 'TODOS', mostrar todos los tratamientos
    if (selectedFilter == null || selectedFilter == 'TODOS') {
      return treatments;
    }
    return treatments.where((t) => t.status == selectedFilter).toList();
  }
}