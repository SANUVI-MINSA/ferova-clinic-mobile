import 'package:ferova_clinic_flutter/feature/treatment/presentation/patient_monitor/patient_header.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/patient_monitor/patient_monitor_view_model.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/patient_monitor/treatment_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/repositories/treatment_repository.dart';
import 'adherence_card.dart';

class PatientMonitorPage extends StatelessWidget {
  final String patientId;

  const PatientMonitorPage({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PatientMonitorViewModel(
        repository: getIt<TreatmentRepository>(),
        patientId: patientId,
      ),
      child: const _PatientMonitorContent(),
    );
  }
}

class _PatientMonitorContent extends StatelessWidget {
  const _PatientMonitorContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PatientMonitorViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Clinical Monitor',
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
          ? _buildErrorWidget(state.errorMessage!, viewModel)
          : state.patient == null
          ? _buildEmptyWidget()
          : _buildContent(state.patient!),
    );
  }

  Widget _buildErrorWidget(String error, PatientMonitorViewModel viewModel) {
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
              'Error al cargar la información',
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
              onPressed: () => viewModel.loadPatientMonitor(),
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

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No se encontró información del paciente',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF6B7D8F),
        ),
      ),
    );
  }

  Widget _buildContent(patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PatientHeader(patient: patient),
          const SizedBox(height: 16),
          AdherenceCard(patient: patient),
          const SizedBox(height: 16),
          TreatmentInfoCard(patient: patient),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}