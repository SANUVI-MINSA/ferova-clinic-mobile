import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/hemoglobin_control_dto.dart';

class GetHemoglobinControlsResponseDto {
  final String patientId;
  final List<HemoglobinControlDto> controls;
  final double averageHemoglobin;
  final double evolution;

  const GetHemoglobinControlsResponseDto({
    required this.patientId,
    required this.controls,
    required this.averageHemoglobin,
    required this.evolution,
  });

  factory GetHemoglobinControlsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetHemoglobinControlsResponseDto(
      patientId: json['patientId'] as String,
      controls: (json['controls'] as List<dynamic>)
          .map(
            (e) => HemoglobinControlDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      averageHemoglobin: (json['averageHemoglobin'] as num).toDouble(),
      evolution: (json['evolution'] as num).toDouble(),
    );
  }
}