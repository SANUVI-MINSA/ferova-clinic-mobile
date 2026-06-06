import '../../../domain/user.dart';

class RegisterStaffResponseDto {
  final String? message;
  final String? id;
  final String? name;
  final String? lastname;
  final String? email;
  final String? dni;
  final String? phone;
  final String? role;
  final String? error;

  const RegisterStaffResponseDto({
    this.message,
    this.id,
    this.name,
    this.lastname,
    this.email,
    this.dni,
    this.phone,
    this.role,
    this.error,
  });

  factory RegisterStaffResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterStaffResponseDto(
      message: json['message'] as String?,
      id: json['id'] as String? ?? json['_id'] as String?,
      name: json['name'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      dni: json['dni'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      error: json['error'] as String?,
    );
  }

  // Solo crear User si tenemos todos los datos necesarios
  User? toDomain() {
    if (id == null || name == null || lastname == null ||
        dni == null || email == null || phone == null || role == null) {
      return null;
    }
    return User(
      id: id!,
      name: name!,
      lastname: lastname!,
      email: email!,
      dni: dni!,
      phone: phone!,
      role: role!,
    );
  }

  // Verificar si el registro fue exitoso (solo por el mensaje)
  bool get isSuccess => message != null && error == null;

  String? getErrorMessage() {
    return error ?? (isSuccess ? null : 'Error desconocido');
  }
}