import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/dashboard_summary.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';

class AdminHomeState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  /// Top postas (TPS-2) — se muestran en "Estado de Postas" del home
  final List<Posta> topPostas;

  /// Puntos del mapa de calor (TPS-3)
  final List<Posta> heatmapPostas;

  /// Resumen del dashboard (TPS-1)
  final DashboardSummary summary;

  const AdminHomeState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.topPostas = const [],
    this.heatmapPostas = const [],
    this.summary = DashboardSummary.empty,
  });

  AdminHomeState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    List<Posta>? topPostas,
    List<Posta>? heatmapPostas,
    DashboardSummary? summary,
  }) {
    return AdminHomeState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      topPostas: topPostas ?? this.topPostas,
      heatmapPostas: heatmapPostas ?? this.heatmapPostas,
      summary: summary ?? this.summary,
    );
  }
}
