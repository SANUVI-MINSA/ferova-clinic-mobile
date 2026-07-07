import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/consultation.dart';

enum ConsultationsInboxStatus {
  hasConsultations,
  noConsultations,
  noPatients,
  noSearchResults,
}

class ConsultationsInboxResult {
  final List<Consultation> consultations;
  final ConsultationsInboxStatus status;
  final String? message;
  final String? detail;
  final String? searchTerm;

  const ConsultationsInboxResult({
    required this.consultations,
    required this.status,
    this.message,
    this.detail,
    this.searchTerm,
  });
}
