import 'package:flutter/material.dart';

import '../../domain/repositories/communication_repository.dart';
import 'consultations_inbox_state.dart';

class ConsultationsInboxViewModel extends ChangeNotifier {
  final CommunicationRepository repository;
  ConsultationsInboxState state = const ConsultationsInboxState();

  int _requestId = 0;

  ConsultationsInboxViewModel({required this.repository});

  Future<void> getConsultations({String searchTerm = ''}) async {
    final int requestId = ++_requestId;

    print('🔄 ViewModel: Cargando consultas con searchTerm: "$searchTerm"');

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      searchTerm: searchTerm,
    );
    notifyListeners();

    try {
      final result = await repository.getConsultations(
        searchTerm: searchTerm,
      );

      if (requestId != _requestId) return;

      print('📊 ViewModel: Resultado recibido - Status: ${result.status}');
      print('📊 ViewModel: Cantidad de consultas: ${result.consultations.length}');

      state = state.copyWith(
        isLoading: false,
        result: result,
        errorMessage: null,
      );

    } catch (e, st) {
      print('❌ ViewModel: Error al cargar consultas: $e');
      print('❌ Stacktrace: $st');
      if (requestId != _requestId) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
    notifyListeners();
  }

  // ✅ Método para forzar recarga desde fuera
  void refresh() {
    print('🔄 ViewModel: Refresh manual solicitado');
    getConsultations(searchTerm: state.searchTerm);
  }
}