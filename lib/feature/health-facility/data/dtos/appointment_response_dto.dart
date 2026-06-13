import 'package:ferova_clinic_flutter/feature/health-facility/domain/model/appointment.dart';

class AppointmentResponseDto {
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String appointmentDate; // YYYY-MM-DD
  final String appointmentTime; // HH:mm
  final String status;

  const AppointmentResponseDto({
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
  });

  factory AppointmentResponseDto.fromJson(Map<String, dynamic> json) {
    return AppointmentResponseDto(
      appointmentId: json['appointmentId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'],
      appointmentDate: json['appointmentDate'] as String,
      appointmentTime: json['appointmentTime'] as String,
      status: json['status'] as String,
    );
  }

  Appointment toDomain() {
    return Appointment(
      id: appointmentId,
      patientId: patientId,
      patientName: patientName,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: status,
    );
  }
}
