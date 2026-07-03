import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_control.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/value_objects/patient_history.dart';

class MedicalRecord {
  final String id;
  final String patientId;
  final String patientName;
  final String lastUpdated;
  final String gender;
  final double weight;
  final int height;
  final List<HemoglobinControl> controls;
  final String consultationReason;
  final String observations;
  final List<PatientHistory> patientHistories;
  final List<String> symptoms;

  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.lastUpdated,
    required this.gender,
    required this.weight,
    required this.height,
    required this.controls,
    required this.consultationReason,
    required this.observations,
    required this.patientHistories,
    required this.symptoms,
  });
}
