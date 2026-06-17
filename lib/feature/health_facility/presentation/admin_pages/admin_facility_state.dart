import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/district.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse.dart';

class AdminFacilityState {
  final bool isLoadingFacilities;
  final String? errorMessage;
  final List<AdminFacility> adminFacilities;
  final bool isLoadingNurseAvailability;
  final bool canRegisterFacilty;
  final bool isLoadingAvailableNurses;
  final List<Nurse> availableNurses;
  final bool isLoadingNurseAssignment;
  final bool isNurseAssigned;
  final String? assignmentMessage;
  final List<District> districts;

  const AdminFacilityState({
    this.isLoadingFacilities = false,
    this.errorMessage,
    this.adminFacilities = const [],
    this.isLoadingNurseAvailability = false,
    this.canRegisterFacilty = false,
    this.isLoadingAvailableNurses = false,
    this.availableNurses = const [],
    this.isLoadingNurseAssignment = false,
    this.isNurseAssigned = false,
    this.assignmentMessage,
    this.districts = const [],
  });

  AdminFacilityState copyWith({
    bool? isLoadingFacilities,
    String? errorMessage,
    List<AdminFacility>? adminFacilities,
    bool? isLoadingNurseAvailability,
    bool? canRegisterFacilty,
    bool? isLoadingAvailableNurses,
    List<Nurse>? availableNurses,
    bool? isLoadingNurseAssignment,
    bool? isNurseAssigned,
    String? assignmentMessage,
    List<District>? districts,
  }) {
    return AdminFacilityState(
      isLoadingFacilities: isLoadingFacilities ?? this.isLoadingFacilities,
      errorMessage: errorMessage,
      adminFacilities: adminFacilities ?? this.adminFacilities,
      isLoadingNurseAvailability:
          isLoadingNurseAvailability ?? this.isLoadingNurseAvailability,
      canRegisterFacilty: canRegisterFacilty ?? this.canRegisterFacilty,
      isLoadingAvailableNurses:
          isLoadingFacilities ?? this.isLoadingAvailableNurses,
      availableNurses: availableNurses ?? this.availableNurses,
      isLoadingNurseAssignment:
          isLoadingNurseAssignment ?? this.isLoadingNurseAssignment,
      isNurseAssigned: isNurseAssigned ?? this.isNurseAssigned,
      assignmentMessage: assignmentMessage ?? this.assignmentMessage,
      districts: districts ?? this.districts,
    );
  }
}
