import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';

abstract class MedicalRecordRepository {
  Future<List<Patient>> getNursePatients();

  Future<void> postMedicalRecord(MedicalRecord medicalRecord);

  Future<MedicalRecord> getMedicalRecord(String patientId);

  Future<void> updateMedicalRecord(MedicalRecord updatedMedicalRecord);

  Future<void> getMedicalRecordPDF(String id);
}
