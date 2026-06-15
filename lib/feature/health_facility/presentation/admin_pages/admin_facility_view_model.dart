import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_available_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/admin_facility_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_state.dart';
import 'package:flutter/material.dart';

class AdminFacilityViewModel extends ChangeNotifier {
  final AdminFacilityRepository repository;
  AdminFacilityState state = AdminFacilityState();

  AdminFacilityViewModel({required this.repository}) {
    getHealthFacilities();
  }

  Future<void> getHealthFacilities() async {
    state = state.copyWith(isLoadingFacilities: true);
    notifyListeners();

    try {
      List<AdminFacility> healthFacilities = await repository
          .getHealthFacilities();
      state = state.copyWith(
        adminFacilities: healthFacilities,
        isLoadingFacilities: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingFacilities: false, errorMessage: '$e');
    }
    notifyListeners();
  }

  Future<void> canRegisterFacility() async {
    state = state.copyWith(isLoadingNurseAvailability: true);
    notifyListeners();

    try {
      NurseAvailableResponseDto response = await repository
          .canRegisterFacility();
      state = state.copyWith(
        isLoadingNurseAvailability: false,
        canRegisterFacilty: response.available,
        canRegisterMessage: response.message,
        canRegisterDetails: response.details,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingNurseAvailability: false,
        errorMessage: '$e',
      );
    }
  }
}
