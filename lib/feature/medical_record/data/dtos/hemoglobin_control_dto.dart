class HemoglobinControlDto {
  final String id;
  final String date;
  final double hemoglobinLevel;
  final String anemiaStatus;

  const HemoglobinControlDto({
    required this.id,
    required this.date,
    required this.hemoglobinLevel,
    required this.anemiaStatus,
  });

  factory HemoglobinControlDto.fromJson(Map<String, dynamic> json) {
    return HemoglobinControlDto(
      id: json['id'] as String,
      date: json['date'] as String,
      hemoglobinLevel: (json['hemoglobinLevel'] as num).toDouble(),
      anemiaStatus: json['anemiaStatus'] as String,
    );
  }
}