import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_available_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse.dart';

abstract class AdminFacilityRepository {
  Future<List<AdminFacility>> getHealthFacilities();

  Future<NurseAvailableResponseDto> canRegisterFacility();

  Future<List<Nurse>> getAvailableNurses();
}
