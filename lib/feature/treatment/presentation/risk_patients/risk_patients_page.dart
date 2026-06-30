import 'package:ferova_clinic_flutter/feature/treatment/presentation/risk_patients/risk_patient_card.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/risk_patients/risk_patients_state.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/risk_patients/risk_patients_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/repositories/treatment_repository.dart';

class RiskPatientsPage extends StatelessWidget {
  final String riskLevel;

  const RiskPatientsPage({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RiskPatientsViewModel(
        repository: getIt<TreatmentRepository>(),
        riskLevel: riskLevel,
      ),
      child: const _RiskPatientsContent(),
    );
  }
}

class _RiskPatientsContent extends StatelessWidget {
  const _RiskPatientsContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RiskPatientsViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pacientes - ${state.riskLabel}',
          style: const TextStyle(
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
          ? _buildErrorWidget(state.errorMessage!, viewModel)
          : state.patients.isEmpty
          ? _buildEmptyWidget(state)
          : _buildPatientList(context, viewModel, state),
    );
  }

  Widget _buildErrorWidget(String error, RiskPatientsViewModel viewModel) {
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
              'Error al cargar los pacientes',
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
              onPressed: () => viewModel.loadPatients(),
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

  Widget _buildEmptyWidget(RiskPatientsState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.riskEmoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay pacientes con ${state.riskLabel.toLowerCase()}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              state.subtitle,
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
      RiskPatientsViewModel viewModel,
      RiskPatientsState state,
      ) {
    return RefreshIndicator(
      color: const Color(0xFF0D6EA8),
      onRefresh: () => viewModel.loadPatients(),
      child: Column(
        children: [
          // Header con contador
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.total} Pacientes encontrados',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: state.riskColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Lista de pacientes
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.patients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final patient = state.patients[index];
                return RiskPatientCard(
                  patient: patient,
                  riskLevel: state.riskLevel,
                  onTap: () => viewModel.viewPatientDetail(patient.patientId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}