class AbandonTreatmentRequestDto {
  final String treatmentId;
  final String observation;

  const AbandonTreatmentRequestDto({
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