// medical_record/data/dtos/get_patient_medical_record_response_dto.dart

import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/hemoglobin_control_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/patient_history_dto.dart';

class GetPatientMedicalRecordResponseDto {
  final String id;
  final String patientId;
  final String patientName;  // ✅ AHORA VIENE DEL BACKEND
  final String updatedAt;
  final String gender;
  final double weight;
  final double height;
  final double? hemoglobinLevel;
  final List<HemoglobinControlDto> controls;
  final String motivoConsulta;
  final String observaciones;
  final List<PatientHistoryDto> antecedentes;
  final List<String> sintomas;

  const GetPatientMedicalRecordResponseDto({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.updatedAt,
    required this.gender,
    required this.weight,
    required this.height,
    required this.hemoglobinLevel,
    required this.controls,
    required this.motivoConsulta,
    required this.observaciones,
    required this.antecedentes,
    required this.sintomas,
  });

  factory GetPatientMedicalRecordResponseDto.fromJson(Map<String, dynamic> json) {
    print('🔍 GetPatientMedicalRecordResponseDto.fromJson: $json');

    // ✅ Ahora los valores vienen directos, no anidados
    return GetPatientMedicalRecordResponseDto(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? 'Paciente',  // ✅ AHORA VIENE DEL BACKEND
      updatedAt: json['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
      gender: _genderToString(json['gender']),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,  // ✅ Directo
      height: (json['height'] as num?)?.toDouble() ?? 0.0,  // ✅ Directo
      hemoglobinLevel: (json['hemoglobinLevel'] as num?)?.toDouble(),
      controls: (json['controls'] as List<dynamic>?)
          ?.map((e) => HemoglobinControlDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      motivoConsulta: json['motivoConsulta']?.toString() ?? '',
      observaciones: json['observaciones']?.toString() ?? '',
      antecedentes: (json['antecedentes'] as List<dynamic>?)
          ?.map((e) => PatientHistoryDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      sintomas: (json['sintomas'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  // ✅ Convertir gender (puede ser string "FEMALE"/"MALE" o número)
  static String _genderToString(dynamic gender) {
    if (gender == null) return 'No especificado';

    if (gender is String) {
      final upper = gender.toUpperCase();
      if (upper == 'FEMALE' || upper == 'FEMENINO') return 'Femenino';
      if (upper == 'MALE' || upper == 'MASCULINO') return 'Masculino';
      return gender;
    }

    if (gender is int) {
      switch (gender) {
        case 1: return 'Femenino';
        case 2: return 'Masculino';
        default: return 'No especificado';
      }
    }

    return 'No especificado';
  }
}