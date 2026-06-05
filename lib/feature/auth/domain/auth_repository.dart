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

  // Guardar token después de login
  Future<void> saveToken(String token);

  // Obtener token guardado
  Future<String?> getToken();

  // Cerrar sesión
  Future<void> logout();
}