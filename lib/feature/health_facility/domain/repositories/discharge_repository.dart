import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/discharge_patient.dart';

abstract class DischargeRepository {
  Future<List<DischargePatient>> getDischargePatients({String? searchTerm});
  Future<void> dischargePatient(String patientId);
}
