import 'package:ferova_clinic_flutter/feature/health-facility/data/services/admin_facility_service.dart';
import 'package:ferova_clinic_flutter/feature/health-facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health-facility/domain/repositories/admin_facility_repository.dart';
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
}
