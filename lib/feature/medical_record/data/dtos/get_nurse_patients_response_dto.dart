import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/patient_dto.dart';

class GetNursePatientsResponseDto {
  final bool success;
  final String status;
  final List<PatientDto> patients;
  final int total;

  const GetNursePatientsResponseDto({
    required this.success,
    required this.status,
    required this.patients,
    required this.total,
  });

  factory GetNursePatientsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GetNursePatientsResponseDto(
      success: json['success'] as bool,
      status: json['status'] as String,
      patients: (data['patients'] as List<dynamic>)
          .map((e) => PatientDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int,
    );
  }
}
