import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/abandon_treatment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/complete_treatment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/pending_patients_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/treatment_detail_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/treatments_card_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dtos/risk_patients_response_dto.dart';
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

  @override
  Future<TreatmentsCardResponseDto> getTreatmentsByNurse({String? status}) async {
    final token = await _token();
    return await service.getTreatmentsByNurse(status, token);
  }

  @override
  Future<void> abandonTreatment(AbandonTreatmentRequestDto request) async {
    final token = await _token();
    return await service.abandonTreatment(request, token);
  }

  @override
  Future<void> completeTreatment(CompleteTreatmentRequestDto request) async {
    final token = await _token();
    return await service.completeTreatment(request, token);
  }

  @override
  Future<TreatmentDetailResponseDto> getTreatmentDetail(String treatmentId) async {
    final token = await _token();
    return await service.getTreatmentDetail(treatmentId, token);
  }

  @override
  Future<RiskPatientsResponseDto> getPatientsByRiskLevel(String riskLevel) async {
    final token = await _token();
    return await service.getPatientsByRiskLevel(riskLevel, token);
  }

}