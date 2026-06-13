import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';

abstract class AppointmentRepository {
  /// Returns a list of appointments for a nurse.
  Future<List<Appointment>> getNurseAppointments();
}
