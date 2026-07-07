class MotherDto {
  final String motherId;
  final String fullName;
  final String dni;

  const MotherDto({
    required this.motherId,
    required this.fullName,
    required this.dni,
  });

  factory MotherDto.fromJson(Map<String, dynamic> json) {
    return MotherDto(
      motherId: json['motherId'] as String,
      fullName: json['fullName'] as String,
      dni: json['dni'] as String,
    );
  }
}
