import '../../data/dtos/AbandonTreatmentRequestDto.dart';
import '../../data/dtos/CompleteTreatmentRequestDto.dart';
import '../../data/dtos/pending_patients_response_dto.dart';
import '../../data/dtos/start_treatment_request_dto.dart';
import '../../data/dtos/start_treatment_response_dto.dart';
import '../../data/dtos/treatment_detail_response_dto.dart';
import '../../data/dtos/treatments_card_response_dto.dart';

abstract class TreatmentRepository {
  // Obtener Pacientes pendientes
  Future<PendingPatientsResponseDto> getPendingPatients();
  // Iniciar tratamiento
  Future<StartTreatmentResponseDto> startTreatment(
      StartTreatmentRequestDto request,
      );
  // Ver Cards de tratamientos
  Future<TreatmentsCardResponseDto> getTreatmentsByNurse({
    String? status,
  });

  // Ver detalle del tratamiento
  Future<TreatmentDetailResponseDto> getTreatmentDetail(String treatmentId);

  // Completar tratamiento
  Future<void> completeTreatment(CompleteTreatmentRequestDto request);

  // Abandonar tratamiento
  Future<void> abandonTreatment(AbandonTreatmentRequestDto request);
}