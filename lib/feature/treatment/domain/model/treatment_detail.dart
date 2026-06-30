// lib/feature/treatment/domain/model/treatment_detail.dart

import 'dart:ui';

class TreatmentDetail {
  final String treatmentId;
  final String patientId;
  final String patientName;
  final String status;
  final String supplementName;
  final String quantity;
  final String dosingHours;
  final int durationDays;
  final String startDate;
  final String endDate;
  final int adherenceScore;
  final int totalConfirmed;
  final int totalOmitted;
  final String? completionObservation;
  final String? abandonmentObservation;

  const TreatmentDetail({
    required this.treatmentId,
    required this.patientId,
    required this.patientName,
    required this.status,
    required this.supplementName,
    required this.quantity,
    required this.dosingHours,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.adherenceScore,
    required this.totalConfirmed,
    required this.totalOmitted,
    this.completionObservation,
    this.abandonmentObservation,
  });

  factory TreatmentDetail.fromJson(Map<String, dynamic> json) {
    // ✅ LOGS PARA DEPURAR
    print('📥 TreatmentDetail.fromJson - JSON recibido:');
    print(json);

    // ✅ Verificar cada campo antes de hacer el cast
    try {
      return TreatmentDetail(
        treatmentId: json['treatmentId'] as String,
        patientId: json['patientId'] as String,
        patientName: json['patientName'] as String,
        status: json['status'] as String,
        supplementName: json['supplementName'] as String,
        quantity: json['quantity'] as String,
        dosingHours: json['dosingHours'] as String,
        durationDays: json['durationDays'] as int,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        adherenceScore: _toInt(json['adherenceScore']), // Usar helper
        totalConfirmed: _toInt(json['totalConfirmed']), //  Usar helper
        totalOmitted: _toInt(json['totalOmitted']), // Usar helper
        completionObservation: json['completionObservation'] as String?,
        abandonmentObservation: json['abandonmentObservation'] as String?,
      );
    } catch (e) {
      rethrow;
    }
  }

  // HELPER para convertir a int (maneja double y string)
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt(); //  Convertir double a int
    if (value is String) return int.tryParse(value) ?? 0;
    print('⚠️ Valor inesperado para int: $value (${value.runtimeType})');
    return 0;
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

  String get formattedStartDate {
    try {
      final date = DateTime.parse(startDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return startDate;
    }
  }

  String get formattedEndDate {
    try {
      final date = DateTime.parse(endDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return endDate;
    }
  }

  double get adherencePercentage {
    final total = totalConfirmed + totalOmitted;
    if (total == 0) return 0;
    return (totalConfirmed / total) * 100;
  }
}