class LoginRequestDto {
  final String dni;
  final String password;

  const LoginRequestDto({
    required this.dni,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return({
      'dni': dni,
      'password': password,
    });
  }
}