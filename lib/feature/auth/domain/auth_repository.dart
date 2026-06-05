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
}