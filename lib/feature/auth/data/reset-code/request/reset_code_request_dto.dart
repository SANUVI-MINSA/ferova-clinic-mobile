class ResetCodeRequestDto {
  final String? email;

  const ResetCodeRequestDto({required this.email});

  Map<String, dynamic> toJson() {
    return({
      'email': email
    });
  }
}