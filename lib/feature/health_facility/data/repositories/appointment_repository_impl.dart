import 'package:ferova_clinic_flutter/feature/health_facility/data/services/appointment_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentService service;

  const AppointmentRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<List<Appointment>> getNurseAppointments() async {
    final token = await _token();
    final dtos = await service.getNurseAppointments(token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
