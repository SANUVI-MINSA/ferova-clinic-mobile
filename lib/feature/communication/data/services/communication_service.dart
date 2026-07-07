import 'dart:convert';
import 'dart:io';

import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/communication/data/dtos/close_consultation_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/communication/data/dtos/get_chat_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/communication/data/dtos/get_consultations_response_dto.dart';
import 'package:ferova_clinic_flutter/feature/communication/data/dtos/send_message_request_dto.dart';
import 'package:http/http.dart' as http;

class CommunicationService {
  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<GetConsultationsResponseDto> getConsultations(
    String token,
    String searchTerm,
  ) async {
    try {
      final Uri baseUri = Uri.parse(
        '${AppConfig.baseUrl}/communication/consultations/nurse',
      );
      final Uri uri = searchTerm.trim().isEmpty
          ? baseUri
          : baseUri.replace(queryParameters: {'searchTerm': searchTerm.trim()});
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      // ignore: avoid_print
      print('CONSULTATIONS ← ${response.statusCode}: ${response.body}');
      if (response.statusCode == HttpStatus.ok) {
        final dynamic json = jsonDecode(response.body);
        return GetConsultationsResponseDto.fromJson(json);
      }
      throw Exception('Failed to fetch consultations. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get consultations. $e');
    }
  }

  Future<GetChatResponseDto> getChat(
    String token,
    String consultationId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/communication/chat/$consultationId',
      );
      final http.Response response = await http.get(
        uri,
        headers: _headers(token),
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return GetChatResponseDto.fromJson(json);
      }
      throw Exception('Failed to fetch chat. ${response.body}');
    } catch (e) {
      throw Exception('Failed to get chat. $e');
    }
  }

  Future<void> sendMessage(String token, SendMessageRequestDto dto) async {
    try {
      final Uri uri = Uri.parse('${AppConfig.baseUrl}/communication/messages');
      final http.Response response = await http.post(
        uri,
        headers: _headers(token),
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return;
      }
      throw Exception('Failed to send message. ${response.body}');
    } catch (e) {
      throw Exception('Failed to send message. $e');
    }
  }

  Future<void> closeConsultation(String token, String consultationId) async {
    try {
      final Uri uri = Uri.parse(
        '${AppConfig.baseUrl}/communication/consultations/close',
      );
      final http.Response response = await http.delete(
        uri,
        headers: _headers(token),
        body: jsonEncode(
          CloseConsultationRequestDto(consultationId: consultationId).toJson(),
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        return;
      }
      throw Exception('Failed to close consultation. ${response.body}');
    } catch (e) {
      throw Exception('Failed to close consultation. $e');
    }
  }
}
