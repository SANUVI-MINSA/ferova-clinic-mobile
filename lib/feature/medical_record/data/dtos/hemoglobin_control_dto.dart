// medical_record/data/dtos/hemoglobin_control_dto.dart

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
    print('📥 HemoglobinControlDto.fromJson: $json');

    // ✅ Ahora vienen directos, no anidados
    return HemoglobinControlDto(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? DateTime.now().toIso8601String(),
      hemoglobinLevel: (json['hemoglobinLevel'] as num?)?.toDouble() ?? 0.0,
      anemiaStatus: _parseAnemiaStatus(json['anemiaStatus']),
    );
  }

  static String _parseAnemiaStatus(dynamic status) {
    if (status == null) return 'CONTROLLED';

    // Si es string (como viene ahora)
    if (status is String) {
      return status.toUpperCase();
    }

    // Si es número (fallback)
    if (status is int) {
      switch (status) {
        case 0: return 'CONTROLLED';
        case 1: return 'MILD';
        case 2: return 'MODERATE';
        case 3: return 'SEVERE';
        default: return 'CONTROLLED';
      }
    }

    return 'CONTROLLED';
  }
}