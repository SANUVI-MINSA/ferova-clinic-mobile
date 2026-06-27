import 'package:ferova_clinic_flutter/feature/health_facility/data/services/nurse_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/risk_overview.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/nurse_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NurseRepositoryImpl implements NurseRepository {
  final NurseService service;

  const NurseRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<List<Appointment>> getTopAppointments() async {
    final token = await _token();
    final dtos = await service.getTopAppointments(token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<RiskOverview?> getRiskOverview() async {
    final token = await _token();
    final dto = await service.getRiskOverview(token);
    return dto?.toDomain();
  }

  @override
  Future<NurseFacility?> getMyFacility() async {
    final token = await _token();
    final dto = await service.getMyFacility(token);
    return dto?.toDomain();
  }

  @override
  Future<int> getActivePatientCount() async {
    final token = await _token();
    return service.getActivePatientCount(token);
  }
}
