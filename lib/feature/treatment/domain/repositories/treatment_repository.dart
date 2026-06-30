import '../../data/dtos/abandon_treatment_request_dto.dart';
import '../../data/dtos/complete_treatment_request_dto.dart';
import '../../data/dtos/patient_monitor_response_dto.dart';
import '../../data/dtos/pending_patients_response_dto.dart';
import '../../data/dtos/risk_patients_response_dto.dart';
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

  // Ver pacientes por nivel de riesgo
  Future<RiskPatientsResponseDto> getPatientsByRiskLevel(String riskLevel);


  Future<PatientMonitorResponseDto> getPatientMonitor(String patientId);

}