import 'package:ferova_clinic_flutter/feature/communication/data/dtos/send_message_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat.dart';
import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/chat_message.dart';
import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/consultation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/model/value-objects/consultations_inbox_result.dart';
import '../../domain/repositories/communication_repository.dart';
import '../services/communication_service.dart';

class CommunicationRepositoryImpl implements CommunicationRepository {
  final CommunicationService service;

  const CommunicationRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  ConsultationsInboxStatus _statusFromCode(String? code) {
    switch (code) {
      case 'NO_CONSULTAS':
        return ConsultationsInboxStatus.noConsultations;
      case 'SIN_PACIENTES':
        return ConsultationsInboxStatus.noPatients;
      case 'BUSQUEDA_SIN_RESULTADOS':
        return ConsultationsInboxStatus.noSearchResults;
      default:
        return ConsultationsInboxStatus.noConsultations;
    }
  }

  @override
  Future<ConsultationsInboxResult> getConsultations({
    String searchTerm = '',
  }) async {
    final token = await _token();
    final response = await service.getConsultations(token, searchTerm);

    if (response.status == null) {
      return ConsultationsInboxResult(
        consultations: response.consultations
            .map(
              (dto) => Consultation(
                consultationId: dto.consultationId,
                patientId: dto.patientId,
                patientName: dto.patientName,
                motherId: dto.motherId,
                motherName: dto.motherName,
                nurseId: dto.nurseId,
                nurseName: dto.nurseName,
                lastMessage: dto.lastMessage,
                lastMessageDate: DateTime.parse(dto.lastMessageDate),
                createdAt: DateTime.parse(dto.createdAt),
                messageCount: dto.messageCount,
              ),
            )
            .toList(),
        status: ConsultationsInboxStatus.hasConsultations,
      );
    }

    return ConsultationsInboxResult(
      consultations: const [],
      status: _statusFromCode(response.status),
      message: response.message,
      detail: response.detail,
      searchTerm: response.searchTerm,
    );
  }

  @override
  Future<Chat> getChat(String consultationId) async {
    final token = await _token();
    final response = await service.getChat(token, consultationId);
    return Chat(
      consultationId: response.consultationId,
      messages: response.messages
          .map(
            (dto) => ChatMessage(
              id: dto.id,
              senderId: dto.senderId,
              senderRole: dto.senderRole == 'NURSE'
                  ? SenderRole.nurse
                  : SenderRole.mother,
              content: dto.content,
              sentAt: DateTime.parse(dto.sentAt),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> sendMessage({
    required String consultationId,
    required String senderId,
    required String content,
  }) async {
    final token = await _token();
    await service.sendMessage(
      token,
      SendMessageRequestDto(
        consultationId: consultationId,
        senderId: senderId,
        content: content,
      ),
    );
  }

  @override
  Future<void> closeConsultation(String consultationId) async {
    final token = await _token();
    await service.closeConsultation(token, consultationId);
  }
}
