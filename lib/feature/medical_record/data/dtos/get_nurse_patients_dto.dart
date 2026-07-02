import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/patient_dto.dart';

class GetNursePatientsDto {
  final bool success;
  final String status;
  final List<PatientDto> patients;
  final int total;

  const GetNursePatientsDto({
    required this.success,
    required this.status,
    required this.patients,
    required this.total,
  });

  factory GetNursePatientsDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GetNursePatientsDto(
      success: json['success'] as bool,
      status: json['status'] as String,
      patients: (data['patients'] as List<dynamic>)
          .map((e) => PatientDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int,
    );
  }
}