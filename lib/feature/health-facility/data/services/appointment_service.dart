import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/health-facility/data/dtos/appointment_response_dto.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  final String _baseUrl =
      '${AppConfig.baseUrl}/health-facilities/appointments/nurse';

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<List<AppointmentResponseDto>> getNurseAppointments(
    String token,
  ) async {
    try {
      final Uri uri = Uri.parse(_baseUrl);
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as List;
        return json
            .map((item) => AppointmentResponseDto.fromJson(item))
            .toList();
      }
      throw Exception('Failed to fetch nurse appointments. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get info from endpoint. $e');
    }
  }
}
