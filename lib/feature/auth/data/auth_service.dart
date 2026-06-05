import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/RegisterStaffRequestDto.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/login_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/login_response_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'RegisterStaffResponseDto.dart';

class AuthService {
  final String _baseUrl =
        '${AppConfig.baseUrl}/users';

  // Login
  Future<LoginResponseDto?> login(LoginRequestDto requestDto) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/login');
      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestDto.toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return LoginResponseDto.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Network error: $e');
      return null;
    }
  }

  // Register
  Future<RegisterStaffResponseDto?> registerStaff(RegisterStaffRequestDto requestDto,) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/register/staff');
      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestDto.toJson()),
      );

      debugPrint('📥 Status code: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == HttpStatus.created) {
        final json = jsonDecode(response.body);
        return RegisterStaffResponseDto.fromJson(json);
      } else {
        // Si hay error, crear un DTO con el error
        try {
          final json = jsonDecode(response.body);
          return RegisterStaffResponseDto(
            error: json['error'] as String? ?? json['message'] as String?,
          );
        } catch (e) {
          return RegisterStaffResponseDto(
            error: 'Error ${response.statusCode}: ${response.body}',
          );
        }
      }
    } catch (e) {
      return RegisterStaffResponseDto(
        error: 'Error de conexión: $e',
      );
    }
  }

  // Request Code
}