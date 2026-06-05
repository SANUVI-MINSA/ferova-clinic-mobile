
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

class LoginResponseDto {
  final String token;
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String dni;
  final String phone;
  final String role;

  const LoginResponseDto({
    required this.token,
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.dni,
    required this.phone,
    required this.role,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String,
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      dni: json['dni'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  User toDomain() {
    return User(
      id: id,
      name: name,
      lastname: lastname,
      email: email,
      dni: dni,
      phone: phone,
      role: role,
    );
  }
}