import 'package:ferova_clinic_flutter/feature/patient_management/data/dtos/assign_nurse_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/data/services/patient_management_service.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/assignable_patient.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/mother.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/domain/repository/patient_management_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientManagementRepositoryImpl implements PatientManagementRepository {
  final PatientManagementService service;

  const PatientManagementRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<Mother> searchMotherByDni(String search) async {
    final token = await _token();
    final dto = await service.searchMotherByDni(token, search);
    return Mother(motherId: dto.motherId, fullName: dto.fullName, dni: dto.dni);
  }

  @override
  Future<List<AssignablePatient>> getMotherPatients(String motherId) async {
    final token = await _token();
    final patients = await service.getMotherPatients(token, motherId);
    return patients
        .map(
          (patient) => AssignablePatient(
            patientId: patient.patientId,
            patientName: patient.patientName,
            patientLastName: patient.patientLastName,
            gender: patient.gender,
            status: patient.status,
            statusAssignment: patient.statusAssignment == 'ASSIGNED'
                ? AssignmentStatus.assigned
                : AssignmentStatus.unassigned,
          ),
        )
        .toList();
  }

  @override
  Future<void> assignNurseToPatient(String patientId) async {
    final token = await _token();
    final dto = AssignNurseRequestDto(patientId: patientId);
    await service.assignNurseToPatient(token, dto);
  }
}
