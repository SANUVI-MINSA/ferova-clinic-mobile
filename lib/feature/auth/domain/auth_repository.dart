import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

abstract class AuthRepository {
  // Login
  Future<User?> login({required String dni, required String password});

  // Register (ahora retorna user o error)
  Future<({User? user, String? error})> registerStaff({
    required String name,
    required String lastname,
    required String dni,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  // Request Code
  Future<({bool success, String? message, String? error})> requestResetCode({required String email});

  // Verify Code
  Future<({bool success, String? message, String? error})> verifyResetCode({required String email, required String code});

  // Reset Password
  Future<({bool success, String? message, String? error})> resetPassword({
    required String email,
    required String code,
    required String newPassword
  });

  // Guardar token después de login
  Future<void> saveToken({required String token});

  // Obtener token guardado
  Future<String?> getToken();

  // Cerrar sesión
  Future<void> logout();
}