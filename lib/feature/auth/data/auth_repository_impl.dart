import 'package:flutter/foundation.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RegisterStaffRequestDto.dart';
import 'auth_service.dart';
import 'login_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  const AuthRepositoryImpl({required this.authService});

  @override
  Future<User?> login({required String dni, required String password}) async {
    try {
      final requestDto = LoginRequestDto(dni: dni, password: password);
      final responseDto = await authService.login(requestDto);

      if (responseDto != null) {
        await saveToken(responseDto.token);
        return responseDto.toDomain();
      }
      return null;
    } catch (e) {
      debugPrint('❌ Login excepción: $e');
      return null;
    }
  }

  @override
  @override
  Future<({User? user, String? error})> registerStaff({
    required String name,
    required String lastname,
    required String dni,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final requestDto = RegisterStaffRequestDto(
        name: name,
        lastname: lastname,
        dni: dni,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );

      final result = await authService.registerStaff(requestDto);

      if (result.success) {
        // Registro exitoso, pero no tenemos los datos del usuario
        // Creamos un User con los datos que enviamos
        final user = User(
          id: '', // Temporal, porque el backend no retorna el id
          name: name,
          lastname: lastname,
          email: email,
          dni: dni,
          phone: phone,
          role: role,
        );
        return (user: user, error: null);
      } else {
        return (user: null, error: result.error);
      }
    } catch (e) {
      return (user: null, error: 'Error inesperado: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}