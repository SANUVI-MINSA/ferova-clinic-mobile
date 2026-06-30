import '../../data/dtos/pending_patients_response_dto.dart';
import '../../data/dtos/start_treatment_request_dto.dart';
import '../../data/dtos/start_treatment_response_dto.dart';

abstract class TreatmentRepository {
  // Obtener Pacientes pendientes
  Future<PendingPatientsResponseDto> getPendingPatients();
  // Iniciar tratamiento
  Future<StartTreatmentResponseDto> startTreatment(
      StartTreatmentRequestDto request,
      );
}