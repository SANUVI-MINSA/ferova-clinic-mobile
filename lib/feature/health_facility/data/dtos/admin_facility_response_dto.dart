import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';

class AdminFacilityResponseDto {
  final String id;
  final String name;
  final String address;
  final String? assignedNurseName;
  final bool hasNurseAssigned;
  final String? displayMessage;

  const AdminFacilityResponseDto({
    required this.id,
    required this.name,
    required this.address,
    this.assignedNurseName,
    required this.hasNurseAssigned,
    this.displayMessage,
  });

  factory AdminFacilityResponseDto.fromJson(Map<String, dynamic> json) {
    return AdminFacilityResponseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      assignedNurseName: json['assignedNurseName'] as String?,
      hasNurseAssigned: json['hasNurseAssigned'] as bool,
      displayMessage: json['displayMessage'] as String?,
    );
  }

  AdminFacility toDomain() {
    return AdminFacility(
      id: id,
      name: name,
      address: address,
      hasNurseAssigned: hasNurseAssigned,
      assignedNurseName: assignedNurseName ?? '',
      displayMessage: displayMessage ?? '',
    );
  }
}
