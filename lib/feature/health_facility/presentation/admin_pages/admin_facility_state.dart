import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';

class AdminFacilityState {
  final bool isLoadingFacilities;
  final String? errorMessage;
  final List<AdminFacility> adminFacilities;
  final bool isLoadingNurseAvailability;
  final bool canRegisterFacilty;
  final String? canRegisterMessage;
  final String? canRegisterDetails;

  const AdminFacilityState({
    this.isLoadingFacilities = false,
    this.errorMessage,
    this.adminFacilities = const [],
    this.isLoadingNurseAvailability = false,
    this.canRegisterFacilty = false,
    this.canRegisterMessage,
    this.canRegisterDetails,
  });

  AdminFacilityState copyWith({
    bool? isLoadingFacilities,
    String? errorMessage,
    List<AdminFacility>? adminFacilities,
    bool? isLoadingNurseAvailability,
    bool? canRegisterFacilty,
    String? canRegisterMessage,
    String? canRegisterDetails,
  }) {
    return AdminFacilityState(
      isLoadingFacilities: isLoadingFacilities ?? this.isLoadingFacilities,
      errorMessage: errorMessage,
      adminFacilities: adminFacilities ?? this.adminFacilities,
      isLoadingNurseAvailability:
          isLoadingNurseAvailability ?? this.isLoadingNurseAvailability,
      canRegisterFacilty: canRegisterFacilty ?? this.canRegisterFacilty,
      canRegisterMessage: canRegisterMessage ?? this.canRegisterMessage,
      canRegisterDetails: canRegisterDetails ?? this.canRegisterDetails,
    );
  }
}
