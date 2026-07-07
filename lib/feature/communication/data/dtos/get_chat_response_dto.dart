import 'package:ferova_clinic_flutter/feature/communication/data/dtos/chat_message_dto.dart';

class GetChatResponseDto {
  final String consultationId;
  final String patientId;
  final String nurseId;
  final List<ChatMessageDto> messages;

  const GetChatResponseDto({
    required this.consultationId,
    required this.patientId,
    required this.nurseId,
    required this.messages,
  });

  factory GetChatResponseDto.fromJson(Map<String, dynamic> json) {
    return GetChatResponseDto(
      consultationId: json['consultationId'] as String,
      patientId: json['patientId'] as String,
      nurseId: json['nurseId'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
