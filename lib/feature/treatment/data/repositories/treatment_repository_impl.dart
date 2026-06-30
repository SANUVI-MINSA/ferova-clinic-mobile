import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/pending_patients_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/treatment_service.dart';

class TreatmentRepositoryImpl implements TreatmentRepository{

  final TreatmentService service;

  const TreatmentRepositoryImpl({required this.service});


  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<PendingPatientsResponseDto> getPendingPatients() async {
    final token = await _token();
    return await service.getPendingPatients(token);
  }

  @override
  Future<StartTreatmentResponseDto> startTreatment(StartTreatmentRequestDto request) async {
    final token = await _token();
    return await service.startTreatment(request, token);
  }

}