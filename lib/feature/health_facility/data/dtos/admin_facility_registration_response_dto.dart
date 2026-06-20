class AdminFacilityRegistrationResponseDto {
  final String? message;
  final String? error;

  AdminFacilityRegistrationResponseDto({this.message, this.error});

  factory AdminFacilityRegistrationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminFacilityRegistrationResponseDto(
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }
}
