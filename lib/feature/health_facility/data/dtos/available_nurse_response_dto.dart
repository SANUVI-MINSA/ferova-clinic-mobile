import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse.dart';

class AvailableNurseResponseDto {
  final String id;
  final String fullName;

  const AvailableNurseResponseDto({required this.id, required this.fullName});

  factory AvailableNurseResponseDto.fromJson(Map<String, dynamic> json) {
    return AvailableNurseResponseDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
    );
  }

  Nurse toDomain() {
    return Nurse(id: id, fullName: fullName);
  }
}
