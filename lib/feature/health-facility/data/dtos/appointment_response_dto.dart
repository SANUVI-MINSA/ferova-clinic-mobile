class AppointmentResponseDto {
  final String appointmentId;
  final String patientId;
  final String appointmentDate; // YYYY-MM-DD
  final String appointmentTime; // HH:mm
  final String status;

  const AppointmentResponseDto({
    required this.appointmentId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
  });

  factory AppointmentResponseDto.fromJson(Map<String, dynamic> json) {
    return AppointmentResponseDto(
      appointmentId: json['appointmentId'] as String,
      patientId: json['patientId'] as String,
      appointmentDate: json['appointmentDate'] as String,
      appointmentTime: json['appointmentTime'] as String,
      status: json['status'] as String,
    );
  }
}
