import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/analytics_repository.dart';
import 'estado_postas_state.dart';

class EstadoPostasViewModel extends ChangeNotifier {
  final AnalyticsRepository repository;

  EstadoPostasViewModel({required this.repository});

  EstadoPostasState _state = const EstadoPostasState();
  EstadoPostasState get state => _state;

  bool _isExporting = false;
  bool get isExporting => _isExporting;

  /// TPS-4: carga TODAS las postas (no solo el top)
  Future<void> load() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final postas = await repository.getAllFacilities();
      _state = _state.copyWith(isLoading: false, postas: postas);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudieron cargar las postas: $e',
      );
    }
    notifyListeners();
  }

  /// Descarga el reporte PDF. Devuelve los bytes, o null si falla.
  Future<Uint8List?> exportReport() async {
    if (_isExporting) return null;
    _isExporting = true;
    notifyListeners();

    try {
      return await repository.getReportPdf();
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }
}
