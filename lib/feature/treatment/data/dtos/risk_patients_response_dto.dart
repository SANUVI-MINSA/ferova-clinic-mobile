import '../../domain/model/risk_patient.dart';

class RiskPatientsResponseDto {
  final String riskLevel;
  final int total;
  final List<RiskPatient> patients;

  const RiskPatientsResponseDto({
    required this.riskLevel,
    required this.total,
    required this.patients,
  });

  factory RiskPatientsResponseDto.fromJson(Map<String, dynamic> json) {
    return RiskPatientsResponseDto(
      riskLevel: json['riskLevel'] as String,
      total: json['total'] as int,
      patients: (json['patients'] as List<dynamic>)
          .map((e) => RiskPatient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}