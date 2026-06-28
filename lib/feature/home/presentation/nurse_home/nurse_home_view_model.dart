import 'dart:async';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/nurse_repository.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_state.dart';
import 'package:flutter/cupertino.dart';

class NurseHomeViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final NurseRepository nurseRepository;
  NurseHomeState state = const NurseHomeState();
  Timer? _pollingTimer;

  NurseHomeViewModel({
    required this.authRepository,
    required this.nurseRepository,
  }) {
    _loadAll();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      Future.wait([
        _loadTopAppointments(silent: true),
        _loadRiskOverview(),
        _loadActivePatientCount(),
      ]);
    });
  }

  Future<void> logout() async {
    _pollingTimer?.cancel();
    await authRepository.logout();
  }

  Future<void> refresh() async {
    await _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadTopAppointments(),
      _loadRiskOverview(),
      _loadMyFacility(),
      _loadActivePatientCount(),
    ]);
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTopAppointments({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoadingAppointments: true);
      notifyListeners();
    }
    try {
      final appointments = await nurseRepository.getTopAppointments();
      state = state.copyWith(
        todayAppointments: appointments,
        isLoadingAppointments: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingAppointments: false, errorMessage: '$e');
    }
    notifyListeners();
  }

  Future<void> _loadRiskOverview() async {
    try {
      final overview = await nurseRepository.getRiskOverview();
      if (overview != null) {
        state = state.copyWith(
          highRiskCount: overview.highCount,
          mediumRiskCount: overview.mediumCount,
          lowRiskCount: overview.lowCount,
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _loadMyFacility() async {
    try {
      final facility = await nurseRepository.getMyFacility();
      if (facility != null) {
        state = state.copyWith(facilityName: facility.facilityName);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _loadActivePatientCount() async {
    try {
      final count = await nurseRepository.getActivePatientCount();
      state = state.copyWith(activePatients: count);
      notifyListeners();
    } catch (_) {}
  }
}
