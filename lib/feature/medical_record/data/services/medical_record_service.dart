import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/create_hemoglobin_level_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/create_medical_record_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/get_check_medical_record_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/get_hemoglobin_controls_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/get_nurse_patients_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/get_patient_medical_record_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/update_medical_record_request_dto.dart';
import 'package:http/http.dart' as http;

import '../dtos/patient_dto.dart';

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

      print('📡 getNursePatients - Status: ${response.statusCode}');
      print('📡 getNursePatients - Body: ${response.body}');

      if (response.statusCode == HttpStatus.ok) {
        final dynamic json = jsonDecode(response.body);

        // ✅ Verificar que la respuesta no sea null
        if (json == null) {
          throw Exception('La respuesta del servidor es null');
        }

        // ✅ Si la respuesta es directa (lista)
        if (json is List) {
          final patients = json.map((e) => PatientDto.fromJson(e as Map<String, dynamic>)).toList();
          return GetNursePatientsResponseDto(
            success: true,
            status: 'SUCCESS',
            patients: patients,
            total: patients.length,
          );
        }

        // ✅ Si la respuesta es un Map
        if (json is Map<String, dynamic>) {
          return GetNursePatientsResponseDto.fromJson(json);
        }

        throw Exception('Formato de respuesta inesperado');
      }
      throw Exception('Failed to fetch nurse patients. ${response.body}');
    } catch (e) {
      print('❌ getNursePatients error: $e');
      throw Exception('Failed to get nurse patients. $e');
    }
  }

  Future<void> createMedicalRecord(
    String token,
    CreateMedicalRecordRequestDto dto,
  ) async {
    try {
      final Uri uri = Uri.parse(_baseUrl);
      final http.Response response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.created) {
        return;
      }
      throw Exception('Failed to create medical record. ${response.body}');
    } catch (e) {
      throw Exception('Failed to create medical record. $e');
    }
  }

  Future<GetPatientMedicalRecordResponseDto> getPatientMedicalRecord(
      String token,
      String patientId,
      ) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/patients/$patientId/medical-record',
      );
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );

      print('📡 getPatientMedicalRecord - Status: ${response.statusCode}');
      print('📡 getPatientMedicalRecord - Body: ${response.body}');

      if (response.statusCode == HttpStatus.ok) {
        final dynamic json = jsonDecode(response.body);

        if (json == null) {
          throw Exception('El paciente no tiene historial médico');
        }

        if (json is Map<String, dynamic>) {
          return GetPatientMedicalRecordResponseDto.fromJson(json);
        }

        throw Exception('Formato de respuesta inesperado');
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Exception('El paciente no tiene historial médico');
      }

      throw Exception('Failed to get patient\'s medical record. ${response.body}');
    } catch (e) {
      print('❌ getPatientMedicalRecord error: $e');
      throw Exception('Failed to get patient\'s medical record. $e');
    }
  }

  Future<void> updateMedicalRecord(
    String token,
    UpdateMedicalRecordRequestDto dto,
  ) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/update');
      final http.Response response = await http.put(
        uri,
        headers: _headers(token),
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return;
      }
      throw Exception('Failed to update medical record. ${response.body}');
    } catch (e) {
      throw Exception('Failed to update medical record. $e');
    }
  }

  Future<Uint8List> getMedicalRecordPdf(
    String token,
    String medicalRecordId,
  ) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/$medicalRecordId/pdf');
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        return response.bodyBytes;
      }
      throw Exception('Failed to get medical record pdf. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get medical record pdf. $e');
    }
  }

  Future<GetCheckMedicalRecordResponseDto> checkMedicalRecord(
      String token,
      String patientId,
      ) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/patients/$patientId/medical-record/check',
      );
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );

      print('📡 checkMedicalRecord - Status: ${response.statusCode}');
      print('📡 checkMedicalRecord - Body: ${response.body}');
      print('📡 checkMedicalRecord - patientId: $patientId');

      if (response.statusCode == HttpStatus.ok) {
        final dynamic json = jsonDecode(response.body);

        // ✅ Si la respuesta es un bool directo
        if (json is bool) {
          return GetCheckMedicalRecordResponseDto(
            patientId: patientId,
            hasMedicalRecord: json,
          );
        }

        // ✅ Si la respuesta es un Map
        if (json is Map<String, dynamic>) {
          return GetCheckMedicalRecordResponseDto.fromJson(json);
        }

        // ✅ Si la respuesta es null
        if (json == null) {
          return GetCheckMedicalRecordResponseDto(
            patientId: patientId,
            hasMedicalRecord: false,
          );
        }

        // ✅ Fallback
        return GetCheckMedicalRecordResponseDto(
          patientId: patientId,
          hasMedicalRecord: false,
        );
      }
      throw Exception('Failed to check medical record. ${response.body}');
    } catch (e) {
      print('❌ checkMedicalRecord error: $e');
      throw Exception('Failed to check medical record. $e');
    }
  }

  Future<void> createHemoglobinLevel(
    String token,
    CreateHemoglobinLevelRequestDto dto,
  ) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/patients/hemoglobin-control',
      );
      final http.Response response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.created) {
        return;
      }
      throw Exception('Failed to create hemoglobin level. ${response.body}');
    } catch (e) {
      throw Exception('Failed to create hemoglobin level. $e');
    }
  }

  Future<GetHemoglobinControlsResponseDto> getHemoglobinControls(
    String token,
    String medicalRecordId,
  ) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/$medicalRecordId/controls');
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return GetHemoglobinControlsResponseDto.fromJson(json);
      }
      throw Exception('Failed to get hemoglobin controls. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get hemoglobin controls. $e');
    }
  }

  Future<Uint8List> getHemoglobinReportPdf(
    String token,
    String medicalRecordId,
  ) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/$medicalRecordId/hemoglobin-report');
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        return response.bodyBytes;
      }
      throw Exception('Failed to get hemoglobin report pdf. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get hemoglobin report pdf. $e');
    }
  }
}
