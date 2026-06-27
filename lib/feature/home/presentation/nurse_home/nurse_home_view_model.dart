import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/nurse_repository.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_state.dart';
import 'package:flutter/cupertino.dart';

class NurseHomeViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final NurseRepository nurseRepository;
  NurseHomeState state = const NurseHomeState();

  NurseHomeViewModel({
    required this.authRepository,
    required this.nurseRepository,
  }) {
    _loadAll();
  }

  Future<void> logout() async {
    await authRepository.logout();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadTopAppointments(),
      _loadRiskOverview(),
      _loadMyFacility(),
      _loadActivePatientCount(),
    ]);
  }

  Future<void> _loadTopAppointments() async {
    state = state.copyWith(isLoadingAppointments: true);
    notifyListeners();
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
