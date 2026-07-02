import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatments_list/treatments_list_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/treatment_repository.dart';
import '../treatment_detail/treatment_detail_page.dart';

class TreatmentsListViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  TreatmentsListState state = const TreatmentsListState();

  TreatmentsListViewModel({required this.repository}) {
    loadTreatments();
  }

  Future<void> loadTreatments({String? status}) async {
    // Si el status es 'TODOS', enviamos null al backend para obtener todos
    final effectiveStatus = (status == 'TODOS') ? null : status;

    state = state.copyWith(
        isLoading: true,
        selectedFilter: status // Guardamos el valor original ('TODOS' o el status específico)
    );
    notifyListeners();

    try {
      final response = await repository.getTreatmentsByNurse(status: effectiveStatus);

      final activeCount = response.treatments.where((t) => t.status == 'ACTIVE').length;
      final completedCount = response.treatments.where((t) => t.status == 'COMPLETED').length;
      final abandonedCount = response.treatments.where((t) => t.status == 'ABANDONED').length;

      state = state.copyWith(
        isLoading: false,
        treatments: response.treatments,
        errorMessage: null,
        selectedFilter: status, // Guardamos el valor original
        activeCount: activeCount,
        completedCount: completedCount,
        abandonedCount: abandonedCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  void filterByStatus(String status) {
    loadTreatments(status: status);
  }

  void clearFilter() {
    // Pasamos 'TODOS' para que se muestren todos
    loadTreatments(status: 'TODOS');
  }

  void viewTreatmentDetails(BuildContext context, String treatmentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TreatmentDetailPage(
          treatmentId: treatmentId,
        ),
      ),
    );
  }
}