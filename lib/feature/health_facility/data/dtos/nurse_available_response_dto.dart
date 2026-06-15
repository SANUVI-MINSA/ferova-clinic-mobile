class NurseAvailableResponseDto {
  final bool available;
  final String message;
  final String? details;

  NurseAvailableResponseDto({
    required this.available,
    required this.message,
    this.details,
  });

  factory NurseAvailableResponseDto.fromJson(Map<String, dynamic> json) =>
      NurseAvailableResponseDto(
        available: json['available'],
        message: json['message'],
        details: json['details'],
      );
}
