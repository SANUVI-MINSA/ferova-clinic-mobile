import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/hemoglobin_control_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/patient_history_dto.dart';

class GetPatientMedicalRecordResponseDto {
  final String id;
  final String patientId;
  final String patientName;
  final String updatedAt;
  final String gender;
  final double weight;
  final int height;
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

  factory GetPatientMedicalRecordResponseDto.fromJson(
      Map<String, dynamic> json,
      ) {
    print('🔍 GetPatientMedicalRecordResponseDto.fromJson: $json');

    // ✅ Extraer valores de objetos anidados
    final weightValue = _extractValue(json['weight']);
    final heightValue = _extractValue(json['height']);
    final motivoConsultaValue = _extractValue(json['motivoConsulta']);
    final observacionesValue = _extractValue(json['observaciones']);

    // ✅ Convertir gender de número a texto
    final genderText = _genderToString(json['gender']);

    return GetPatientMedicalRecordResponseDto(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      patientName: 'Paciente', // Se actualizará con el nombre desde el repositorio
      updatedAt: json['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
      gender: genderText,
      weight: weightValue is num ? weightValue.toDouble() : 0.0,
      height: heightValue is num ? heightValue.toInt() : 0,
      hemoglobinLevel: json['hemoglobinLevel'] != null
          ? (json['hemoglobinLevel'] as num).toDouble()
          : null,
      controls: (json['controls'] as List<dynamic>?)
          ?.map((e) => HemoglobinControlDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      motivoConsulta: motivoConsultaValue?.toString() ?? '',
      observaciones: observacionesValue?.toString() ?? '',
      antecedentes: (json['antecedentes'] as List<dynamic>?)
          ?.map((e) => PatientHistoryDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      sintomas: (json['sintomas'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  // ✅ Helper para extraer valor de objetos { value: ... }
  static dynamic _extractValue(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data['value'];
    }
    return data;
  }

  // ✅ Convertir gender numérico a texto
  static String _genderToString(dynamic gender) {
    if (gender == null) return 'No especificado';

    if (gender is int) {
      switch (gender) {
        case 1:
          return 'Femenino';
        case 2:
          return 'Masculino';
        default:
          return 'No especificado';
      }
    }

    if (gender is String) {
      // Si ya es texto, intentar normalizar
      final lower = gender.toLowerCase();
      if (lower.contains('fem') || lower == 'f' || lower == '1') return 'Femenino';
      if (lower.contains('mas') || lower == 'm' || lower == '2') return 'Masculino';
      return gender;
    }

    return 'No especificado';
  }
}