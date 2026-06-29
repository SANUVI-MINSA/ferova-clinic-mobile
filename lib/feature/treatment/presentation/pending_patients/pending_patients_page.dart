import 'package:ferova_clinic_flutter/feature/treatment/presentation/pending_patients/pending_patients_state.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/pending_patients/pending_patients_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/model/pending_patient.dart';
import '../../domain/repositories/treatment_repository.dart';

class PendingPatientsPage extends StatelessWidget {
  const PendingPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<PendingPatientsViewModel>(),
      child: const _PendingPatientsContent(),
    );
  }
}

class _PendingPatientsContent extends StatelessWidget {
  const _PendingPatientsContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PendingPatientsViewModel>();
    final PendingPatientsState state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Selecionar Paciente',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D6EA8),
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
      )
          : state.errorMessage != null
          ? _buildErrorWidget(context, state.errorMessage!)
          : _buildContent(context, viewModel, state),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los datos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context
                  .read<PendingPatientsViewModel>()
                  .loadPendingPatients(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EA8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      PendingPatientsViewModel viewModel,
      PendingPatientsState state,
      ) {
    final response = state.response!;

    // Caso 1: No tiene pacientes asignados
    if (!response.hasPatientsAssigned) {
      return _buildNoPatientsAssigned(context, viewModel, response.message);
    }

    // Caso 2: Todos los pacientes ya iniciaron tratamiento
    if (!response.hasPendingPatients) {
      return _buildAllPatientsHaveTreatment(context, response.message);
    }

    // Caso 3: Tiene pacientes pendientes (vista de selección)
    return _buildPatientList(context, viewModel, response.pendingPatients);
  }

  Widget _buildNoPatientsAssigned(
      BuildContext context,
      PendingPatientsViewModel viewModel,
      String? message,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes pacientes asignados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Para comenzar, debes asignar pacientes a tu lista de trabajo.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.assignPatients,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D6EA8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Asignar Pacientes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllPatientsHaveTreatment(
      BuildContext context,
      String? message,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Ya todos los pacientes han iniciado su tratamiento.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'No hay pacientes pendientes de selección en este momento.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList(
      BuildContext context,
      PendingPatientsViewModel viewModel,
      List<PendingPatient> patients,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona un paciente para iniciar su tratamiento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: patients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return _buildPatientCard(
                  context,
                  viewModel,
                  patient,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(
      BuildContext context,
      PendingPatientsViewModel viewModel,
      PendingPatient patient,
      ) {
    return GestureDetector(
      onTap: () => viewModel.selectPatient(patient.patientId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE8F3FB),
              child: Text(
                _getInitials(patient.patientName),
                style: const TextStyle(
                  color: Color(0xFF0D6EA8),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                patient.patientName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3A5C),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9EAFC0),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.trim().isEmpty) return '?';
    final words = fullName.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    if (fullName.length < 2) return fullName.toUpperCase();
    return fullName.substring(0, 2).toUpperCase();
  }
}