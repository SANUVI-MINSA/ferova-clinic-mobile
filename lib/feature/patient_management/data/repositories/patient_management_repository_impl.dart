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

  // ✅ CAMBIADO: ahora devuelve List<Mother>
  @override
  Future<List<Mother>> searchMotherByDni(String search) async {
    final token = await _token();
    final dtos = await service.searchMotherByDni(token, search);
    return dtos
        .map(
          (dto) => Mother(
        motherId: dto.motherId,
        fullName: dto.fullName,
        dni: dto.dni,
      ),
    )
        .toList();
  }

  @override
  Future<List<AssignablePatient>> getMotherPatients(String motherId) async {
    final token = await _token();
    try {
      final patients = await service.getMotherPatients(token, motherId);

      // ✅ Si la lista está vacía, retornar lista vacía
      if (patients.isEmpty) {
        return [];
      }

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
    } catch (e) {
      print('❌ Error en getMotherPatients: $e');
      // ✅ En lugar de lanzar excepción, retornar lista vacía
      return [];
    }
  }

  @override
  Future<void> assignNurseToPatient(String patientId) async {
    final token = await _token();
    final dto = AssignNurseRequestDto(patientId: patientId);
    await service.assignNurseToPatient(token, dto);
  }
}