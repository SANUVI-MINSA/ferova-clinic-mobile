import 'package:ferova_clinic_flutter/core/di/dependency_injection.dart';
import 'package:ferova_clinic_flutter/feature/communication/presentation/chat/chat_state.dart';
import 'package:ferova_clinic_flutter/feature/communication/presentation/chat/chat_view_model.dart';
import 'package:ferova_clinic_flutter/feature/communication/presentation/chat/close_consultation_dialog.dart';
import 'package:ferova_clinic_flutter/feature/communication/presentation/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/repositories/communication_repository.dart';

const _accentBlue = Color(0xFF0D6EA8);
const _background = Color(0xFFF0F4F8);
const _mutedGrey = Color(0xFF6B7D8F);

class ChatPage extends StatelessWidget {
  final String consultationId;
  final String nurseId;

  const ChatPage({
    super.key,
    required this.consultationId,
    required this.nurseId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatViewModel>(
      create: (_) => ChatViewModel(
        repository: getIt<CommunicationRepository>(),
        consultationId: consultationId,
        nurseId: nurseId,
      ),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatViewModel>().getChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    final content = _messageController.text;
    if (content.trim().isEmpty) return;

    final viewModel = context.read<ChatViewModel>();
    _messageController.clear();
    await viewModel.sendMessage(content);
  }

  Future<void> _onCloseConsultation() async {
    final confirmed = await showCloseConsultationDialog(context);
    if (confirmed != true || !mounted) return;

    final viewModel = context.read<ChatViewModel>();
    final success = await viewModel.closeConsultation();

    if (!mounted) return;

    if (success) {
      // ✅ Retornar true para indicar que se debe refrescar la bandeja
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo cerrar la consulta: '
                '${viewModel.state.closeErrorMessage}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatViewModel>().state;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _accentBlue,
        foregroundColor: Colors.white,
        title: const Text('Consulta'),
        actions: [
          IconButton(
            onPressed: state.hasNurseReplied && !state.isClosingConsultation
                ? _onCloseConsultation
                : null,
            icon: state.isClosingConsultation
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline_rounded),
            tooltip: state.hasNurseReplied
                ? 'Cerrar consulta'
                : 'Respondé al menos un mensaje para poder cerrar',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessages(state)),
            _buildInput(state),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(ChatState state) {
    if (state.isLoadingChat && state.chat == null) {
      return const Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }

    if (state.chatErrorMessage != null && state.chat == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.chatErrorMessage}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.read<ChatViewModel>().getChat(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final messages = state.chat?.messages ?? const [];
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'Todavía no hay mensajes en esta consulta.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) => MessageBubble(message: messages[index]),
    );
  }

  Widget _buildInput(ChatState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escribí un mensaje...',
                  hintStyle: const TextStyle(color: _mutedGrey, fontSize: 14),
                  filled: true,
                  fillColor: _background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: state.isSendingMessage ? null : _onSend,
              icon: state.isSendingMessage
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _accentBlue,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: _accentBlue),
            ),
          ],
        ),
      ),
    );
  }
}
