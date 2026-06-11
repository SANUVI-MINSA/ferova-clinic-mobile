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

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      appointmentDate: json['appointmentDate'] as String,
      appointmentTime: json['appointmentTime'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'status': status,
    };
  }
}
