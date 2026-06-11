import 'package:ferova_clinic_flutter/feature/home/domain/dashboard_summary.dart';

class DashboardSummaryDto {
  final int totalActiveFacilities;
  final int totalCriticalFacilities;
  final num globalAdherenceRate;

  const DashboardSummaryDto({
    required this.totalActiveFacilities,
    required this.totalCriticalFacilities,
    required this.globalAdherenceRate,
  });

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryDto(
      totalActiveFacilities: (json['totalActiveFacilities'] as num?)?.toInt() ?? 0,
      totalCriticalFacilities: (json['totalCriticalFacilities'] as num?)?.toInt() ?? 0,
      globalAdherenceRate: (json['globalAdherenceRate'] as num?) ?? 0,
    );
  }

  DashboardSummary toDomain() {
    return DashboardSummary(
      totalActiveFacilities: totalActiveFacilities,
      totalCriticalFacilities: totalCriticalFacilities,
      globalAdherenceRate: globalAdherenceRate.toDouble(),
    );
  }
}
