import 'dart:convert';
import 'dart:io';

import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/get_nurse_patients_response_dto.dart';
import 'package:http/http.dart' as http;

class MedicalRecordService {
  final String _baseUrl = '${AppConfig.baseUrl}/patients/medical-record';

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<GetNursePatientsResponseDto> getNursePatients(String token) async {
    try {
      final Uri uri = Uri.parse('${AppConfig.baseUrl}/patients/nurse');
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final GetNursePatientsResponseDto dto =
            GetNursePatientsResponseDto.fromJson(json);
        return dto;
      }
      throw Exception('Failed to fetch nurse patients. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get nurse patients: $e');
    }
  }
}
