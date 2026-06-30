import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/discharge_patient_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DischargeService {
  final String _baseUrl = AppConfig.baseUrl;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<DischargePatientDto>> getDischargePatients(
    String token, {
    String? searchTerm,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (searchTerm != null && searchTerm.isNotEmpty) {
        queryParams['searchTerm'] = searchTerm;
      }
      final uri = Uri.parse('$_baseUrl/patients/discharge/nurse')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      debugPrint('DISCHARGE PATIENTS → GET $uri');
      final response = await http.get(uri, headers: _headers(token));
      debugPrint('DISCHARGE PATIENTS ← ${response.statusCode}: ${response.body}');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>;
        final list = data['patients'] as List<dynamic>;
        return list
            .map((e) => DischargePatientDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('DischargePatients network error: $e');
      return [];
    }
  }

  Future<void> dischargePatient(String token, String patientId) async {
    final uri = Uri.parse('$_baseUrl/patients/discharge');
    debugPrint('DISCHARGE → PUT $uri  patientId=$patientId');
    final response = await http.put(
      uri,
      headers: _headers(token),
      body: jsonEncode({'patientId': patientId}),
    );
    debugPrint('DISCHARGE ← ${response.statusCode}: ${response.body}');
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Error al dar de alta: ${response.body}');
    }
  }
}
