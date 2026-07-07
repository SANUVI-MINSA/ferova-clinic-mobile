import 'package:ferova_clinic_flutter/feature/health_facility/data/services/discharge_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/discharge_patient.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/discharge_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DischargeRepositoryImpl implements DischargeRepository {
  final DischargeService service;

  const DischargeRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<List<DischargePatient>> getDischargePatients({String? searchTerm}) async {
    final token = await _token();
    debugPrint('🔑 Token disponible: ${token.isNotEmpty ? "✅ Sí" : "❌ No"}');

    if (token.isEmpty) {
      debugPrint('⚠️ Token vacío, no se puede obtener pacientes');
      return [];
    }

    final dtos = await service.getDischargePatients(token, searchTerm: searchTerm);
    debugPrint('📊 Pacientes obtenidos: ${dtos.length}');
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> dischargePatient(String patientId) async {
    final token = await _token();
    await service.dischargePatient(token, patientId);
  }
}