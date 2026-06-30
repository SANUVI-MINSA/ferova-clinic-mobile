import 'dart:ui';

class TreatmentSummary {
  final String treatmentId;
  final String patientId;
  final String patientName;
  final String status;
  final String supplementName;

  const TreatmentSummary({
    required this.treatmentId,
    required this.patientId,
    required this.patientName,
    required this.status,
    required this.supplementName,
  });

  factory TreatmentSummary.fromJson(Map<String, dynamic> json) {
    return TreatmentSummary(
      treatmentId: json['treatmentId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      status: json['status'] as String,
      supplementName: json['supplementName'] as String,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'ACTIVE':
        return 'ACTIVO';
      case 'COMPLETED':
        return 'COMPLETADO';
      case 'ABANDONED':
        return 'ABANDONADO';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'ACTIVE':
        return const Color(0xFF2E7D32);
      case 'COMPLETED':
        return const Color(0xFF1565C0);
      case 'ABANDONED':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF6B7D8F);
    }
  }
}