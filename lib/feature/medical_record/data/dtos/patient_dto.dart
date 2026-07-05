class PatientDto {
  final String patientId;
  final String fullName;
  final String gender;
  final String status;

  const PatientDto({
    required this.patientId,
    required this.fullName,
    required this.gender,
    required this.status,
  });

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      patientId: json['patientId'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
    );
  }
}
