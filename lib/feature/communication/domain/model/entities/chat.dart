import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat_message.dart';

class Chat {
  final String consultationId;
  final List<ChatMessage> messages;

  const Chat({
    required this.consultationId,
    required this.messages,
  });
}
