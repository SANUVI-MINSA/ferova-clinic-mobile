import 'package:ferova_clinic_flutter/feature/communication/presentation/chat/chat_state.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/communication_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final CommunicationRepository repository;
  final String consultationId;
  final String nurseId;
  ChatState state = const ChatState();

  ChatViewModel({
    required this.repository,
    required this.consultationId,
    required this.nurseId,
  });

  Future<void> getChat() async {
    state = state.copyWith(isLoadingChat: true, chatErrorMessage: null);
    notifyListeners();

    try {
      final chat = await repository.getChat(consultationId);
      state = state.copyWith(
        isLoadingChat: false,
        chat: chat,
        chatErrorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingChat: false, chatErrorMessage: e.toString());
    }
    notifyListeners();
  }

  // ✅ Método para refrescar el chat
  Future<void> refreshChat() async {
    await getChat();
  }

  Future<bool> sendMessage(String content) async {
    if (content.trim().isEmpty) return false;

    state = state.copyWith(isSendingMessage: true, sendErrorMessage: null);
    notifyListeners();

    try {
      await repository.sendMessage(
        consultationId: consultationId,
        senderId: nurseId,
        content: content.trim(),
      );
      state = state.copyWith(isSendingMessage: false, sendErrorMessage: null);
      notifyListeners();
      await getChat();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        sendErrorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> closeConsultation() async {
    state = state.copyWith(isClosingConsultation: true, closeErrorMessage: null);
    notifyListeners();

    try {
      await repository.closeConsultation(consultationId);

      // ✅ Refrescar el chat después de cerrar
      await getChat();

      state = state.copyWith(
        isClosingConsultation: false,
        closeErrorMessage: null,
        consultationClosed: true,
      );
      notifyListeners();
      return true;
    } catch (e) {
      state = state.copyWith(
        isClosingConsultation: false,
        closeErrorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }
}