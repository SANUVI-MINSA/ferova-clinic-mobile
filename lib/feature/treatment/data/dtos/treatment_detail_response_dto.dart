import '../../domain/model/treatment_detail.dart';

class TreatmentDetailResponseDto {
  final TreatmentDetail treatment;

  const TreatmentDetailResponseDto({
    required this.treatment,
  });

  factory TreatmentDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return TreatmentDetailResponseDto(
      treatment: TreatmentDetail.fromJson(json),
    );
  }
}