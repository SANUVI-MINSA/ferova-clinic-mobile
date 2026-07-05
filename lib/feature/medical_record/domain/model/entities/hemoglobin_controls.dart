import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_control.dart';

class HemoglobinControls {
  final String patientId;
  final List<HemoglobinControl> controls;
  final double averageHemoglobin;
  final double? evolution;

  const HemoglobinControls({
    required this.patientId,
    required this.controls,
    required this.averageHemoglobin,
    required this.evolution,
  });
}
