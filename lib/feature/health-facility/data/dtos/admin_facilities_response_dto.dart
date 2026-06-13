import 'package:ferova_clinic_flutter/feature/health-facility/data/dtos/admin_facility_response_dto.dart';

class AdminFacilitiesResponseDto {
  final int total;
  final List<AdminFacilityResponseDto> healthFacilities; // ← tipo correcto

  const AdminFacilitiesResponseDto({
    required this.total,
    required this.healthFacilities,
  });

  factory AdminFacilitiesResponseDto.fromJson(Map<String, dynamic> json) {
    return AdminFacilitiesResponseDto(
      total: json['total'] as int,
      healthFacilities: (json['healthFacilities'] as List)
          .map((item) => AdminFacilityResponseDto.fromJson(item))
          .toList(),
    );
  }
}
