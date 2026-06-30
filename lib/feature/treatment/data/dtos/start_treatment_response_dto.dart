import '../../domain/model/treatment.dart';

class StartTreatmentResponseDto {
  final String message;
  final Treatment? treatment;  // ✅ Ahora puede ser null
  final int totalGeneratedDoses;

  const StartTreatmentResponseDto({
    required this.message,
    this.treatment,  // ✅ No es required
    required this.totalGeneratedDoses,
  });

  factory StartTreatmentResponseDto.fromJson(Map<String, dynamic> json) {
    return StartTreatmentResponseDto(
      message: json['message'] as String? ?? 'Tratamiento iniciado',
      treatment: json['treatment'] != null
          ? Treatment.fromJson(json['treatment'] as Map<String, dynamic>)
          : null,
      totalGeneratedDoses: json['totalGeneratedDoses'] as int? ?? 0,
    );
  }
}