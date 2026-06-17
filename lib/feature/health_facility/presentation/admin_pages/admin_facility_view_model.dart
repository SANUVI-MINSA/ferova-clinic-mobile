import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_assignment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_assignment_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_availability_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/district.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse.dart';
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
    state = state.copyWith(isLoadingFacilities: true, errorMessage: null);
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
    state = state.copyWith(
      isLoadingNurseAvailability: true,
      errorMessage: null,
    );
    notifyListeners();

    try {
      NurseAvailabilityResponseDto response = await repository
          .canRegisterFacility();
      state = state.copyWith(
        isLoadingNurseAvailability: false,
        canRegisterFacilty: response.available,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingNurseAvailability: false,
        errorMessage: '$e',
      );
    }
  }

  Future<void> getAvailableNurses() async {
    state = state.copyWith(isLoadingAvailableNurses: true, errorMessage: null);
    notifyListeners();

    try {
      List<Nurse> availableNurses = await repository.getAvailableNurses();
      state = state.copyWith(
        availableNurses: availableNurses,
        isLoadingAvailableNurses: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingAvailableNurses: false,
        errorMessage: '$e',
      );
    }
    notifyListeners();
  }

  Future<void> assignNurse(String facilityId, String nurseId) async {
    state = state.copyWith(isLoadingNurseAssignment: true, errorMessage: null);
    notifyListeners();

    NurseAssignmentRequestDto request = NurseAssignmentRequestDto(
      facilityId: facilityId,
      nurseId: nurseId,
    );
    NurseAssignmentResponseDto dto = await repository.assignNurse(request);
    if (dto.message != null) {
      state = state.copyWith(
        isNurseAssigned: true,
        isLoadingNurseAssignment: false,
        assignmentMessage: dto.message,
      );
    } else {
      state = state.copyWith(
        isNurseAssigned: false,
        isLoadingNurseAssignment: false,
        errorMessage: dto.error,
      );
    }
  }

  Future<void> getDistricts() async {
    state = state.copyWith(isLoadingDistricts: true, errorMessage: null);
    notifyListeners();
    try {
      List<District> districts = await repository.getDistricts();
      state = state.copyWith(districts: districts, isLoadingDistricts: false);
    } catch (e) {
      state = state.copyWith(isLoadingDistricts: false, errorMessage: '$e');
    }
    notifyListeners();
  }
}
