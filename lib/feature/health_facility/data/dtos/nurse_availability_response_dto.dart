class NurseAvailabilityResponseDto {
  final bool available;
  final String message;
  final String? details;

  NurseAvailabilityResponseDto({
    required this.available,
    required this.message,
    this.details,
  });

  factory NurseAvailabilityResponseDto.fromJson(Map<String, dynamic> json) =>
      NurseAvailabilityResponseDto(
        available: json['available'],
        message: json['message'],
        details: json['details'],
      );
}
