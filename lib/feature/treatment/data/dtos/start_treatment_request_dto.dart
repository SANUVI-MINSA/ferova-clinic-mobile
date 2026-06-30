class StartTreatmentRequestDto {
  final String patientId;
  final String supplementName;
  final String quantity;
  final String dosingHours;
  final int durationDays;

  const StartTreatmentRequestDto(
    {
      required this.patientId,
      required this.supplementName,
      required this.quantity,
      required this.dosingHours,
      required this.durationDays
    });

  Map<String, dynamic> toJson() {
   return {
     'patientId': patientId,
     'supplementName': supplementName,
     'quantity': quantity,
     'dosingHours': dosingHours,
     'durationDays': durationDays
   };
  }
}