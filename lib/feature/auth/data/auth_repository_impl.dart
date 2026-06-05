import 'package:ferova_clinic_flutter/feature/auth/data/RegisterStaffRequestDto.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/auth_service.dart';
import 'package:ferova_clinic_flutter/feature/auth/data/login_request_dto.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthService authService;

  const AuthRepositoryImpl({required this.authService});

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Future<User?> login({required String dni, required String password}) async {
      final requestDto  = LoginRequestDto(dni: dni, password: password);
      final responseDto = await authService.login(requestDto);

      if (responseDto != null) {
        await saveToken(responseDto.token);
        return responseDto.toDomain();
      }

      return null;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  @override
  Future<User?> registerStaff({required String name, required String lastname, required String dni, required String email, required String phone, required String password, required String role}) async {
      final requestDto = RegisterStaffRequestDto(name: name, lastname: lastname, dni: dni, email: email, phone: phone, password: password, role: role);
      final responseDto = await authService.registerStaff(requestDto);
      return responseDto?.toDomain();
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
}