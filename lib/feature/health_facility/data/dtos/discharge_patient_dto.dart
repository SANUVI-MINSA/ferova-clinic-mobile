import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/discharge_patient.dart';

class DischargePatientDto {
  final String id;
  final String name;
  final String lastName;

  const DischargePatientDto({
    required this.id,
    required this.name,
    required this.lastName,
  });

  factory DischargePatientDto.fromJson(Map<String, dynamic> json) {
    return DischargePatientDto(
      id: json['id'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
    );
  }

  DischargePatient toDomain() => DischargePatient(
        id: id,
        name: name,
        lastName: lastName,
      );
}
