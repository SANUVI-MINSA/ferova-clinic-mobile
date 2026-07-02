class CreateHemoglobinLevelRequestDto {
  final String patientId;
  final double hemoglobinLevel;

  const CreateHemoglobinLevelRequestDto({
    required this.patientId,
    required this.hemoglobinLevel,
  });

  Map<String, dynamic> toJson() {
    return {'patientId': patientId, 'hemoglobinLevel': hemoglobinLevel};
  }
}
