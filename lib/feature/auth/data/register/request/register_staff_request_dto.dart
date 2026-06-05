class RegisterStaffRequestDto {
  final String name;
  final String lastname;
  final String dni;
  final String email;
  final String phone;
  final String password;
  final String role; // 'Nurse' o 'Admin'

  const RegisterStaffRequestDto({
    required this.name,
    required this.lastname,
    required this.dni,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'dni': dni,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }
}