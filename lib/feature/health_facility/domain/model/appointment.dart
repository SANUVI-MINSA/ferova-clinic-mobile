class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String appointmentDate;
  final String appointmentTime;
  final String status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
  });
}
