class PendingPatient {
  final String patientId;
  final String patientName;

  const PendingPatient(
    {
      required this.patientId,
      required this.patientName,
    }
  );

  factory PendingPatient.fromJson(Map<String, dynamic> json) {
    return PendingPatient(
        patientId: json['patientId'] as String,
        patientName: json['patientName'] as String
    );
  }
}