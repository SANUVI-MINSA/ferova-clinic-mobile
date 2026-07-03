import 'dart:typed_data';

import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_controls.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';

abstract class MedicalRecordRepository {
  Future<List<Patient>> getNursePatients();

  Future<void> postMedicalRecord(MedicalRecord medicalRecord);

  Future<MedicalRecord> getMedicalRecord(String patientId);

  Future<void> updateMedicalRecord(MedicalRecord updatedMedicalRecord);

  Future<Uint8List> getMedicalRecordPDF(String id);

  Future<bool> checkMedicalRecord(String patientId);

  Future<void> createHemoglobinLevel(String patientId, double hemoglobinLevel);

  Future<HemoglobinControls> getHemoglobinControls(String medicalRecordId);

  Future<Uint8List> getHemoglobinReportPdf(String medicalRecordId);
}
