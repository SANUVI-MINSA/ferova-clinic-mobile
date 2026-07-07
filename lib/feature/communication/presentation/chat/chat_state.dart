import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat.dart';
import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat_message.dart';

class ChatState {
  final bool isLoadingChat;
  final String? chatErrorMessage;
  final Chat? chat;
  final bool isSendingMessage;
  final String? sendErrorMessage;
  final bool isClosingConsultation;
  final String? closeErrorMessage;
  final bool consultationClosed; // ✅ Este flag indica si se cerró

  const ChatState({
    this.isLoadingChat = false,
    this.chatErrorMessage,
    this.chat,
    this.isSendingMessage = false,
    this.sendErrorMessage,
    this.isClosingConsultation = false,
    this.closeErrorMessage,
    this.consultationClosed = false, // ✅ Inicializar en false
  });

  bool get hasNurseReplied =>
      chat?.messages.any((m) => m.senderRole == SenderRole.nurse) ?? false;

  ChatState copyWith({
    bool? isLoadingChat,
    String? chatErrorMessage,
    Chat? chat,
    bool? isSendingMessage,
    String? sendErrorMessage,
    bool? isClosingConsultation,
    String? closeErrorMessage,
    bool? consultationClosed,
  }) {
    return ChatState(
      isLoadingChat: isLoadingChat ?? this.isLoadingChat,
      chatErrorMessage: chatErrorMessage,
      chat: chat ?? this.chat,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      sendErrorMessage: sendErrorMessage,
      isClosingConsultation:
      isClosingConsultation ?? this.isClosingConsultation,
      closeErrorMessage: closeErrorMessage,
      consultationClosed: consultationClosed ?? this.consultationClosed,
    );
  }
}