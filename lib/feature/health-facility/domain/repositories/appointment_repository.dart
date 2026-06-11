import 'package:ferova_clinic_flutter/feature/health-facility/domain/model/appointment.dart';

abstract class AppointmentRepository {
  /// Returns a list of appointments for a nurse.
  List<Appointment> getNurseAppointments();
}
