import 'dart:typed_data';

import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/create_hemoglobin_level_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/create_medical_record_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/patient_history_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/dtos/update_medical_record_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/services/medical_record_service.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_control.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_controls.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/value_objects/patient_history.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/repository/medical_record_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordService service;

  const MedicalRecordRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<List<Patient>> getNursePatients() async {
    final token = await _token();
    try {
      final response = await service.getNursePatients(token);
      print('✅ getNursePatients - pacientes encontrados: ${response.patients.length}');

      return response.patients
          .map(
            (patient) => Patient(
          id: patient.patientId.isNotEmpty ? patient.patientId : 'unknown',
          fullName: patient.fullName.isNotEmpty ? patient.fullName : 'Sin nombre',
        ),
      )
          .toList();
    } catch (e) {
      print('❌ getNursePatients error: $e');
      // ✅ En caso de error, retornar lista vacía en lugar de lanzar excepción
      return [];
    }
  }

  @override
  Future<void> postMedicalRecord(MedicalRecord medicalRecord) async {
    final token = await _token();
    final dto = CreateMedicalRecordRequestDto(
      patientId: medicalRecord.patientId,
      weight: medicalRecord.weight,
      height: medicalRecord.height,
      motivoConsulta: medicalRecord.consultationReason,
      observaciones: medicalRecord.observations,
      antecedentes: medicalRecord.patientHistories
          .map(
            (history) => PatientHistoryDto(
              type: history.type,
              description: history.description,
            ),
          )
          .toList(),
      sintomas: medicalRecord.symptoms,
    );
    await service.createMedicalRecord(token, dto);
  }

  @override
  Future<MedicalRecord> getMedicalRecord(String patientId) async {
    final token = await _token();

    try {
      // Obtener el historial médico
      final response = await service.getPatientMedicalRecord(token, patientId);

      // Obtener el nombre del paciente (opcional: desde otro endpoint)
      // Si no tienes un endpoint para obtener el paciente, usa un valor por defecto
      final patientName = await _getPatientName(token, patientId);

      return MedicalRecord(
        id: response.id,
        patientId: response.patientId,
        patientName: patientName,
        lastUpdated: response.updatedAt,
        gender: response.gender,
        weight: response.weight,
        height: response.height,
        controls: response.controls
            .map(
              (control) => HemoglobinControl(
            id: control.id,
            date: control.date,
            hemoglobinLevel: control.hemoglobinLevel,
            anemiaStatus: control.anemiaStatus,
          ),
        )
            .toList(),
        consultationReason: response.motivoConsulta,
        observations: response.observaciones,
        patientHistories: response.antecedentes
            .map(
              (history) => PatientHistory(
            type: history.type,
            description: history.description,
          ),
        )
            .toList(),
        symptoms: response.sintomas,
      );
    } catch (e) {
      print('❌ getMedicalRecord error: $e');
      rethrow;
    }
  }

// ✅ Método auxiliar para obtener el nombre del paciente
  Future<String> _getPatientName(String token, String patientId) async {
    try {
      // Si tienes un endpoint para obtener información básica del paciente
      // final patient = await service.getPatientBasicInfo(token, patientId);
      // return '${patient.name} ${patient.lastName}';

      // Por ahora, retornamos un nombre por defecto
      return 'Paciente';
    } catch (e) {
      print('❌ Error getting patient name: $e');
      return 'Paciente';
    }
  }
  @override
  Future<void> updateMedicalRecord(MedicalRecord updatedMedicalRecord) async {
    final token = await _token();
    final dto = UpdateMedicalRecordRequestDto(
      patientId: updatedMedicalRecord.patientId,
      weight: updatedMedicalRecord.weight,
      height: updatedMedicalRecord.height,
      motivoConsulta: updatedMedicalRecord.consultationReason,
      observaciones: updatedMedicalRecord.observations,
      antecedentes: updatedMedicalRecord.patientHistories
          .map(
            (history) => PatientHistoryDto(
              type: history.type,
              description: history.description,
            ),
          )
          .toList(),
      sintomas: updatedMedicalRecord.symptoms,
    );
    await service.updateMedicalRecord(token, dto);
  }

  @override
  Future<Uint8List> getMedicalRecordPDF(String id) async {
    final token = await _token();
    return service.getMedicalRecordPdf(token, id);
  }

  @override
  Future<bool> checkMedicalRecord(String patientId) async {
    final token = await _token();
    try {
      final response = await service.checkMedicalRecord(token, patientId);
      print('✅ checkMedicalRecord result for $patientId: ${response.hasMedicalRecord}');
      return response.hasMedicalRecord;
    } catch (e) {
      print('❌ checkMedicalRecord repository error: $e');
      // ✅ Si falla, retornar false (NO HISTORIAL)
      return false;
    }
  }

  @override
  Future<void> createHemoglobinLevel(
    String patientId,
    double hemoglobinLevel,
  ) async {
    final token = await _token();
    final dto = CreateHemoglobinLevelRequestDto(
      patientId: patientId,
      hemoglobinLevel: hemoglobinLevel,
    );
    await service.createHemoglobinLevel(token, dto);
  }

  @override
  Future<HemoglobinControls> getHemoglobinControls(
    String medicalRecordId,
  ) async {
    final token = await _token();
    final response = await service.getHemoglobinControls(
      token,
      medicalRecordId,
    );
    return HemoglobinControls(
      patientId: response.patientId,
      controls: response.controls
          .map(
            (control) => HemoglobinControl(
              id: control.id,
              date: control.date,
              hemoglobinLevel: control.hemoglobinLevel,
              anemiaStatus: control.anemiaStatus,
            ),
          )
          .toList(),
      averageHemoglobin: response.averageHemoglobin,
      evolution: response.evolution,
    );
  }

  @override
  Future<Uint8List> getHemoglobinReportPdf(String medicalRecordId) async {
    final token = await _token();
    return service.getHemoglobinReportPdf(token, medicalRecordId);
  }
}
