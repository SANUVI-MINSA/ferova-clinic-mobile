// assignable_patient.dart
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

  // ✅ Getter para saber si está asignado
  bool get isAssigned => statusAssignment == AssignmentStatus.assigned;

  AssignablePatient copyWith({
    String? patientId,
    String? patientName,
    String? patientLastName,
    String? gender,
    String? status,
    AssignmentStatus? statusAssignment,
  }) {
    return AssignablePatient(
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientLastName: patientLastName ?? this.patientLastName,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      statusAssignment: statusAssignment ?? this.statusAssignment,
    );
  }
}