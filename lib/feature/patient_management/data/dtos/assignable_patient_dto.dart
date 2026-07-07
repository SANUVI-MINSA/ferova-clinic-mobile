class AssignablePatientDto {
  final String patientId;
  final String patientName;
  final String patientLastName;
  final String gender;
  final String status;
  final String statusAssignment;

  const AssignablePatientDto({
    required this.patientId,
    required this.patientName,
    required this.patientLastName,
    required this.gender,
    required this.status,
    required this.statusAssignment,
  });

  factory AssignablePatientDto.fromJson(Map<String, dynamic> json) {
    return AssignablePatientDto(
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientLastName: json['patientLastName'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
      statusAssignment: json['statusAssignment'] as String,
    );
  }
}
