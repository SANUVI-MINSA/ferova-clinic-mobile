import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';

/// DTO para un punto de /analytics/heatmap
class HeatmapPointDto {
  final String facilityId;
  final String facilityName;
  final double lat;
  final double lng;
  final String riskLevel;
  final num adherenceRate;

  const HeatmapPointDto({
    required this.facilityId,
    required this.facilityName,
    required this.lat,
    required this.lng,
    required this.riskLevel,
    required this.adherenceRate,
  });

  factory HeatmapPointDto.fromJson(Map<String, dynamic> json) {
    return HeatmapPointDto(
      facilityId: json['facilityId'] as String? ?? '',
      facilityName: json['facilityName'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? -12.046374,
      lng: (json['lng'] as num?)?.toDouble() ?? -77.042793,
      riskLevel: json['riskLevel'] as String? ?? 'LOW',
      adherenceRate: (json['adherenceRate'] as num?) ?? 0,
    );
  }

  Posta toDomain() {
    return Posta(
      id: facilityId,
      name: facilityName,
      coveragePercentage: adherenceRate.toDouble(),
      status: postaStatusFromRiskLevel(riskLevel),
      location: '',
      latitude: lat,
      longitude: lng,
    );
  }
}
