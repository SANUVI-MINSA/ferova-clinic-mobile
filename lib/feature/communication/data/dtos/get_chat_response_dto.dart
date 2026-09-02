import 'package:ferova_clinic_flutter/feature/communication/data/dtos/chat_message_dto.dart';

class GetChatResponseDto {
  final String consultationId;
  final List<ChatMessageDto> messages;

  const GetChatResponseDto({
    required this.consultationId,
    required this.messages,
  });

  factory GetChatResponseDto.fromJson(Map<String, dynamic> json) {
    return GetChatResponseDto(
      consultationId: json['consultationId'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
