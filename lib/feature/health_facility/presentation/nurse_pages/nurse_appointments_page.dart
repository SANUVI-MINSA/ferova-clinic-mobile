import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_state.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NurseAppointmentsPage extends StatelessWidget {
  const NurseAppointmentsPage({super.key});

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    const days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${days[date.weekday - 1]} ${date.day} de ${months[date.month]}, ${date.year}';
  }

  String _formatTime(String timeStr) {
    final parts = timeStr.split(':');
    int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    final String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String _initials(String fullName) {
    if (fullName.trim().isEmpty) return '?';
    final words = fullName.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    if (fullName.length < 2) return fullName.toUpperCase();
    return fullName.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentViewModel viewModel = context
        .watch<AppointmentViewModel>();
    final AppointmentState state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: const Color(0xFF2563EB),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Agenda de Citas',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF2563EB),
        onRefresh: () => viewModel.getNurseAppointments(),
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF2563EB)),
              )
            : state.errorMessage != null
            ? ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  Center(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : state.appointments.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  const Center(
                    child: Text(
                      'No hay citas programadas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: state.appointments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final Appointment a = state.appointments[index];
                  return AppointmentCard(
                    appointment: a,
                    initials: _initials(a.patientName),
                    formattedDate: _formatDate(a.appointmentDate),
                    formattedTime: _formatTime(a.appointmentTime),
                  );
                },
              ),
      ),
    );
  }
}
