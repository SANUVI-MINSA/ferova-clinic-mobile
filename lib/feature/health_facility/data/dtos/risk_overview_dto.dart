import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/risk_overview.dart';

class RiskOverviewDto {
  final int highCount;
  final int mediumCount;
  final int lowCount;
  final int total;

  const RiskOverviewDto({
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
    required this.total,
  });

  factory RiskOverviewDto.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>;
    final high = summary['HIGH'] as Map<String, dynamic>;
    final medium = summary['MEDIUM'] as Map<String, dynamic>;
    final low = summary['LOW'] as Map<String, dynamic>;
    return RiskOverviewDto(
      highCount: high['count'] as int,
      mediumCount: medium['count'] as int,
      lowCount: low['count'] as int,
      total: summary['total'] as int,
    );
  }

  RiskOverview toDomain() {
    return RiskOverview(
      highCount: highCount,
      mediumCount: mediumCount,
      lowCount: lowCount,
      total: total,
    );
  }
}
