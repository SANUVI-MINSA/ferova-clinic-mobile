import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';

class TopAppointmentDto {
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String facilityId;
  final String facilityName;
  final String appointmentDate;
  final String appointmentTime;
  final String status;

  const TopAppointmentDto({
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.facilityId,
    required this.facilityName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
  });

  factory TopAppointmentDto.fromJson(Map<String, dynamic> json) {
    return TopAppointmentDto(
      appointmentId: json['appointmentId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      facilityId: json['facilityId'] as String,
      facilityName: json['facilityName'] as String,
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
