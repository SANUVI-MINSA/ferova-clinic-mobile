import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/patient_history_dto.dart';

class UpdateMedicalRecordRequestDto {
  final String patientId;
  final double weight;
  final int height;
  final String motivoConsulta;
  final String observaciones;
  final List<PatientHistoryDto> antecedentes;
  final List<String> sintomas;

  const UpdateMedicalRecordRequestDto({
    required this.patientId,
    required this.weight,
    required this.height,
    required this.motivoConsulta,
    required this.observaciones,
    required this.antecedentes,
    required this.sintomas,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'weight': weight,
      'height': height,
      'motivoConsulta': motivoConsulta,
      'observaciones': observaciones,
      'antecedentes': antecedentes.map((e) => e.toJson()).toList(),
      'sintomas': sintomas,
    };
  }
}
