class VerifyResetCodeRequestDto {
  final String email;
  final String code;

  const VerifyResetCodeRequestDto({required this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {'email': email, 'code': code};
  }
}