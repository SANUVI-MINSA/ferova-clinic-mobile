import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/available_nurse_response_dto.dart';

class AvailableNursesResponseDto {
  final bool success;
  final List<AvailableNurseResponseDto> data;

  const AvailableNursesResponseDto({required this.success, required this.data});

  factory AvailableNursesResponseDto.fromJson(Map<String, dynamic> json) {
    return AvailableNursesResponseDto(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((item) => AvailableNurseResponseDto.fromJson(item))
          .toList(),
    );
  }
}
