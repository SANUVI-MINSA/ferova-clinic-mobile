import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';

/// DTO para un item de /analytics/facilities y /analytics/facilities/top
class FacilityDto {
  final String facilityId;
  final String facilityName;
  final String districtName;
  final num adherenceRate;
  final String riskLevel;
  final int totalPatients;
  final int totalConfirmed;
  final int totalOmitted;

  const FacilityDto({
    required this.facilityId,
    required this.facilityName,
    required this.districtName,
    required this.adherenceRate,
    required this.riskLevel,
    required this.totalPatients,
    required this.totalConfirmed,
    required this.totalOmitted,
  });

  factory FacilityDto.fromJson(Map<String, dynamic> json) {
    return FacilityDto(
      facilityId: json['facilityId'] as String? ?? '',
      facilityName: json['facilityName'] as String? ?? '',
      districtName: json['districtName'] as String? ?? '',
      adherenceRate: (json['adherenceRate'] as num?) ?? 0,
      riskLevel: json['riskLevel'] as String? ?? 'LOW',
      totalPatients: (json['totalPatients'] as num?)?.toInt() ?? 0,
      totalConfirmed: (json['totalConfirmed'] as num?)?.toInt() ?? 0,
      totalOmitted: (json['totalOmitted'] as num?)?.toInt() ?? 0,
    );
  }

  Posta toDomain() {
    return Posta(
      id: facilityId,
      name: facilityName,
      coveragePercentage: adherenceRate.toDouble(),
      status: postaStatusFromRiskLevel(riskLevel),
      location: districtName,
    );
  }
}
