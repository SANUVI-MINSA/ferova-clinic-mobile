import 'package:ferova_clinic_flutter/feature/treatment/domain/model/patient_monitor.dart';

class PatientMonitorResponseDto {
  final PatientMonitor patient;

  const PatientMonitorResponseDto({
    required this.patient,
  });

  factory PatientMonitorResponseDto.fromJson(Map<String, dynamic> json) {
    return PatientMonitorResponseDto(
      patient: PatientMonitor.fromJson(json),
    );
  }
}