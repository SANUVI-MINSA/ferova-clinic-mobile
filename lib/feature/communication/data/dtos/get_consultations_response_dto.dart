import 'package:ferova_clinic_flutter/feature/communication/data/dtos/consultation_dto.dart';

/// The `GET /communication/consultations/nurse` endpoint returns a
/// discriminated union at the JSON top level: either a plain array of
/// consultations, or an object describing one of three special states
/// (`NO_CONSULTAS`, `SIN_PACIENTES`, `BUSQUEDA_SIN_RESULTADOS`).
///
/// [status] is `null` when the response was a `List` (i.e. there are active
/// consultations).
class GetConsultationsResponseDto {
  final List<ConsultationDto> consultations;
  final String? status;
  final String? message;
  final String? detail;
  final String? searchTerm;

  const GetConsultationsResponseDto({
    this.consultations = const [],
    this.status,
    this.message,
    this.detail,
    this.searchTerm,
  });

  factory GetConsultationsResponseDto.fromJson(dynamic json) {
    if (json is List) {
      return GetConsultationsResponseDto(
        consultations: json
            .map((e) => ConsultationDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    if (json is Map<String, dynamic>) {
      return GetConsultationsResponseDto(
        status: json['status'] as String?,
        message: json['message'] as String?,
        detail: json['detail'] as String?,
        searchTerm: json['searchTerm'] as String?,
      );
    }

    throw Exception('Unexpected consultations response shape: $json');
  }
}
