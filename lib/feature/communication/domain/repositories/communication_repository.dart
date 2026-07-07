import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat.dart';

import '../model/value-objects/consultations_inbox_result.dart';

abstract class CommunicationRepository {
  Future<ConsultationsInboxResult> getConsultations({String searchTerm});

  Future<Chat> getChat(String consultationId);

  Future<void> sendMessage({
    required String consultationId,
    required String senderId,
    required String content,
  });

  Future<void> closeConsultation(String consultationId);
}
