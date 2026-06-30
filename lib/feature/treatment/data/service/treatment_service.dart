import 'dart:convert';
import 'dart:io';

import 'package:ferova_clinic_flutter/feature/treatment/data/dtos/start_treatment_response_dto.dart';
import 'package:http/http.dart' as http;

import '../../../../config/app_config.dart';
import '../dtos/pending_patients_response_dto.dart';
import '../dtos/start_treatment_request_dto.dart';
import '../dtos/treatments_card_response_dto.dart';

class TreatmentService {
  final String _baseUrl = '${AppConfig.baseUrl}/treatment-tracking';

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<PendingPatientsResponseDto> getPendingPatients(String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/nurses/pending-patients');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PendingPatientsResponseDto.fromJson(json);
      }
      throw Exception('Failed to fetch pending patients. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get pending patients. $e');
    }
  }

  Future<StartTreatmentResponseDto> startTreatment(
      StartTreatmentRequestDto request, String token
      ) async {
      try {
        final Uri uri = Uri.parse('$_baseUrl/treatments');
        final response = await http.post(
          uri,
          headers: _headers(token),
          body: jsonEncode(request.toJson()),
        );

        if (response.statusCode == HttpStatus.created) {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return StartTreatmentResponseDto.fromJson(json);
        }

        // Manejar error específico del backend
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorJson['error'] as String? ?? 'Error al iniciar el tratamiento');
      } catch (e) {
        throw Exception('Error al iniciar el tratamiento: $e');
      }
  }

  Future<TreatmentsCardResponseDto> getTreatmentsByNurse(
      String? status, String token
      ) async {
    try {
      // Construir la URL base
      final baseUri = Uri.parse('$_baseUrl/nurses/treatments');

      // Si status no es null y no es 'TODOS', agregar el parámetro
      final uri = (status != null && status != 'TODOS')
          ? baseUri.replace(queryParameters: {'status': status})
          : baseUri;

      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TreatmentsCardResponseDto.fromJson(json);
      }
      throw Exception('Failed to fetch treatments. ${response.body}');
    } catch (e){
      throw Exception('Failed to get treatments. $e');
    }
  }

}