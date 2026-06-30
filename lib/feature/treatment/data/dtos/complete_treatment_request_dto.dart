class CompleteTreatmentRequestDto {
  final String treatmentId;
  final String observation;

  const CompleteTreatmentRequestDto({
    required this.treatmentId,
    required this.observation,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatmentId': treatmentId,
      'observation': observation,
    };
  }
}