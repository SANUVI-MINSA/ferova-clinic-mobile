class NurseAvailabilityResponseDto {
  final bool canRegister;  // ✅ Cambiar de 'available' a 'canRegister'
  final String message;
  final String? details;

  NurseAvailabilityResponseDto({
    required this.canRegister,  // ✅ Cambiar a 'canRegister'
    required this.message,
    this.details,
  });

  factory NurseAvailabilityResponseDto.fromJson(Map<String, dynamic> json) {
    // ✅ Manejar caso donde el campo venga como null
    final canRegisterValue = json['canRegister'] ?? json['available'] ?? false;

    return NurseAvailabilityResponseDto(
      canRegister: canRegisterValue is bool ? canRegisterValue : false,
      message: json['message'] as String? ?? '',
      details: json['details'] as String?,
    );
  }

  // ✅ Mantener 'available' para compatibilidad
  bool get available => canRegister;
}