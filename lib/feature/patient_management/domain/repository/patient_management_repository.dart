import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/assignable_patient.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/mother.dart';

abstract class PatientManagementRepository {
  Future<Mother> searchMotherByDni(String search);

  Future<List<AssignablePatient>> getMotherPatients(String motherId);

  Future<void> assignNurseToPatient(String patientId);
}
