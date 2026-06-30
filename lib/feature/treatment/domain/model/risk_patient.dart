
import 'dart:ui';

class RiskPatient {
  final String patientId;
  final String patientName;
  final int? patientAge;
  final int score;
  final int? hoursWithoutConfirmation;

  const RiskPatient({
    required this.patientId,
    required this.patientName,
    this.patientAge,
    required this.score,
    this.hoursWithoutConfirmation,
  });

  factory RiskPatient.fromJson(Map<String, dynamic> json) {
    return RiskPatient(
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as int?,
      score: _toInt(json['score']),
      hoursWithoutConfirmation: json['hoursWithoutConfirmation'] as int?,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get riskLevel {
    if (score > 70) return 'HIGH';
    if (score >= 30) return 'MEDIUM';
    return 'LOW';
  }

  String get riskLabel {
    switch (riskLevel) {
      case 'HIGH':
        return 'Alto Riesgo';
      case 'MEDIUM':
        return 'Riesgo Medio';
      case 'LOW':
        return 'Riesgo Bajo';
      default:
        return 'Sin Riesgo';
    }
  }

  Color get riskColor {
    switch (riskLevel) {
      case 'HIGH':
        return const Color(0xFFD32F2F);
      case 'MEDIUM':
        return const Color(0xFFF57F17);
      case 'LOW':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF6B7D8F);
    }
  }

  // ✅ SOLO HORAS - Sin convertir a días
  String get hoursDisplay {
    if (hoursWithoutConfirmation == null) return '--';
    final hours = hoursWithoutConfirmation!.abs();
    return '$hours h';
  }

  // ✅ Determinar si está pendiente
  bool get isPending => hoursWithoutConfirmation != null && hoursWithoutConfirmation!.abs() > 0;
}