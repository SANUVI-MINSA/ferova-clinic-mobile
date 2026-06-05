
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

class RegisterStaffResponseDto {
  final String message;
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String dni;
  final String phone;
  final String role;

  const RegisterStaffResponseDto({
    required this.message,
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.dni,
    required this.phone,
    required this.role,
  });

  factory RegisterStaffResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterStaffResponseDto(
      message: json['message'] ?? '',
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