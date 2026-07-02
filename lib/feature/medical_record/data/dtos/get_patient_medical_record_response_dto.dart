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
    final patient = json['patient'] as Map<String, dynamic>;
    final medicalRecord = json['medicalRecord'] as Map<String, dynamic>;

    return GetPatientMedicalRecordResponseDto(
      id: medicalRecord['id'] as String,
      patientId: patient['id'] as String,
      patientName: '${patient['name']} ${patient['lastName']}',
      updatedAt: medicalRecord['updatedAt'] as String,
      gender: medicalRecord['gender'] as String,
      weight: (medicalRecord['weight'] as num).toDouble(),
      height: medicalRecord['height'] as int,
      hemoglobinLevel: (medicalRecord['hemoglobinLevel'] as num?)
          ?.toDouble(),
      controls: (medicalRecord['controls'] as List<dynamic>)
          .map(
            (e) => HemoglobinControlDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      motivoConsulta: medicalRecord['motivoConsulta'] as String,
      observaciones: medicalRecord['observaciones'] as String,
      antecedentes: (medicalRecord['antecedentes'] as List<dynamic>)
          .map((e) => PatientHistoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      sintomas: (medicalRecord['sintomas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
