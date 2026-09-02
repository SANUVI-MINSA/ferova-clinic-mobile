// assignable_patient_dto.dart
class AssignablePatientDto {
  final String patientId;
  final String patientName;
  final String patientLastName;
  final String gender;
  final String status;
  final String statusAssignment; // ✅ Agregar este campo

  const AssignablePatientDto({
    required this.patientId,
    required this.patientName,
    required this.patientLastName,
    required this.gender,
    required this.status,
    required this.statusAssignment, // ✅ Agregar
  });

  factory AssignablePatientDto.fromJson(Map<String, dynamic> json) {
    return AssignablePatientDto(
      patientId: json['patientId']?.toString() ?? json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? json['name']?.toString() ?? '',
      patientLastName: json['patientLastName']?.toString() ?? json['lastName']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusAssignment: json['statusAssignment']?.toString() ?? 'UNASSIGNED', // ✅ Mapear
    );
  }
}