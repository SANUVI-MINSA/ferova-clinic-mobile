import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/health-facility/domain/model/appointment.dart';
import 'package:ferova_clinic_flutter/feature/health-facility/domain/repositories/appointment_repository.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_state.dart';
import 'package:flutter/cupertino.dart';

/// ViewModel para la pantalla principal de Enfermería
///
/// Responsabilidades:
/// - Cargar datos iniciales del nurse (pacientes, citas, etc.)
/// - Manejar el estado de carga y errores
/// - Proveer métodos para actualizar datos (refresh)
/// - Gestionar logout
class NurseHomeViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final AppointmentRepository appointmentRepository;
  NurseHomeState state = NurseHomeState();

  NurseHomeViewModel({
    required this.authRepository,
    required this.appointmentRepository,
  }) {
    loadTodayAppointments();
  }

  Future<void> logout() async {
    await authRepository.logout();
  }

  Future<void> loadTodayAppointments() async {
    state = state.copyWith(isLoadingAppointments: true);
    notifyListeners();
    try {
      List<Appointment> appointments = await appointmentRepository
          .getNurseAppointments();
      final String today = '2026-06-18';
      //final String today = DateTime.now().toIso8601String().substring(0, 10);

      final List<Appointment> todayAppointments = appointments
          .where((a) => a.appointmentDate == today)
          .take(3)
          .toList();

      state = state.copyWith(
        todayAppointments: todayAppointments,
        isLoadingAppointments: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingAppointments: false, errorMessage: '$e');
    }
    notifyListeners();
  }
}
