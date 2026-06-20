import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/appointment_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_state.dart';
import 'package:flutter/material.dart';

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentRepository repository;
  AppointmentState state = AppointmentState();

  AppointmentViewModel({required this.repository}) {
    getNurseAppointments();
  }

  Future<void> getNurseAppointments() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      List<Appointment> appointments = await repository.getNurseAppointments();
      state = state.copyWith(appointments: appointments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '$e');
    }

    notifyListeners();
  }
}
