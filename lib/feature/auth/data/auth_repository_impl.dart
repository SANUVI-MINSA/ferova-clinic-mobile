import 'package:flutter/foundation.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register/request/register_staff_request_dto.dart';
import 'auth_service.dart';
import 'login/request/login_request_dto.dart';

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

      final responseDto = await authService.registerStaff(requestDto);

      // Verificar si hay error
      if (responseDto?.error != null) {
        return (user: null, error: responseDto!.error);
      }

      // Si el registro fue exitoso, crear User con los datos que enviamos
      // (porque el backend no retorna los datos del usuario)
      if (responseDto?.isSuccess == true) {
        final user = User(
          id: '', // El backend no retorna id en el registro
          name: name,
          lastname: lastname,
          email: email,
          dni: dni,
          phone: phone,
          role: role,
        );
        return (user: user, error: null);
      }

      return (user: null, error: 'Error desconocido');
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

  @override
  Future<User?> requestCode({required String email}) async {
    // TODO: implement requestCode
    throw UnimplementedError();
  }

  @override
  Future<User?> resetPassword({required String email, required String code, required String newPassword}) async {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<User?> verifyCode({required String email, required String code}) async {
    // TODO: implement verifyCode
    throw UnimplementedError();
  }
}