import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat_message.dart';

class Chat {
  final String consultationId;
  final String patientId;
  final String nurseId;
  final List<ChatMessage> messages;

  const Chat({
    required this.consultationId,
    required this.patientId,
    required this.nurseId,
    required this.messages,
  });
}
