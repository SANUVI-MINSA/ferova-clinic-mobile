enum AssignmentStatus { assigned, unassigned }

class AssignablePatient {
  final String patientId;
  final String patientName;
  final String patientLastName;
  final String gender;
  final String status;
  final AssignmentStatus statusAssignment;

  const AssignablePatient({
    required this.patientId,
    required this.patientName,
    required this.patientLastName,
    required this.gender,
    required this.status,
    required this.statusAssignment,
  });

  String get fullName => '$patientName $patientLastName'.trim();

  AssignablePatient copyWith({AssignmentStatus? statusAssignment}) {
    return AssignablePatient(
      patientId: patientId,
      patientName: patientName,
      patientLastName: patientLastName,
      gender: gender,
      status: status,
      statusAssignment: statusAssignment ?? this.statusAssignment,
    );
  }
}