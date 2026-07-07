import 'dart:convert';
import 'dart:io';

import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/data/dtos/assign_nurse_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/data/dtos/assignable_patient_dto.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/data/dtos/mother_dto.dart';
import 'package:http/http.dart' as http;

import '../../domain/execptions/nurse_not_assigned_exception.dart';

class PatientManagementService {
  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<MotherDto> searchMotherByDni(String token, String search) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/patients/mother/search/$search',
      );
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        final dynamic json = jsonDecode(response.body);
        // El backend responde con un array (aunque solo pueda haber una
        // coincidencia de DNI exacto), no con un objeto plano.
        final Map<String, dynamic> motherJson = json is List
            ? json.first as Map<String, dynamic>
            : json as Map<String, dynamic>;
        return MotherDto.fromJson(motherJson);
      }
      throw Exception('Failed to search mother. ${response.body}');
    } catch (e) {
      throw Exception('Failed to search mother. $e');
    }
  }

  Future<List<AssignablePatientDto>> getMotherPatients(
    String token,
    String motherId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/patients/mother/$motherId',
      );
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map(
              (e) => AssignablePatientDto.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      throw Exception('Failed to get mother\'s patients. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get mother\'s patients. $e');
    }
  }

  Future<void> assignNurseToPatient(
    String token,
    AssignNurseRequestDto dto,
  ) async {
    try {
      final Uri uri = Uri.parse('${AppConfig.baseUrl}/patients/assign-nurse');
      final http.Response response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return;
      }
      if (response.statusCode == HttpStatus.notFound) {
        throw const NurseNotAssignedException(
          'Nurse is not assigned to any facility',
        );
      }
      throw Exception('Failed to assign nurse to patient. ${response.body}');
    } on NurseNotAssignedException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to assign nurse to patient. $e');
    }
  }
}
