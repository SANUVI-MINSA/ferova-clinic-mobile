import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/nurse_appointments_page.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_state.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/today_appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/login/login_page.dart';
import '../../../treatment/presentation/pending_patients/pending_patients_page.dart';
import '../../../treatment/presentation/treatments_list/treatments_list_page.dart';

class NurseHomePage extends StatefulWidget {
  final User user;

  const NurseHomePage({super.key, required this.user});

  @override
  State<NurseHomePage> createState() => _NurseHomePageState();
}

class _NurseHomePageState extends State<NurseHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NurseHomeViewModel>().refresh();
    });
  }

  void _logout(BuildContext context, NurseHomeViewModel viewModel) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesion'),
        content: const Text('Estas seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await viewModel.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  //  MÉTODO PARA NAVEGAR A PENDING PATIENTS
  void _navigateToPendingPatients(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PendingPatientsPage(),
      ),
    );
  }

  // METODO PARA NAVEGAR A MIS TRATAMIENTOS
  void _navigateToTreatmentsList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TreatmentsListPage(),
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    const days = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'];
    const months = ['', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
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
    final viewModel = context.watch<NurseHomeViewModel>();
    final NurseHomeState state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
          onPressed: () => _logout(context, viewModel),
        ),
        title: const Text(
          'FerovaClinic',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D6EA8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNurseHeader(state.facilityName),
            const SizedBox(height: 16),
            _buildActivePatientCard(state.activePatients),
            const SizedBox(height: 16),
            _buildRiskStatusSection(state.highRiskCount, state.mediumRiskCount, state.lowRiskCount),
            const SizedBox(height: 20),
            _buildQuickAccess(),
            const SizedBox(height: 20),
            _buildDaySchedule(state),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildNurseHeader(String facilityName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enf. ${widget.user.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A3A5C)),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF6B7D8F)),
                const SizedBox(width: 2),
                Text(
                  facilityName,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7D8F)),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFD0E8F5),
          child: ClipOval(
            child: Image.asset(
              'assets/images/nurse_avatar.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.person_rounded, size: 34, color: Color(0xFF0D6EA8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePatientCard(int activePatients) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CARTERA DE PACIENTES',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0D6EA8), letterSpacing: 0.8),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                activePatients.toString(),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1A3A5C)),
              ),
              const SizedBox(width: 8),
              const Text('Activos', style: TextStyle(fontSize: 16, color: Color(0xFF6B7D8F))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskStatusSection(int highRiskCount, int mediumRiskCount, int lowRiskCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de Riesgo Clinico',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3A5C)),
          ),
          const SizedBox(height: 14),
          _buildRiskCard(label: 'HIGH', count: highRiskCount, subtitle: 'score mayor de 70',
              bgColor: const Color(0xFFFFEBEB), textColor: const Color(0xFFD32F2F), icon: Icons.warning_rounded),
          const SizedBox(height: 10),
          _buildRiskCard(label: 'MEDIUM', count: mediumRiskCount, subtitle: 'score entre 30 y 70',
              bgColor: const Color(0xFFFFF9C4), textColor: const Color(0xFFF57F17), icon: Icons.error_rounded),
          const SizedBox(height: 10),
          _buildRiskCard(label: 'LOW', count: lowRiskCount, subtitle: 'score menor de 30',
              bgColor: const Color(0xFFE8F5E9), textColor: const Color(0xFF2E7D32), icon: Icons.check_circle_rounded),
        ],
      ),
    );
  }

  Widget _buildRiskCard({
    required String label,
    required int count,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text('$count pacientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    final List<_QuickAccessItem> items = [
      _QuickAccessItem(
        icon: Icons.medical_information_rounded,
        label: 'Iniciar\nTratamiento',
        onTap: () => _navigateToPendingPatients(context),
      ),
      _QuickAccessItem(icon: Icons.fact_check_rounded, label: 'Registrar\nControl', onTap: () {}),
      _QuickAccessItem(
        icon: Icons.checklist_rounded,
        label: 'Mis\nTratamientos',
        onTap: () => _navigateToTreatmentsList(context),
      ),
      _QuickAccessItem(icon: Icons.person_add_rounded, label: 'Dar de Alta', onTap: () {}),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Accesos Rapidos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3A5C))),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: items.map((item) => _buildQuickAccessTile(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickAccessTile(_QuickAccessItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFE8F3FB), borderRadius: BorderRadius.circular(10)),
              child: Icon(item.icon, color: const Color(0xFF0D6EA8), size: 24),
            ),
            const SizedBox(height: 8),
            Text(item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1A3A5C), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySchedule(NurseHomeState state) {
    final topAppointments = state.todayAppointments;
    final isLoadingAppointments = state.isLoadingAppointments;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: Color(0xFF0D6EA8), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Proximas Citas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3A5C)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NurseAppointmentsPage()),
                  ),
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 3, color: Color(0xFFF1F5F9)),
          if (isLoadingAppointments)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            ))
          else if (topAppointments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  state.errorMessage != null
                      ? 'Error: ${state.errorMessage}'
                      : 'No tienes citas proximas',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF9EAFC0)),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: topAppointments.length,
                itemBuilder: (context, index) {
                  final Appointment a = topAppointments[index];
                  return TodayAppointmentCard(
                    appointment: a,
                    initials: _initials(a.patientName),
                    formattedDate: _formatDate(a.appointmentDate),
                    formattedTime: _formatTime(a.appointmentTime),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0D6EA8),
      unselectedItemColor: const Color(0xFF9EAFC0),
      backgroundColor: Colors.white,
      elevation: 12,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'INICIO'),
        BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'PACIENTES'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'CONSULTAS'),
        BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'HISTORIAL'),
      ],
    );
  }
}

class _QuickAccessItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _QuickAccessItem({required this.icon, required this.label, required this.onTap});
}

