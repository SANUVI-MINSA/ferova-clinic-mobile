import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_facility_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/risk_overview_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/top_appointment_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NurseService {
  final String _baseUrl = AppConfig.baseUrl;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<TopAppointmentDto>> getTopAppointments(String token, {int limit = 4}) async {
    try {
      final uri = Uri.parse('$_baseUrl/health-facilities/appointments/nurse/top?limit=$limit');
      debugPrint('TOP APPOINTMENTS → GET $uri');
      final response = await http.get(uri, headers: _headers(token));
      debugPrint('TOP APPOINTMENTS ← ${response.statusCode}: ${response.body}');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final list = json['data'] as List<dynamic>;
        return list
            .map((e) => TopAppointmentDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('TopAppointments network error: $e');
      return [];
    }
  }

  Future<RiskOverviewDto?> getRiskOverview(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/treatment-tracking/risk-overview');
      final response = await http.get(uri, headers: _headers(token));
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return RiskOverviewDto.fromJson(json);
      }
      debugPrint('RiskOverview error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('RiskOverview network error: $e');
      return null;
    }
  }

  Future<NurseFacilityDto?> getMyFacility(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/health-facilities/nurse/my-facility');
      final response = await http.get(uri, headers: _headers(token));
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return NurseFacilityDto.fromJson(json);
      }
      // 404 = enfermero sin posta asignada, no es un error
      if (response.statusCode == HttpStatus.notFound) return null;
      debugPrint('MyFacility error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('MyFacility network error: $e');
      return null;
    }
  }

  Future<int> getActivePatientCount(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/patients/nurse/active-count');
      final response = await http.get(uri, headers: _headers(token));
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['activePatientsCount'] as int;
      }
      debugPrint('ActiveCount error ${response.statusCode}: ${response.body}');
      return 0;
    } catch (e) {
      debugPrint('ActiveCount network error: $e');
      return 0;
    }
  }
}
