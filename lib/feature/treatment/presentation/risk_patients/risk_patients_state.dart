import 'dart:ui';

import '../../domain/model/risk_patient.dart';

class RiskPatientsState {
  final bool isLoading;
  final String? errorMessage;
  final String riskLevel;
  final List<RiskPatient> patients;
  final int total;

  const RiskPatientsState({
    this.isLoading = false,
    this.errorMessage,
    required this.riskLevel,
    this.patients = const [],
    this.total = 0,
  });

  RiskPatientsState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? riskLevel,
    List<RiskPatient>? patients,
    int? total,
  }) {
    return RiskPatientsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      riskLevel: riskLevel ?? this.riskLevel,
      patients: patients ?? this.patients,
      total: total ?? this.total,
    );
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

  String get riskEmoji {
    switch (riskLevel) {
      case 'HIGH':
        return '🔴';
      case 'MEDIUM':
        return '🟡';
      case 'LOW':
        return '🟢';
      default:
        return '⚪';
    }
  }

  String get subtitle {
    switch (riskLevel) {
      case 'HIGH':
        return 'Se requiere atención inmediata para estos perfiles.';
      case 'MEDIUM':
        return 'Monitoreo preventivo requerido';
      case 'LOW':
        return 'Pacientes con riesgo bajo';
      default:
        return '';
    }
  }
}