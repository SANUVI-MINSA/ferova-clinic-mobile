import 'dart:ui';

import 'TreatmentInfo.dart';

class PatientMonitor {
  final String patientId;
  final String patientName;
  final String riskLevel;
  final int score;
  final int adherenceScore;
  final int totalConfirmed;
  final int totalOmitted;
  final TreatmentInfo treatment;

  const PatientMonitor({
    required this.patientId,
    required this.patientName,
    required this.riskLevel,
    required this.score,
    required this.adherenceScore,
    required this.totalConfirmed,
    required this.totalOmitted,
    required this.treatment,
  });

  factory PatientMonitor.fromJson(Map<String, dynamic> json) {
    return PatientMonitor(
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      riskLevel: json['riskLevel'] as String,
      score: _toInt(json['score']),
      adherenceScore: _toInt(json['adherenceScore']),
      totalConfirmed: _toInt(json['totalConfirmed']),
      totalOmitted: _toInt(json['totalOmitted']),
      treatment: TreatmentInfo.fromJson(json['treatment'] as Map<String, dynamic>),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get riskLabel {
    switch (riskLevel) {
      case 'HIGH':
        return 'RIESGO ALTO';
      case 'MEDIUM':
        return 'RIESGO MEDIO';
      case 'LOW':
        return 'RIESGO BAJO';
      default:
        return riskLevel;
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

  int get adherencePercentage {
    return adherenceScore; // ✅ Directamente del backend
  }

  double get calculatedAdherence {
    final total = totalConfirmed + totalOmitted;
    if (total == 0) return 0;
    return (totalConfirmed / total) * 100;
  }
}