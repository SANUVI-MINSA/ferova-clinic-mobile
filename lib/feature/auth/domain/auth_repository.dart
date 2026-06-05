import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

abstract class AuthRepository {

  // Login
  Future<User?> login({required String dni, required String password});

  // Register
  Future<User?> registerStaff({
    required String name,
    required String lastname,
    required String dni,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  // Preguntar al profesor mayta si esta correcto poner estos metodos relacionados al token aca mismo

  // Guardar token después de login
  Future<void> saveToken(String token);

  // Obtener token guardado
  Future<String?> getToken();

  // Cerrar sesión
  Future<void> logout();

}