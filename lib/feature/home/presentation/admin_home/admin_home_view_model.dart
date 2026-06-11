import 'package:flutter/material.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/analytics_repository.dart';
import 'admin_home_state.dart';

class AdminHomeViewModel extends ChangeNotifier {
  final AnalyticsRepository repository;
  final AuthRepository authRepository;

  AdminHomeViewModel({
    required this.repository,
    required this.authRepository,
  });

  AdminHomeState _state = const AdminHomeState();
  AdminHomeState get state => _state;

  void init(User user) {
    _state = _state.copyWith(user: user);
    _loadData();
  }

  Future<void> refresh() => _loadData();

  Future<void> _loadData() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      // TPS-1 (summary), TPS-2 (top), TPS-3 (heatmap) en paralelo
      final summaryFuture = repository.getDashboardSummary();
      final topFuture = repository.getTopFacilities();
      final heatmapFuture = repository.getHeatmapPoints();

      _state = _state.copyWith(
        isLoading: false,
        summary: await summaryFuture,
        topPostas: await topFuture,
        heatmapPostas: await heatmapFuture,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudieron cargar los datos: $e',
      );
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await authRepository.logout();
  }
}
