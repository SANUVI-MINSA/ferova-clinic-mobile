import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';

class AdminFacilityState {
  final bool isLoadingFacilities;
  final String? errorMessage;
  final List<AdminFacility> adminFacilities;

  const AdminFacilityState({
    this.isLoadingFacilities = false,
    this.errorMessage,
    this.adminFacilities = const [],
  });

  AdminFacilityState copyWith({
    bool? isLoadingFacilities,
    String? errorMessage,
    List<AdminFacility>? adminFacilities,
  }) {
    return AdminFacilityState(
      isLoadingFacilities: isLoadingFacilities ?? this.isLoadingFacilities,
      errorMessage: errorMessage,
      adminFacilities: adminFacilities ?? this.adminFacilities,
    );
  }
}
