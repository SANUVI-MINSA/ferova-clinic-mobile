import 'package:ferova_clinic_flutter/feature/treatment/domain/model/treatment_summary.dart';

class TreatmentsCardResponseDto {
  final String nurseId;
  final List<TreatmentSummary> treatments;

  const TreatmentsCardResponseDto({
    required this.nurseId,
    required this.treatments,
  });

  factory TreatmentsCardResponseDto.fromJson(Map<String, dynamic> json) {
    return TreatmentsCardResponseDto(
      nurseId: json['nurseId'] as String,
      treatments: (json['treatments'] as List<dynamic>)
          .map((e) => TreatmentSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}