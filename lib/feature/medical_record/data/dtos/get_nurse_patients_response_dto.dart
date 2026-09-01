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
    // ✅ Verificar si la respuesta es directa
    if (json.containsKey('patients') && json['patients'] is List) {
      final patientsList = json['patients'] as List<dynamic>;
      return GetNursePatientsResponseDto(
        success: json['success'] as bool? ?? true,
        status: json['status']?.toString() ?? 'SUCCESS',
        patients: patientsList
            .map((e) => PatientDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: patientsList.length,
      );
    }

    // ✅ Respuesta anidada en 'data'
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final patientsList = data['patients'] as List<dynamic>? ?? [];

    return GetNursePatientsResponseDto(
      success: json['success'] as bool? ?? true,
      status: json['status']?.toString() ?? 'SUCCESS',
      patients: patientsList
          .map((e) => PatientDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int? ?? patientsList.length,
    );
  }
}