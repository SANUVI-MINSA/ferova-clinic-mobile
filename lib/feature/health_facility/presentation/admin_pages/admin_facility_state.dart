import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';

class AdminFacilityState {
  final bool isLoadingFacilities;
  final String? errorMessage;
  final List<AdminFacility> adminFacilities;
  final bool isLoadingNurseAvailability;
  final bool canRegisterFacilty;

  const AdminFacilityState({
    this.isLoadingFacilities = false,
    this.errorMessage,
    this.adminFacilities = const [],
    this.isLoadingNurseAvailability = false,
    this.canRegisterFacilty = false,
  });

  AdminFacilityState copyWith({
    bool? isLoadingFacilities,
    String? errorMessage,
    List<AdminFacility>? adminFacilities,
    bool? isLoadingNurseAvailability,
    bool? canRegisterFacilty,
  }) {
    return AdminFacilityState(
      isLoadingFacilities: isLoadingFacilities ?? this.isLoadingFacilities,
      errorMessage: errorMessage,
      adminFacilities: adminFacilities ?? this.adminFacilities,
      isLoadingNurseAvailability:
          isLoadingNurseAvailability ?? this.isLoadingNurseAvailability,
      canRegisterFacilty: canRegisterFacilty ?? this.canRegisterFacilty,
    );
  }
}
