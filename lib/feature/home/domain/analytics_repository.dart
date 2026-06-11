import 'dart:typed_data';

import 'dashboard_summary.dart';
import 'posta.dart';

abstract class AnalyticsRepository {
  /// TPS-1: resumen del dashboard (postas activas, críticas, adherencia global)
  Future<DashboardSummary> getDashboardSummary();

  /// TPS-2: top 4 postas con mayor adherencia
  Future<List<Posta>> getTopFacilities();

  /// TPS-3: puntos del mapa de calor (coordenadas + nivel de riesgo)
  Future<List<Posta>> getHeatmapPoints();

  /// TPS-4: todas las postas con adherencia y nivel de riesgo
  Future<List<Posta>> getAllFacilities();

  /// Reporte PDF con el resumen de postas (devuelve los bytes, null si falla)
  Future<Uint8List?> getReportPdf();
}
