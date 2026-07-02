import 'package:ferova_clinic_flutter/feature/treatment/domain/model/pending_patient.dart';

class PendingPatientsResponseDto {
  final String nurseId;
  final bool hasPatientsAssigned;
  final bool hasPendingPatients;
  final List<PendingPatient> pendingPatients;
  final String? message;

  const PendingPatientsResponseDto({
    required this.nurseId,
    required this.hasPatientsAssigned,
    required this.hasPendingPatients,
    required this.pendingPatients,
    this.message,
  });

  factory PendingPatientsResponseDto.fromJson(Map<String, dynamic> json) {
    return PendingPatientsResponseDto(
      nurseId: json['nurseId'] as String,
      hasPatientsAssigned: json['hasPatientsAssigned'] as bool,
      hasPendingPatients: json['hasPendingPatients'] as bool,
      pendingPatients: (json['pendingPatients'] as List<dynamic>)
          .map((e) => PendingPatient.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );
  }
}