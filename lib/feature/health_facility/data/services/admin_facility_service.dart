import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/admin_facilities_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/admin_facility_response_dto.dart';
import 'package:http/http.dart' as http;

class AdminFacilityService {
  final String _baseUrl = '${AppConfig.baseUrl}/health-facilities';

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<List<AdminFacilityResponseDto>> getFacilities(String token) async {
    try {
      final Uri uri = Uri.parse(_baseUrl);
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final AdminFacilitiesResponseDto dto =
            AdminFacilitiesResponseDto.fromJson(json);
        return dto.healthFacilities;
      }
      throw Exception('Failed to fetch admin facilities. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get info from endpoint. $e');
    }
  }
}
