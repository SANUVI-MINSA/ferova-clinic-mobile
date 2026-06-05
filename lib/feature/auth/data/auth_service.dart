import 'dart:convert';
import 'dart:io';

import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/RegisterStaffRequestDto.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/RegisterStaffResponseDto.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/login_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/login_response_dto.dart';
import 'package:http/http.dart' as http;

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
      return null;
    }
  }

  // Register
  Future<RegisterStaffResponseDto?> registerStaff(RegisterStaffRequestDto requestDto) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/register/staff');
      final http.Response response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestDto.toJson())
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return RegisterStaffResponseDto.fromJson(json);
      }

      return null;

    } catch (e) {
      return null;
    }
  }
}