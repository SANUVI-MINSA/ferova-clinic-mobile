import '../../data/dtos/pending_patients_response_dto.dart';

abstract class TreatmentRepository {
  Future<PendingPatientsResponseDto> getPendingPatients();
}