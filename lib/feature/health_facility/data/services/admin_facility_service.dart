import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/admin_facilities_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/admin_facility_registration_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/admin_facility_registration_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/admin_facility_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/available_nurses_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/district_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_assignment_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_assignment_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/dtos/nurse_availability_response_dto.dart';
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

  Future<NurseAvailabilityResponseDto> canRegisterFacility(String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/can-register');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return NurseAvailabilityResponseDto.fromJson(json);
      }
      throw Exception('Failed to fetch nurse availability. ${response.body}');
    } catch (e) {
      throw Exception('Failed to check nurse availability. $e');
    }
  }

  Future<AvailableNursesResponseDto> getAvailableNurses(String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/nurses/unassigned');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AvailableNursesResponseDto.fromJson(json);
      }
      throw Exception('Failed to fetch available nurses. ${response.body}');
    } catch (e) {
      throw Exception('Failed to check available nurses. $e');
    }
  }

  Future<NurseAssignmentResponseDto> postNurseAssignment(
    String token,
    NurseAssignmentRequestDto request,
  ) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/assign-nurse');
      final response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return NurseAssignmentResponseDto.fromJson(json);
      }

      throw Exception('Failed to fetch nurse assignment. ${response.body}');
    } catch (e) {
      throw Exception('Failed to post nurse assignment. $e');
    }
  }

  Future<AdminFacilityRegistrationResponseDto> postAdminFacility(
    String token,
    AdminFacilityRegistrationRequestDto request,
  ) async {
    try {
      final Uri uri = Uri.parse(_baseUrl);
      final response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.created) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AdminFacilityRegistrationResponseDto.fromJson(json);
      }
      throw Exception(
        'Failed to fetch health facility registration. ${response.body}',
      );
    } catch (e) {
      throw Exception('Failed to post health facility. $e');
    }
  }

  Future<List<DistrictDto>> getDistricts(String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/districts');
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as List;
        return json.map((item) => DistrictDto.fromJson(item)).toList();
      }

      throw Exception('Failed to fetch districts. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get info from endpoint. $e');
    }
  }
}
