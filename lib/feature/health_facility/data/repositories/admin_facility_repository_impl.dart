import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_available_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/services/admin_facility_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/admin_facility_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminFacilityRepositoryImpl implements AdminFacilityRepository {
  final AdminFacilityService service;

  const AdminFacilityRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<List<AdminFacility>> getHealthFacilities() async {
    final token = await _token();
    final dtos = await service.getFacilities(token);
    return dtos.map((item) => item.toDomain()).toList();
  }

  @override
  Future<NurseAvailableResponseDto> canRegisterFacility() async {
    final token = await _token();
    final dto = await service.canRegisterFacility(token);
    return dto;
  }
}
