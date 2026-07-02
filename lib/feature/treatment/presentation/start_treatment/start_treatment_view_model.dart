import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/start_treatment/start_treatment_state.dart';
import 'package:flutter/material.dart';

class StartTreatmentViewModel extends ChangeNotifier {
  final TreatmentRepository repository;
  StartTreatmentState state;

  StartTreatmentViewModel({
    required this.repository,
    required String patientId,
    required String patientName,
  }) : state = StartTreatmentState(
    patientId: patientId,
    patientName: patientName,
  ) {
    _calculateEndDate();
  }

  void _calculateEndDate() {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: state.durationDays));
    state = state.copyWith(
      endDate: _formatDate(endDate),
    );
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${date.day} de ${months[date.month]}, ${date.year}';
  }

  void updateSupplementName(String value) {
    state = state.copyWith(supplementName: value);
    notifyListeners();
  }

  void updateQuantity(String value) {
    state = state.copyWith(quantity: value);
    notifyListeners();
  }

  void updateDosingHours(String value) {
    state = state.copyWith(dosingHours: value);
    notifyListeners();
  }

  void updateDurationDays(int value) {
    state = state.copyWith(durationDays: value);
    _calculateEndDate();
    notifyListeners();
  }

  Future<StartTreatmentResponseDto> startTreatment() async {
    // Validar que los campos no estén vacíos
    if (state.supplementName.trim().isEmpty ||
        state.quantity.trim().isEmpty ||
        state.dosingHours.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Por favor, completa todos los campos',
      );
      notifyListeners();
      throw Exception('Campos incompletos');
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final request = StartTreatmentRequestDto(
        patientId: state.patientId,
        supplementName: state.supplementName,
        quantity: state.quantity,
        dosingHours: state.dosingHours,
        durationDays: state.durationDays,
      );

      final response = await repository.startTreatment(request);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
      );
      notifyListeners();

      return response;

    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: errorMsg,
      );
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
    notifyListeners();
  }

  void resetState() {
    state = state.copyWith(isSuccess: false, errorMessage: null);
    notifyListeners();
  }
}