import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../config/app_config.dart';
import '../dtos/pending_patients_response_dto.dart';

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

}